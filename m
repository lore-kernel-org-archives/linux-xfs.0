Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CBF037F61
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 11:53:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BF25C8F804B
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 09:53:00 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dVGMqnjfHQ2jpON2 for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 09:52:59 -0700 (PDT)
Message-ID: <5363CD70.3000006@sandeen.net>
Date: Fri, 02 May 2014 11:53:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <5363A1D8.2020402@gmail.com> <5363B4C9.4000900@sandeen.net>
	<5363CB5E.3090008@gmail.com>
In-Reply-To: <5363CB5E.3090008@gmail.com>
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
To: Martin Papik <mp6058@gmail.com>, xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 5/2/14, 11:44 AM, Martin Papik wrote:
> 
>> so something, somewhere thinks it's mounted.  Check /proc/mounts?
> 
> There was nothing in /proc/mounts, nor was there any visible reference
> in /proc. If there was, the first thing I would have done is to make
> sure no process is using the FS. But I only did it later based on a hunch.

BTW sorry for replying twice, my mailer was being weird and the first
one didn't seem to send.

>>> Please let me know what I can do short of zeroing the log, which
>>> I believe would result in some data loss.
> 
>> Hate to say it, but a reboot may be simplest.  Zeroing the log
>> won't help.  OTOH, if you lost USB connectivity, you already lost
>> some data.
> 
> Please explain why losing USB connectivity means I've lost data. Is a
> SATA/SCSI/NBD disconnect less likely to lose data?

If the device goes away and does not come back, any pending buffered data
to that device will be lost.  That's true of any filesystem, on any type
of connection.

i.e. these IOs have nowhere to go:

> [346220.652432] Buffer I/O error on device sdb104, logical block
> 3906961152

and if they can't ever hit the disk, they'll be lost.

In the USB case when it comes back with a new name, as far as I know
there is no mechanism to handle that anywhere in the kernel.

> Is XFS is not stable enough to function without a need to reboot in
> case of a relatively minor HW failure? Minor meaning affecting only
> some disks.

It's not a question of XFS stability, IMHO.  XFS was talking to device A;
device A went away and never came back.

The issue of being unable to repair it seems to have been a result of files
still open on the (disappeared) device?  Once you resolved that, all was
well, and no reboot was needed, correct?

I suggested the reboot as a big-hammer fix to clear the mysterious stale
mount; turns out that was not required, apparently.

If ustat(device) was reporting that it's mounted, but /proc/partitions
didn't show it, then the device was in some kind of limbo state, I guess,
and that sort of umount handling is below XFS (or any other filesystem),
as far as I know.

What initiated the unmount, was it you (after the USB disconnect) or some
udev magic?

- -Eric

> Martin
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTY81vAAoJECCuFpLhPd7gSxYP/0FEYa82SBczZZLRDe9MWvqC
/lMK475w5wHaHfHcgph9f8i7YbAirrpIS42+QqHVKp92SE5kGRbHhNorUp2Me202
4fvt4oLbro7UxA66BsdrCG7OuaRB4+6FUYGsI6EudnwIAwvG3jur8urf61vZIb+8
BXSd2Y7Z+wQIqPIEKB2n4myrgyZC8GlW0ILNynqL1DFW3y0bkxgV/kFZFTbReOb0
Er0ekrW8A8eQ8R6mU8/msCfSUgNaqSyStkU3Vw35m1gGc+BLE4tArRsCb/AF414j
U9JzgFLtGaf8xdfbmTrOsduaIwchv3F+NaHimClpHMHGaxiBpXkNXrWxGVvy76Fd
IpGTsqnjBP5Dhh35ymrmOgE3YR+GNax0ckjd4gpW15QHhjiHWayCQEMc1GZ9VWKj
USXmT+jENLGGorF8hjWFuC8rMVjWyGwMKFU6wK9xQxHrxn/6/eJqu3DGnV2Bpj70
XTNHvVAn+AFo9tiFd3S1kqiXvZ/HB/mM3DRf5KNkGtpGxTtKxhpNnujG4w6QIkZw
ltAAM/i0iBrq/llb3tfthnwZpSUnqwvY+hYh51TRjAA+HBnRfrQygOozrpSfEeIN
ebJmyFoLpbTLiRFcUzqnpOlhcX5X1dAIw/Llr0Yp57Y38CmQ5XcWjFabgYwdTgkr
2TjHvhDwU5b4mtEG1OOW
=OWFX
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
