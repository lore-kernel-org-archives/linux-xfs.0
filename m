Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F4BC433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B564620775
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 08:59:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bnuQUPQo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgGAI7S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:59:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41398 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726009AbgGAI7S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:59:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593593957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RXx0Lt2k/CnFtiPZfqkgGhtQHxk3BrTjWviC2VpC1Fo=;
        b=bnuQUPQoOaGzsA25f3r6uRDAFqXDtvZsJB1eAg4M+wb4gySxf11p4KWeljDjpW+ARQhbaW
        /Qx7sU1NWT81ZJgMMhMulGdjOrtnE74cwsuY9YrfYPgCL3PO0Ig2IIXf6edx+HPb8QwJV4
        IZNTdGe+SnjdDZBjU2OwoeY0n6oafYQ=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-2_8iNpmBMcay40VKKNMeJQ-1; Wed, 01 Jul 2020 04:59:15 -0400
X-MC-Unique: 2_8iNpmBMcay40VKKNMeJQ-1
Received: by mail-pg1-f197.google.com with SMTP id j9so13793814pgm.8
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jul 2020 01:59:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RXx0Lt2k/CnFtiPZfqkgGhtQHxk3BrTjWviC2VpC1Fo=;
        b=me93PIi9CIVGeijZeLYR3KWHHaJwxN0ciwfjaT8ctu5LMfJtxc1HnvatvJ8QRt/MOn
         Tru8ySaAl9tkddhR6/DfNLFLal+a9xZv5FIRLdFf4Gld1pbA7IXEiaw3tLUmNIj61yRP
         Kn+FOjt3CxMBupoAIThD3XLKtK05rOe5xG6nQAhDa9zy77CYOp8wksl25yVeOQdQKk8Z
         cPSIu4XFGDJjelycKjvY/ZyHJqpOIlF2437LLbWlb9PDVc90smi2GSv6cQluTEvXIBO8
         +suolBBWvxK4hcfmT75KsHpgFAMJmcJg49/38XfDcIdPclEZZzblS3IZdKZfryCwaZG/
         EuxA==
X-Gm-Message-State: AOAM531c3Q0+353qoNbAFhKB7Z9y4M8bXwOBcLv59rAGRAAGiWk3ieol
        CqJqDSxXxdunlaTcJ0arpVOLH9/rLWKQ2ljallkJ62UQoHU+0SEL98vcPYLEs710SVT32m+tFvS
        ieR/LTBX4T+MoDe3cbJXt
X-Received: by 2002:a17:90a:32cb:: with SMTP id l69mr24314076pjb.205.1593593954518;
        Wed, 01 Jul 2020 01:59:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYW7b9ZMALy+n/Mdm/mfra0+RzcqV8FHp9AfC83mw1WsO6Wa7/54aPJr0Tzh3pzfUrg3GBFg==
X-Received: by 2002:a17:90a:32cb:: with SMTP id l69mr24314057pjb.205.1593593954246;
        Wed, 01 Jul 2020 01:59:14 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k23sm4838744pgb.92.2020.07.01.01.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 01:59:13 -0700 (PDT)
Date:   Wed, 1 Jul 2020 16:59:04 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: track unlinked inodes in core inode
Message-ID: <20200701085904.GB10152@xiangao.remote.csb>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-4-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623095015.1934171-4-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 23, 2020 at 07:50:14PM +1000, Dave Chinner wrote:

...

> +static struct xfs_inode *
> +xfs_iunlink_ilookup(
>  	struct xfs_perag	*pag,
>  	xfs_agino_t		agino)
>  {
> -	struct xfs_iunlink	*iu;
> +	struct xfs_mount	*mp = pag->pag_mount;
> +	struct xfs_inode	*ip;
>  
> -	iu = rhashtable_lookup_fast(&pag->pagi_unlinked_hash, &agino,
> -			xfs_iunlink_hash_params);

Just notice that when working on this patchset. Since pagi_unlinked_hash
is unused now, let's kill pagi_unlinked_hash in xfs_perag as well.

typedef struct xfs_perag {
...
struct rhashtable       pagi_unlinked_hash;
...
};

(I will try to add a mutex and a tail xfs_inode for this later
 in this structure...)

Also I noticed xfs_iunlink_insert_inode and xfs_iunlink_remove_inode
are used once now, maybe folding into the caller would be better...
(Just my personal thought...)

Thanks,
Gao Xiang

