Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 May 2008 02:27:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m469R0jj025852
	for <xfs@oss.sgi.com>; Tue, 6 May 2008 02:27:04 -0700
Received: from bay0-omc1-s30.bay0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CDCC1B1418A
	for <xfs@oss.sgi.com>; Tue,  6 May 2008 02:27:46 -0700 (PDT)
Received: from bay0-omc1-s30.bay0.hotmail.com (bay0-omc1-s30.bay0.hotmail.com [65.54.246.102]) by cuda.sgi.com with ESMTP id YROHSlfGJwAsGt6m for <xfs@oss.sgi.com>; Tue, 06 May 2008 02:27:46 -0700 (PDT)
Message-ID: <BAY103-DAV78BE1E59193F0C8852503B2D60@phx.gbl>
From: "Marco Berizzi" <pupilla@hotmail.com>
References: <BAY103-DAV7CF38DF784B82EC3F2CFAB2D70@phx.gbl> <20080505231754.GL155679365@sgi.com> <BAY103-DAV584F4B005A4F9B7B5E19CB2D60@phx.gbl> <20080506085632.GT155679365@sgi.com>
Subject: Re: XFS shutdown in xfs_iunlink_remove() (was Re: 2.6.25: swapper: page allocation failure. order:3, mode:0x4020)
Date: Tue, 6 May 2008 11:25:21 +0200
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

David Chinner wrote:

> Hmmmmm - interesting. Both the reports of this problem are from
> machines running as squid proxies. Are you using AUFS for the cache?

no, I'm using cache_dir ufs with cache_replacement_policy heap LFUDA

> You've run repair, there's not much I can look at now.
>
> As a suggestion, when the cache gets close to full next time, can
> you take a metadump of the filesystem (obfuscates names and contains
> no data) and then trigger the cache cleanup function? If the
> filesystem falls over, I'd be very interested in getting a copy of
> hte metadump image and trying to reproduce the problem locally.
> (BTW, you'll need a newer xfsprogs to get xfs_metadump).

could you please tell me the exact command to run
when this happen again?

> Still, thank you for the information

no problem: 2.6.25 is a bit unlucky for me :-((
