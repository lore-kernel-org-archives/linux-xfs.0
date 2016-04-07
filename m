Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8DFD57CA0
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 21:48:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E1139AC004
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 19:48:51 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KLwwPVRp9POw7QBL for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2016 19:48:37 -0700 (PDT)
Received: from Liberator.local (erlite [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id C12BA16C152
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2016 21:48:36 -0500 (CDT)
Subject: Re: [PATCH 05/19] mkfs: factor boolean option parsing
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-6-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5705CA84.9080603@sandeen.net>
Date: Wed, 6 Apr 2016 21:48:36 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-6-git-send-email-jtulak@redhat.com>
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
> UPDATE:
> - add a forgotten getbool update to FINOBT
> - change -m crc and ftype to enable by specifying (instead of toggle off)
> 
> Many of the options passed to mkfs have boolean options (0 or 1) and
> all hand roll the same code and validity checks. Factor these out
> into a common function.
> 
> Note that the lazy-count option is now changed to match other
> booleans in that if you don't specify a value, it reverts to the
> default value (on) rather than throwing an error. 
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jan Tulak <jtulak@redhat.com>
> ---
>  mkfs/xfs_mkfs.c | 109 +++++++++++++++++++++++---------------------------------
>  1 file changed, 44 insertions(+), 65 deletions(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index 4811d77..9394bd3 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c

...

> @@ -1451,12 +1459,8 @@ main(
>  					sb_feat.attr_version = c;
>  					break;
>  				case I_PROJID32BIT:
> -					if (!value || *value == '\0')
> -						value = "0";
> -					c = getnum(value, 0, 0, false);
> -					if (c < 0 || c > 1)
> -						illegal(value, "i projid32bit");
> -					sb_feat.projid16bit = c ? false : true;
> +					sb_feat.projid16bit = !getbool(value,
> +							"i projid32bit", false);
>  					break;
>  				case I_SPINODES:
>  					if (!value || *value == '\0')

I_SPINODES now needs the getbool() treatment as well.

...

> @@ -1631,28 +1625,20 @@ main(
> 
>  				switch (getsubopt(&p, (constpp)mopts, &value)) {
>  				case M_CRC:
> -					if (!value || *value == '\0')
> -						reqval('m', mopts, M_CRC);
> -					c = getnum(value, 0, 0, false);
> -					if (c < 0 || c > 1)
> -						illegal(value, "m crc");
> -					if (c && nftype) {
> +					sb_feat.crcs_enabled = getbool(
> +							value, "m crc", true);
> +					if (sb_feat.crcs_enabled && nftype) {
>  						fprintf(stderr,
> -_("cannot specify both crc and ftype\n"));
> +_("cannot specify both -m crc=1 and -n ftype\n"));
>  						usage();
>  					}
> -					sb_feat.crcs_enabled = c ? true : false;
> -					if (c)
> +					if (sb_feat.crcs_enabled)
>  						sb_feat.dirftype = true;
>  					break;
>  				case M_FINOBT:
> -					if (!value || *value == '\0')
> -						reqval('m', mopts, M_CRC);

                                                                   ^^^ whoops ;)
Well that bug goes away now ;)

> -					c = atoi(value);
> -					if (c < 0 || c > 1)
> -						illegal(value, "m finobt");
>  					sb_feat.finobtflag = true;
> -					sb_feat.finobt = c;
> +					sb_feat.finobt = getbool(
> +						value, "m finobt", true);
>  					break;
>  				case M_UUID:
>  					if (!value || *value == '\0')

Other than SPINODES this one looks ok to me.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
