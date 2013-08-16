Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A57037CBE
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 12:55:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7047D304053
	for <xfs@oss.sgi.com>; Fri, 16 Aug 2013 10:55:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4FG8uV8lO7LTROtR for
	<xfs@oss.sgi.com>; Fri, 16 Aug 2013 10:55:31 -0700 (PDT)
Message-ID: <520E678F.3010307@redhat.com>
Date: Fri, 16 Aug 2013 12:55:27 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: btrfs/009 never shrinked or removed $seqres.full
References: <1376675094-21522-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1376675094-21522-1-git-send-email-sbehrens@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On 8/16/13 12:44 PM, Stefan Behrens wrote:
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  tests/btrfs/009 | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tests/btrfs/009 b/tests/btrfs/009
> index d46744c..08aa508 100755
> --- a/tests/btrfs/009
> +++ b/tests/btrfs/009
> @@ -47,6 +47,8 @@ _supported_fs btrfs
>  _supported_os Linux
>  _require_scratch
>  
> +rm -f $seqres.full
> +
>  _scratch_mkfs > /dev/null 2>&1
>  _scratch_mount
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
