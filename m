Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F333CC433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 00:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbiKBAbK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 20:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiKBAbJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 20:31:09 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFBF12D1B
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 17:31:09 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y203so837571pfb.4
        for <linux-xfs@vger.kernel.org>; Tue, 01 Nov 2022 17:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v697MMsDxn7N0uMAJhOLfwyhcigNiWi7m8uiN84Vqfc=;
        b=hqK9l6N2CKvb9sLMvWhnLoVRfTOqy3P1aoXs/cx7XwLpowyW3KQxi1npeA4iGNqmhF
         uy4jJOFPotg7NFUaoPelwvyQh9TFShAxad7JJEINwgD175tGyTnPMkeS5M4xyc4XbAXO
         oaJq1i/+mGbn7CWfKzEqqvV+GRsP/mAP2gcHs6I5fFy1ildhvDnclGZvJb0gVdhuzb9l
         eSTZ3Q2QS+XJJ6UzcaPWjq85yGz+lAkS1SJHUHyLDOXZ+olV/z0oVmaDjz6KkS/NEdTG
         YuaukKAX/MC5KvmTpjN1aZkiqklR6oCZ9Q5c2ox9hNylExY7omwA/LxE+49h51T3Bwdw
         HBEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v697MMsDxn7N0uMAJhOLfwyhcigNiWi7m8uiN84Vqfc=;
        b=UBvHxLHp9i8s4FkspOSZLVqc5n+i8ajMSnsPjZrJYfuw5Gh18slGhImMam4FYR6eg9
         qrA5GWcCUT0d3RQBlyEDpBBZM78kzWhRxaRa7uVi2RU8G6hMRWxgkCBgbHYtaCkNN5g2
         jcSCL/GOia3UtgkIt9B9r6TCm+5k3eZg+O+yRvmZVdWA71RRxcdCyGM+epHjCVDqwTLO
         Xyzunqjr7eCUJ4FZXPe6Qtw49yud2G9Qex8kZTTFgaV7A0HQqdWDnVYDIc9xn0VPk9qU
         OAoS7AcHowHGOk0qbQUE6hz0zMVnKVLTjVg2QHiJViyHf6oGmulek9eZvDJGxTkky+Ls
         t10Q==
X-Gm-Message-State: ACrzQf2cq+mjIRowG+3T5/YxLf0N6XmC1QyEZyo3CekIRMwcF9oxRACs
        r7j2aRW/jARJQy+J5LIj0y2JSXPIgecc0A==
X-Google-Smtp-Source: AMsMyM5+XHeXh6crb3sSEzg4uE20ga4Qvb/8IMAVSjQQfU3NYkaifF+N+8byoifY5BH6WaepC09oXA==
X-Received: by 2002:a63:1861:0:b0:462:4961:9a8f with SMTP id 33-20020a631861000000b0046249619a8fmr19622790pgy.372.1667349068604;
        Tue, 01 Nov 2022 17:31:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id gd24-20020a17090b0fd800b0020669c8bd87sm104752pjb.36.2022.11.01.17.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 17:31:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oq1eq-009BOF-FX; Wed, 02 Nov 2022 11:31:04 +1100
Date:   Wed, 2 Nov 2022 11:31:04 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: refactor converting btree irec to btree key
Message-ID: <20221102003104.GS3600936@dread.disaster.area>
References: <166473481572.1084209.5434516873607335909.stgit@magnolia>
 <166473481613.1084209.14289552157471603973.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473481613.1084209.14289552157471603973.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:16AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> We keep doing these conversions to support btree queries, so refactor
> this into a helper.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_btree.c |   33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)

LGTM.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
