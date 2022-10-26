Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80CC1C38A2D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 00:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiJZAqI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Oct 2022 20:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiJZAqH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2022 20:46:07 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71F7D38E9
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 17:46:06 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n7so12542699plp.1
        for <linux-xfs@vger.kernel.org>; Tue, 25 Oct 2022 17:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6SNen96G8r5HHDU7voNNs9kJkF1o1pFLR0tNBPsPkfI=;
        b=XTGVoXXY3iRbNHeEdKmzH6yAQ3xkszHnkdBsgVgXdoLFYXZarVahOVv8Rf0GRzNcdn
         sYh8w3TRteWOPcV4Es/CwlvXWu3YtiVvaIAjNbBo+1elbSD/+OTaXF7wQHJL6D8/Q4S2
         +TNqSnKsmm3ZtzDHAtV5hQ/hIWXx94oQ/fSiqN7eBdPkgCF/EhutnxK5iPYwcm5dy9v3
         nL6Cde8rbEsuXe71XevDckFpDtyhqmQq/ON7IxGPE7natZ8I5a2ym1OHov8cOY1lVmzC
         73GJG5AGQgA+yA/ArPeGo9rwA0Agn7kzNQq9HRgLbUZ3wrmn9YfBX3YdBCYLBbBVTmdx
         x4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6SNen96G8r5HHDU7voNNs9kJkF1o1pFLR0tNBPsPkfI=;
        b=KOrXsOTWsuEXtDgcMcmY25zOeI+TLi1D8HBI2grLkRrceeXh97GVk4lpvYCcBIPBqx
         nkCKmINGNHS3XfEg2xfPMsvE9JkW+y/aiI+Itgrm8oBRvzpv88YMvqJvdYM966kQov5l
         zrAFnjB5v6GMJNi6dYe5y0KL7o+NbiZss5AlJOYoJoVMRI99ypAU5NUHKxUcOEVNpT10
         onKt3qdV2l4afpAHFCjTm6IcE2AwYNLE0fjyAHl0Evt77Tk9EHeQTeia63tIIMHAYJWD
         VIls1mZjZA0RXTcnJHX+68bAs2voPdiXGT4ZSzbsPSs0yDTztZQTq9TIwT9TGZgerglI
         t5dA==
X-Gm-Message-State: ACrzQf2yyIGol06kCuNvegjW5jVBBUKJC3uFT9ydVe/k9QLHvrnjnkXf
        y06MZLRHxyH1rfG9kgbpM0QoP2jObMnMYg==
X-Google-Smtp-Source: AMsMyM4XgaWo9m4nlNK9AhIz6mM5y1pzB3Df0CS1q3oPBwEmUmZU3HIMGaHrUVFDEBD6eAZsYxCtbQ==
X-Received: by 2002:a17:902:ab5d:b0:186:bb2e:85a4 with SMTP id ij29-20020a170902ab5d00b00186bb2e85a4mr8396265plb.135.1666745166268;
        Tue, 25 Oct 2022 17:46:06 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id mn22-20020a17090b189600b0020d24ea4400sm168817pjb.38.2022.10.25.17.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 17:46:05 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1onUYV-006QJm-0k; Wed, 26 Oct 2022 11:46:03 +1100
Date:   Wed, 26 Oct 2022 11:46:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/5] xfs: check deferred refcount op continuation
 parameters
Message-ID: <20221026004603.GM3600936@dread.disaster.area>
References: <166664718897.2690245.5721183007309479393.stgit@magnolia>
 <166664721743.2690245.17086652152508491843.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166664721743.2690245.17086652152508491843.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 24, 2022 at 02:33:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If we're in the middle of a deferred refcount operation and decide to
> roll the transaction to avoid overflowing the transaction space, we need
> to check the new agbno/aglen parameters that we're about to record in
> the new intent.  Specifically, we need to check that the new extent is
> completely within the filesystem, and that continuation does not put us
> into a different AG.

Huh. Why would they not be withing the filesystem or AG, given that
the current transaction should only be operating on an extent within
the current filesystem/AG?

IIUC, this is code intended to catch the sort of refcount irec
startblock corruption that the series fixes, right? If so, shouldn't it be
first in the patch series, not last?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
