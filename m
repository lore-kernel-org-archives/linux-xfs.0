Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D45C636D7
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Feb 2023 06:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjBRGRL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 18 Feb 2023 01:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjBRGRL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 18 Feb 2023 01:17:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338E753EFF
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:16:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676700986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=APW3oIrUEWEjGiKY4gDaezSSYCh4pa4uaTuapF7axes=;
        b=bjv3dJjMqGoddbyC7UDW/zZNFKEJ7v8alsWTpPpiznyVH9E7d3P1T7r4LH4wsXx+tArP4q
        P1uzbE+X1m/ahoSPPFgiVEeeGY2tLIc6pApqBMEF0R9lC2W8Z5uxJaVgx2VCZzxlBCod+u
        tX+Rqa1RVTEtSZ2iDCFYI+2Gekjo8Ug=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-120-7BqoSD4VMgCaqxUjXVu_eA-1; Sat, 18 Feb 2023 01:16:24 -0500
X-MC-Unique: 7BqoSD4VMgCaqxUjXVu_eA-1
Received: by mail-pl1-f200.google.com with SMTP id 12-20020a170902c14c00b00199404808b9so31636plj.1
        for <linux-xfs@vger.kernel.org>; Fri, 17 Feb 2023 22:16:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=APW3oIrUEWEjGiKY4gDaezSSYCh4pa4uaTuapF7axes=;
        b=kPT+PbgR8yEm1R9ceTEC2rIOy+INwlKQfAG7SgshTwbFuLyehlVLeI3smLthFPTiaN
         qvIi5Q3kZxdkhhzOiZJm0LB0TtcvKh+IDIf3OAg0nQj1f4KTDgg1VAJfC4D4MYnTGhrt
         MmYrKYfN5MooAjfGBK5LvvMKAKufEd4nf/NuNuImtw4AHg7xekbgvJWkTYvEIDz+f+2y
         ahlK8KVlV+al0i81KVKIEs001yQAWkV1yduh/l7D7qA/sG5bRzBQt2TYNmWV4+WnS6t2
         yr8TM+W5jn8/WiOykbG+M196AyDxJYGuJncP1dXSga9fktte9XDsAVEGs126LxMusjGt
         wGnQ==
X-Gm-Message-State: AO0yUKXSN+fG6pEBDBsaqB3jd5u+PUAwKxDnUfCSpHP2DiYARODFMcfb
        iME/FqBlvntq8o4NXrsqdPNrU4NvEC8oE4EQl1tehUmJARomOM2XX5U6gfJnfi2A3+YSJXxPXFs
        +sCD6E+wZMIBK78V42oFq
X-Received: by 2002:a62:3207:0:b0:5a8:f259:21ff with SMTP id y7-20020a623207000000b005a8f25921ffmr2898173pfy.14.1676700983556;
        Fri, 17 Feb 2023 22:16:23 -0800 (PST)
X-Google-Smtp-Source: AK7set9wqmFS6PWOBqSHVUEHyt/bHCfsFspW5IAN98x62TFf3khHQXVJ+PsyTaecy0FHxXowJKNAmA==
X-Received: by 2002:a62:3207:0:b0:5a8:f259:21ff with SMTP id y7-20020a623207000000b005a8f25921ffmr2898161pfy.14.1676700983232;
        Fri, 17 Feb 2023 22:16:23 -0800 (PST)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t17-20020a62ea11000000b005ac8a51d591sm655123pfh.21.2023.02.17.22.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 22:16:22 -0800 (PST)
Date:   Sat, 18 Feb 2023 14:16:19 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCHSET v24.0 0/2] fstests: fix a few bugs in fs population
Message-ID: <20230218061619.djsl2ljza625qjx5@zlang-mailbox>
References: <Y69Unb7KRM5awJoV@magnolia>
 <167243877612.728350.1799909806305296744.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167243877612.728350.1799909806305296744.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Dec 30, 2022 at 02:19:36PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Before we start on an intense patchset of improving the XFS fuzz testing
> framework, let's fix a couple of bugs in the code that creates sample
> filesystems with all types of metadata.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D

Ack,

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-populate-problems
> ---
>  common/populate |   70 ++++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 46 insertions(+), 24 deletions(-)
> 

