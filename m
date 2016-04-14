Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E49997CA0
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 22:22:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B51B2304032
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 20:22:19 -0700 (PDT)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id L6i6GtMXSHWxhrGu (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 20:22:17 -0700 (PDT)
Date: Wed, 13 Apr 2016 23:22:07 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 error
Message-ID: <20160414032207.GC16656@thunk.org>
References: <0255994B402DE243B1DFC1057A00655201AC6F@ZXSHMBX02.zhaoxin.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <0255994B402DE243B1DFC1057A00655201AC6F@ZXSHMBX02.zhaoxin.com>
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
To: Eric Shang <EricShang@zhaoxin.com>
Cc: "jack@suse.cz" <jack@suse.cz>, Toshi Kani <toshi.kani@hpe.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>

On Wed, Apr 13, 2016 at 01:44:55PM +0000, Eric Shang wrote:
> HI All:
>   I meet an ext4 error, following is the error log. After panic, I check the emmc by the tool debufs, the inode 69878 i_nlink is not zero. And this inode don't belong to parent dir 6987, it belong to other file(this inode belong to two files when check by debugfs ncheck), I guess than this inode has beed deleted in memory and already used by other file. But the parent dentry buff_head not flush to emmc. But when lookup this dentry can't find it' in dentry cache, and then lookup_real, read the dentry from emmc, get the file inode which already be deleted. 
>   Can any give me some help how to check this issue. My kernel version is 3.18 form Android . I thinks something wrong with dentry cache flush and dirty buff_head flush to emmc. Thanks all!

If I had to guess, this was caused starting with a corrupted file
system, where the inode allocation bitmap showed that an inode which
was in use by the file system, was erroneously showing it as free.
This allowed it to be allocated for use in a second file (which would
have wiped out the contents for the original file stored at that
inode).  Later on, the file was deleted via either the older or newer
pathname, which dropped the ref count to zero, and then an access via
the other pathname would have resulted in this error.

After the panic, the on-disk data structures wouldn't have been
updated from whatever the in-memory data structures might have been
("Kernel panic - not syncing").  So what you see from using debugfs
after the crash might not be represenatative of what you saw before
the crash.

I'm not sure there's much debugging that can be done, because there
are any number of sources for the original corruption.  It could be
caused by a hardware issue in the flash or the memory, or it could be
caused by a wild pointer corrupting a disk buffer, etc. etc.  The
panic won't result in a useful stack trace because that's when the
problem was *noticed*.  But that's very different from where the file
system corruption was *introduced*.

If you can reliably reproduce this sort of failure, then it becomes
possible to try to track it down.  But if it's a one-off event,
there's not much anyone can do.

Best regards,

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
