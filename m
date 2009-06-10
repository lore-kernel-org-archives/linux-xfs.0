Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5AKU6qB112082 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 15:30:06 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D6D838F80FB
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 13:30:24 -0700 (PDT)
Message-Id: <DDFFA1F6-FDAA-4C88-956D-B19570F77934@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <4A2FF2CB.1060805@sandeen.net>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: [PATCH] xfstests:  Skip dump _cleanup if filesystem is not xfs
Date: Wed, 10 Jun 2009 15:30:24 -0500
References: <4A2FF2CB.1060805@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>


On Jun 10, 2009, at 12:52 PM, Eric Sandeen wrote:

> Skip dump _cleanup if filesystem is not xfs
>
> Many/most dump tests include common.dump before checking
> supported fs, and this means that even if the dump tests
> are skipped, the sleep & filesystem check in _cleanup
> gets run, which makes it take rather a long time to
> skip these tests for non-xfs filesystems.
>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Reviewed-by: Felix Blyakher <felixb@sgi.com>

>
> ---
>
>
> diff --git a/common.dump b/common.dump
> index 94de07f..d5aadfc 100644
> --- a/common.dump
> +++ b/common.dump
> @@ -233,6 +233,12 @@ _wipe_fs()
> #
> _cleanup()
> {
> +    # Some tests include this before checking _supported_fs xfs
> +    # and the sleeps & checks get annoying
> +    if [ "$FSTYP" != "xfs" ]; then
> +       return
> +    fi
> +
>     cd $here
>     rm -f $tmp.*
>
>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
