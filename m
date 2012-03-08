Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q28Mg5o8090447 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 16:42:06 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id WTxj215RotvF7O0U for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 14:42:05 -0800 (PST)
Message-ID: <4F5935BC.4050104@sandeen.net>
Date: Thu, 08 Mar 2012 16:42:04 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [patch 1/1] xfstests: update inode softlimit output in 050
References: <20120222182713.040087240@sgi.com>
	<20120222182832.076759206@sgi.com>
In-Reply-To: <20120222182832.076759206@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com, Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>, Christoph Hellwig <hch@lst.de>, Mark Tinguely <tinguely@sgi.com>

On 2/22/12 12:27 PM, Ben Myers wrote:

> With Mitsuo Hayasaka's kernel patch "xfs: change available ranges of softlimit
> and hardlimit in quota check", xfs quota behavior is slightly different.
> 
> This needs to be reflected in test 050.  The new behavior is that we only start
> the timer when we're above soft inode quota, and we don't start the timer when
> we're at or below.
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>
> Index: xfstests/050.out
> ===================================================================
> --- xfstests.orig/050.out
> +++ xfstests/050.out
> @@ -20,7 +20,7 @@ realtime =RDEV extsz=XXX blocks=XXX, rte
>  
>  *** push past the soft block limit
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 140 100 500 00 [7 days] 4 4 10 00 [7 days] 0 0 0 00 [--------]
> +[NAME] 140 100 500 00 [7 days] 4 4 10 00 [--------] 0 0 0 00 [--------]

...


Hm, but now old kernels would fail.

Maybe it's better to go 1 past the limit in the test, rather than meet it, and then it'd fail on both old & new kernels?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
