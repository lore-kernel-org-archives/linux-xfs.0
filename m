Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Apr 2008 07:05:23 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3IE529L007735
	for <xfs@oss.sgi.com>; Fri, 18 Apr 2008 07:05:04 -0700
Message-ID: <4808AAA5.1060201@sandeen.net>
Date: Fri, 18 Apr 2008 09:05:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
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
Cc: Andi Kleen <andi@firstfloor.org>, David Chinner <dgc@sgi.com>, Niv Sardi <xaiki@cxhome.ath.cx>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

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
> 
> --Tim

ISTR that the dir2 code on Irix had tons of compiler pragmas for likely
and unlikely paths, and that it actually was well-profiled and tested.
Did that ever get translated into Linux hints?

-Eric
