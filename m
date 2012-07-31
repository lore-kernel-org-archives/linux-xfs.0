Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6VH5fme201324 for <xfs@oss.sgi.com>; Tue, 31 Jul 2012 12:05:41 -0500
Date: Tue, 31 Jul 2012 12:05:37 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: xfstests git trees are drifting a little
Message-ID: <20120731170537.GP29979@sgi.com>
References: <50180EAB.8030008@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50180EAB.8030008@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Hey Eric,

On Tue, Jul 31, 2012 at 11:58:19AM -0500, Eric Sandeen wrote:
> kernel.org & oss.sgi.com have gotten a bit out of sync, I think.
> 
> Are there plans to address this soon, on either side?

Now our 3.6 queue is taken care of.  I can spend some time on this within the
next week or so.

Thanks,
	Ben

> xfstests vs. xfstests-dev:
> 
>  016                    |    9 
>  030                    |    3 
>  030.out.linux          |    1 
>  273                    |   10 
>  274                    |   70 ++---
>  285                    |   58 ----
>  285.full               |  116 --------
>  285.out                |    1 
>  286                    |  114 --------
>  286.full               |   70 -----
>  286.out                |    1 
>  README                 |    4 
>  common.attr            |    4 
>  common.dump            |    2 
>  group                  |    2 
>  src/Makefile           |    3 
>  src/seek_copy_test.c   |  249 -----------------
>  src/seek_sanity_test.c |  683 -------------------------------------------------
> 
> 
> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
