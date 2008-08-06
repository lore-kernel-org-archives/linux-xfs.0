Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Aug 2008 12:55:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m76JtCOq007239
	for <xfs@oss.sgi.com>; Wed, 6 Aug 2008 12:55:12 -0700
Message-ID: <489A01E1.1040309@sandeen.net>
Date: Wed, 06 Aug 2008 14:56:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: TAKE 981498 - Use KM_NOFS for debug trace buffers
References: <20080806061553.A8D8958C52A4@chook.melbourne.sgi.com> <cc7060690808061012x43511581m15c794e72129becc@mail.gmail.com>
In-Reply-To: <cc7060690808061012x43511581m15c794e72129becc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Bhagi rathi wrote:
> I couldn't get a chance to read the diff's completely. If I click on
> Lachlan's url for diff's, I couldn't access them. 

Try again, it takes a while for cvs to catch up.

-Eric

> It looks to me that
> the issue is not just with trace buffers. It can extend to xfs_iformat
> as well. The same dead-lock can spring via
> 
> xfs_iread -> xfs_iformat -> xfs_iformat_extents -> xfs_iext_add ->
> xfs_iext_inline_to_direct -> which can do kmem_alloc with
> KM_SLEEP flag.
> 
> 
> The source of the problem is that holding a lock and entering into
> file-system once again. This can lead to dead-lock on the same
> clustered buffer during cleaning of log space.
> 
> Cheers,
> Bhagi.
