Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Apr 2008 06:34:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3IDYPD9005520
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2008 06:34:28 -0700
Received: from one.firstfloor.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70095158FBC2
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2008 06:35:05 -0700 (PDT)
Received: from one.firstfloor.org (one.firstfloor.org [213.235.205.2]) by cuda.sgi.com with ESMTP id spcN6v39T7bB05v5 for <xfs@oss.sgi.com>; Fri, 18 Apr 2008 06:35:05 -0700 (PDT)
Message-ID: <4808A383.5050907@firstfloor.org>
Date: Fri, 18 Apr 2008 15:34:59 +0200
From: Andi Kleen <andi@firstfloor.org>
MIME-Version: 1.0
Subject: Re: likely and unlikely was: Re: [PATCH] split xfs_ioc_xattr
References: <20080319204014.GA23644@lst.de> <ncciqylf7q0.fsf@sgi.com>	<20080414032940.GA10579@lst.de> <ncclk3ejwam.fsf@sgi.com>	<20080416063712.GN108924158@sgi.com> <4805A589.7080906@sgi.com> <87ve2i5kbs.fsf@basil.nowhere.org> <4808488A.7010204@sgi.com>
In-Reply-To: <4808488A.7010204@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Niv Sardi <xaiki@cxhome.ath.cx>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Timothy Shimmin wrote:
> Hi,
> 
> Thanks for the explanation, Andi.
> So I guess the upshot is, that it can make a difference but
> in many cases (where the perf difference isn't an issue)
> it is probably not worth the ugliness.
> And in performance cases, it would be best to test the hypothesis
> with the unlikely profiler patch
> => it will be _unlikely_ we will bother ;-)
> So I don't think I'll be bothering with them then unless
> an issue comes up :)

Ideal would be to not bother by default, but occasionally
run oprofile with icache and branch misprediction profiling for macro
benchmarks (significant user space code running) and if you see
any icache miss/mispredict hot spots in your code  add the annotations
there and then double check with the unlikely profiler.

-Andi
