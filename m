Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F110C38A02
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Oct 2022 23:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbiJYX4T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 19:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233062AbiJYX4Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 19:56:16 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C26C4DAC
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 16:56:15 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id i3so13551461pfc.11
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 16:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ztw9rbI9xP7JzaSBYRnlkIELNcKDSYQiiicCXSjE4YQ=;
        b=qLWhUVqpfNGxr1VNajhA1jBWah8/XO5l77UEKJMjcdyfMJKnvZfDEABZvLIhZ46sn/
         /XCVWiWuug2Ws/PK2cAkamgjTTJI2ExtBq+cU6MPXXOgagp/BQEJYuRdl2Xr2Z1tfxBk
         7oyj2LiEeUtUbdF/c6s51hVECCKQmKqEwqbbIYmhaKABcWpJs/KnHmTwO9uw3duJ8QBy
         WQCTI1woi8V/85mXxMvc6PBztzNznx831RktlvdJDVUdUn5EJ1PQolBscRUvKLoifa4d
         SUhUKkVxLDcYxm8Z57OBAB5hWkpqP+btrn1b6VuFs42GaRgr/6TBe+gvV66JskZIWPbB
         Cv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ztw9rbI9xP7JzaSBYRnlkIELNcKDSYQiiicCXSjE4YQ=;
        b=cvPauWu/qcBOh9XnOkykkkBDFo9aKPnPo4MfkF94TdEnrxJUdePp74saZd+VcEDhvj
         Ig/911gtek3mSg35o4HO7JSQgclKYPBFYpF6rgfuAkfWzXIt/Hoyo5LuzySAFXrUpApz
         6flDmiieloLZKWFor1T3Ifya5DWkh8lO0UQh4KdfX/ZW/hVPBpoO3JkB6QeSPwd+8+Dg
         H8/U5zZqXcwLu7ip0v4QgufiUF5h0to1ZeGrgz2SqiLxmTpVuzdixgKhpipQrRu7PvqN
         qHaxms8NmVk6HxUEcozT5X2Z/Y3Mz7JttwHHZNkinPDi3EsYy8KFzsBiI9V65R09Uz2k
         sFTQ==
X-Gm-Message-State: ACrzQf0xmkc/FP6H+lV67rbD3xIskdDcAg480aPOx+0O0RSMZjo2SdHb
        f6KotfxN31fDO8Pa99YpiL43Sg==
X-Google-Smtp-Source: AMsMyM7nxnfsSqLiCV6lMG6kI3c9n1wBcMtYIfIY0A+dPQfKriefO4DwGO6/Fj9L7QCi/1oYnVMy6w==
X-Received: by 2002:a63:ea4e:0:b0:454:26eb:b73f with SMTP id l14-20020a63ea4e000000b0045426ebb73fmr35638926pgk.451.1666742175481;
        Tue, 25 Oct 2022 16:56:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id p1-20020a1709027ec100b00185480a85f1sm1675472plb.285.2022.10.25.16.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 16:56:14 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onTmF-006PYW-Ak; Wed, 26 Oct 2022 10:56:11 +1100
Date:   Wed, 26 Oct 2022 10:56:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: move _irec structs to xfs_types.h
Message-ID: <20221025235611.GI3600936@dread.disaster.area>
References: <166664718897.2690245.5721183007309479393.stgit@magnolia>
 <166664719469.2690245.17398561365687268746.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664719469.2690245.17398561365687268746.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:33:14PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Structure definitions for incore objects do not belong in the ondisk
> format header.  Move them to the incore types header where they belong.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_format.h |   20 --------------------
>  fs/xfs/libxfs/xfs_types.h  |   20 ++++++++++++++++++++
>  2 files changed, 20 insertions(+), 20 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
