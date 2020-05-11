Return-Path: <SRS0=Jrso=6Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3177EC47255
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 11:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10AE920708
	for <linux-xfs@archiver.kernel.org>; Mon, 11 May 2020 11:40:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bvTtZRfU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbgEKLkq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 May 2020 07:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729596AbgEKLkp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 May 2020 07:40:45 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A743C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 04:40:45 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id p25so4608886pfn.11
        for <linux-xfs@vger.kernel.org>; Mon, 11 May 2020 04:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dELuqzWhUAxPQcJP5fGhtjcAnIq04cGt4VYLIlLvHMc=;
        b=bvTtZRfU17jh83dcbd9u4JniCnuJ09vJFY+eZ2N14UiLUQE8eQd/1km85EXrjEz8zt
         b1IdP6G66jYB7kqpD+6bzNI9j0bp9HIzBWkEPMOGeIa8U4wZSOm/oZRmAy2/lovttXD3
         QTWt7DSw6sNNk4vN3izfV4n5sJe1HfVQG0vx4O/h/+70A9EYYlHOFIduw6851b6aWy6e
         oVrNHwqUANpOxD02H2t47bX6MWqQ6EVPlNkmnF2m25YnZLeY/t9004ENRIyFDJ/6MYyE
         5UKRbWXBVBSHBaXAlcmrb+dbYWoF4aCH7EJEA6s7O74DTp1Zy8m415S5K31p1rRQtgP9
         B+8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dELuqzWhUAxPQcJP5fGhtjcAnIq04cGt4VYLIlLvHMc=;
        b=JRLz2in3aM0pbEd3HqF/N3oPQb4qMbX/2GgEZVZiUFaufeU9vMuHSoytYCiH+WyGjw
         z371kHwLxWmI6PoWEgR60FF2xEn7/zcbW54fch+o+b//afuPk1x5Z9jet8i/GT/CjIPa
         eF1kTJc2yAXGCXDWasM7J/xjW+dSMpNdO6RKyFHLcyiOW63pC+NUGUgfwEfZ+pABX1TT
         QeuyoL1TStrDISg3ys+nJpWHrIP1BQAgqBpOz73EwuyDAr+nKXB8jJL4NeyhwhCyJvea
         dR18iDfc2Xjzij/hwERRSWP3xfVGfOBZbxnZ3jAEDiJqovwRzcwxdS5M5T+yxb2MdG4Y
         6o2A==
X-Gm-Message-State: AGi0PuauOmjMLzYNT4K6KPC1sAzgAzYCxosGKLfs4cqGMQQB5KuMgxmF
        hOiRLwxaYB3c2walKmEJ5xltUCLI1Tc=
X-Google-Smtp-Source: APiQypJ35rXkmBXXylUITHUu9+HwxZf0IvOKfo/exODylG1Lnt6TwxQXEdtLkI7gs0zdAzNTRtUBwg==
X-Received: by 2002:a62:18c8:: with SMTP id 191mr15933565pfy.255.1589197245056;
        Mon, 11 May 2020 04:40:45 -0700 (PDT)
Received: from garuda.localnet ([122.171.220.131])
        by smtp.gmail.com with ESMTPSA id a15sm9799634pju.3.2020.05.11.04.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 04:40:44 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: use XFS_IFORK_BOFF xchk_bmap_check_rmaps
Date:   Mon, 11 May 2020 17:10:04 +0530
Message-ID: <2615851.ejxhajbSum@garuda>
In-Reply-To: <20200510072404.986627-2-hch@lst.de>
References: <20200510072404.986627-1-hch@lst.de> <20200510072404.986627-2-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sunday 10 May 2020 12:53:59 PM IST Christoph Hellwig wrote:
> XFS_IFORK_Q is to be used in boolean context, not for a size.  This
> doesn't make a difference in practice as size is only checked for
> 0, but this keeps the logic sane.
>

Wouldn't XFS_IFORK_ASIZE() be a better fit since it gives the space used by the
attr fork inside an inode's literal area?

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/scrub/bmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> index add8598eacd5d..283424d6d2bb6 100644
> --- a/fs/xfs/scrub/bmap.c
> +++ b/fs/xfs/scrub/bmap.c
> @@ -591,7 +591,7 @@ xchk_bmap_check_rmaps(
>  		size = i_size_read(VFS_I(sc->ip));
>  		break;
>  	case XFS_ATTR_FORK:
> -		size = XFS_IFORK_Q(sc->ip);
> +		size = XFS_IFORK_BOFF(sc->ip);
>  		break;
>  	default:
>  		size = 0;
> 


-- 
chandan



