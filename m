Return-Path: <SRS0=BK4F=CC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46ACFC433E1
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 09:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EF202075B
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Aug 2020 09:58:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DLPPWAWy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbgHXJ6U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 05:58:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20540 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727881AbgHXIeR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Aug 2020 04:34:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598258056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pXqN7hz6Jbb1RFg+TPt9h3H3Op4WByETrFevWvEUpow=;
        b=DLPPWAWycAqDy/WzXxm08ZafSrvVsA//PZuyDLp+43KtMM4XY1a/UEjn8cR4sk8J+nz2iE
        CSVRqDIF8oqbdK+UzcR0pi5bdizXj+ewkys8ofXVJ7I205gUbgbPF0E/9E8lC1sWCv4y0d
        GmlK9anp3Dpz+3IWPXQn/rgZ4xW8sA4=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-462-yaZklssaPVaNHmURDZMYdw-1; Mon, 24 Aug 2020 04:34:13 -0400
X-MC-Unique: yaZklssaPVaNHmURDZMYdw-1
Received: by mail-pl1-f197.google.com with SMTP id p24so4979102plr.23
        for <linux-xfs@vger.kernel.org>; Mon, 24 Aug 2020 01:34:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pXqN7hz6Jbb1RFg+TPt9h3H3Op4WByETrFevWvEUpow=;
        b=RIwRVU5INJyGNExWLTbFLAC2vkAwbjYQtNg+IcK017YtSY6qF5dYbHERLtF0BCGoHe
         +UaZe1BFA3LdY2+Z07oFO8pj0uIhZXh48AycIy+zZDxaUA+unbW8sLOWvxDyRwU4vuZF
         NMxRJ/jGqEHcgp8ly+2ubmEHZFkSJAklVbIOecyueBAvMv3XtHXaH8SVLXvr+7IF93LN
         cfgVATnArOgaacsITp+O4frjfgikavP7cCbuC5EEO31KQortOu3U7XcychqNKse11YCq
         /AbtfA0mGWMj81EN4RHw++mrr1MIR3dlF7vlsvwF20SiwDLJSSRq2cq7hS2kTVtyWuLS
         itAg==
X-Gm-Message-State: AOAM530+rGZ1vu2jkaCZCEAHBETT6cKD4XC1y56sOOyU7mv03f6miLVJ
        Tkq4Q3ZMpNTxquVJFKpt1zwvZ3vJociEgARpJirCrUl8gyoQyqmi8sLEC2U8vt+di3VJ99QGupi
        8jlJ7yIGMuucEDgN4av7r
X-Received: by 2002:a63:2d83:: with SMTP id t125mr2528328pgt.441.1598258052605;
        Mon, 24 Aug 2020 01:34:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrWlw1f0yAtShagbB8q7poWXlBKRmsVx+h5zfph/cOIlUO7KdNUV907RJEABaSRETvLnKKKQ==
X-Received: by 2002:a63:2d83:: with SMTP id t125mr2528323pgt.441.1598258052360;
        Mon, 24 Aug 2020 01:34:12 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x13sm2037232pfr.69.2020.08.24.01.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 01:34:11 -0700 (PDT)
Date:   Mon, 24 Aug 2020 16:34:02 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC PATCH] xfs: use log_incompat feature instead of speculate
 matching
Message-ID: <20200824083402.GB16579@xiangao.remote.csb>
References: <20200823172421.GA16579@xiangao.remote.csb>
 <20200824081900.27573-1-hsiangkao@aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824081900.27573-1-hsiangkao@aol.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 24, 2020 at 04:19:00PM +0800, Gao Xiang wrote:
> From: Gao Xiang <hsiangkao@redhat.com>
> 
> Use a log_incompat feature just to be safe.
> If the current mount is in RO state, it will defer
> to next RW remount.
> 
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> 
> After some careful thinking, I think it's probably not working for
> supported V4 XFS filesystem. So, I think we'd probably insist on the
> previous way (correct me if I'm wrong)...
> 
> (since xfs_sb_to_disk() refuses to set up any feature bits for non V5
>  fses. That is another awkward setting here (doesn't write out/check
>  feature bits for V4 even though using V4 sb reserved fields) and
>  unless let V4 completely RO since this commit. )
> 
> Just send out as a RFC patch. Not fully tested after I thought as above.

Unless we also use sb_features2 for V4 filesystem to entirely
refuse to mount such V4 filesystem...
Some more opinions on this?

Thanks,
Gao Xiang

