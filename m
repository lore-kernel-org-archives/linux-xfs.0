Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5DGCGCa160995 for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 11:12:17 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id pEzzl5pX2NepY9Wp
	for <xfs@oss.sgi.com>; Wed, 13 Jun 2012 09:12:15 -0700 (PDT)
Message-ID: <4FD8BBDF.8060503@hardwarefreak.com>
Date: Wed, 13 Jun 2012 11:12:15 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS hangs and freezes with LSI 9265-8i controller on high i/o
References: <4FD66513.2000108@xsnews.nl> <4FD8552C.4090208@xsnews.nl>
	<20120613115934.GX32601@systemlinux.org>
	<6637532.ZKYiNbq2uo@saturn>
In-Reply-To: <6637532.ZKYiNbq2uo@saturn>
Reply-To: stan@hardwarefreak.com
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On 6/13/2012 7:13 AM, Michael Monnerie wrote:

> Write Cache DISABLED if Bad BBU

This is the LSI/3ware firmware default policy Michael, so every user is
safe out-of-the-box.  If the BBU/FBU is not present (never installed),
or the control logic determines it is not functioning properly, the
firmware disables writeback caching.

In absence of paying attention to logs/alerts, one will know pretty
quickly when the BBU has failed, as write performance with many/most
workloads will fall off a cliff.

-- 
Stan


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
