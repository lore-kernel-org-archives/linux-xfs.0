Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 May 2008 14:41:34 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4FLfBqI010073
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 14:41:14 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D12DB6A05E
	for <xfs@oss.sgi.com>; Thu, 15 May 2008 14:41:58 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id wFvBHUFbjuisF2nD for <xfs@oss.sgi.com>; Thu, 15 May 2008 14:41:58 -0700 (PDT)
Message-ID: <482CAE26.8080707@sandeen.net>
Date: Thu, 15 May 2008 16:41:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS shutdown in xfs_iunlink_remove() (was Re: 2.6.25: swapper:
 page allocation failure. order:3, mode:0x4020)
References: <BAY103-DAV7CF38DF784B82EC3F2CFAB2D70@phx.gbl> <20080505231754.GL155679365@sgi.com> <BAY103-DAV584F4B005A4F9B7B5E19CB2D60@phx.gbl> <20080506085632.GT155679365@sgi.com> <BAY103-DAV78BE1E59193F0C8852503B2D60@phx.gbl> <482062F5.9010402@sandeen.net>
In-Reply-To: <482062F5.9010402@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Marco Berizzi <pupilla@hotmail.com>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Eric Sandeen wrote:
> Marco Berizzi wrote:
>> David Chinner wrote:
>>
>>> Hmmmmm - interesting. Both the reports of this problem are from
>>> machines running as squid proxies. Are you using AUFS for the cache?
>> no, I'm using cache_dir ufs with cache_replacement_policy heap LFUDA

Christoph recently sent a patch to the xfs list which resolves my
testcase for this problem, FYI.

[PATCH] fix memory corruption with small buffer reads

-Eric
