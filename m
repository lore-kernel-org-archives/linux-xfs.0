Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5EF7C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 21:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240434AbhKWVU1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 16:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240424AbhKWVUR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Nov 2021 16:20:17 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B04EC061746
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 13:17:09 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id o4so500187pfp.13
        for <linux-xfs@vger.kernel.org>; Tue, 23 Nov 2021 13:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PQeh1LIqbqFtSovgn5WZ7VLYBwfefd3KuHYAxcJ6bdE=;
        b=z/Kv5aF3II2Q1LX6Aazu4oeYGV1DsHDm6VPftSCm/GsXUqcvpUYlHGhNQfvcAEzM+t
         KHEErzvzy9AE7efI2veDZidjjq+fK6s2UJs7fEhnYmQiPFx9rvXEwel822roodlc/FcK
         DEv5SfZdo4Mf/qMs7Jb75ZFTHTDu0awILjq9sqTvXs+VIsFn7y/1XB/C+/lY4NwLFtHP
         cHAfa2a7eS26AcezybSCXTWBbxiGPri9iUr8Wx/IV+DiOD4YHSNiMvTZGqn4/3tFE8gU
         fEqZVpI1Dt83hXy63DNbfv4vosQWDr6RKn8ZmI1PKEqbMIgBEyzoH/HXIZQqJ3XqzuZq
         V9lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PQeh1LIqbqFtSovgn5WZ7VLYBwfefd3KuHYAxcJ6bdE=;
        b=rEOsnodKZHTh9CQhRgyhke1IOtodlyLAYtjxbXPf/PPkIc5MWVqdvgWDpcZedTdvIt
         1UPwv+uDe5GQyVVYubdghr9nHNAVt8YODUoN+zNtrBNlIYsfvnTi7mfAkkO/c5Yq3QSt
         LrBtnYKPmcCMxBDCAY4upAQlTQOwg5xrEtVhvZAp5mJVnRAZOcb1CWppy+2oC0NaAU8S
         GS7KGAwuivCtsrPAMrH1r/bcH4alY/cBIdeF6CycqZW98LHz6MHPglNcxNQkuZWnfKHC
         JX031Hl+u/vV+UypMsptVsjQDfRITPwwI5q5PgQycGet9UvFkIHSDBQKU7RqvNwoeEJo
         b2Gw==
X-Gm-Message-State: AOAM531z7QGTf8qqubxtOMid/1cE+h5YkDgbu5F6ccl7XuUiO8bipS+4
        VU2u9vOiGJ13hlx0TtrsaDyTg+dU3ojMEklTRasavw==
X-Google-Smtp-Source: ABdhPJxo6xmNJWXyaaVPBEUy4anrM6xGk5zJ5S54bOFTPTbJYWg88+GG8ODe3guk693xmG8x/Zkzy+Ul3gB1uuDCJIA=
X-Received: by 2002:a63:5401:: with SMTP id i1mr6112849pgb.356.1637702228750;
 Tue, 23 Nov 2021 13:17:08 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-17-hch@lst.de>
In-Reply-To: <20211109083309.584081-17-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Tue, 23 Nov 2021 13:16:58 -0800
Message-ID: <CAPcyv4jjvoT=aW+_Ks+8L60HG0ypesSi8A+a5F2JXu1dEWHVCw@mail.gmail.com>
Subject: Re: [PATCH 16/29] fsdax: simplify the offset check in dax_iomap_zero
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mike Snitzer <snitzer@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> The file relative offset must have the same alignment as the storage
> offset, so use that and get rid of the call to iomap_sector.

Agree.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
