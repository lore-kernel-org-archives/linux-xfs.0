Return-Path: <SRS0=IYS1=XL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B31C49ED7
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 08:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDB4020890
	for <linux-xfs@archiver.kernel.org>; Mon, 16 Sep 2019 08:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfIPISf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 16 Sep 2019 04:18:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfIPISf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 16 Sep 2019 04:18:35 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C4BD9368CF
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 08:18:34 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id w8so1090909wrm.3
        for <linux-xfs@vger.kernel.org>; Mon, 16 Sep 2019 01:18:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=8WyA/zQvad/Ie09Yib1XOMlbO2lHl0DW6i3g8GhUm80=;
        b=kYpmL25Qid8/+xQTrAjJPgXgm83grL7MMX9Tx1ay5aS3HEp5P6DMpdTx2dyywFY0Lu
         SWW6RqXu+Sji0PDycDyoNKijxPkgIkmoj9lq2vupO49koZI3d4noG1B1ODWiruqghCna
         /mRFa0IX1z8gowrJKBgGYX5+SrtgAjcxx7FfPPIdYwLfZIVds/Blyo+d1cAHipRYgyMn
         3tOmwhOvQfDWWHuntTRQ7Tv6NIs0x69n+4KZ9rzW8SqKdbhafJpbPS6m84Y6kBBhAyNw
         NA45V6CgRiPSjDrePB0fkCakLgopScQiYdMc5dwz9CnhnyyuaSEACAxydfxxq9/Jv0+3
         lQPw==
X-Gm-Message-State: APjAAAVpb2uX5m8HvcQgkJ+twdE8e4ukSEfSq15p9pd/MnHEu6l+r0So
        2kp+DfsMyr2Eu/4C7vaSbUjBPQxX0y2NwPzEOHpl0ncnhhwqXO7o3fovipQiBbOEezvoxiWyYUD
        4yGS6ZX/qn7hq95qw/22s
X-Received: by 2002:a5d:6a09:: with SMTP id m9mr3601668wru.12.1568621913582;
        Mon, 16 Sep 2019 01:18:33 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw7KcsBwNvhOcUt1wi6UreVw5PsX5iIwWFEWMWwnnsmEtVHlsiK7AD4BvigeZhjt+4m71T7fA==
X-Received: by 2002:a5d:6a09:: with SMTP id m9mr3601658wru.12.1568621913403;
        Mon, 16 Sep 2019 01:18:33 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id b194sm20642002wmg.46.2019.09.16.01.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 01:18:32 -0700 (PDT)
Date:   Mon, 16 Sep 2019 10:18:31 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH REPOST 0/2] xfs: rely on minleft instead of total for
 bmbt res
Message-ID: <20190916081830.54hdfppv47h3afe5@pegasus.maiolino.io>
Mail-Followup-To: Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org
References: <20190912143223.24194-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912143223.24194-1-bfoster@redhat.com>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 12, 2019 at 10:32:21AM -0400, Brian Foster wrote:
> Hi all,
> 
> This is a repost of a couple patches I posted a few months ago[1]. There
> are no changes other than a rebase to for-next. Any thoughts on these? I
> think Carlos had also run into some related generic/223 failures fairly
> recently...

Hi Brian,

Sure, I'll take a look at these patches now, my apologies, I only saw these
patches now.

> 
> Carlos,
> 
> Any chance you could give these a try?
> 
> Brian
> 
> [1] https://lore.kernel.org/linux-xfs/20190501140504.16435-1-bfoster@redhat.com/
> 
> Brian Foster (2):
>   xfs: drop minlen before tossing alignment on bmap allocs
>   xfs: don't set bmapi total block req where minleft is sufficient
> 
>  fs/xfs/libxfs/xfs_bmap.c | 13 +++++++++----
>  fs/xfs/xfs_bmap_util.c   |  4 ++--
>  fs/xfs/xfs_dquot.c       |  4 ++--
>  fs/xfs/xfs_iomap.c       |  4 ++--
>  fs/xfs/xfs_reflink.c     |  4 ++--
>  fs/xfs/xfs_rtalloc.c     |  3 +--
>  6 files changed, 18 insertions(+), 14 deletions(-)
> 
> -- 
> 2.20.1
> 

-- 
Carlos
