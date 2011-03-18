Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2IHinUZ047749 for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 12:44:55 -0500
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id C781413C06E4
	for <xfs@oss.sgi.com>; Fri, 18 Mar 2011 10:47:46 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with SMTP id O5V4WBbvBFpFzDpU for
	<xfs@oss.sgi.com>; Fri, 18 Mar 2011 10:47:46 -0700 (PDT)
Date: Fri, 18 Mar 2011 13:47:45 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
In-Reply-To: <Pine.LNX.4.44L0.1103181135190.2391-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.02.1103181346340.21715@p34.internal.lan>
References: <Pine.LNX.4.44L0.1103181135190.2391-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-1100183954-1300470465=:21715"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Piszcz <ap@solarrain.com>, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-1100183954-1300470465=:21715
Content-Type: TEXT/PLAIN; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 18 Mar 2011, Alan Stern wrote:

> On Fri, 18 Mar 2011, Justin Piszcz wrote:
>
>> Hi,
>>
>> I can write to just about the entire USB stick, with no errors:
>>
>> atom:~# df -h
>> Filesystem            Size  Used Avail Use% Mounted on
>> /dev/sda2             5.8G  1.5G  4.3G  26% /
>> tmpfs                 2.0G     0  2.0G   0% /lib/init/rw
>> udev                   10M  140K  9.9M   2% /dev
>> tmpfs                 2.0G     0  2.0G   0% /dev/shm
>> atom:~# cd /
>> atom:/# ls
>> bin   cdrom  etc   lib    media  nfs  proc  sbin     srv  tmp  var
>> boot  dev    home  lib64  mnt    opt  root  selinux  sys  usr
>> atom:/# dd if=3D/dev/zero of=3Dbigfile bs=3D1M count=3D4000
>> 4000+0 records in
>> 4000+0 records out
>> 4194304000 bytes (4.2 GB) copied, 135.536 s, 30.9 MB/s
>> atom:/# df -h
>> Filesystem            Size  Used Avail Use% Mounted on
>> /dev/sda2             5.8G  5.4G  350M  95% /
>> tmpfs                 2.0G     0  2.0G   0% /lib/init/rw
>> udev                   10M  140K  9.9M   2% /dev
>> tmpfs                 2.0G     0  2.0G   0% /dev/shm
>> atom:/# rm bigfile
>>
>> However, after some amount of time, the errors occur below, is this USB
>> stick failing?  Since it has no SMART, is there any other way to verify
>> the 'health' of a USB stick?
>
> None that I know of.
>
>> Mar 18 07:55:12 atom [   10.034310] e1000e 0000:03:00.0: eth1: 10/100 sp=
eed: disabling TSO
>>
>> [ .. no errors .. ]
>>
>> Mar 18 08:32:44 atom [ 2261.883848] usb 1-1: USB disconnect, address 2
>> Mar 18 08:32:44 atom [ 2261.884465] Buffer I/O error on device sda2, log=
ical block 1317256
>
> The stick didn't "fail" in any obvious way, but for some reason it was
> disconnected from the USB bus.  (If it initiated that disconnect by
> itself, I guess you could consider that a failure.)  Maybe it was
> something as simple as overheating causing a loss of electrical contact
> between the connector and the pins in the USB port.

It is possible, but the box is kept cool:

w83627dhg-isa-0ca0
Adapter: ISA adapter
Vcore:       +1.16 V  (min =3D  +0.72 V, max =3D  +1.39 V)=20
in1:         +1.04 V  (min =3D  +0.94 V, max =3D  +1.16 V)=20
AVCC:        +3.34 V  (min =3D  +2.96 V, max =3D  +3.63 V)=20
+3.3V:       +3.34 V  (min =3D  +2.98 V, max =3D  +3.63 V)=20
in4:         +1.84 V  (min =3D  +1.62 V, max =3D  +1.98 V)=20
in5:         +1.26 V  (min =3D  +1.13 V, max =3D  +1.38 V)=20
in6:         +0.75 V  (min =3D  +0.67 V, max =3D  +0.83 V)=20
3VSB:        +3.30 V  (min =3D  +2.96 V, max =3D  +3.63 V)=20
Vbat:        +3.07 V  (min =3D  +2.96 V, max =3D  +3.63 V)=20
fan1:          0 RPM  (min =3D  727 RPM, div =3D 64)  ALARM
fan2:          0 RPM  (min =3D  727 RPM, div =3D 64)  ALARM
fan3:          0 RPM  (min =3D  727 RPM, div =3D 64)  ALARM
fan4:       1240 RPM  (min =3D  712 RPM, div =3D 8)
fan5:          0 RPM  (min =3D  727 RPM, div =3D 64)  ALARM
temp1:       +36.0=C2=B0C  (high =3D +75.0=C2=B0C, hyst =3D +70.0=C2=B0C)  =
sensor =3D thermistor
temp2:       +35.5=C2=B0C  (high =3D +90.0=C2=B0C, hyst =3D +87.0=C2=B0C)  =
sensor =3D diode
temp3:       +19.0=C2=B0C  (high =3D +80.0=C2=B0C, hyst =3D +75.0=C2=B0C)  =
sensor =3D diode
cpu0_vid:   +0.000 V

coretemp-isa-0000
Adapter: ISA adapter
Core 0:      +12.0=C2=B0C  (crit =3D +100.0=C2=B0C)

coretemp-isa-0001
Adapter: ISA adapter
Core 1:      +16.0=C2=B0C  (crit =3D +100.0=C2=B0C)

>
> ...
>> Mar 18 08:33:06 atom [ 2283.963059] usb 1-1: new high speed USB device u=
sing ehci_hcd and address 4
>> Mar 18 08:33:06 atom [ 2284.080647] usb 1-1: New USB device found, idVen=
dor=3D0325, idProduct=3Dac02
>> Mar 18 08:33:06 atom [ 2284.080707] usb 1-1: New USB device strings: Mfr=
=3D1, Product=3D2, SerialNumber=3D3
>> Mar 18 08:33:06 atom [ 2284.080752] usb 1-1: Product: R2_TURBO
>> Mar 18 08:33:06 atom [ 2284.080794] usb 1-1: Manufacturer: OCZ Technolog=
y
>> Mar 18 08:33:06 atom [ 2284.080831] usb 1-1: SerialNumber: (removed)
>
> And then 22 seconds later it reconnected.
>
> Alan Stern
>

Very strange, could some USB option cause this?  I guess next step is use
ext2 and a different stick in the same port to see if I can get it to recur=
=2E
Then if it happens again, try a different port.

Justin.

--655872-1100183954-1300470465=:21715
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--655872-1100183954-1300470465=:21715--
