Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 19:32:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8K2WVuw000462
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 19:32:35 -0700
Date: Thu, 20 Sep 2007 12:36:52 +1000
Subject: Re: Cant find sunit and swidth on luks encrypted raid6 device
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <728b8e3b0709191129j27b7c319h2efd51ffc9cb64f3@mail.gmail.com> <46F17BBE.7060304@sandeen.net>
Message-ID: <op.tyxljq0l3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <46F17BBE.7060304@sandeen.net>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, "Jochen K." <jochen.f.k@googlemail.com>
Cc: xfs@oss.sgi.com

On Thu, 20 Sep 2007 05:42:54 +1000, Eric Sandeen <sandeen@sandeen.net>  
wrote:

> Jochen K. wrote:
>
>> [output with encryption]
>>
>> mkfs.xfs -f /dev/mapper/raid6
>>
>> meta-data=/dev/mapper/raid6      isize=256    agcount=32,  
>> agsize=53412581
>> blks
>>          =                       sectsz=512   attr=0
>> data     =                       bsize=4096   blocks=1709202592,  
>> imaxpct=25
>>          =                       sunit=0      swidth=0 blks, unwritten=1
>> naming   =version 2              bsize=4096
>> log      =internal log           bsize=4096   blocks=32768, version=1
>>          =                       sectsz=512   sunit=0 blks, lazy-count=0
>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>> b7f57ad0: Badness in key lookup (length)
>> bp=(bno 13673620728, len 131072 bytes) key=(bno 13673620728, len 4096  
>> bytes)
>
> What generates the last two lines in the above message, and do you know
> what it indicates?

The following patch should fix this problem:

--- a/xfsprogs/mkfs/xfs_mkfs.c  2007-09-20 12:31:33.000000000 +1000
+++ b/xfsprogs/mkfs/xfs_mkfs.c  2007-09-20 12:28:46.698533734 +1000
@@ -2115,6 +2115,7 @@
                                     BTOBB(WHACK_SIZE));
                 bzero(XFS_BUF_PTR(buf), WHACK_SIZE);
                 libxfs_writebuf(buf, LIBXFS_EXIT_ON_FAILURE);
+               libxfs_purgebuf(buf);
         }

         /*
