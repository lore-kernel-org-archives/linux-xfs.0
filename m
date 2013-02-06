Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 55E237F3F
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 22:08:59 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 42EF7304039
	for <xfs@oss.sgi.com>; Tue,  5 Feb 2013 20:08:56 -0800 (PST)
Received: from thunder.skymagik.net (thunder.skymagik.net [76.75.207.68]) by
	cuda.sgi.com with ESMTP id QR67t1bdwdgNIBlH for
	<xfs@oss.sgi.com>; Tue, 05 Feb 2013 20:08:55 -0800 (PST)
Message-ID: <55720.75.149.17.233.1360123732.squirrel@secure.skymagik.net>
Date: Tue, 5 Feb 2013 23:08:52 -0500 (EST)
Subject: Re: XFS appears to cause strange hang with md raid1 on reboot
From: "Tom" <storm9c1@skymagik.com>
In-Reply-To: <20130205213206.GP2667@dastard>
References: <32271.192.104.24.222.1359415698.squirrel@secure.skymagik.net>
	<20130129151833.GF27055@sgi.com>
	<42720.75.149.17.233.1359515780.squirrel@secure.skymagik.net>
	<20130130234650.GE32297@disturbed.disaster>
	<45702.75.149.17.233.1359599410.squirrel@secure.skymagik.net>
	<20130204125510.GL2667@dastard>
	<11083.192.104.24.222.1360088562.squirrel@secure.skymagik.net>
	<20130205213206.GP2667@dastard>
MIME-Version: 1.0
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
To: david@fromorbit.com
Cc: storm9c1@skymagik.com, xfs@oss.sgi.com

In a previous message, Dave Chinner wrote:
>
> Find out if the unmount is returning an error first. If there is no
> error, then you need to find what is doing bind mounts on your
> system and make sure they are unmounted properly before the final
> unmount is done. If lazy unmount is being done, make it a normal
> unmount an see where the unmount is getting stcuk or taking time to
> complete by using sysrq-w if it gets delayed for any length of time.

OK, here is what I did tonight.  I added debug toward the end of
/etc/rc.d/rc6.d/S01reboot  ...where the umounts are normally handled.

Turns out that / and /proc cannot be unmounted (of course), so it gets
remounted as read-only.  See output below.

I also noticed that md3 (root fs) isn't showing up in this list
at the very end (I believe these messages are produced by the kernel
md driver):
md: md2 switched to read-only mode.
md: md1 switched to read-only mode.


So just for kicks, I added "mdadm --readonly --force /dev/md3" as well
after the umounts.  Of course /dev/md3 can't be forced into readonly
mode because the root file system is still mounted (albeit also read-only).
So no luck there.


Shutting down interface eth0:  [  OK  ]
Shutting down loopback interface:  [  OK  ]
Starting killall:  [  OK  ]
Sending all processes the TERM signal...
Sending all processes the KILL signal...
Saving random seed:
Syncing hardware clock to system time
Turning off swap:
Unmounting pipe file systems:
Unmounting file systems:

DEBUG: remounting '/' as read-only using 'mount -n -o ro,remount'
DEBUG: remounting '/proc' as read-only using 'mount -n -o ro,remount'
mdadm: failed to set readonly for /dev/md3: Device or resource busy

Please stand by while rebooting the system...
md: stopping all md devices.
md: md2 switched to read-only mode.
md: md1 switched to read-only mode.
(hang)

Just for kicks, I get the same output with the 308 kernel, with the
addition of this:

md: md3 still in use.

But the same system happily reboots just fine with the 308 kernel even
after producing that "still in use" message that 348 does not produce.


I did some more experiments with mdadm and I can't get any underlying
md device to go into read-only mode even if the fs is mounted read-only.
The only way I could get that to work is if the fs is completely unmounted.
Whether it is XFS or ext3.  Yet a system on ext3 reboots fine.

During reboot, I would expect /proc and / to be still mounted, albeit
read-only, and I would expect that md should be able to handle this.
But it can't.  What I didn't expect is the mdadm behavior to be consistent
between the 308 and 348 kernels.  But it is.  So something special happens
at the moment of reboot (that's different than what mdadm allows).

Now why this only happens with XFS and not ext3 is beyond me.

Is there more specific information that I can gather that may help?

-- Tom



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
