Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D78C5479D
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Jan 2023 22:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235934AbjAKWKd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Jan 2023 17:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbjAKWKc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2023 17:10:32 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBCF431AE
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2023 14:10:31 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v23so17236886pju.3
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2023 14:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=94hRjNkuiXTX89xtFtEkm1sYK0XJ43+wmsBDql/UaUE=;
        b=FKyU24PiQaMZFlXaW2E4gO9oKe4D+VEsGnPNJxto6eMnRn/H8D92Ri8Ad6icBSOT/c
         1zHj//dff8Rqyl4g4Y539pfDoI5ZsiSvutW2nbyo5dTpqWiJfq5AUpIzNmw38HY0E1RS
         RW74cvwRJuan3IB6sbMTUHMayeW+jQzw6OavtRp4IIhqIx4ghl0j5rRQ0J7VPCPh/UtV
         kC/YKRDgpVQmrT/r6JjrTX5VzdnILbmp54iRc6KuA4dtLAVan4Fm5kHx0IDib9DevHCM
         znE8Q+3KtfZ6q/v7s50s5oArMiGPDFLTIMbFs2bTvcDPVysWl+5VGSkeB2IOjCDJF4Cd
         5OyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=94hRjNkuiXTX89xtFtEkm1sYK0XJ43+wmsBDql/UaUE=;
        b=rgA3rjDZX4T6Jxrc1U9Ljd9/QOAXi8sMgYzT2Eex+xMqAVEcV1PL4dYeO5lKDW/3F5
         iAX2cSvV/2z+YDCOVcZFw7xbCqJrYl4i/0FfgV8d+MRN8ND7/YURHKYt2SJFjRpR6TCK
         w4gTu9HTHOSZi2nTjkziblQcEXwgftW1IrMe7JseW/78E++YhZ37sFjvhNqtui+L37Pb
         E7GULgDqHWiW7pEElvLahgIIsjmDLqJIqSKRg67si/vf0EvOzPqQPpcrJY3cAV9AgKmc
         A6Uh00Hxdjqo0PzNFfsLonXrEp+d+aVCeGP0lSIORjIorj1xCcD5U1jqpTZEFaRycggO
         I50w==
X-Gm-Message-State: AFqh2ko6/NcZjwNUBCHZcOKPGj0erRQdIZz9jAK5DcXM9gNjXjwAEhfm
        GyAIe1Jqz+IhUowEe7VKz/vMBQ==
X-Google-Smtp-Source: AMrXdXvfKDnhsf8bV7RTkQr/UhQ/E0lWNA7Kqb/kX6Og8vqKPH8cRyc4EBPzpdVoT5joDh81BE1TjA==
X-Received: by 2002:a17:902:bc86:b0:192:721d:6f0a with SMTP id bb6-20020a170902bc8600b00192721d6f0amr53790669plb.60.1673475030529;
        Wed, 11 Jan 2023 14:10:30 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id p5-20020a170902bd0500b001932a9e4f2csm7540195pls.255.2023.01.11.14.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 14:10:30 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pFjIh-001wfU-55; Thu, 12 Jan 2023 09:10:27 +1100
Date:   Thu, 12 Jan 2023 09:10:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Csaba Henk <chenk@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfsdocs: add epub output
Message-ID: <20230111221027.GC360264@dread.disaster.area>
References: <20230111081557.rpmcmkkat7gagqup@nixos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111081557.rpmcmkkat7gagqup@nixos>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 11, 2023 at 09:15:57AM +0100, Csaba Henk wrote:
> ---
>  .gitignore                               |  1 +
>  admin/Makefile                           | 13 +++++++++++--
>  admin/XFS_Performance_Tuning/Makefile    | 13 +++++++++++--
>  design/Makefile                          | 13 +++++++++++--
>  design/XFS_Filesystem_Structure/Makefile | 13 +++++++++++--
>  5 files changed, 45 insertions(+), 8 deletions(-)

The change looks fine, but why do we need to build documentation in
epub format? Empty commit messages are generally considered a bad
thing - the commit message should explain to us why building epub
format documentation is desired, what problem it solves, what new
dependencies it introduces (e.g. build tools), how we should
determine that the generated documentation is good, etc so that have
some basis from which to evaluate the change from.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
