Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5CERrqk207892 for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 09:27:54 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 479011491183
	for <xfs@oss.sgi.com>; Fri, 12 Jun 2009 07:35:29 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id XB81YjJQdDUNx6rr for
	<xfs@oss.sgi.com>; Fri, 12 Jun 2009 07:35:29 -0700 (PDT)
Message-ID: <4A3265F8.1080703@sandeen.net>
Date: Fri, 12 Jun 2009 09:28:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: grub no longer being maintained?  drops support for XFS?
References: <4A31E0FF.8050400@tlinx.org>
In-Reply-To: <4A31E0FF.8050400@tlinx.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Linda A. Walsh" <suse@tlinx.org>
Cc: SuSE Linux <opensuse@opensuse.org>, xfs-oss <xfs@oss.sgi.com>

Linda A. Walsh wrote:
> I just saw this bug, https://bugzilla.novell.com/show_bug.cgi?id=459792,
> that reports a problem in OpenSUSE with Grub being unable to boot with
> XFS when someone upgraded from OpenSuSE11.0 to OpenSuSE11.1.
> Quote:
> 
> Grub is unable to start if /boot is on xfs partition.
> Found after updating from 11.0 to 11.1.

Well, I see we have a thread...

Grub makes bad assumptions about what it can do to a filesystem, and the
problems lie with reading directly from and writing directly to a
filesystem's block device while it's -mounted-, when grub is being
installed.

Sometimes this even trips up ext3 as well, but the problem is more
obvious with xfs.  If you look at all the sync sync sync sleeps in grub
you'll see that they are desperately trying to make the block device
coherent with the filesystem, which they simply cannot do with syncs and
sleeps.  Some distros have tried adding xfs_freeze calls to quiesce the
filesystem, and when this can be done, it generally works, but it'd be
better if grub would just not do IO to the device while it's mounted, in
general.

That being said, hch's recent xfs sync changes should make this much
more likely to succeed in the future at least, despite grub's notions of
what's safe.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
