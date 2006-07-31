Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Jul 2006 17:26:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6V0QGDW002700
	for <xfs@oss.sgi.com>; Sun, 30 Jul 2006 17:26:16 -0700
Message-ID: <44CD4E0F.2070905@sandeen.net>
Date: Sun, 30 Jul 2006 19:25:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] kill no-op buf macros
References: <44CC2A55.6030207@sandeen.net> <20060731090815.B2280998@wobbly.melbourne.sgi.com>
In-Reply-To: <20060731090815.B2280998@wobbly.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Nathan Scott <nathans@sgi.com>
Cc: dgc@sgi.com, xfs@oss.sgi.com

Nathan Scott wrote:
> On Sat, Jul 29, 2006 at 10:41:09PM -0500, Eric Sandeen wrote:
>> It looks like these macros are not particularly interesting... this patch kills 
>> them.
> 
> Hmm, I'm not sure about some of these..
> 
>> #define XFS_BUF_BUSY(bp)	do { } while (0)
>> #define XFS_BUF_ISBUSY(bp)	(1)
> 
> This ones used on 2.4, I'd like to get Daves thoughts on whether
> we do the right thing here based on his buffer cache fu.

Grr, just realized my cvs checkout didn't even pull linux-2.4 :/  Suppose I'd 
better re-check everything I sent.

Grr!

-Eric
