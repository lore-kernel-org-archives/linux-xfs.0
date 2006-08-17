Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 16 Aug 2006 23:36:59 -0700 (PDT)
Received: from mail.rentalia.net (mail.rentalia.com [213.192.209.8])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7H6acDW004070
	for <xfs@oss.sgi.com>; Wed, 16 Aug 2006 23:36:38 -0700
Message-ID: <44E40E50.3070708@rentalia.com>
Date: Thu, 17 Aug 2006 08:36:00 +0200
From: Ruben Rubio <ruben@rentalia.com>
MIME-Version: 1.0
Subject: Re: File problem question
References: <44DC44FA.4060401@rentalia.com> <20060814103139.B2698880@wobbly.melbourne.sgi.com>
In-Reply-To: <20060814103139.B2698880@wobbly.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: xfs@oss.sgi.com

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Nathan Scott wrote:
> On Fri, Aug 11, 2006 at 10:51:06AM +0200, Ruben Rubio wrote:
>> root@rigodon log # pwd
>> /var/log
>> root@rigodon log # ls -al lastlog
>> - -r--------  1 root root 146292 ago 11 10:44 lastlog
>> root@rigodon log # du -sh * | grep lastlog
>> 7,6G    lastlog
> 
> what does "xfs_bmap -vp lastlog" say?

root@rigodon log # xfs_bmap -vp lastlog
lastlog:
 EXT: FILE-OFFSET      BLOCK-RANGE        AG AG-OFFSET        TOTAL
   0: [0..279]:        hole                                     280
   1: [280..287]:      64537592..64537599 15 (17552..17559)       8


> 
> cheers.
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFE5A5QIo1XmbAXRboRApuuAKCEaMWm17e2YWJwbD/sL/aq88+S+wCgpHJi
yFtYxP3wzm+7WS7H/Ci94tk=
=k8IT
-----END PGP SIGNATURE-----
