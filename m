Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B9A37CA2
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 14:58:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8882AC002
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 12:58:41 -0800 (PST)
Received: from mail-yw0-f174.google.com (mail-yw0-f174.google.com
	[209.85.161.174]) by cuda.sgi.com with ESMTP id
	DOREEMIjVfBNLCU2 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Feb 2016 12:58:39 -0800 (PST)
Received: by mail-yw0-f174.google.com with SMTP id u200so49601002ywf.0
	for <xfs@oss.sgi.com>; Thu, 11 Feb 2016 12:58:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160211204635.GI19486@dastard>
References: <1455137336-28720-1-git-send-email-ross.zwisler@linux.intel.com>
	<1455137336-28720-3-git-send-email-ross.zwisler@linux.intel.com>
	<20160210220312.GP14668@dastard>
	<20160210224340.GA30938@linux.intel.com>
	<20160211125044.GJ21760@quack.suse.cz>
	<CAPcyv4g60iOTd-ShBCfsK+B7xArcc5pWXWktNop53otDbUW-3g@mail.gmail.com>
	<20160211204635.GI19486@dastard>
Date: Thu, 11 Feb 2016 12:58:38 -0800
Message-ID: <CAPcyv4h4u+LB5U5nm4Jo32r=33D02yv36k5QxmJoy3DRiHmQEQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] dax: move writeback calls into the filesystems
From: Dan Williams <dan.j.williams@intel.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Theodore Ts'o <tytso@mit.edu>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, XFS Developers <xfs@oss.sgi.com>, Linux MM <linux-mm@kvack.org>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4 <linux-ext4@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Feb 11, 2016 at 12:46 PM, Dave Chinner <david@fromorbit.com> wrote:
[..]
>> It seems to me we need to modify the
>> metadata i/o paths to bypass the page cache,
>
> XFS doesn't use the block device page cache for it's metadata - it
> has it's own internal metadata cache structures and uses get_pages
> or heap memory to back it's metadata. But that doesn't make mixing
> DAX and pages in the block device mapping tree sane.
>
> What you are missing here is that the underlying architecture of
> journalling filesystems mean they can't use DAX for their metadata.
> Modifications have to be buffered, because they have to be written
> to the journal first before they are written back in place. IOWs, we
> need to buffer changes in volatile memory for some time, and that
> means we can't use DAX during transactional modifications.
>
> And to put the final nail in that coffin, metadata in XFS can be
> discontiguous multi-block objects - in those situations we vmap the
> underlying pages so they appear to the code to be a contiguous
> buffer, and that's something we can't do with DAX....

Sorry, I wasn't clear when I said "bypass page cache" I meant a
solution similar to commit d1a5f2b4d8a1 "block: use DAX for partition
table reads".  However, I suspect that is broken if the filesystem is
not ready to see a new page allocated for every I/O.  I assume one
thread will want to insert a page in the radix for another thread to
find/manipulate before metadata gets written back to storage.

>> or teach the fsync code
>> how to flush populated data pages out of the radix.
>
> That doesn't solve the problem. Filesystems free and reallocate
> filesystem blocks without intermediate block device mapping
> invalidation calls, so what is one minute a data block accessed by
> DAX may become a metadata block that accessed via buffered IO.  It
> all goes to crap very quickly....
>
> However, I'd say fsync is not the place to address this. This block
> device cache aliasing issue is supposed to be what
> unmap_underlying_metadata() solves, right?

I'll take a look at this.  Right now I'm trying to implement the
"clear block-device-inode S_DAX on fs mount" approach.  My concern
though is that  we need to disable block device mmap while a
filesystem is mounted...

Maybe I don't need to worry because it's already the case that a mmap
of the raw device may not see the most up to date data for a file that
has dirty fs-page-cache data.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
