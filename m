Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3840CC7EE2D
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Feb 2023 22:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjBZWl3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Feb 2023 17:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjBZWl3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Feb 2023 17:41:29 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DAFF97C
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2023 14:41:28 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id q31-20020a17090a17a200b0023750b69614so4391319pja.5
        for <linux-xfs@vger.kernel.org>; Sun, 26 Feb 2023 14:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p9LhfR0oodBx3v7W5v+LRBO7Sex8xkiGdEA6BEM38VQ=;
        b=SvMf/Aa/hINJJK+A+0OAUPBYjkwfLODutr5QpRE0rg1W8Iq5vTf3M4UE8AJWoV+5zl
         LI/4/IDP3sBM7wlBOja43On1clJdCw0olIaoc+GmkzcNXBkt0USZzXXyxBci/twPcKnr
         RXRLgoSjUY6Sr3p+RTm0fID5OGz+wxWz6CVvROp5B7u8ANhf2w9JPixQKi5JJiEy0069
         5CieO5FxYVv3MUoR2Tf5gGFykJSu/erhYiUtk9oSE8LD+Mr/fovKJqlURyJh7eTCGOj+
         OrwxmqaSCALAuwdMKcC4ETrTjHJ0+qtN6ac7LKdtcAlX+Hkz9T/x8HybTJHi9eLgCCyh
         lKiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p9LhfR0oodBx3v7W5v+LRBO7Sex8xkiGdEA6BEM38VQ=;
        b=KYQh7W9ym3lgo5PVQCBPt8wxhYXBfR7btuEYeZiMqvkMQa6LyErWYPd2Q+20T5NLFA
         n/0UlJziQCe3+ZR16WVjal9YQLwHcs5PjIHR5Q+PqRAPNJrFz7HHP0HI87UAGJSimn9D
         TqAzyOianRtbwhHlIioF27JJAwDsvSIRvOkCsAxlkyAlyizQc/iFveyZQvBYxJMftIgX
         UEXbs3W9ZjV39NaV2MbMBsOR/SqAuMRqfw4gNtOn7CUSoPHneb7wFSctk8stjRSz/HFH
         naNkccUk5kPkv3TITc52snr3g0/gyqIHtBpLi5Wqb1ZCfSYtXkKN2DM67pbrE6QAqLSn
         ciWA==
X-Gm-Message-State: AO0yUKURpPf6CMPgsQ+0GFwYpuneLKnPqdrOBFe4T//DtoZDWuSWeRCC
        CLUGl4IctOzPExhrkE7yYxBrPBdL1athgeUI
X-Google-Smtp-Source: AK7set9rIu1VwsvuZMj29s1m7LcQVqvU+Ge0CGfxHX2/i2DEr3oYvC3iX93Ew+Vjg8xwyFgYKGjPGg==
X-Received: by 2002:a05:6a20:a004:b0:cc:a93:2b82 with SMTP id p4-20020a056a20a00400b000cc0a932b82mr15675687pzj.58.1677451287966;
        Sun, 26 Feb 2023 14:41:27 -0800 (PST)
Received: from dread.disaster.area (pa49-186-4-237.pa.vic.optusnet.com.au. [49.186.4.237])
        by smtp.gmail.com with ESMTPSA id t20-20020a62ea14000000b005809d382016sm2907282pfh.74.2023.02.26.14.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 14:41:27 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pWPhs-002VTc-R0; Mon, 27 Feb 2023 09:41:24 +1100
Date:   Mon, 27 Feb 2023 09:41:24 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFCv3 1/3] iomap: Allocate iop in ->write_begin() early
Message-ID: <20230226224124.GV360264@dread.disaster.area>
References: <cover.1677428794.git.ritesh.list@gmail.com>
 <34dafb5e15dba3bb0b0e072404ac6fb9f11561b8.1677428794.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34dafb5e15dba3bb0b0e072404ac6fb9f11561b8.1677428794.git.ritesh.list@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 27, 2023 at 01:13:30AM +0530, Ritesh Harjani (IBM) wrote:
> Earlier when the folio is uptodate, we only allocate iop at writeback
> time (in iomap_writepage_map()). This is ok until now, but when we are
> going to add support for subpage size dirty bitmap tracking in iop, this
> could cause some performance degradation. The reason is that if we don't
> allocate iop during ->write_begin(), then we will never mark the
> necessary dirty bits in ->write_end() call. And we will have to mark all
> the bits as dirty at the writeback time, that could cause the same write
> amplification and performance problems as it is now (w/o subpage dirty
> bitmap tracking in iop).
> 
> However, for all the writes with (pos, len) which completely overlaps
> the given folio, there is no need to allocate an iop during
> ->write_begin(). So skip those cases.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  fs/iomap/buffered-io.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 356193e44cf0..c5b51ab1184e 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -535,11 +535,16 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
>  	size_t from = offset_in_folio(folio, pos), to = from + len;
>  	size_t poff, plen;
>  
> +	if (pos <= folio_pos(folio) &&
> +	    pos + len >= folio_pos(folio) + folio_size(folio))
> +		return 0;

This is magic without a comment explaining why it exists. You have
that explanation in the commit message, but that doesn't help anyone
looking at the code:

	/*
	 * If the write completely overlaps the current folio, then
	 * entire folio will be dirtied so there is no need for
	 * sub-folio state tracking structures to be attached to this folio.
	 */

-Dave.

-- 
Dave Chinner
david@fromorbit.com
