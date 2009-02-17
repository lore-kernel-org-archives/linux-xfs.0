Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1H0GWlx182680 for <xfs@oss.sgi.com>; Mon, 16 Feb 2009 18:16:33 -0600
Received: from wf-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 470DDA31551
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2009 16:15:58 -0800 (PST)
Received: from wf-out-1314.google.com (wf-out-1314.google.com
	[209.85.200.170]) by cuda.sgi.com with ESMTP id
	1fDiZPeEyU41vqA9 for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2009 16:15:58 -0800 (PST)
Received: by wf-out-1314.google.com with SMTP id 26so2655628wfd.32
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2009 16:15:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090216102845.GA6835@infradead.org>
References: <20090216102845.GA6835@infradead.org>
Date: Tue, 17 Feb 2009 11:08:33 +1100
Message-ID: <d38e348a0902161608r466a2582pfd5fd75e17a66f12@mail.gmail.com>
Subject: Re: [PATCH] xfsdump: fix system() error reporting
From: Timothy Shimmin <timothy.shimmin@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi Christoph,

Looks reasonable.
Though, in the case of returning -1, it might be more interesting
to know the value of errno ? (I presume errno would be set in that case).

--Tim

On Mon, Feb 16, 2009 at 9:28 PM, Christoph Hellwig <hch@infradead.org> wrote:
> Positive returns from system need the WEXITSTATUS macro applies to get
> the real exit code of the executed command.
>
> Based on analysis in oss BZ #804.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>
> Index: xfsdump-dev/dump/content.c
> ===================================================================
> --- xfsdump-dev.orig/dump/content.c     2009-02-16 11:23:10.361944048 +0100
> +++ xfsdump-dev/dump/content.c  2009-02-16 11:23:47.629070808 +0100
> @@ -6735,7 +6735,8 @@ save_quotas( char *mntpnt, quota_info_t
>         sts = system( buf );
>         if( sts != 0 ) {
>             mlog( MLOG_ERROR, _(
> -                  "%s failed with exit status: %d\n"), REPQUOTA, sts);
> +                  "%s failed with exit status: %d\n"), REPQUOTA,
> +                 sts == -1 ? -1 : WEXITSTATUS(sts));
>             return BOOL_FALSE;
>         }
>         if((fd = open( quotainfo->quotapath, O_RDONLY|O_DSYNC)) < 0) {
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
