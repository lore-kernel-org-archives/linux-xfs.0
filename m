Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 129B4C43219
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 03:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhKWECq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 23:02:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbhKWECo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 23:02:44 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5B6C061714
        for <linux-xfs@vger.kernel.org>; Mon, 22 Nov 2021 19:59:36 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id o4so18059462pfp.13
        for <linux-xfs@vger.kernel.org>; Mon, 22 Nov 2021 19:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g/ky7DkMfynxz93Jg1Thyokk1eZpzUf1Xl2rDhRoyWA=;
        b=gwTsNrCEoSododJW02pXoG5va8bW6OECitQWc09+sfRQX7sjnk65lMa71jflZhqZ1Z
         86aeuya1xffrx25hqOEdYvOiHJs5SgCPT9ynh1h37Y6R+YK22M+VCRKtE4fEa7B4vmJj
         FgIl1EAn3HVhHAskqaElmROImyfgrhseCNECcArK+N8mGcWyaNrHQ2uUa5SryedQ51xK
         EFHOUqysfj0ZP5ewN50SJI8X536nWAnVKZXIvFxFdkrKxXPVOOjm85CFAu2VFaD2Y1/c
         IkmhJjqPuO4/my+NrNDZVrBhbYZL7tBr4KB5P4Dw+Kdi1tW3eMcLXRLw1g/M1n7CsTvT
         3cxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g/ky7DkMfynxz93Jg1Thyokk1eZpzUf1Xl2rDhRoyWA=;
        b=7fedM8eIobW7x3a3cyYF6cZtGmdpO4kay0qekI9HlKxayvem6/4RyxJqkgNitGHY5g
         GR97U6UommPo0uVmgS8ziUSqtaQPY5LRYI7YtixW+SyczZjA76UBoLmxiFGAG0LIcAfu
         fGRuTW7QIOINV8F/DOytPqXVAQ6qcWk2Tf0vPG49LpDKQrBT4UPubEHAajtciG3UpJd+
         mOsmXEckzlt3q2oQzCsWH6vKRb+PVvbzEtgSrMd95PgL7igteU+fkHDaFUF1VqnHm+M/
         QUA/cGqtLQOvpBxWq0W3pj0py3kOOpHGYKeD5c3k5O+2+Jo5AWJP0JW6QA0E8SbCRo8M
         INyQ==
X-Gm-Message-State: AOAM531Y8WGjbB6N78CACyze+YZS/FgxTLTJMCXm3+n+d+XVywH3nGWS
        Z+Iu/FeKqHVg9Sr/knLvopeGkCmpYvmyzrF/Mryziw==
X-Google-Smtp-Source: ABdhPJwGHnABHnUK3lJPgD02NSEK0H2EfeyLizUEIRr93I6wp+H8p3N47d3IhUfBHGyYAjrqraEpCA3HamH0r9lHbyI=
X-Received: by 2002:a63:85c6:: with SMTP id u189mr1546658pgd.377.1637639976375;
 Mon, 22 Nov 2021 19:59:36 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-10-hch@lst.de>
In-Reply-To: <20211109083309.584081-10-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 22 Nov 2021 19:59:25 -0800
Message-ID: <CAPcyv4igxMdMA0XpjZt0aXahef5Worvz663ynd5i4=HeKJAqKw@mail.gmail.com>
Subject: Re: [PATCH 09/29] dm-linear: add a linear_dax_pgoff helper
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

On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Add a helper to perform the entire remapping for DAX accesses.  This
> helper open codes bdev_dax_pgoff given that the alignment checks have
> already been done by the submitting file system and don't need to be
> repeated.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Mike Snitzer <snitzer@redhat.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
