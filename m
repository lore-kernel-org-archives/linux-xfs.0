Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Dec 2007 03:12:44 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBCBC2fS024393
	for <xfs@oss.sgi.com>; Wed, 12 Dec 2007 03:12:07 -0800
Date: Wed, 12 Dec 2007 22:12:02 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: XFS internal error xfs_btree_check_sblock
Message-ID: <20071212111202.GI4612@sgi.com>
References: <475ED66F.40800@dgreaves.com> <20071211222546.GD4612@sgi.com> <475F2008.5030702@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475F2008.5030702@dgreaves.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Tue, Dec 11, 2007 at 11:40:56PM +0000, David Greaves wrote:
> David Chinner wrote:
> > On Tue, Dec 11, 2007 at 06:26:55PM +0000, David Greaves wrote:
> >> Once every 2 or 3 cold boots I get this in dmesg as the user logs in and
> > So there's a corrupted freespace btree block.
> OK, ta
> 
> >> I ssh in as root, umount, mount, umount and run xfs_repair.
> > repair doesn't check the freespace btrees - it just rebuilds them from
> > scratch. use xfs_check to tell you what is wrong with the filesystem, then
> > use xfs_repair to fix it....
> 
> OK, having repaired it:
> haze:~# xfs_check /dev/video_vg/video_lv
> haze:~#

Of course there's no errors - you just repaired them ;)

Run xfs_check before you run xfs-repair when a corruption occurs.

> So why do I have to do this on a regular basis (ie run xfs_repair)?

Don't know yet.

> I am shutting the machine down cleanly (init 0)

That doesn't mean everything shuts down cleanly....

> >> It is possible this fs suffered in the 2.6.17 timeframe
> >> It is also possible something got broken whilst I was having lots of issues with
> >>  hibernate (which is still unreliable).
> > 
> > Suspend does not quiesce filesystems safely, so you risk filesystem
> > corruption every time you suspend and resume no matter what filesystem
> > you use.
> 
> Well, FWIW, I've not hibernated this machine for a *long* time.

Ok, so ignore that.

> Also my hibernate script used to run xfs_freeze before hibernating (to be on the
> safe side). This would regularly hang with an xfs_io process (or some such IIRC)
> in an unkillable state.

Well, 2.6.23 completely broke this, along with freezing XFS filesystems.

> I was about to edit my init scripts to do a mount, umount, xfs_repair, mount
> cycle. But then I thought "this is wrong - I'll report it".
> So is there anything else I should do?

Check the filesystem before repairing it.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
