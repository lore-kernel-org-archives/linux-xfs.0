Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q15F5qiu046877 for <xfs@oss.sgi.com>; Sun, 5 Feb 2012 09:05:52 -0600
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id netQ4dAiBQSvOtEt
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Feb 2012 07:05:51 -0800 (PST)
Received: by dady25 with SMTP id y25so5061067dad.26
	for <xfs@oss.sgi.com>; Sun, 05 Feb 2012 07:05:50 -0800 (PST)
Date: Sun, 5 Feb 2012 20:35:44 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Subject: Re: sparsify - utility to punch out blocks of 0s in a file
Message-ID: <20120205150544.GA4319@Xye>
References: <4F2D8F30.3090802@redhat.com>
 <4F2D90B6.4070008@redhat.com>
MIME-Version: 1.0
In-Reply-To: <4F2D90B6.4070008@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2028982446374663455=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>


--===============2028982446374663455==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline


--i0/AhcQY5QxfSsSZ
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,


* On Sat, Feb 04, 2012 at 02:10:30PM -0600, Eric Sandeen <sandeen@redhat.co=
m> wrote:
>On 2/4/12 2:04 PM, Eric Sandeen wrote:
>> Now that ext4, xfs, & ocfs2 can support punch hole, a tool to
>> "re-sparsify" a file by punching out ranges of 0s might be in order.
>
>Gah, of course I sent the version with the actual hole punch commented out=
 ;)
>Try this one.
>
>[root@inode sparsify]# ./sparsify -v fsfile
>blocksize is 4096
>orig start/end 0/536870912/0
>new start/end/min 0/536870912/4096
>punching out holes of minimum size 4096 in range 0-536870912
>punching at 16384 len 16384
>punching at 49152 len 134168576
>punching at 134234112 len 134201344
>punching at 268455936 len 134197248
>punching at 402669568 len 134201344
>[root@inode sparsify]#
>
>Hm but something is weird, right after the punch-out xfs says
>it uses 84K:
>
>[root@inode sparsify]# du -hc fsfile
>84K	fsfile
>84K	total
>
>but then after an xfs_repair it looks saner:
># du -hc fsfile
>4.8M	fsfile
>4.8M	total
>
>something to look into I guess... weird.
>
>
>
>
>_______________________________________________
>xfs mailing list
>xfs@oss.sgi.com
>http://oss.sgi.com/mailman/listinfo/xfs


So I tried with both resparsify and with cp --sparse, the results=20
before xfs_repair looks different (5 extents vs 1) but after that=20
it looks similar (5 extents vs 4)


Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=att

>>dd if=/dev/zero of=tst bs=1M count=100                                                                                                                                                                                                                           (/tmp)~20:08-0
100+0 records in
100+0 records out
104857600 bytes (105 MB) copied, 0.0722117 s, 1.5 GB/s
>>mkfs.xfs tst                                                                                                                                                                                                                                                     (/tmp)~20:08-0
meta-data=tst                    isize=256    agcount=4, agsize=6400 blks
         =                       sectsz=512   attr=2, projid32bit=0
data     =                       bsize=4096   blocks=25600, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
>>filefrag -v tst                                                                                                                                                                                                                                                  (/tmp)~20:08-0
Filesystem type is: ef53
File size of tst is 104857600 (25600 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0   913408            2048
   1    2048  1030144   915456   2048
   2    4096  1024000  1032192   2048
   3    6144   970752  1026048   2048
   4    8192  1026048   972800   2048
   5   10240  1196032  1028096   2048
   6   12288   974848  1198080   2048
   7   14336  1210368   976896   4096
   8   18432   972800  1214464   2048
   9   20480  1214464   974848   4096
  10   24576   915456  1218560   1024 eof
tst: 11 extents found
>>=du -hc tst                                                                                                                                                                                                                                                      (/tmp)~20:08-0
101M    tst
101M    total
>>cp --sparse=always tst tst1                                                                                                                                                                                                                                      (/tmp)~20:08-0
>>=du -hc tst                                                                                                                                                                                                                                                      (/tmp)~20:08-0
101M    tst
101M    total
>>=du -hc tst*                                                                                                                                                                                                                                                     (/tmp)~20:08-0
101M    tst
160K    tst1
101M    total
>>filefrag -v tst1                                                                                                                                                                                                                                                 (/tmp)~20:08-0
Filesystem type is: ef53
File size of tst1 is 104857600 (25600 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0        0              16 unknown,delalloc
tst1: 1 extent found
>>./resparsify tst                                                                                                                                                                                                                                                 (/tmp)~20:09-0
punching out holes of minimum size 4096 in range 0-104857600
>>=du -hc tst*                                                                                                                                                                                                                                                     (/tmp)~20:09-0
88K     tst
160K    tst1
248K    total
>>filefrag -v tst                                                                                                                                                                                                                                                  (/tmp)~20:09-0
Filesystem type is: ef53
File size of tst is 104857600 (25600 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0   913408               4
   1       8   913416   913412      4
   2    6400   971008   913420      4
   3   12800   975360   971012      5
   4   19200   973568   975365      4
tst: 5 extents found>>xfs_repair tst                                                                                                                                                                                                                                                   (/tmp)~20:17-0
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
>>=du -hc tst                                                                                                                                                                                                                                                      (/tmp)~20:19-0
4.8M    tst
4.8M    total
>>filefrag -v tst                                                                                                                                                                                                                                                  (/tmp)~20:19-0
Filesystem type is: ef53
File size of tst is 104857600 (25600 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0   913408               4
   1       8   913416   913412      4
   2    6400   971008   913420      4
   3   12800   975360   971012   1204
   4   19200   973568   976564      4
tst: 5 extents found
>>xfs_repair tst1                                                                                                                                                                                                                                                  (/tmp)~20:20-0
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan and clear agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno = 0
        - agno = 1
        - agno = 2
        - agno = 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno = 0
        - agno = 3
        - agno = 2
        - agno = 1
Phase 5 - rebuild AG headers and trees...
        - reset superblock...
Phase 6 - check inode connectivity...
        - resetting contents of realtime bitmap and summary inodes
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify and correct link counts...
done
>>=du -hc tst1                                                                                                                                                                                                                                                     (/tmp)~20:23-0
4.9M    tst1
4.9M    total
>>filefrag -v tst1                                                                                                                                                                                                                                                 (/tmp)~20:23-0
Filesystem type is: ef53
File size of tst1 is 104857600 (25600 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0  1218560              16
   1    6400  1231104  1218576      8
   2   12800  1237504  1231112   1204
   3   19200  1239808  1238708      8
tst1: 4 extents found
--NzB8fVQJ5HfG6fxh--

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPLprIAAoJEKYW3KHXK+l39rYH/3ueIO9O1bY1wD/oAJXgYiGd
QPTOpDWmHWkriT57WzVPAOb3OZnzN2pC7z6vgsJf7JA46UBLQJ//flj7qBWBQ6kK
+dwYiaRcwiQoCVpiCq2FYgAxgfVUzUth2fUYkfdKPCGITUUeuEZEYLLH+xqQSI6o
zYNAX+YOLfpfG2zd6lhovF9TzEn8BDjvqvfUxBuKBbLT4ds/Ahd1M5/hXNw9VTse
qfvYnm1r6hV0y4nOKZSqd4rr4XdIChGf3/QRaroL4Zz4FOhEQoGFfhHy8IWr76hm
G6Z2v85jJkWhpYGRZeEZiv9wTZUrTM8axVLc16YQAZ88UJeAhltRiamJVQ/I6Gk=
=i4Rl
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--


--===============2028982446374663455==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2028982446374663455==--
