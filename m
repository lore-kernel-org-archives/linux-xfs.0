Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A55B29DF8
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 19:06:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ABE6EAC001
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 17:06:48 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	K9jQg0sdSk7i28j9 for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 17:06:46 -0700 (PDT)
Date: Fri, 4 Jul 2014 10:04:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
Message-ID: <20140704000426.GX4453@dastard>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
	<20140703094347.GU4453@dastard>
	<alpine.LSU.2.11.1407040113340.9881@Telcontar.valinor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1407040113340.9881@Telcontar.valinor>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Fri, Jul 04, 2014 at 01:34:52AM +0200, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> 
> 
> On Thursday, 2014-07-03 at 19:43 +1000, Dave Chinner wrote:
> >On Thu, Jul 03, 2014 at 05:00:47AM +0200, Carlos E. R. wrote:
> >>On Wednesday, 2014-07-02 at 08:04 -0400, Brian Foster wrote:
> >>>On Wed, Jul 02, 2014 at 11:57:25AM +0200, Carlos E. R. wrote:
> >>
> >>...
> 
> >>hibernated at least once a day, perhaps three times if I have to go
> >>out several times. It makes no sense to me to leave the machine
> >>powered doing nothing, if hibernating is so easy and reliable - till
> >>now. If I have to leave for more than a week, I tend to do a full
> >>"halt".
> >
> >Hibernation has always been suspect w.r.t. flushing filesystem
> >metadata. It does not guarantee that the filesystem is quiesced
> >and idle, it just does a sync() and hopes that is sufficient to get
> >the filesystem into a consistent state. The mess that this leaves is
> >then left to filesystem developers to play whack-a-mole with when
> >users have problems.
> 
> 
> Ah, but my problem would then not happen always on the same
> partition. It would affect others, would not?

It needs a busy/dirty filesystem. if the other filesystems are
mostly idle, then they are unlikely to trip over the problem.

> >>But soon after, it oopses:
> >
> >Point of note: there is no oops or crash occurring. XFS dumps the
> >stack when a corruption occurs to tell use where it was detected
> >and then shuts down the filesystem. Your system is still just fine
> >apart from not being able to access that filesystem until you
> >unmount it, rpeair it and mount it again.
> 
> Ok, true, there is no formal "Oops".
> 
> But no, the system does not remains fine, I had to hit the hardware
> reset or power off button to get out.

That usually only happens when the root filesystem is shut down and
you can't access any of the binaries needed to run the system. Is
the filesystem that is shutting down the root?

> >>Question.
> >>
> >>As this always happens on recovery from hibernation, and seeing the message
> >>"Corruption of in-memory data detected", could it be that thawing does a bad
> >>memory recovery from the swap?  I thought that the procedure includes some
> >>checksum, but I don't know for sure.
> >
> >It's the fact that the filesystem si still running and modifying
> >state when the snapshot is being taken that results in the snapshot
> >image containing an inconsistent snapshot. That then gets loaded
> >on thaw and it goes boom.
> 
> But it only happens on the /home partition, not on the email
> partition, for instance, also in the same hard disk.

/home is typically where all the application have open files and are
writing data to.

Email partitions are unlikely to have problems because email
programs are pretty good about using fsync() to ensure your email
doesn't go missing and so aren't dirty at the time of a hibernation.

> Unless... there are probably more things writing on the home
> partition than on the mail partition any time.

*nod*

> >>To me, there are two problems:
> >>
> >> 1) The corruption itself.
> >> 2) That xfs_repair fails to repair the filesystem. In fact, I believe
> >>    it does not detect it!
> >
> >That's because the filesystem is likely to be consistent on disk.
> >The issue is in-memory corruption, not on-disk corruption, like
> >the messages are telling us:
> 
> No, the on disk filesystem is not healthy. If I continue using it,
> after reboot and using "xfs_repair" several times, it fails again
> within a day.

After at least one hibernation and thaw cycle, right?

FWIW, to rule out other issues with repair, you should probably
upgrade to the 3.2.0 xfsprogs release...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
