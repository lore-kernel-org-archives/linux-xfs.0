Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n42AABEt050864 for <xfs@oss.sgi.com>; Sat, 2 May 2009 05:10:12 -0500
Received: from moutng.kundenserver.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BFD5B146A2C6
	for <xfs@oss.sgi.com>; Sat,  2 May 2009 03:13:50 -0700 (PDT)
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.186]) by cuda.sgi.com with ESMTP id
	TnD20fOdXDtxCVwL for <xfs@oss.sgi.com>;
	Sat, 02 May 2009 03:13:50 -0700 (PDT)
Date: Sat, 2 May 2009 12:14:05 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
Message-ID: <20090502101405.GA6145@fancy-poultry.org>
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, Alexander Beregalov <a.beregalov@gmail.com>, xfs@oss.sgi.com

On 01.05.2009, Alexander Beregalov wrote: 

> # xfs_db -r /dev/sdc1
> xfs_db> frag
> actual 23805, ideal 22890, fragmentation factor 3.84%
> # xfs_fsr -v /dev/sdc1
> /mnt/c start inode=0
> ino=158
> extents before:3 after:1 DONE ino=158
> 
>  then it hangs

I can't confirm this here on my systems:

liesel:~ # uname -a
Linux liesel 2.6.30-rc4 #1 SMP PREEMPT Sat May 2 11:49:13 CEST 2009 x86_64 x86_64 x86_64 GNU/Linux

liesel:~ # xfs_db -r /dev/sdc1
xfs_db> frag
actual 42974, ideal 42842, fragmentation factor 0.31%
xfs_db> quit

liesel:~ # xfs_fsr -v /dev/sdc1
/home start inode=0
ino=248755507
ino=248755507 already fully defragmented.
ino=536871160
extents before:2 after:1 DONE ino=536871160
ino=536875693
extents before:3 after:1 DONE ino=536875693
ino=615920545
extents before:2 after:1 DONE ino=615920545
ino=615920557
extents before:2 after:1 DONE ino=615920557
ino=1092324584
extents before:4 after:1 DONE ino=1092324584
liesel:~ #

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
