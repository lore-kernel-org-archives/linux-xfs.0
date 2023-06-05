Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47CBDC77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  5 Jun 2023 20:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjFEUXV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 5 Jun 2023 16:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjFEUXU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Jun 2023 16:23:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19BFE64
        for <linux-xfs@vger.kernel.org>; Mon,  5 Jun 2023 13:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685996527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z2y4WdrLd0axe9RDI5Uf29dxdGdX9yCuIZXu38SKZS8=;
        b=f6kUm1BLxu3nnz6dNM5wCWGL39+clteBhIYRObziAP7QK2xwIfabZlHogP7kOLKCBiZzWM
        6KOdoAnjWzzjhsKpNJLH7Np8PoWunO6j7l5FRl6TBHeCJyj2CFTCkBD+f0aO3FtUGb+K0o
        dLAgqXzBwp8WqiNxozPFpAivx+OjECo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-5fc7jzK1MTSw1BUMl64gFg-1; Mon, 05 Jun 2023 16:22:06 -0400
X-MC-Unique: 5fc7jzK1MTSw1BUMl64gFg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f7005d4a85so22759435e9.1
        for <linux-xfs@vger.kernel.org>; Mon, 05 Jun 2023 13:22:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685996525; x=1688588525;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z2y4WdrLd0axe9RDI5Uf29dxdGdX9yCuIZXu38SKZS8=;
        b=MTkq6WXu/9itcLN1BnY8vlbMqRvXp8+S+HVb6cZXb+LatXBzK0HyxMhP1Rui8gwe+o
         4ebFvl5/LadlkbQ5Y03C7zT+RSW1aIRilK2RyQ80J/OOCFtx5r40y4Tt5iud9zGMAw5J
         mCY1LePdwjR7INY22usaZSI3zYKGa6S4HMduFf6XSDUTi09iA52tFVxhHoikvtciqedV
         NtG7oaOvq17gza5cpvdiudSOi7Tz0FtHJ+GiNjcMr3kRfVofoMy1dXkgzWOxOUKOPkjo
         dZvXuRtj1aEjZVSZHSZ5VSPgoNbFShDE0ZZ8BuyUYeQlKhXwnAWswVks1zk37CbyQH1L
         5ELw==
X-Gm-Message-State: AC+VfDx9UJA3XGGY9oqI5v7TLO0M9Eg7vpXxjTCTm6FCeFBjtF8ABJWH
        40kGWyArbHhLR4YTpGXz3ojJmX9oVrZMbYVtOLbFZCP9J9cwOYvZCcuPf/LDiip0jv1D5SrGGT6
        t0KwLFQf8cvoKVXAcThDOAb12Soc=
X-Received: by 2002:a05:600c:2257:b0:3f6:f152:1183 with SMTP id a23-20020a05600c225700b003f6f1521183mr194576wmm.37.1685996524987;
        Mon, 05 Jun 2023 13:22:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4V8ymR2QJU1iO17CiAyni9SFnNf9gxC+617keFNayIDGt5YIbRlU9KSeBQU0zHmO9l6g55iw==
X-Received: by 2002:a05:600c:2257:b0:3f6:f152:1183 with SMTP id a23-20020a05600c225700b003f6f1521183mr194566wmm.37.1685996524680;
        Mon, 05 Jun 2023 13:22:04 -0700 (PDT)
Received: from aalbersh.remote.csb ([109.183.6.197])
        by smtp.gmail.com with ESMTPSA id n4-20020a05600c294400b003f739167217sm5995215wmd.34.2023.06.05.13.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 13:22:04 -0700 (PDT)
Date:   Mon, 5 Jun 2023 22:22:02 +0200
From:   Andrey Albershteyn <aalbersh@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 0/3] xfs_db: create names with colliding hashes
Message-ID: <20230605202202.fniea27gdkyp7t34@aalbersh.remote.csb>
References: <168597941869.1226265.3314805710581551617.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168597941869.1226265.3314805710581551617.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2023-06-05 08:36:58, Darrick J. Wong wrote:
> Hi all,
> 
> While we're on the topic of directory entry naming, create a couple of
> new debugger commands to create directory or xattr names that have the
> same name hash.  This enables further testing of that aspect of the
> dabtree code, which in turn enables us to perform worst case performance
> analysis of the parent pointers code.
> 
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
> 
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=db-hash-collisions
> ---
>  db/Makefile       |    2 
>  db/hash.c         |  418 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  db/metadump.c     |  383 -------------------------------------------------
>  db/obfuscate.c    |  389 +++++++++++++++++++++++++++++++++++++++++++++++++
>  db/obfuscate.h    |   17 ++
>  man/man8/xfs_db.8 |   39 +++++
>  6 files changed, 859 insertions(+), 389 deletions(-)
>  create mode 100644 db/obfuscate.c
>  create mode 100644 db/obfuscate.h
> 

This patchset looks good to me. Seems to work.
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>

-- 
- Andrey

