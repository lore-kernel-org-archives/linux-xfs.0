Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2897A7F61
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:42:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 085CA8F8040
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 03:42:20 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id rH7GPGhvEtJZszRJ for
	<xfs@oss.sgi.com>; Tue, 12 Mar 2013 03:42:19 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: XFS filesystem corruption
Date: Tue, 12 Mar 2013 11:42:13 +0100
References: <CAPcwv6wZJSBtgF-L6KNSn6N6Y+wUZJFXdbcg+zYRwoaB2sDdjw@mail.gmail.com>
	<5137CD46.6070909@redhat.com> <5139A3B6.3040805@hardwarefreak.com>
	(sfid-20130308_132012_037479_915CAB49)
In-Reply-To: <5139A3B6.3040805@hardwarefreak.com>
MIME-Version: 1.0
Message-Id: <201303121142.13980.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, stan@hardwarefreak.com
Cc: Julien FERRERO <jferrero06@gmail.com>, Ric Wheeler <rwheeler@redhat.com>

Am Freitag, 8. M=E4rz 2013 schrieb Stan Hoeppner:
> If the techs are determined to hard cut power because they don't have
> the time or the knowledge to do a clean shutdown, it may be well worth
> your time/effort to write a script and teach the field techs to execute
> it, before flipping the master switch.  Your simple script would run as
> root, or you'd need to do some sudo foo within, and would contain
> something like:
> =

> #! /bin/sh
> sync
> echo 2 > /proc/sys/vm/drop_caches
> echo "Ready for power down."

mount -o remount,ro /your/mount/point

One can at least try. Maybe some "service stop" commands before that.

But then, if using a script like this, why not just type "halt"?

Heck, Linux kernel / userspace / distro developers prepared safe shutdown =

already, so why not use it?

Another idea:

On Debian Usually on Ctrl-Alt-Delete on a TTY get a shutdown:

# What to do when CTRL-ALT-DEL is pressed.
ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now


Then you plug a keyboard to the server and tell the local admins to just =

press Ctrl-Alt-Del in order to shutdown the server instead of the power =

button.

But heck, even just pressing the power button for a short period of time =

should work. In Debian it does. So you can just tip the power button.

So, I do see not much of a reason to not shutdown the server properly.

Ciao,
-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
