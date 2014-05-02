Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 190137F5E
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 11:44:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DC1478F804C
	for <xfs@oss.sgi.com>; Fri,  2 May 2014 09:44:20 -0700 (PDT)
Received: from mail-ee0-f50.google.com (mail-ee0-f50.google.com
	[74.125.83.50]) by cuda.sgi.com with ESMTP id O3H1ifQvcorGeZbI
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 May 2014 09:44:15 -0700 (PDT)
Received: by mail-ee0-f50.google.com with SMTP id c13so3367543eek.9
	for <xfs@oss.sgi.com>; Fri, 02 May 2014 09:44:14 -0700 (PDT)
Message-ID: <5363CB5E.3090008@gmail.com>
Date: Fri, 02 May 2014 19:44:14 +0300
From: Martin Papik <mp6058@gmail.com>
MIME-Version: 1.0
Subject: Re: XFS filesystem claims to be mounted after a disconnect
References: <5363A1D8.2020402@gmail.com> <5363B4C9.4000900@sandeen.net>
In-Reply-To: <5363B4C9.4000900@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512


> so something, somewhere thinks it's mounted.  Check /proc/mounts?

There was nothing in /proc/mounts, nor was there any visible reference
in /proc. If there was, the first thing I would have done is to make
sure no process is using the FS. But I only did it later based on a hunch.

>> Please let me know what I can do short of zeroing the log, which
>> I believe would result in some data loss.
> 
> Hate to say it, but a reboot may be simplest.  Zeroing the log
> won't help.  OTOH, if you lost USB connectivity, you already lost
> some data.

Please explain why losing USB connectivity means I've lost data. Is a
SATA/SCSI/NBD disconnect less likely to lose data?

Is XFS is not stable enough to function without a need to reboot in
case of a relatively minor HW failure? Minor meaning affecting only
some disks.

Martin
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJTY8tNAAoJELsEaSRwbVYrbRsQALh8cNWAUElNyGMlJg9xWKE+
hAXtwIgX8/zkdMAHKbqHCuGmid+D3FF6kMW5VJUH/i3+OW5l9BD+zps9QqBtTW6X
XZjjV3AOslLK6EKm5S796z/42QNIPZUprqJZKkyI70N6BhtfaIEIN+iaSaPWNLjd
AgB/Mh57NCziISsfGbGWiq3x1X/0/qs7LvzlFcuQEcq8KlesjJNybPqMZloMuYMO
G9tQ9X403bnZBMzn7LXIwii+0hAVylLA94L3C6ygar2PcZagrwp6sUVEN1DP8KXu
2ghlrV4EBkRIJmk7ckUAjc45E9zK17qFOfUg/j3UO8q4rS4BtoQapxvZwb+4np2R
RbhLJu/o+OvEfd7mTnMvHk7INDnalqnAkKCrKzJ/I9cgmNvl5GOwSaclDDynMH2/
8ZftI5lBOtnZ1BXSRjm+l7WuxxIQPKTGKjGAlDoFkyhZu4T1BJ9UA4Cx8dRdEW/1
V2pzuSuPhBvQ92x45PC7HDGByxc2AIBGM8+zPTdFA9z9dht0T4R4VSgyUgx53FvP
lyZ63ZzLLsaMY3KCeQefqWIsRCbBwTIKLoqjX7iEQ9MAUBo6OnqL5u6Hc+I/35gO
I1u7uTaDnrQoqqGc+F9rA9ApW7bYbuq+hmuhr3stsYGrHCMSyRcHR3gbeVMKH/NR
AD2DbwmwDv0h/NEf1DER
=/tYi
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
