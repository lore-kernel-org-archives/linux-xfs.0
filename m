Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3S7QMPJ255404 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 02:26:23 -0500
Date: Thu, 28 Apr 2011 09:29:48 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] xfstests: fix error discard test output in 251.out.
In-Reply-To: <1303962551-14893-1-git-send-email-tm@tao.ma>
Message-ID: <alpine.LFD.2.00.1104280927070.4245@dhcp-27-109.brq.redhat.com>
References: <1303962551-14893-1-git-send-email-tm@tao.ma>
MIME-Version: 1.0
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
To: Tao Ma <tm@tao.ma>
Cc: Lukas Czerner <lczerner@redhat.com>, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Thu, 28 Apr 2011, Tao Ma wrote:

> From: Tao Ma <boyu.mt@taobao.com>
> 
> I don't know why, but discard tests is 251 in xfs,
> but 251.out has number of 248 in it, So it fails.
> Change it to 251 now.
> 
> Cc: Lukas Czerner <lczerner@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Alex Elder <aelder@sgi.com>
> Signed-off-by: Tao Ma <boyu.mt@taobao.com>
> ---
>  251.out |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/251.out b/251.out
> index 880d9c7..3017b5e 100644
> --- a/251.out
> +++ b/251.out
> @@ -1,3 +1,3 @@
> -QA output created by 248
> +QA output created by 251
>  Checking FITRIM support: done.
>  Running the test: done.
> 

Oh, thanks Tao for noticing this. Funny thing is I have never noticed
it, but that's probably just because I usually change test variables
to run more processes for a longer time, hence I never wait for it to
completely finish:)

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
