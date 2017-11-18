Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from gozora.sk ([83.167.232.19]:38042 "EHLO gozora.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762881AbdKRPGL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 18 Nov 2017 10:06:11 -0500
Date: Sat, 18 Nov 2017 16:00:08 +0100 (CET)
From: Vladimir Gozora <c@gozora.sk>
Subject: Illegal value 0 for -l sunit option ?
Message-ID: <alpine.DEB.2.10.1711181547110.14549@gozora.sk>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1487727640-1612436286-1511017208=:14549"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1487727640-1612436286-1511017208=:14549
Content-Type: TEXT/PLAIN; format=flowed; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

Hello XFS team,

I'm working on ReaR project (https://github.com/rear/rear) which aims for 
bare-metal disaster recovery.
Lately I¢ve run across behavior of mkfs.xfs which I don¢t really know if 
is correct or not.
The thing is that when I try to create XFS file system with xfsprogs-4.5.0 
following commands runs just fine:
mkfs.xfs -f -i size=512 -d agcount=4 -s size=512 -i attr=2 -i 
projid32bit=1 -m crc=1 -m finobt=1 -b size=4096 -i maxpct=25 -d sunit=0 -d 
swidth=0 -l version=2 -l sunit=0 -l lazy-count=1 -n size=4096 -n version=2 
-r extsize=4096 <destination>
when I try same command with xfsprogs-4.10.0, I get following error:
Illegal value 0 for -l sunit option. value is too small

In ReaR we are trying to backup whole OS and recreate it closest to 
original as possible, so I was collecting data obtained from xfs_info and 
used them during recovery phase. This approach would unfortunately not 
work any more, since I can't use (at least) log sections "sunit=0 blks"
and pass it back to mkfs.xfs ...

Is there some (correct) way how I could save options that were used during 
XFS file system creation and use them later, during recovery phase?

Thx in advance for your inputs!

Best regards

Vlado
---1487727640-1612436286-1511017208=:14549--
