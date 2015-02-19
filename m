Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1CC147F3F
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 09:42:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8F717AC003
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 07:42:50 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id EZ3scJPYZyV2YKIU (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 07:42:48 -0800 (PST)
Date: Thu, 19 Feb 2015 16:42:41 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: + ext4-add-dax-functionality.patch added to -mm tree
Message-ID: <20150219154241.GC22712@quack.suse.cz>
References: <54b45495.+RptMlNQorYE9TTf%akpm@linux-foundation.org>
	<20150115124106.GF12739@quack.suse.cz>
	<100D68C7BA14664A8938383216E40DE040853440@FMSMSX114.amr.corp.intel.com>
	<20150119141858.GF5662@quack.suse.cz>
	<20150217085200.GA23192@quack.suse.cz>
	<20150217133745.GG3364@wil.cx>
	<20150218104009.GB4614@quack.suse.cz>
	<20150218215523.GO12722@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150218215523.GO12722@dastard>
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "boaz@plexistor.com" <boaz@plexistor.com>, xfs@oss.sgi.com, Jan Kara <jack@suse.cz>, "rdunlap@infradead.org" <rdunlap@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>, "hch@lst.de" <hch@lst.de>, "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>, "Dilger, Andreas" <andreas.dilger@intel.com>, Matthew Wilcox <willy@linux.intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>

On Thu 19-02-15 08:55:23, Dave Chinner wrote:
> On Wed, Feb 18, 2015 at 11:40:09AM +0100, Jan Kara wrote:
> > On Tue 17-02-15 08:37:45, Matthew Wilcox wrote:
> > > On Tue, Feb 17, 2015 at 09:52:00AM +0100, Jan Kara wrote:
> > > > > > This got added to fix a problem that Dave Chinner pointed out.  We need
> > > > > > the allocated extent to either be zeroed (as ext2 does), or marked as
> > > > > > unwritten (ext4, XFS) so that a racing read/page fault doesn't return
> > > > > > uninitialized data.  If it's marked as unwritten, we need to convert it
> > > > > > to a written extent after we've initialised the contents.  We use the
> > > > > > b_end_io() callback to do this, and it's called from the DAX code, not in
> > > > > > softirq context.
> > > > >   OK, I see. But I didn't find where ->b_end_io gets called from dax code
> > > > > (specifically I don't see it anywhere in dax_do_IO() or dax_io()). Can you
> > > > > point me please?
> > > 
> > > For faults, we call it in dax_insert_mapping(), the very last thing
> > > before returning in the fault path.  The normal I/O path gets to use
> > > the dio_iodone_t for the same purpose.
> >   I see. I didn't think of races with reads (hum, I actually wonder whether
> > we don't have this data exposure problem for ext4 for mmapped write into
> > a hole vs direct read as well). So I guess we do need those unwritten
> > extent dances after all (or we would need to have a page covering hole when
> > writing to it via mmap but I guess unwritten extent dances are somewhat
> > more standard).
> 
> Right, that was the reason for doing it that way - it leveraged all
> the existing methods we have for avoiding data exposure races in
> XFS. but it's also not just for races - it's for ensuring that if we
> crash between the allocation and the write to the persistent store
> we don't expose the underlying contents when the system next comes
> up.
  Well, ext3/4 handles the crash situation differently - we make sure we
flush data to allocated blocks before committing a transaction that
allocates them. That works perfectly for crashes but doesn't avoid the
race with DIO.

> > > > > Also abusing b_end_io of a phony buffer for that looks ugly to me (we are
> > > > > trying to get away from passing phony bh around and this would entangle us
> > > > > even more into that mess). Normally I would think that end_io() callback
> > > > > passed into dax_do_io() should perform necessary conversions and for
> > > > > dax_fault() we could do necessary conversions inside foofs_page_mkwrite()...
> > > 
> > > Dave sees to be the one trying the hardest to get rid of the phony BHs
> > > ... and it was his idea to (ab)use b_end_io for this.  The problem with
> > > doing the conversion in ext4_page_mkwrite() is that we don't know at
> > > that point whether the BH is unwritten or not.
> >   I see, thanks for explanation. So it would be enough to pass a bit of
> > information (unwritten / written) to a caller of do_dax_fault() and that
> > can then call conversion function. IMO doing that (either in a return value
> > or in a separate argument of do_dax_fault()) would be cleaner and more
> > readable than playing with b_private and b_end_io... Thoughts?
> 
> I'm happy for a better mechanism to be thought up. The current one
> was expedient, but not pretty. The need for the end_io function was
> because unwritten conversion needed to happen after the page was
> zeroed. If we change dax_fault() to also take a "end_io" function
> callback (already takes a get_blocks callback), then we can avoid
> the need to use the phony bh for this purpose. i.e filesystems that
> allocate unwritten extents can pass a completion function
  Yeah, that's probably even better.

> And speaking of phony BHs, the pnfs block layout changes introduce
> an struct iomap and a "map_blocks" method to the export_ops in
> exportfs.h. This is the model what we should be using instead of
> phony BHs for block mapping/allocation operations...
  Yup, that'd be nice.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
