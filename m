Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4AE867F47
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 16:32:42 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A34330406A
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 14:32:42 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	y8ZEjn8K0zHX5vSz for <xfs@oss.sgi.com>;
	Tue, 05 Jan 2016 14:32:39 -0800 (PST)
Date: Wed, 6 Jan 2016 09:32:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [resend PATCH 1/3] block, fs: reliably communicate bdev
	end-of-life
Message-ID: <20160105223236.GD21461@dastard>
References: <20160104181220.24118.96661.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160104182005.24118.50361.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20160105035147.GJ19802@dastard>
	<CAPcyv4i=5-e6mobC5yu1SgESBNgCeqU5jwbaxhN8ZmNW+xUnJA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4i=5-e6mobC5yu1SgESBNgCeqU5jwbaxhN8ZmNW+xUnJA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@fb.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, XFS Developers <xfs@oss.sgi.com>, linux-block@vger.kernel.org, Jan Kara <jack@suse.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>

On Mon, Jan 04, 2016 at 08:25:16PM -0800, Dan Williams wrote:
> On Mon, Jan 4, 2016 at 7:51 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Jan 04, 2016 at 10:20:05AM -0800, Dan Williams wrote:
> >> Historically we have waited for filesystem specific heuristics to
> >> attempt to guess when a block device is gone.  Sometimes this works, but
> >> in other cases the system can hang waiting for the fs to trigger its
> >> shutdown protocol.
....
> True, and following this logic I think the existing
> generic_shutdown_super() should be renamed generic_kill_super() to
> match the fs actions, but see below...
> 
> > Operation methods should be named after what they do, not what their
> > calling context is. i.e. these are "invalidate" and "shutdown"
> > superblock operations, not "quiesce" and "bdi_gone".
> 
> I was running out of colors to paint the bike shed given
> generic_shutdown_super() was already in use.  Also, since

Ah, yeah, i forgot about that function. To many different shades of
purple are already in use. :/

> >> +void shutdown_partition(struct gendisk *disk, int partno)
> >> +{
> >> +     struct block_device *bdev = bdget_disk(disk, partno);
> >> +     struct super_block *sb = get_super(bdev);
> >> +
> >> +     if (!bdev)
> >> +             return;
> >
> > Null pointer deref. Certainly a landmine waiting for someone to
> > tread on.
> >
> 
> Nope, get_super() checks for a NULL argument.

Hence my comment about it being a landmine. If get_super() is ever
changed, this code will explode on us when we least expect it. If I
have to go read other code in a completely different file just to
determine the code is actually safe, then I consider that bad code.
Code that is slightly more verbose but is obviously correct and
balanced is much, much easier to understand and maintain....

> >> +     if (!sb) {
> >> +             bdput(bdev);
> >> +             return;
> >> +     }
> >> +
> >> +     if (sb->s_op->bdi_gone)
> >> +             sb->s_op->bdi_gone(sb);
> >> +     else
> >> +             generic_bdi_gone(sb);
> >
> >         if (sb->s_op->shutdown)
> >                 sb->s_op->shutdown(sb);
> >         else
> >                 unmap_dax_inodes(sb);
> >
> > name things correctly, and the code documents itself.
> 
> How about 'stop' or 'halt' instead of 'shutdown' to preserve the
> historical meaning of generic_shutdown_super?

It's hard chosing a different color that is appropriate. :/

Because it's a brute-force behavioural override, I think that needs
to be obvious from the op name. So something like force_stop or
force_failure seems best to me.

In fact, now that I've thought/repaeated/written force_failure a
couple of times, it seems quite appropriate here, as what we want to
be able to do is force the filesystem into a (permanent) failure
state.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
