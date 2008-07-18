Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Jul 2008 05:00:36 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6KC0XS0018159
	for <xfs@OSS.SGI.com>; Sun, 20 Jul 2008 05:00:34 -0700
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2DA7130B029
	for <xfs@OSS.SGI.com>; Sun, 20 Jul 2008 05:01:42 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk [82.69.39.138]) by cuda.sgi.com with ESMTP id ZltZ95sromzZbo1G for <xfs@OSS.SGI.com>; Sun, 20 Jul 2008 05:01:42 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.68 #1)
	id 1KJuYV-0003A0-2A
	for <xfs@OSS.SGI.com>; Fri, 18 Jul 2008 19:19:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18560.57006.898336.560030@tree.ty.sabi.co.uk>
Date: Fri, 18 Jul 2008 19:19:26 +0100
Subject: RE: Power loss causes bad magic number??
In-Reply-To: <F46A887185FC6044A7FAC577E31118AE021E0625@rsbne01.RSBNE.LOCAL>
References: <F46A887185FC6044A7FAC577E31118AE022316C0@rsbne01.RSBNE.LOCAL>
	<487D5F80.1050909@sandeen.net>
	<F46A887185FC6044A7FAC577E31118AE021E0623@rsbne01.RSBNE.LOCAL>
	<20080716073503.GE29319@disturbed>
	<F46A887185FC6044A7FAC577E31118AE021E0625@rsbne01.RSBNE.LOCAL>
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Linux XFS <xfs@oss.sgi.com>

[ ... ]

> [ ... ] ls of /dev/sd* and the devices have been remapped (any
> idea what would have caused that?), sdc is no longer sdc, it
> is now sda, the boot devices are now detected as sdb and sdc
> (2 mirrored physical disks, used to be sda and sdb).

A BIOS or OS upgrade or just about anything might change the
names of any device because there isn't any well defined
enumeration order for devices.

Therefore the only safe option is the same as used by XFS or MD:
to give a unique name/token, but to all storage volumes.

The most useful scheme would be to give unique names to container
volumes like hard drives and then position based letters/numbers
for partitions (because for partitions the ordering is well
defined), but no current GNU/Linux distro supports that.

Probably you should then investigate the 'LABEL=' and 'UUID='
options of '/etc/fstab'.

> How was the machine able to boot? [ ... ]

Depends a bit on which booter you have installed; for example
LILO nowadays uses MS-DOS volume IDs to identify hard drives.
GRUB does not, and therefore I have stopped using it, as the
frequent drive reordering that I suffer has made it almost
unusable.

Also, the BIOS (used for booting) and Linux can and will number
drives in a different order, so the BIOS boot drive may well be
not '/dev/sda' or '/dev/hda'.
