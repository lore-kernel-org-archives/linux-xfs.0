Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5GLTRl3063094 for <xfs@oss.sgi.com>; Thu, 16 Jun 2011 16:29:27 -0500
Subject: Re: xfstests test case 180 fails often
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1308077464.7661.473.camel@chandra-lucid.beaverton.ibm.com>
References: <1308077464.7661.473.camel@chandra-lucid.beaverton.ibm.com>
Date: Thu, 16 Jun 2011 16:29:22 -0500
Message-ID: <1308259762.2717.31.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: sekharan@us.ibm.com
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Tue, 2011-06-14 at 11:51 -0700, Chandra Seetharaman wrote:
> Hello All,
> 
> test case 180 fails often (4 out of 5) in my x86_64 system.
> Any suggestions on how to proceed to debug ?

I have been seeing failures like that sometimes
(more often recently I think) for a while.  I
have not had the chance to really chase it down.

If you can reproduce it pretty relibly you could
use "git bisect" to try to find out whether the
failures started to occur after a particular
commit.

					-Alex

> regards,
> 
> chandra
> 
> 80 176s ... - output mismatch (see 180.out.bad)^M
> --- 180.out     2011-04-20 08:34:36.000000000 -0700^M
> +++ 180.out.bad 2011-06-03 14:10:45.000000000 -0700^M
> @@ -1 +1,4 @@^M
>  QA output created by 180^M
> +file /mnt/xfsScratchMntPt/656 has incorrect size - sync failed^M
> +file /mnt/xfsScratchMntPt/818 has incorrect size - sync failed^M
> +file /mnt/xfsScratchMntPt/899 has incorrect size - sync failed^M
> Ran: 180^M
> Failures: 180^M
> Failed 1 of 1 tests^M
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
