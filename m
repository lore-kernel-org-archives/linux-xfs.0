Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4814HAX241211 for <xfs@oss.sgi.com>; Thu, 7 May 2009 20:04:18 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47B17AC002
	for <xfs@oss.sgi.com>; Thu,  7 May 2009 18:04:19 -0700 (PDT)
Message-Id: <ABCCDF18-5100-4891-AF1C-BA9513C8A334@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A037503.1070904@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: 2.6.30-rc4: xfs_fsr hangs
Date: Thu, 7 May 2009 20:04:17 -0500
References: <a4423d670905011333s664115bdh1d72392897567c1d@mail.gmail.com>
	<4A036FBC.9020201@sandeen.net> <4A037503.1070904@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexander Beregalov <a.beregalov@gmail.com>, xfs@oss.sgi.com


On May 7, 2009, at 6:55 PM, Eric Sandeen wrote:

> Eric Sandeen wrote:
>
>> there are 2 subsequent unlocks for the same inode:
>>
>> 1:
>> xfs_iunlock: ip ca2304c0 ino 132  flags 0x5
>
> ...
>
>> 2:
>> xfs_iunlock: ip ca230980 ino 131  flags 0x5
>
>
> Ugh no, those are 2 different inodes.... I can read, really.  :)   
> still,
> looking into it.

I've been chasing this as well, and I found the double xfs iolock
unlock which is causing xfs_fsr deadlock itself. I have a fix tested.
The patch is coming.

Felix

>
>
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
