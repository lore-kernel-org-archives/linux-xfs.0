Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 69A437F3F
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 17:51:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 581D7304043
	for <xfs@oss.sgi.com>; Wed,  6 Feb 2013 15:51:41 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	j4DaL8OdHMs97aah for <xfs@oss.sgi.com>;
	Wed, 06 Feb 2013 15:51:39 -0800 (PST)
Date: Thu, 7 Feb 2013 10:51:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
Message-ID: <20130206235137.GV2667@dastard>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<20130129151833.GF27055@sgi.com>
	<42720.75.149.17.233.1359515780.squirrel@secure.skymagik.net>
	<20130130234650.GE32297@disturbed.disaster>
	<45702.75.149.17.233.1359599410.squirrel@secure.skymagik.net>
	<20130204125510.GL2667@dastard>
	<11083.192.104.24.222.1360088562.squirrel@secure.skymagik.net>
	<20130205213206.GP2667@dastard>
	<55720.75.149.17.233.1360123732.squirrel@secure.skymagik.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55720.75.149.17.233.1360123732.squirrel@secure.skymagik.net>
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
To: Tom <storm9c1@skymagik.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 05, 2013 at 11:08:52PM -0500, Tom wrote:
> In a previous message, Dave Chinner wrote:
> >
> > Find out if the unmount is returning an error first. If there is no
> > error, then you need to find what is doing bind mounts on your
> > system and make sure they are unmounted properly before the final
> > unmount is done. If lazy unmount is being done, make it a normal
> > unmount an see where the unmount is getting stcuk or taking time to
> > complete by using sysrq-w if it gets delayed for any length of time.
> 
> OK, here is what I did tonight.  I added debug toward the end of
> /etc/rc.d/rc6.d/S01reboot  ...where the umounts are normally handled.

> DEBUG: remounting '/' as read-only using 'mount -n -o ro,remount'
> DEBUG: remounting '/proc' as read-only using 'mount -n -o ro,remount'
> mdadm: failed to set readonly for /dev/md3: Device or resource busy

EBUSY means one of two possibilities:

	1. there's a file still open for write. => lsof
	2. there's an unlinked but still open file => lsof

But I don't think that's the problem at all.

> Please stand by while rebooting the system...
> md: stopping all md devices.
> md: md2 switched to read-only mode.
> md: md1 switched to read-only mode.
> (hang)
> 
> Just for kicks, I get the same output with the 308 kernel, with the
> addition of this:
> 
> md: md3 still in use.

Which implies that the problem is a change in behaviour in the md
layer or below. i.e. previously md just saw that it was busy and
did not try to tear down the device. Now it is trying to tear down
the device with a filesystem that is still active on it.

> But the same system happily reboots just fine with the 308 kernel even
> after producing that "still in use" message that 348 does not produce.

Right, because it correctly detects the filesystem is still in use
and doesn't try to tear down the device.

> I did some more experiments with mdadm and I can't get any underlying
> md device to go into read-only mode even if the fs is mounted read-only.
> The only way I could get that to work is if the fs is completely unmounted.
> Whether it is XFS or ext3.  Yet a system on ext3 reboots fine.

And that will be because ext3 won't be issuing any IO on the sync
that is triggered when tearing down the MD device. XFS is writing
the superblock, and that's where the MD device is hanging on itself.

> Is there more specific information that I can gather that may help?

No need - I can tell you the exact commit in the RHEL 5.9 tree that
caused this regression:

11ff4073: [md] Fix reboot stall with raid on megaraid_sas controller

The result is that the final shutdown of md devices now uses a
"force readonly" method, which means it ignores the fact that a
filesystem may still be active on top of it and rips the device out
from under the filesystem. This really only affects root devices,
and given that XFs is not supported as a root device on RHEL, it
isn't in the QE test matrix and so the problem was never noticed.

Feel free to report this all to the RH bugzilla - depending the
implications of the regression for supported configurations, it may
need to be fixed in RHEL anyway.

But now you know the problem, you can probably fix it yourself
rather than have to wait for RHEL/CentOS product cycle updates...

Cheers,

Dave.

PS: has the fact I quoted a RHEL5.9 commit id triggered a lightbulb
moment for you yet?  Hint: my other email address is
dchinner@redhat.com - this XFS community support effort was brought
to you by Red Hat.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
