Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EEBA07CA0
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 06:16:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BC9058F8033
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 04:16:41 -0700 (PDT)
Received: from mk-outboundfilter-4.mail.uk.tiscali.com
	(mk-outboundfilter-4.mail.uk.tiscali.com [212.74.114.32]) by
	cuda.sgi.com with ESMTP id JBi0ae3FmQNipATi for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2016 04:16:39 -0700 (PDT)
Received: from [192.168.10.10]
	by host-92-27-244-57.static.as13285.net with esmtpsa
	(TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80)
	(envelope-from <ntamplin@codefaber.co.uk>) id 1bAbT5-000813-SN
	for xfs@oss.sgi.com; Wed, 08 Jun 2016 12:16:16 +0100
From: Nigel Tamplin <ntamplin@codefaber.co.uk>
Subject: invalid inode numbers ? after drive moved from Linux 2.6.32 to Linux
	3.16.0 then back again
Message-ID: <5757FE7A.8020504@codefaber.co.uk>
Date: Wed, 8 Jun 2016 12:16:10 +0100
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hello,

I have a drive with a partition containing an XFS file system.
This drive normally resides in a Linux 2.6.32 (Debian 6) server, which 
is also where the file system was created many months ago.
Last week I removed this drive from it's usual 2.6.32 server and for a 
few hours it was attached to an alternative Linux 3.16.0 (Debian 8) 
server, where the XFS file system was mounted and during this time I 
created /modified / deleted some files.
Later the drive was moved back to the normal Linux 2.6.32.

I've noticed something strange has happened.
Some (maybe all) of the files worked on whilst the drive was in the 
Linux 3.16.0 are not accessible when the file system is mounted on the 
Linux 2.6.32.

If I put the drive back in the 3.16.0 server, all files are again 
accessible.

The few files which are inaccessible on 2.6.32 seem to have no inodes 
when viewed under 2.6.32 but look ok when the drive is in 3.16.0


"ls -li" on 3.16.0

7249604387 drwxrwxr-x 2 nigel users      118 Jun  2 16:40 01
     104207 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 02
     101524 drwxrwxr-x 2 nigel users       62 Jun  2 16:39 03
2220005080 drwxrwxr-x 2 nigel users      118 Jun  2 16:40 06
5637828101 drwxrwxr-x 2 nigel users      118 Jun  2 16:40 07
1344499710 drwxrwxr-x 2 nigel users      118 Jun  2 16:40 09
2958135019 drwxrwxr-x 2 nigel users       62 Jun  2 16:39 0b
7516254020 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 0c
5905580833 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 0f
3494120096 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 10
1988369908 drwxrwxr-x 2 nigel users       62 Jun  2 16:40 12
2446706848 drwxrwxr-x 2 nigel users       62 Jun  2 16:40 13
2446706832 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 14
5905580836 drwxrwxr-x 2 nigel users       62 Jun  2 16:40 16
  807056393 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 17
2688006922 drwxrwxr-x 2 nigel users       62 Jun  2 16:40 18


"ls -li" on 2.6.32

          ? ?????????? ? ?     ?            ?            ? 01
     104207 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 02
     101524 drwxrwxr-x 2 nigel users       62 Jun  2 16:39 03
2220005080 drwxrwxr-x 2 nigel users      118 Jun  2 16:40 06
          ? ?????????? ? ?     ?            ?            ? 07
1344499710 drwxrwxr-x 2 nigel users      118 Jun  2 16:40 09
2958135019 drwxrwxr-x 2 nigel users       62 Jun  2 16:39 0b
          ? ?????????? ? ?     ?            ?            ? 0c
          ? ?????????? ? ?     ?            ?            ? 0f
3494120096 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 10
1988369908 drwxrwxr-x 2 nigel users       62 Jun  2 16:40 12
2446706848 drwxrwxr-x 2 nigel users       62 Jun  2 16:40 13
2446706832 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 14
          ? ?????????? ? ?     ?            ?            ? 16
  807056393 drwxrwxr-x 2 nigel users     4096 Jun  2 16:40 17
2688006922 drwxrwxr-x 2 nigel users       62 Jun  2 16:40 18


I notice that the files created on 3.16.0 which cannot be accessed on 
2.6.32, seem to have much higher inode numbers than those which can be 
accessed on both systems.  Could the numbers chosen by 3.16.0 be 
overflowing on 2.6.32 ?  I experimented on another almost empty file 
system, and this seems fine in both systems, but this has very low inode 
numbers, hence my inode number idea.

I can attach the drive to either system and run diagnostic commands if 
more information is required.

Regards,
Nigel

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
