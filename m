Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 19 Jan 2008 12:12:22 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0JKCHTQ009074
	for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 12:12:18 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E518CA09DB
	for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 12:12:33 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id REswos6vQaUKzozC for <xfs@oss.sgi.com>; Sat, 19 Jan 2008 12:12:33 -0800 (PST)
Message-ID: <47925990.7070004@sandeen.net>
Date: Sat, 19 Jan 2008 14:12:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Volume too big
References: <Pine.LNX.4.64.0801191650260.4780@fbirervta.pbzchgretzou.qr> <4792223E.7080805@sandeen.net> <Pine.LNX.4.64.0801191808100.4780@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0801191808100.4780@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: xfs@oss.sgi.com

Jan Engelhardt wrote:

>> (Hm, argument list too long is an interesting result tho...)
> 
> I suppose it's right here:
> 
> #if XFS_BIG_BLKNOS     /* Limited by ULONG_MAX of page cache index */ 
>         if (nblocks >> (PAGE_CACHE_SHIFT - sbp->sb_blocklog) > ULONG_MAX)
>                 return E2BIG;
> #else                  /* Limited by UINT_MAX of sectors */ 
> 

Yeah, I really think the E2BIGs in xfs should probably be swapped for
EFBIG; more helpful error message.

-Eric
