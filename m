Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C23C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 03:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhKWDoV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 22:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhKWDoU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 22:44:20 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFADC061574
        for <linux-xfs@vger.kernel.org>; Mon, 22 Nov 2021 19:41:13 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u17so15875386plg.9
        for <linux-xfs@vger.kernel.org>; Mon, 22 Nov 2021 19:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yuisy9zT1caIpoCJEL+LfomruK38WXIi70xmI7lYDdI=;
        b=Y08/be2uy1a6FHo2yuq5V6dIERIFe+eeTyXLXTKFjFxfAYARUBwDdqRv9XulygxcF5
         4zZfKtYGqV6eckQSPyIqI+Gn3GMQFWIP9FXR6DHHwN+9GDnZm18bVZGFa88rvhT3Zhp8
         eBxG8SJu0LWqmuhUvXdN5Q8E0N7Fv2c7+1ZOSnPpTxrI3q5JIXNMGFvAj0k+TWuhQgQG
         tLoyO8DVm7L0ndxV5dBnp+whJ587dE90ANm0vqzPKJbxSHtsEtd3ERFpgMcAPItk+09G
         dbm69RRAjzWoV6a6vlvEHV0tkZfEJqiOGj5p0uoKbINk6WBGJnIFfCSAm3gIT8TG78mL
         kVoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yuisy9zT1caIpoCJEL+LfomruK38WXIi70xmI7lYDdI=;
        b=6af05ph7X9yLmxsPGN+q6cSheG1t0XkVXZLG8mXHVAweKy3pXdNGZbAY3YdrFfe26g
         /NYrzAGCMjAKdE1IEQQTTxzovZe7+wDSdXtkx5h3zJmt7YSyzQ8TgYeIhsSvQfmob7lQ
         stLj2/hLziBarSFV+ZmF9KICp9yS3Lywggg8hC1PZNdSEgyEAENr4yp6VZ76QtQu9Klc
         FQ918mLAsh52xGdU0PrtBKG3u9DKuOxFLSHsadaiomXnMHkz9K763XpxH8iZqqwGUJmr
         OPXUD8mlsT332mMYDdAOaPi7BjHXl/njGG6TlRd9u0fNvZ0WO2IziBkBCOXhTGmpdDn8
         M2zA==
X-Gm-Message-State: AOAM533PxyKlcAp9B/Vn9ZMki1ISHseVjJltlV6t+uUZfv+AkHSfxvJS
        ytWVZzafNBlTWNaNn4HlZTEnHmXAFkBUDe+z35Xp2A==
X-Google-Smtp-Source: ABdhPJwgBzEQtBEEt5JgwawqvX/CZbZsaXh/qAQWeeflxeagBI6MsJ+fyqKdfOXHrkiL5G4d5gMRZlq/mNM2Mj9gTds=
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr2525502pjb.93.1637638872640;
 Mon, 22 Nov 2021 19:41:12 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-7-hch@lst.de>
In-Reply-To: <20211109083309.584081-7-hch@lst.de>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 22 Nov 2021 19:41:01 -0800
Message-ID: <CAPcyv4imYR=NLizABpZA+gKH+amNQ6jcVNQhtF+1jyevdWzmBw@mail.gmail.com>
Subject: Re: [PATCH 06/29] dax: move the partition alignment check into fs_dax_get_by_bdev
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
> fs_dax_get_by_bdev is the primary interface to find a dax device for a
> block device, so move the partition alignment check there instead of
> wiring it up through ->dax_supported.
>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
