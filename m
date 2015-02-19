Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9B2AF7F4E
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 15:12:59 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6804E8F8050
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 13:12:56 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	aHiJcrNmbEV6HBM1 for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 13:12:53 -0800 (PST)
Date: Fri, 20 Feb 2015 08:12:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: + ext4-add-dax-functionality.patch added to -mm tree
Message-ID: <20150219211210.GS12722@dastard>
References: <54b45495.+RptMlNQorYE9TTf%akpm@linux-foundation.org>
	<20150115124106.GF12739@quack.suse.cz>
	<100D68C7BA14664A8938383216E40DE040853440@FMSMSX114.amr.corp.intel.com>
	<20150119141858.GF5662@quack.suse.cz>
	<20150217085200.GA23192@quack.suse.cz>
	<20150217133745.GG3364@wil.cx>
	<20150218104009.GB4614@quack.suse.cz>
	<20150218215523.GO12722@dastard>
	<20150219154241.GC22712@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150219154241.GC22712@quack.suse.cz>
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

On Thu, Feb 19, 2015 at 04:42:41PM +0100, Jan Kara wrote:
> On Thu 19-02-15 08:55:23, Dave Chinner wrote:
> > On Wed, Feb 18, 2015 at 11:40:09AM +0100, Jan Kara wrote:
> > > On Tue 17-02-15 08:37:45, Matthew Wilcox wrote:
> > > > On Tue, Feb 17, 2015 at 09:52:00AM +0100, Jan Kara wrote:
> > > > > > > This got added to fix a problem that Dave Chinner pointed out.  We need
> > > > > > > the allocated extent to either be zeroed (as ext2 does), or marked as
> > > > > > > unwritten (ext4, XFS) so that a racing read/page fault doesn't return
> > > > > > > uninitialized data.  If it's marked as unwritten, we need to convert it
> > > > > > > to a written extent after we've initialised the contents.  We use the
> > > > > > > b_end_io() callback to do this, and it's called from the DAX code, not in
> > > > > > > softirq context.
> > > > > >   OK, I see. But I didn't find where ->b_end_io gets called from dax code
> > > > > > (specifically I don't see it anywhere in dax_do_IO() or dax_io()). Can you
> > > > > > point me please?
> > > > 
> > > > For faults, we call it in dax_insert_mapping(), the very last thing
> > > > before returning in the fault path.  The normal I/O path gets to use
> > > > the dio_iodone_t for the same purpose.
> > >   I see. I didn't think of races with reads (hum, I actually wonder whether
> > > we don't have this data exposure problem for ext4 for mmapped write into
> > > a hole vs direct read as well). So I guess we do need those unwritten
> > > extent dances after all (or we would need to have a page covering hole when
> > > writing to it via mmap but I guess unwritten extent dances are somewhat
> > > more standard).
> > 
> > Right, that was the reason for doing it that way - it leveraged all
> > the existing methods we have for avoiding data exposure races in
> > XFS. but it's also not just for races - it's for ensuring that if we
> > crash between the allocation and the write to the persistent store
> > we don't expose the underlying contents when the system next comes
> > up.
>   Well, ext3/4 handles the crash situation differently - we make sure we
> flush data to allocated blocks before committing a transaction that
> allocates them. That works perfectly for crashes but doesn't avoid the
> race with DIO.

I was talking about direct IO, not buffered IO. DAX is modeled on
the direct IO stack, not buffered IO. I did go and look at the ext4
IO completion path, and I can see where ext4_end_io_dio() triggers a
commit outside of doing unwritten extent conversion. Can you clue me
in - IO completion in ext4 is a maze of twisty passages...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
