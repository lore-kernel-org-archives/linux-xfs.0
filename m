Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C15817CA2
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 21:05:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 88FE1304032
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 19:05:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XzPounrAgn7SdhQv for <xfs@oss.sgi.com>;
	Thu, 31 Mar 2016 19:05:06 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 86EAC56A
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 21:05:05 -0500 (CDT)
Subject: Re: [PATCH 03/19] mkfs: Sanitise the superblock feature macros
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-4-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56FDD750.3040002@sandeen.net>
Date: Thu, 31 Mar 2016 21:05:04 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-4-git-send-email-jtulak@redhat.com>
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

On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> UPDATE
> o disable finobt when crc=0 no matter if user used -m finobt=X
> o split line > 80 chars
> o remove unused variable
> o add omitted finobtflag
> o change variables in spinodes case to look like surrounding code
> o add I_ALIGN reqval

Just FYI - generally, the patch changelog goes below the "---"
so it doesn't end up as part of the changelog in git.

...

(sorry for being late to the review party btw...)

>  	} else {
>  		/*
>  		 * The kernel doesn't currently support crc=0,finobt=1
> -		 * filesystems. If crcs are not enabled and the user has
> -		 * explicitly turned them off then silently turn them off
> -		 * to avoid an unnecessary warning. If the user explicitly
> -		 * tried to use crc=0,finobt=1, then issue a warning before
> -		 * turning them off.
> +		 * filesystems. If crcs are not enabled and the user has not
> +		 * explicitly turned finobt on, then silently turn it off to
> +		 * avoid an unnecessary warning. If the user explicitly tried
> +		 * to use crc=0,finobt=1, then issue a warning before turning
> +		 * them off.
>  		 */
> -		if (finobt && finobtflag) {
> -			fprintf(stderr,
> -_("warning: finobt not supported without CRC support, disabled.\n"));
> +		if (sb_feat.finobt){
> +			if (sb_feat.finobtflag) {
> +				fprintf(stderr,
> +	_("warning: finobt not supported without CRC support, disabled.\n"));
> +			}
> +			sb_feat.finobt = 0;
>  		}
> -		finobt = 0;
>  	}

Is there any other case in mkfs where options are automatically disabled?
I don't think so .. I'd just prefer a failure here, not a fix-up, even
with the warning.  But I guess that's how it was before, so probably
not something to change in this patch.  So never mind.  :)

But, do we need the extra indentation?

		if (sb_feat.finobt && sb_feat.finobtflag) {
			fprintf(stderr,
_("warning: finobt not supported without CRC support, disabled.\n"));
		}
		sb_feat.finobt = 0;

would suffice as before, no? Meh.  Not a big deal I guess....

> @@ -2962,7 +3038,7 @@ _("size %s specified for log subvolume is too large, maximum is %lld blocks\n"),
>  		/*
>  		 * Free INO btree root block
>  		 */
> -		if (!finobt) {
> +		if (!sb_feat.finobt){
                                    ^ please fix whitespace :)

>  			xfs_perag_put(pag);
>  			continue;
>  		}
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
