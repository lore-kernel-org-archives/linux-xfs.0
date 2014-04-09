Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 34B9529E37
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 08:55:46 -0500 (CDT)
Message-ID: <53455163.4070906@sgi.com>
Date: Wed, 09 Apr 2014 08:55:47 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 12/14] xfs_repair: address never-true tests in
	repair/bmap.c on 64 bit
References: <1396999504-13769-1-git-send-email-sandeen@redhat.com>
	<1396999504-13769-13-git-send-email-sandeen@redhat.com>
In-Reply-To: <1396999504-13769-13-git-send-email-sandeen@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On 04/08/14 18:25, Eric Sandeen wrote:
> The test "if (new_naexts > BLKMAP_NEXTS_MAX)" is never true
> on a 64-bit platform; new_naexts is an int, and BLKMAP_NEXTS_MAX
> is INT_MAX.  So just wrap the whole thing in the #ifdef.
>
> Signed-off-by: Eric Sandeen<sandeen@redhat.com>
> ---
>   repair/bmap.c |    8 ++++----
>   1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/repair/bmap.c b/repair/bmap.c
> index 85d66dc..b81efb9 100644
> --- a/repair/bmap.c
> +++ b/repair/bmap.c
> @@ -47,16 +47,16 @@ blkmap_alloc(
>   	if (nex < 1)
>   		nex = 1;
>
> +#if (BITS_PER_LONG == 32)	/* on 64-bit platformsethis is never true */
                                              platforms this ..,
>   	if (nex > BLKMAP_NEXTS_MAX) {
> -#if (BITS_PER_LONG == 32)
>   		do_warn(
>   	_("Number of extents requested in blkmap_alloc (%d) overflows 32 bits.\n"
>   	  "If this is not a corruption, then you will need a 64 bit system\n"
>   	  "to repair this filesystem.\n"),
>   			nex);
> -#endif
>   		return NULL;
>   	}
> +#endif

Looks good. The other patches look good too.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
