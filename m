Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7BF017F9E
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 15:55:48 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 671B38F8054
	for <xfs@oss.sgi.com>; Wed, 18 Feb 2015 13:55:48 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	xwrctddVnNGnUvKK for <xfs@oss.sgi.com>;
	Wed, 18 Feb 2015 13:55:45 -0800 (PST)
Date: Thu, 19 Feb 2015 08:55:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: + ext4-add-dax-functionality.patch added to -mm tree
Message-ID: <20150218215523.GO12722@dastard>
References: <54b45495.+RptMlNQorYE9TTf%akpm@linux-foundation.org>
	<20150115124106.GF12739@quack.suse.cz>
	<100D68C7BA14664A8938383216E40DE040853440@FMSMSX114.amr.corp.intel.com>
	<20150119141858.GF5662@quack.suse.cz>
	<20150217085200.GA23192@quack.suse.cz>
	<20150217133745.GG3364@wil.cx>
	<20150218104009.GB4614@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150218104009.GB4614@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "boaz@plexistor.com" <boaz@plexistor.com>, xfs@oss.sgi.com, "Dilger, Andreas" <andreas.dilger@intel.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>, "hch@lst.de" <hch@lst.de>, "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>

On Wed, Feb 18, 2015 at 11:40:09AM +0100, Jan Kara wrote:
> On Tue 17-02-15 08:37:45, Matthew Wilcox wrote:
> > On Tue, Feb 17, 2015 at 09:52:00AM +0100, Jan Kara wrote:
> > > > > This got added to fix a problem that Dave Chinner pointed out.  We need
> > > > > the allocated extent to either be zeroed (as ext2 does), or marked as
> > > > > unwritten (ext4, XFS) so that a racing read/page fault doesn't return
> > > > > uninitialized data.  If it's marked as unwritten, we need to convert it
> > > > > to a written extent after we've initialised the contents.  We use the
> > > > > b_end_io() callback to do this, and it's called from the DAX code, not in
> > > > > softirq context.
> > > >   OK, I see. But I didn't find where ->b_end_io gets called from dax code
> > > > (specifically I don't see it anywhere in dax_do_IO() or dax_io()). Can you
> > > > point me please?
> > 
> > For faults, we call it in dax_insert_mapping(), the very last thing
> > before returning in the fault path.  The normal I/O path gets to use
> > the dio_iodone_t for the same purpose.
>   I see. I didn't think of races with reads (hum, I actually wonder whether
> we don't have this data exposure problem for ext4 for mmapped write into
> a hole vs direct read as well). So I guess we do need those unwritten
> extent dances after all (or we would need to have a page covering hole when
> writing to it via mmap but I guess unwritten extent dances are somewhat
> more standard).

Right, that was the reason for doing it that way - it leveraged all
the existing methods we have for avoiding data exposure races in
XFS. but it's also not just for races - it's for ensuring that if we
crash between the allocation and the write to the persistent store
we don't expose the underlying contents when the system next comes
up.

These problems were found long ago on XFS and that's one of the
reasons why all direct IO block allocation uses unwritten extents -
until the data is on disk there is a window for stale data exposure
and things like crashing systems running high throughput IO are
very good at exposing such small windows of exposure. Hence I
thought it best to have DAX close that hole for everyone.

> So in that case you need ext4_get_block_write() in the above call to
> do_dax_fault() (note that we still do need ext4 version of the fault
> function like above due to lock ranking and retry on ENOSPC). And please
> comment about the read races at that call site so that we have that
> subtlety documented somewhere.

Actually, I thought it was obvious that  ;)

> 
> > > > Also abusing b_end_io of a phony buffer for that looks ugly to me (we are
> > > > trying to get away from passing phony bh around and this would entangle us
> > > > even more into that mess). Normally I would think that end_io() callback
> > > > passed into dax_do_io() should perform necessary conversions and for
> > > > dax_fault() we could do necessary conversions inside foofs_page_mkwrite()...
> > 
> > Dave sees to be the one trying the hardest to get rid of the phony BHs
> > ... and it was his idea to (ab)use b_end_io for this.  The problem with
> > doing the conversion in ext4_page_mkwrite() is that we don't know at
> > that point whether the BH is unwritten or not.
>   I see, thanks for explanation. So it would be enough to pass a bit of
> information (unwritten / written) to a caller of do_dax_fault() and that
> can then call conversion function. IMO doing that (either in a return value
> or in a separate argument of do_dax_fault()) would be cleaner and more
> readable than playing with b_private and b_end_io... Thoughts?

I'm happy for a better mechanism to be thought up. The current one
was expedient, but not pretty. The need for the end_io function was
because unwritten conversion needed to happen after the page was
zeroed. If we change dax_fault() to also take a "end_io" function
callback (already takes a get_blocks callback), then we can avoid
the need to use the phony bh for this purpose. i.e filesystems that
allocate unwritten extents can pass a completion function

I've got to update the XFS DAX patches I have for the next merge
cycle, so I'll take another at it when I page that information back
into my brain.

And speaking of phony BHs, the pnfs block layout changes introduce
an struct iomap and a "map_blocks" method to the export_ops in
exportfs.h. This is the model what we should be using instead of
phony BHs for block mapping/allocation operations...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
