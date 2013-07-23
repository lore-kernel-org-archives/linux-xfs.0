Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 987577F3F
	for <xfs@oss.sgi.com>; Tue, 23 Jul 2013 13:52:28 -0500 (CDT)
Date: Tue, 23 Jul 2013 13:52:28 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 04/48] xfsprogs: add crc format chagnes to ag headers
Message-ID: <20130723185228.GJ3111@sgi.com>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1370564771-4929-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Fri, Jun 07, 2013 at 10:25:27AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>

This corresponds with commits 4e0e6040c405, 77c95bba013, and 983d09ffe3.

> diff --git a/include/xfs_ag.h b/include/xfs_ag.h
> index f2aeedb..1e0fa34 100644
> --- a/include/xfs_ag.h
> +++ b/include/xfs_ag.h

...

> @@ -83,6 +101,7 @@ typedef struct xfs_agf {
>  #define	XFS_AGF_FREEBLKS	0x00000200
>  #define	XFS_AGF_LONGEST		0x00000400
>  #define	XFS_AGF_BTREEBLKS	0x00000800
> +#define	XFS_AGF_UUID		0x00001000
>  #define	XFS_AGF_NUM_BITS	12
					^^

					Should be 13 now.

s/chagnes/changes in the subject line.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
