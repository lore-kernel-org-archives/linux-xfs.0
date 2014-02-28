Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9A3B47F3F
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 11:55:13 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D8F88F8039
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 09:55:12 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id s9dNAlQF03CDYuC6 for <xfs@oss.sgi.com>;
	Fri, 28 Feb 2014 09:55:12 -0800 (PST)
Message-ID: <5310CD7F.7090902@sandeen.net>
Date: Fri, 28 Feb 2014 11:55:11 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 6/8] fsstress: translate flags in fiemap_f
References: <1393603865-26198-1-git-send-email-lczerner@redhat.com>
	<1393603865-26198-6-git-send-email-lczerner@redhat.com>
In-Reply-To: <1393603865-26198-6-git-send-email-lczerner@redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On 2/28/14, 10:11 AM, Lukas Czerner wrote:
> Translate flags in fiemap_f output to human readable strings.

This looks fine, w/ the caveats about translate_flags that I mentioned
on the earlier patch.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>  ltp/fsstress.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 24864db..869a8ac 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -2252,6 +2252,18 @@ fdatasync_f(int opno, long r)
>  	free_pathname(&f);
>  	close(fd);
>  }
> +
> +#ifdef HAVE_LINUX_FIEMAP_H
> +struct print_flags fiemap_flags[] = {
> +	{ FIEMAP_FLAG_SYNC, "SYNC"},
> +	{ FIEMAP_FLAG_XATTR, "XATTR"},
> +	{ -1, NULL}
> +};
> +
> +#define translate_fiemap_flags(mode)	\
> +	({translate_flags(mode, "|", fiemap_flags);})
> +#endif
> +
>  void
>  fiemap_f(int opno, long r)
>  {
> @@ -2314,9 +2326,10 @@ fiemap_f(int opno, long r)
>  
>  	e = ioctl(fd, FS_IOC_FIEMAP, (unsigned long)fiemap);
>  	if (v)
> -		printf("%d/%d: ioctl(FIEMAP) %s%s %lld %lld %x %d\n",
> +		printf("%d/%d: ioctl(FIEMAP) %s%s %lld %lld (%s) %d\n",
>  		       procid, opno, f.path, st, (long long)fiemap->fm_start,
> -		       (long long) fiemap->fm_length, fiemap->fm_flags, e);
> +		       (long long) fiemap->fm_length,
> +		       translate_fiemap_flags(fiemap->fm_flags), e);
>  	free(fiemap);
>  	free_pathname(&f);
>  	close(fd);
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
