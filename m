Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA822Ohm085235 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 20:02:25 -0600
Message-ID: <1320717740.3186.91.camel@doink>
Subject: Re: [PATCH v2 5/8] xfsdump: convert IRIX sproc threads to pthreads
From: Alex Elder <aelder@sgi.com>
Date: Mon, 7 Nov 2011 20:02:20 -0600
In-Reply-To: <1320699511-12281-6-git-send-email-wkendall@sgi.com>
References: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
	<1320699511-12281-6-git-send-email-wkendall@sgi.com>
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

On Mon, 2011-11-07 at 14:58 -0600, Bill Kendall wrote:
> The existing (disabled) threading code in xfsdump is based on IRIX
> sprocs. This patch converts the code to use pthreads. The threading code
> remains disabled at this point.
> 
> Changes:
>    - pid_t to pthread_t
>    - getpid() to pthread_self()
>    - "pid1 == pid2" to pthread_equal(tid1, tid2)
>    - sigprocmask() to pthread_sigmask()
>    - sproc() to pthread_create()
> 
> Also the following are not referenced and have been removed:
>    - cldmgr_pid2streamix()
>    - PROCMAX
>    - r_slavepid
>    - sproc.c and sproc.h
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
