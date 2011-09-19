Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JLHJCd015282 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 16:17:19 -0500
Subject: Re: [PATCH] xfsdump: remove unnecessary #ifdefs
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1314740824-4231-1-git-send-email-wkendall@sgi.com>
References: <1314740824-4231-1-git-send-email-wkendall@sgi.com>
Date: Mon, 19 Sep 2011 16:17:15 -0500
Message-ID: <1316467035.2941.87.camel@doink>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, 2011-08-30 at 16:47 -0500, Bill Kendall wrote:
> There are a number of #defines in xfsdump that are always enabled and
> no longer need to be conditional code. This patch removes the
> following macros and enables the related code unconditionally:
> 
> - SIZEEST is required for multi-stream dumps for determining split
>   points.
> 
> - RMT, BASED and SESSCPLT are tied to command line options
>   (dump/restore -m, dump -B and restore -Q, respectively).
> 
> - INVCONVFIX, PIPEINVFIX, and EOMFIX are all related to fixes that
>   went in a long time ago.
> 
> - WHITEPARSE allows for filenames with spaces and special chars to be
>   properly parsed during an interactive restore session.
> 
> - DOSOCKS allows Unix domain sockets to be backed up and restored.
>   Other special files (block/char devs, FIFOs) are always backed up,
>   so do the same for sockets.
> 
> Additionally the definition of F_FSSETDM has been removed from
> restore/Makefile since it is never referenced.

Looks good.  Sorry it took so long to get to this.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
