Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 02E497F59
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 11:26:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D86B730404E
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 09:26:31 -0700 (PDT)
Received: from mail-ee0-f41.google.com (mail-ee0-f41.google.com
	[74.125.83.41]) by cuda.sgi.com with ESMTP id MDxPXrmSbkYd2w7s
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 May 2014 09:26:29 -0700 (PDT)
Received: by mail-ee0-f41.google.com with SMTP id d49so576663eek.14
	for <xfs@oss.sgi.com>; Fri, 02 May 2014 09:26:28 -0700 (PDT)
Message-ID: <5363C734.6050901@gmail.com>
Date: Fri, 02 May 2014 19:26:28 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <5363A1D8.2020402@gmail.com> <5363B4C9.4000900@sandeen.net>
	<5363BD62.7050707@sgi.com>
In-Reply-To: <5363BD62.7050707@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 05/02/2014 06:44 PM, Mark Tinguely wrote:
> 
> Please do a "ps -ef" before umount to see if the unmount is hung.
> 
> --Mark.

Can't do that any more, I think I've figured out part of the problem
and "resolved" it. There's nothing in "ps -ef" any more, maybe there
was. What seemed to be the problem was that after the device got
disconnected the xfs module was still aware of the mount, even though
I could not see it in /proc/mounts or find any other trace of it
anywhere. After I went through all processes which had a working
directory on the mounted device and changed it to something else the
xfs was able to complete its job. But before then it wasn't allowing
me to do anything.

It's strange that I didn't see xfs mounted (/proc/mounts) or was able
to see any directories (find /proc -type l -ls | grep <mount-dir>)
used. Any idea why this is? Personally I think this is some kind of a
bug. IMHO the xfs driver should be able to inform the user/admin that
the filesystem is still in use.

Below is what appeared in the kernel log after the last process
stopped using the filesystem.

One more question, even though in this case it's moot now, is there
any possibility of telling xfs that device sdd104 is the new sdb104
and tell it to resume writing where it left off? I know there are
risks involved, especially if the USB device device doesn't report
write completion correctly (FUA). But I'd like to know. I believe that
in this case it would have been safe, the filesystem was idle for at
least an hour before the USB disconnected.

Martin

[352505.707397] XFS (sdb104): metadata I/O error: block 0x7470230c
("xlog_iodone") error 19 numblks 64
[352505.707415] XFS (sdb104): xfs_do_force_shutdown(0x2) called from
line 1115 of file
/build/buildd/linux-lts-raring-3.8.0/fs/xfs/xfs_log.c.  Return address
= 0xffffffffa07f4fd1
[352505.707445] XFS (sdb104): Log I/O Error Detected.  Shutting down
filesystem
[352505.707448] XFS (sdb104): Please umount the filesystem and rectify
the problem(s)
[352505.707452] XFS (sdb104): Unable to update superblock counters.
Freespace may not be correct on next mount.
[352505.707463] XFS (sdb104): xfs_log_force: error 5 returned.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTY8cfAAoJELsEaSRwbVYrOvoP/jaeYZ59qbqhZCauO6Lhir1i
zWKyfX6R3vNfQPmu0mWeVn/1+uqmufEbtK6gXoROJsta+7YaBDZtnRvuvN5JeE76
GR9ZxS7Jghffj+CbSwoI+q41K6dorD+fTpHm8uUbsYkNq1N4eVfrULP+7PcchjLx
mRDkeffHdESSLF3ZtXhMD/cd7Ok6ILG2PpJ5+yEVu2XKr6QLgOMY8cIUpoDNoKgh
/Mawcex1Bz6oItXPGTWth34harbnbOUOU3gRfd6pbXxvXlFfIihUkg6cpre55U0o
O6H+3KGZj9gGtxP+Atcb1dc4oJaT7J+SL6PTBNmRuP5oqqGWI2YPDiuQX3BnJMZv
VrV78rkJLjMNAmS9c47TkJe9No267dOFK+6pZXj+b3gsmg1/5PrhSJnt5IdVrU6+
kext/CGmtb80Q8O/K6WBb5VmQTD0ZhLV+UPEgllRn8QOu8RfGjp5NgGyeFcqLuWb
YgS2OMp1F+EZ/wnXf0LgQECq0FLj5UBmOmhri3fJ3pHlusOjq/VCNIPcCgTl4YaA
F7eiM/tYy7m42USyyT76N0g1lAqPq26INfFCiXdGdJGUfdHiK8/ucoGIvsEW8lY8
cfZFSOdfpWtqZLytr8tOVA8rs4c+7EZcnuxb9T49qcPvf9/lL2WRSOWShTdCz6cV
sE//zq0BJttX8VDTCp1G
=z+sB
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
