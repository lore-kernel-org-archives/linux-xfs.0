Return-Path: <SRS0=ZxTw=CK=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B38D6C433E2
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 08:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DAF9206CD
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Sep 2020 08:19:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X52toUg2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgIAITk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 04:19:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:26309 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725848AbgIAITi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 04:19:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598948377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8nJSmsVYi+mvqK8pVkimcTmEqqQH15FPs8Sd5zefJKc=;
        b=X52toUg2wCfacYZaqaBjUixZCOpHUCdg+C8huo9Cjtu9wMYwj24T5fUky3F+cEDT8DnXzk
        jLOd5d9g2Max0vpBsvLjj2C2MpENvEXXSFuTCQ1QMEF1jtNZQ9Hoqhrw9e915OqMra21oH
        SJ8zoEJQK/vdqr8gCUVStEH6W/XuL0g=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-4vuHx6fbO3Gqk23v_cNaGg-1; Tue, 01 Sep 2020 04:19:35 -0400
X-MC-Unique: 4vuHx6fbO3Gqk23v_cNaGg-1
Received: by mail-pl1-f197.google.com with SMTP id c6so225977pll.15
        for <linux-xfs@vger.kernel.org>; Tue, 01 Sep 2020 01:19:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8nJSmsVYi+mvqK8pVkimcTmEqqQH15FPs8Sd5zefJKc=;
        b=TOd+72EqkalebZ244STsDy7pKxlAhexDviDkIsQNzlTvsiLgBR6M6hvc3meqdLj9iR
         xHDi5n7L94wccOwqUS3ME0OKvOji7m/6x4PWPuJRWq3+LrvS+YYnKg0x6FbZqVGPm+pM
         C8k2viKn3znP5cqw4AGcNsepTttKYs5HeqTsw1ssySlmwaYRM42u+V3l68ZlUDUHYX3m
         PJAT1PpCvvuYRsCy1C/joKLLJ3iN+wBi3eyvjJsgwejfpAvOfcsETtRZIldcaytGaGxe
         CTQHGN7CaMX0hY3NA/fVLUhxK3Pv+ZMLNLiQn5S1Al40cWuflvMBaBeHslUhToG+Tcyo
         fvZw==
X-Gm-Message-State: AOAM5314u0AsUvBC4DNzI7Jng5eKKcUru4Td11F30GtHvmWjVw7SeIG4
        yMh40fchvY+FOhKJN0zHp8A6kbvojmrn4+JaS5EiDfM7g5gY7Erj7iFSez6RMJaCwXty+o4IGp0
        VRihGMiDUfTs3Mr1+Q4I8
X-Received: by 2002:a17:902:c40d:: with SMTP id k13mr412961plk.220.1598948375021;
        Tue, 01 Sep 2020 01:19:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaqWOohPiBHyPX0zUCt6LlsoX7d6eZcmI78se5iVMR4NTYY+zR5S5QvbNl5n1gcSwHImivBw==
X-Received: by 2002:a17:902:c40d:: with SMTP id k13mr412953plk.220.1598948374832;
        Tue, 01 Sep 2020 01:19:34 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a14sm655405pju.30.2020.09.01.01.19.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 01:19:34 -0700 (PDT)
Date:   Tue, 1 Sep 2020 16:19:23 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>,
        Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, amir73il@gmail.com, sandeen@sandeen.net
Subject: Re: [PATCH 05/11] xfs: move xfs_log_dinode_to_disk to the log
 recovery code
Message-ID: <20200901081923.GB32609@xiangao.remote.csb>
References: <159885400575.3608006.17716724192510967135.stgit@magnolia>
 <159885403949.3608006.461873440398923846.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159885403949.3608006.461873440398923846.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 30, 2020 at 11:07:19PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move this function to xfs_inode_item_recover.c since there's only one
> caller of it.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>

Reviewed-by: Gao Xiang <hsiangkao@redhat.com>

Thanks,
Gao Xiang

