Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3189C32771
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Sep 2022 15:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiI1PYx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Sep 2022 11:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbiI1PYa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Sep 2022 11:24:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E973C9958
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 08:23:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C65B2B820EB
        for <linux-xfs@vger.kernel.org>; Wed, 28 Sep 2022 15:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E30C4314D;
        Wed, 28 Sep 2022 15:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664378612;
        bh=1VmhMbVcQJrI54306aVVeOmq+Pi/7JYkCPes5mC/u3Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=epvZbtNDfmxiNSMXDz5jV0We4JrySSDASDIL8fBauN6A5DwB82AFrqy0DRjIYiZIm
         oBCN8Y7ZlwSaV3AEIqxyeGIQaBX4ZID7qA1GzlTcwLmkDLMR2cLJitseHpiFtU3PRE
         /T9kQEvy2MqgKe33n9YbY7GQtMb9wUbjUKC9rbL+8czFIvKzUYC6ku/AKha1cBUWj3
         bbIpCH+sdDDWlu+GTELlXdgwe+2+IvnpYeU0iA3mxq/X2ypuVJpshxtgJbxtQIIDLn
         yc8LcFF9DhhmbhCgjDb32WuWBXmNkoYxvG/e8AR7XUtETK5ygqqXIB9NZx6TybxOBv
         Tf9W+7tN3e1vw==
Date:   Wed, 28 Sep 2022 08:23:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Donald Douwsma <ddouwsma@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfsrestore: stobj_unpack_sessinfo cleanup
Message-ID: <YzRm86tcCc2m+YeX@magnolia>
References: <20220928055307.79341-1-ddouwsma@redhat.com>
 <20220928055307.79341-3-ddouwsma@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928055307.79341-3-ddouwsma@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 28, 2022 at 03:53:06PM +1000, Donald Douwsma wrote:
> stobj_unpack_sessinfo should be the reverse of stobj_pack_sessinfo, make
> this clearer with respect to the session header and streams processing.
> 
> signed-off-by: Donald Douwsma <ddouwsma@redhat.com>
> ---
>  inventory/inv_stobj.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/inventory/inv_stobj.c b/inventory/inv_stobj.c
> index 5075ee4..521acff 100644
> --- a/inventory/inv_stobj.c
> +++ b/inventory/inv_stobj.c
> @@ -1065,25 +1065,26 @@ stobj_unpack_sessinfo(
>  		return BOOL_FALSE;
>  	}
>  
> +	/* get the seshdr and then, the remainder of the session */
>  	xlate_invt_seshdr((invt_seshdr_t *)p, (invt_seshdr_t *)tmpbuf, 1);
>  	bcopy(tmpbuf, p, sizeof(invt_seshdr_t));
> -
> -	/* get the seshdr and then, the remainder of the session */
>  	s->seshdr = (invt_seshdr_t *)p;
>  	s->seshdr->sh_sess_off = -1;
>  	p += sizeof(invt_seshdr_t);
>  
> -
>  	xlate_invt_session((invt_session_t *)p, (invt_session_t *)tmpbuf, 1);
>  	bcopy (tmpbuf, p, sizeof(invt_session_t));
>  	s->ses = (invt_session_t *)p;
>  	p += sizeof(invt_session_t);
>  
>  	/* the array of all the streams belonging to this session */
> -	xlate_invt_stream((invt_stream_t *)p, (invt_stream_t *)tmpbuf, 1);
> -	bcopy(tmpbuf, p, sizeof(invt_stream_t));
>  	s->strms = (invt_stream_t *)p;
> -	p += s->ses->s_cur_nstreams * sizeof(invt_stream_t);
> +	for (i = 0; i < s->ses->s_cur_nstreams; i++) {
> +		xlate_invt_stream((invt_stream_t *)p, 

Nit: trailing whitespace                        here ^

> +				  (invt_stream_t *)tmpbuf, 1);
> +		bcopy(tmpbuf, p, sizeof(invt_stream_t));
> +		p += sizeof(invt_stream_t);

Ok, so we translate p into tmpbuf, then bcopy tmpbuf back to p.  That
part makes sense, but I am puzzled by what stobj_pack_sessinfo does:

	for (i = 0; i < ses->s_cur_nstreams; i++) {
		xlate_invt_stream(strms, (invt_stream_t *)sesbuf, 1);
		sesbuf += sizeof(invt_stream_t);
	}

Why isn't that callsite xlate_invt_stream(&strms[i], ...); ?

--D

> +	}
>  
>  	/* all the media files */
>  	s->mfiles = (invt_mediafile_t *)p;
> -- 
> 2.31.1
> 
