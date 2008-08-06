Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Aug 2008 12:54:24 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m76JsM14006847
	for <xfs@oss.sgi.com>; Wed, 6 Aug 2008 12:54:22 -0700
Message-ID: <489A01B0.5050606@sandeen.net>
Date: Wed, 06 Aug 2008 14:55:28 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: TAKE 981498 - use KM_MAYFAIL in xfs_mountfs
References: <20080806054121.CB2F258C52A4@chook.melbourne.sgi.com> <cc7060690808061022i1dce01dfx9e43ad3a75e5c936@mail.gmail.com>
In-Reply-To: <cc7060690808061022i1dce01dfx9e43ad3a75e5c936@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Bhagi rathi <jahnu77@gmail.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

Bhagi rathi wrote:
> Why are we going to block for ever? Mounting a file-system
> requires in-core log space buffers, reading of other buffers
> which needs allocation of memory greater than per ag
> structures.
> 
> I am trying to understand why xfs_perag_t? Mount/Unmount
> are not frequent activities, it is better for them to succeed
> if operating system can allocate memory and take them
> forward.

But that's the big if, right?

If the system is so starved that you can't get this memory to even start
the mount process, I'm sure it's better to fail the mount with -ENOMEM
than to add to the current system memory stress.

In general KM_MAYFAIL sounds like a good plan when you can handle the
failure gracefully, I think.

-Eric
