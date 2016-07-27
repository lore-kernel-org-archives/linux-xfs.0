Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E1A407CA0
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2016 07:07:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 533D4AC002
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2016 05:07:54 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id YKIGK60YKioBLY3J (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 27 Jul 2016 05:07:49 -0700 (PDT)
Date: Wed, 27 Jul 2016 14:07:45 +0200
From: Jan Kara <jack@suse.cz>
Subject: Subtle races between DAX mmap fault and write path
Message-ID: <20160727120745.GI6860@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>

Hi,

when testing my latest changes to DXA fault handling code I have hit the
following interesting race between the fault and write path (I'll show
function names for ext4 but xfs has the same issue AFAICT).

We have a file 'f' which has a hole at offset 0.

Process 0				Process 1

data = mmap('f');
read data[0]
  -> fault, we map a hole page

					pwrite('f', buf, len, 0)
					  -> ext4_file_write_iter
					    inode_lock(inode);
					    __generic_file_write_iter()
					      generic_file_direct_write()
						invalidate_inode_pages2_range()
						  - drops hole page from
						    the radix tree
						ext4_direct_IO()
						  dax_do_io()
						    - allocates block for
						      offset 0
data[0] = 1
  -> page_mkwrite fault
    -> ext4_dax_fault()
      down_read(&EXT4_I(inode)->i_mmap_sem);
      __dax_fault()
	grab_mapping_entry()
	  - creates locked radix tree entry
	- maps block into PTE
	put_locked_mapping_entry()

						invalidate_inode_pages2_range()
						  - removes dax entry from
						    the radix tree

So we have just lost information that block 0 is mapped and needs flushing
caches.

Also the fact that the consistency of data as viewed by mmap and
dax_do_io() relies on invalidate_inode_pages2_range() is somewhat
unexpected to me and we should document it somewhere.

The question is how to best fix this. I see three options:

1) Lock out faults during writes via exclusive i_mmap_sem. That is rather
harsh but should work - we call filemap_write_and_wait() in
generic_file_direct_write() so we flush out all caches for the relevant
area before dropping radix tree entries.

2) Call filemap_write_and_wait() after we return from ->direct_IO before we
call invalidate_inode_pages2_range() and hold i_mmap_sem exclusively only
for those two calls. Lock hold time will be shorter than 1) but it will
require additional flush and we'd probably have to stop using
generic_file_direct_write() for DAX writes to allow for all this special
hackery.

3) Remodel dax_do_io() to work more like buffered IO and use radix tree
entry locks to protect against similar races. That has likely better
scalability than 1) but may be actually slower in the uncontended case (due
to all the radix tree operations).

Any opinions on this?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
