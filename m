Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D218A7F52
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 15:08:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A2D21304048
	for <xfs@oss.sgi.com>; Wed, 30 Oct 2013 13:08:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ZzpDxJJ9RDyT0Qvp for <xfs@oss.sgi.com>;
	Wed, 30 Oct 2013 13:08:14 -0700 (PDT)
Message-ID: <5271672C.7070101@sandeen.net>
Date: Wed, 30 Oct 2013 15:08:12 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix possible NULL dereference
References: <20131021231849.GL10553@sgi.com>
	<20131021235601.GG4446@dastard>	<5265C03B.50701@sandeen.net>
	<20131022001732.GI4446@dastard>	<CAGG-pUTh-PJJ4Nzo0r-f3VDPMc81U2z_NMX+Wcex3KzGs=U8cA@mail.gmail.com>	<20131022203946.GB2797@dastard>
	<5266E4BD.8030601@sandeen.net>	<20131022210300.GC2797@dastard>
	<5266EBF0.901@sandeen.net>	<CAGG-pUTtYomspBXn=RE7YFU=vu6rWZ1fU7CBO45Mmodj8DZFiQ@mail.gmail.com>
	<20131023203435.GR1935@sgi.com>
In-Reply-To: <20131023203435.GR1935@sgi.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>, =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
Cc: Alex Elder <elder@kernel.org>, open list <linux-kernel@vger.kernel.org>, XFS FILESYSTEM <xfs@oss.sgi.com>

On 10/23/13 3:34 PM, Ben Myers wrote:

> xfs: fix possible NULL dereference in xlog_verify_iclog
> 
> In xlog_verify_iclog a debug check of the incore log buffers prints an
> error if icptr is null and then goes on to dereference the pointer
> regardless.  Convert this to an assert so that the intention is clear.
> This was reported by Coverty.
> 
> Reported-by: Geyslan G. Bem <geyslan@gmail.com>
> Signed-off-by: Ben Myers <bpm@sgi.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  fs/xfs/xfs_log.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> Index: b/fs/xfs/xfs_log.c
> ===================================================================
> --- a/fs/xfs/xfs_log.c	2013-10-23 14:52:47.875216875 -0500
> +++ b/fs/xfs/xfs_log.c	2013-10-23 14:53:53.775245830 -0500
> @@ -3714,11 +3714,9 @@ xlog_verify_iclog(
>  	/* check validity of iclog pointers */
>  	spin_lock(&log->l_icloglock);
>  	icptr = log->l_iclog;
> -	for (i=0; i < log->l_iclog_bufs; i++) {
> -		if (icptr == NULL)
> -			xfs_emerg(log->l_mp, "%s: invalid ptr", __func__);
> -		icptr = icptr->ic_next;
> -	}
> +	for (i=0; i < log->l_iclog_bufs; i++, icptr = icptr->ic_next)
> +      		ASSERT(icptr);
> +
>  	if (icptr != log->l_iclog)
>  		xfs_emerg(log->l_mp, "%s: corrupt iclog ring", __func__);
>  	spin_unlock(&log->l_icloglock);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
