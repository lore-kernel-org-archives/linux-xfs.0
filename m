Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD60C47082
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 12:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CDAA610C9
	for <linux-xfs@archiver.kernel.org>; Mon, 31 May 2021 12:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhEaM3U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 31 May 2021 08:29:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56554 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231327AbhEaM3S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 May 2021 08:29:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622464056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qwHK6PetfiJT/PEiSU6FSKKcGtAI+jyi0suzU4ROZHU=;
        b=OcVvcU1gDQtXtwXufk7IfMgDxCOwVfTrpgUfX11p6G2HOSODUTWU1hnqToAT+3bZpCjqU6
        ribTr7AYiRlBfP8DDNsxfD6JJHhj9oOxczFDPMteB+SfX1QPnqQUob3vuYLS/EwEPBHtMS
        qSW7Nd7U6kQQEEzfEg0RA95z4JBv0bI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-5CXhf59SN62rwKxXLr1PFw-1; Mon, 31 May 2021 08:27:35 -0400
X-MC-Unique: 5CXhf59SN62rwKxXLr1PFw-1
Received: by mail-wr1-f69.google.com with SMTP id i102-20020adf90ef0000b029010dfcfc46c0so3938558wri.1
        for <linux-xfs@vger.kernel.org>; Mon, 31 May 2021 05:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=qwHK6PetfiJT/PEiSU6FSKKcGtAI+jyi0suzU4ROZHU=;
        b=WdxV4ZJENVmHdB9C5Wgn8LetURFUgF9eZKoHj9EvC6DSDbU3Ce4PxWIGDILtlI31Hu
         Eg7GwgLTi8xhHt2BoatladmbsmV8DNX820K0+wIrHJ5rloWsnPecjJb7IkqLdOh0/x2s
         6sSY9unQZReqbq5HjiMuYS5/GaTd4Kt+SznelKhTmJkvzBPl/IKP6iyaAtOzDsBS6X6u
         X50Qvls8IzCYK4yb2yr1CZ8/8AygBPssuxZ7FNFVqg6dRqcieQu/9LhcuZHssAxJ00tn
         DbAn6ZcLlhEKl4wpY+S4olG1BKhMecGKKqopLPF97PFqzij5a1WsA8mUvhzfmn6vPz64
         zm2w==
X-Gm-Message-State: AOAM530ao0tlMAPkH/q5o752acl38rXhAczS9XjNmy6zGsy8Vu0PKClL
        IzWIZWbMyFnBcSDxvyMd8k5bvX3OAFoYm9rZPw5YhKShWCzQ/J2AY7Vk9t/778FS7EFHo9tfGY7
        4wJkIeN/aw7LJoKWnbo7V
X-Received: by 2002:adf:9d81:: with SMTP id p1mr15590856wre.287.1622464054077;
        Mon, 31 May 2021 05:27:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUKoMQBY3r1V9+wQtZEmAH/06eoM5pus4j2/St2Ebjv/29IF8dR0PRf1XL9zVw2J7uYXN+3w==
X-Received: by 2002:adf:9d81:: with SMTP id p1mr15590844wre.287.1622464053924;
        Mon, 31 May 2021 05:27:33 -0700 (PDT)
Received: from omega.lan (ip4-46-39-172-19.cust.nbox.cz. [46.39.172.19])
        by smtp.gmail.com with ESMTPSA id v10sm16331516wre.33.2021.05.31.05.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 05:27:33 -0700 (PDT)
Date:   Mon, 31 May 2021 14:27:31 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH] xfs: sort variable alphabetically to avoid repeated
 declaration
Message-ID: <20210531122731.pv67ed67p3fkbdb6@omega.lan>
Mail-Followup-To: Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
References: <1622181328-9852-1-git-send-email-zhangshaokun@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622181328-9852-1-git-send-email-zhangshaokun@hisilicon.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 28, 2021 at 01:55:28PM +0800, Shaokun Zhang wrote:
> Variable 'xfs_agf_buf_ops', 'xfs_agi_buf_ops', 'xfs_dquot_buf_ops' and
> 'xfs_symlink_buf_ops' are declared twice, so sort these variables
> alphabetically and remove the repeated declaration.
> 
> Cc: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>

Looks good.
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_shared.h | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
> index 782fdd08f759..25c4cab58851 100644
> --- a/fs/xfs/libxfs/xfs_shared.h
> +++ b/fs/xfs/libxfs/xfs_shared.h
> @@ -22,30 +22,26 @@ struct xfs_inode;
>   * Buffer verifier operations are widely used, including userspace tools
>   */
>  extern const struct xfs_buf_ops xfs_agf_buf_ops;
> -extern const struct xfs_buf_ops xfs_agi_buf_ops;
> -extern const struct xfs_buf_ops xfs_agf_buf_ops;
>  extern const struct xfs_buf_ops xfs_agfl_buf_ops;
> -extern const struct xfs_buf_ops xfs_bnobt_buf_ops;
> -extern const struct xfs_buf_ops xfs_cntbt_buf_ops;
> -extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
> -extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
> +extern const struct xfs_buf_ops xfs_agi_buf_ops;
>  extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
>  extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
>  extern const struct xfs_buf_ops xfs_bmbt_buf_ops;
> +extern const struct xfs_buf_ops xfs_bnobt_buf_ops;
> +extern const struct xfs_buf_ops xfs_cntbt_buf_ops;
>  extern const struct xfs_buf_ops xfs_da3_node_buf_ops;
>  extern const struct xfs_buf_ops xfs_dquot_buf_ops;
> -extern const struct xfs_buf_ops xfs_symlink_buf_ops;
> -extern const struct xfs_buf_ops xfs_agi_buf_ops;
> -extern const struct xfs_buf_ops xfs_inobt_buf_ops;
> +extern const struct xfs_buf_ops xfs_dquot_buf_ra_ops;
>  extern const struct xfs_buf_ops xfs_finobt_buf_ops;
> +extern const struct xfs_buf_ops xfs_inobt_buf_ops;
>  extern const struct xfs_buf_ops xfs_inode_buf_ops;
>  extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
> -extern const struct xfs_buf_ops xfs_dquot_buf_ops;
> -extern const struct xfs_buf_ops xfs_dquot_buf_ra_ops;
> +extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
> +extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
> +extern const struct xfs_buf_ops xfs_rtbuf_ops;
>  extern const struct xfs_buf_ops xfs_sb_buf_ops;
>  extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
>  extern const struct xfs_buf_ops xfs_symlink_buf_ops;
> -extern const struct xfs_buf_ops xfs_rtbuf_ops;
>  
>  /* log size calculation functions */
>  int	xfs_log_calc_unit_res(struct xfs_mount *mp, int unit_bytes);
> -- 
> 2.7.4
> 

-- 
Carlos

