Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CAB1E7F55
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 10:06:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 60382AC002
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 08:06:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WQ7CC3vYqTXRCTtC for <xfs@oss.sgi.com>;
	Fri, 02 May 2014 08:06:46 -0700 (PDT)
Message-ID: <5363B416.2010905@sandeen.net>
Date: Fri, 02 May 2014 10:04:54 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <5363A1D8.2020402@gmail.com>
In-Reply-To: <5363A1D8.2020402@gmail.com>
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

On 5/2/14, 8:47 AM, Martin Papik wrote:
> 
> 
> I ran into a problem using XFS. The USB device on which I have an XFS
> file system got disconnected and xfs_repair and xfs_check fail with a
> message saying the file system is mounted writable. There is no entry
> in /etc/mtab or /proc/mounts. However I see messages in the kernel log
> (dmesg) about write failures to the disconnected drive.
> 

platform_check_iswritable() and platform_check_ismounted() in xfsprogs check
these things.

platform_check_ismounted() does a ustat() of the block device,
"ustat() returns  information  about  a mounted file system"
and it knows if it's mounted or not,
"EINVAL: dev does not refer to a device containing a mounted file system."

so something, somewhere thinks it's mounted.  Check /proc/mounts?

> Please let me know what I can do short of zeroing the log, which I
> believe would result in some data loss.

Hate to say it, but a reboot may be simplest.  Zeroing the log won't
help.

- -Eric

> Martin
> 
> 
> # xfs_repair /dev/sdd104
> xfs_repair: /dev/sdd104 contains a mounted filesystem
> 
> fatal error -- couldn't initialize XFS library
> # xfs_check /dev/sdd104
> xfs_check: /dev/sdd104 contains a mounted and writable filesystem
> 
> fatal error -- couldn't initialize XFS library
> 
> 
> partial dmesg output:
> 
> [346220.652432] Buffer I/O error on device sdb104, logical block
> 3906961152
> [346220.652440] Buffer I/O error on device sdb104, logical block
> 3906961153
> [346220.652443] Buffer I/O error on device sdb104, logical block
> 3906961154
> [346220.652446] Buffer I/O error on device sdb104, logical block
> 3906961155
> [346220.652449] Buffer I/O error on device sdb104, logical block
> 3906961156
> [346220.652452] Buffer I/O error on device sdb104, logical block
> 3906961157
> [346220.652455] Buffer I/O error on device sdb104, logical block
> 3906961158
> [346220.652459] Buffer I/O error on device sdb104, logical block
> 3906961159
> [346220.652473] Buffer I/O error on device sdb104, logical block
> 3906961352
> [346220.652476] Buffer I/O error on device sdb104, logical block
> 3906961353
> [346554.917502] quiet_error: 1924 callbacks suppressed
> [346554.917510] Buffer I/O error on device sdb104, logical block 0
> [346554.917518] Buffer I/O error on device sdb104, logical block 1
> [346554.917522] Buffer I/O error on device sdb104, logical block 2
> [346554.917525] Buffer I/O error on device sdb104, logical block 3
> [346554.917529] Buffer I/O error on device sdb104, logical block 4
> [346554.917532] Buffer I/O error on device sdb104, logical block 5
> [346554.917536] Buffer I/O error on device sdb104, logical block 6
> [346554.917539] Buffer I/O error on device sdb104, logical block 7
> [346554.951030] Buffer I/O error on device sdb104, logical block
> 3906961152
> [346554.951051] Buffer I/O error on device sdb104, logical block
> 3906961153
> 
> The current disk is /dev/sdd104 and sdb104 doesn't appear anywhere in
> the kernel, despite the messages in dmesg.
> 
> # cat /proc/partitions
> major minor  #blocks  name
> 
>    7        0     131072 loop0
>    8        0  488386584 sda
>    8        1     204800 sda1
>    8        2  104384512 sda2
>    8        3          1 sda3
>    8        4   15471640 sda4
>    8        5   30403584 sda5
>    8        6     104391 sda6
>    8        7  117187584 sda7
>   11        0    1048575 sr0
>    8       64 1953481728 sde
>    8       75 1953480687 sde11
>    8       80  312571224 sdf
>    8       48 1953481728 sdd
>  259        0 1953480687 sdd104
> 
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTY7QVAAoJECCuFpLhPd7gh8sP/3etms+dvasiiUX6dEwoGf4C
uiZarjqYG6liwMgBgtsfBfHs35p5r70kab55kf6keAx0zIvFewQbyCGKZ931Ok1B
c0XgXaBVrSCzEtgRAJjJMDnIguEOCn0E/duIkjRcq7Gp8lcb1C83yr9fJ16HMYaz
xdYy1Gc3VeDmVAZ3Bf3ojXu1Uqeaa0QZjFSTx7cdUXtsftxtIO906snqU+xc8+pr
BPwzneWntEYiR8Fy5ZyjFCwnhlLnfRwu/EivUkLCcNIBHANko12Uzf/0t0xvcTGQ
z+VZzmZF5Us8ytFsTqfP6a55jQeWU5p2jr7flRSLnjDZ3RK3wUXIK1Yvngq+zTc6
57o2EhNNBTjqLkIzqDG5rAJYVNsv/9gIR3u7QzbdpzquwSHborfUDLS9Ss3saK8D
Qk7FgyM72sNyI5KntO0/HFc443Qvj3ptWfgFengCSd8pDklnIGMC2ykT2MRVazm4
QmeX9XCQ40SZ6y/X67dMrR6hLMSbij7XXZkRjOAFTWkePLNvo2RjzHBW8gFEybHM
d/uFP5HWGtKqUEgwUoQWQ+U/MENv878UqT1Hq7XRNtt+TCWNQQOzuAMbdUSniuCG
V1WFVZEKsKqmzBJ5bdOLXmkUPXcV73Ou2vvTfRqDCHcPIKJTd9Yq/lNZAE5I6NiE
mM4LhitVZUvUn/94NGvX
=m/u5
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
