Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Mar 2007 22:05:43 -0800 (PST)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2965U6p010711
	for <xfs@oss.sgi.com>; Thu, 8 Mar 2007 22:05:32 -0800
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id l2965T3A030392
	for <xfs@oss.sgi.com>; Thu, 8 Mar 2007 22:05:29 -0800
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id l2965auY010732
	for <xfs@oss.sgi.com>; Thu, 8 Mar 2007 22:05:36 -0800
Message-ID: <45F0F7B6.9070406@agami.com>
Date: Fri, 09 Mar 2007 11:29:18 +0530
From: Shailendra Tripathi <stripathi@agami.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair doesn't detect corrupt btree roots in nodes
References: <200703090358.OAA12270@larry.melbourne.sgi.com>
In-Reply-To: <200703090358.OAA12270@larry.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@melbourne.sgi.com>
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

Looks ok to me.

Can you test if it works by manually corrupting some B+Tree using xfs_db 
(or in fact, you can write a small program which does so. You can just 
write a program which reads the location on the disk directly, modify 
the 512 size sector corresponding to these with some selected fields and 
write them out.)

Try the code when major B+Trees are corrupted --> AGI /BCNTi/BSIZE tree.

-shailendra

Barry Naujok wrote:
> Ping?
> 
> 
>>-----Original Message-----
>>From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
>>On Behalf Of Barry Naujok
>>Sent: Thursday, 22 February 2007 12:33 PM
>>To: xfs@oss.sgi.com
>>Cc: xfs-dev@sgi.com
>>Subject: [PATCH] xfs_repair doesn't detect corrupt btree 
>>roots in nodes
>>
>>The attached patch detect invalid btree root field (numrecs = 
>>0, levels >
>>permissable value).
>>
>>The patch also does some cleanup with the level and numrecs 
>>usage for the
>>process_btinode function.
>>
>>
