Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 May 2008 00:45:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4G7j3P3032578
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 00:45:04 -0700
Received: from bay0-omc1-s26.bay0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24FB8B6DD43
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 00:45:51 -0700 (PDT)
Received: from bay0-omc1-s26.bay0.hotmail.com (bay0-omc1-s26.bay0.hotmail.com [65.54.246.98]) by cuda.sgi.com with ESMTP id Cn6Quw3MKp2zYtUK for <xfs@oss.sgi.com>; Fri, 16 May 2008 00:45:51 -0700 (PDT)
Message-ID: <BAY103-DAV7AAC1BD4FD2FBCE25B6FBB2C80@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV7CF38DF784B82EC3F2CFAB2D70@phx.gbl> <20080505231754.GL155679365@sgi.com> <BAY103-DAV584F4B005A4F9B7B5E19CB2D60@phx.gbl> <20080506085632.GT155679365@sgi.com> <BAY103-DAV78BE1E59193F0C8852503B2D60@phx.gbl> <482062F5.9010402@sandeen.net> <482CAE26.8080707@sandeen.net>
Subject: Re: XFS shutdown in xfs_iunlink_remove() (was Re: 2.6.25: swapper: page allocation failure. order:3, mode:0x4020)
Date: Fri, 16 May 2008 09:43:14 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, nuclearcat@nuclearcat.com

Eric Sandeen wrote:

> Eric Sandeen wrote:
> > Marco Berizzi wrote:
> >> David Chinner wrote:
> >>
> >>> Hmmmmm - interesting. Both the reports of this problem are from
> >>> machines running as squid proxies. Are you using AUFS for the
cache?
> >> no, I'm using cache_dir ufs with cache_replacement_policy heap
LFUDA
>
> Christoph recently sent a patch to the xfs list which resolves my
> testcase for this problem, FYI.
>
> [PATCH] fix memory corruption with small buffer reads

Thanks I will try asap. I have also cc'ed
Denys which had opened bug #10421
