Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F376C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Apr 2022 17:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239156AbiDFRkS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239310AbiDFRkJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 13:40:09 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07BEC2B5251
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 09:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iS+Beyephiy+IlxVksJAIAxTiwShfekUktsrXbLsRZo=; b=tkO0t9kMACVMz3ty5ojlQmq6X4
        HiG15dq4bRySDdlIxXtaHYg3Gjtu62MzlnIlc329VMVNOnXcBWjEIAI1DFh3HduAAP3J/IzLiPP6s
        Fxttf20paKdTDaXQij0axXFebue53UYm6SykY+MBJLLB41tiQ0TtqY+XAnc94K341whn9yhgVuNqR
        QkUzqAJ7V8SlYGwEHPOS8KlEJwikfBCHeKfXH6UBl8cwE0TxSASuRxWnty6qZq9Rxjlc8GlwPXxKW
        ctY5qx7PRCcTwk14qY8NKaF8WjIw6hO+MtDVayI0hdc5GhbjZZLb6aT1BMbRUnisLdZtPmUZzPLSZ
        v3q5ZOvQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nc8ZY-007Cu6-Jo; Wed, 06 Apr 2022 16:31:56 +0000
Date:   Wed, 6 Apr 2022 09:31:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_quota: separate quota info acquisition into
 get_quota()
Message-ID: <Yk3AfCIkcb1h31H7@infradead.org>
References: <20220328222503.146496-1-aalbersh@redhat.com>
 <20220328222503.146496-2-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328222503.146496-2-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 29, 2022 at 12:24:59AM +0200, Andrey Albershteyn wrote:
> Both report_mount() and dump_file() have identical code to get quota
> information. This could be used for further separation of the
> functions.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> ---
>  quota/report.c | 49 +++++++++++++++++++++++--------------------------
>  1 file changed, 23 insertions(+), 26 deletions(-)
> 
> diff --git a/quota/report.c b/quota/report.c
> index 2eb5b5a9..97a89a92 100644
> --- a/quota/report.c
> +++ b/quota/report.c
> @@ -59,16 +59,15 @@ report_help(void)
>  "\n"));
>  }
>  
> -static int 
> -dump_file(
> -	FILE		*fp,
> +static int
> +get_quota(
> +	fs_disk_quota_t *d,
>  	uint		id,
>  	uint		*oid,
>  	uint		type,
>  	char		*dev,
>  	int		flags)
>  {
> -	fs_disk_quota_t	d;
>  	int		cmd;
>  
>  	if (flags & GETNEXTQUOTA_FLAG)
> @@ -77,7 +76,7 @@ dump_file(
>  		cmd = XFS_GETQUOTA;
>  
>  	/* Fall back silently if XFS_GETNEXTQUOTA fails, warn on XFS_GETQUOTA */
> -	if (xfsquotactl(cmd, dev, type, id, (void *)&d) < 0) {
> +	if (xfsquotactl(cmd, dev, type, id, (void *)d) < 0) {
>  		if (errno != ENOENT && errno != ENOSYS && errno != ESRCH &&
>  		    cmd == XFS_GETQUOTA)
>  			perror("XFS_GETQUOTA");
> @@ -85,12 +84,29 @@ dump_file(
>  	}
>  
>  	if (oid) {
> -		*oid = d.d_id;
> +		*oid = d->d_id;
>  		/* Did kernelspace wrap? */
>  		if (*oid < id)
>  			return 0;
>  	}
>  
> +	return 1;
> +}
> +
> +static int
> +dump_file(
> +	FILE		*fp,
> +	uint		id,
> +	uint		*oid,
> +	uint		type,
> +	char		*dev,
> +	int		flags)
> +{
> +	fs_disk_quota_t	d;
> +
> +	if	(!get_quota(&d, id, oid, type, dev, flags))

Tab instead of a space after the if here.

Also if you touch this anyway it might be worth to replace
fs_disk_quota_t with struct fs_disk_quota.

> +	if	(!get_quota(&d, id, oid, type, mount->fs_name, flags))

Same here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
