Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 127797F5A
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 21:34:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 03A6E8F804B
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 19:34:42 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XOGx2tASxIzQA2XT for <xfs@oss.sgi.com>;
	Wed, 02 Dec 2015 19:34:40 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id C590663C5A9F
	for <xfs@oss.sgi.com>; Wed,  2 Dec 2015 21:34:40 -0600 (CST)
Subject: Re: [PATCH 03/11] xfsprogs: mkfs: fix unintentional integer overflow
References: <1449055167-19936-1-git-send-email-t.vivek@samsung.com>
	<1449055167-19936-4-git-send-email-t.vivek@samsung.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <565FB850.6030704@sandeen.net>
Date: Wed, 2 Dec 2015 21:34:40 -0600
MIME-Version: 1.0
In-Reply-To: <1449055167-19936-4-git-send-email-t.vivek@samsung.com>
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
To: xfs@oss.sgi.com

I don't think it's possible for blocklog to be large enough to overflow,
but I suppose being defensive is fine.

Coverity-Id: 996962
Reviewed-by: Eric Sandeen <sandeen@redhat.com>

On 12/2/15 5:19 AM, Vivek Trivedi wrote:
> Fix unintentional integer overflow  in mkfs.
> Reported by coverity.
> 
> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
> ---
>  mkfs/xfs_mkfs.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 7cba41a..e540c48 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -2033,7 +2033,7 @@ _("warning: sparse inodes not supported without CRC support, disabled.\n"));
>  		/* check that rswidth is a multiple of fs blocksize */
>  		if (!norsflag && rswidth && !(BBTOB(rswidth) % blocksize)) {
>  			rswidth = DTOBT(rswidth);
> -			rtextbytes = rswidth << blocklog;
> +			rtextbytes = (__uint64_t)rswidth << blocklog;
>  			if (XFS_MIN_RTEXTSIZE <= rtextbytes &&
>  			    (rtextbytes <= XFS_MAX_RTEXTSIZE)) {
>  				rtextblocks = rswidth;
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
