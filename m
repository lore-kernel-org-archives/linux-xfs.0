Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3EFEC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 02:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbhKWC6B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Nov 2021 21:58:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232824AbhKWC6A (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Nov 2021 21:58:00 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79098C061714
        for <linux-xfs@vger.kernel.org>; Mon, 22 Nov 2021 18:54:53 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so902241pjb.2
        for <linux-xfs@vger.kernel.org>; Mon, 22 Nov 2021 18:54:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hzu6WTfZUrCey1J7m6mzu3SyuG3mlb0cV5bc4AfptPs=;
        b=beaUT1FtsNFsra95ne0owHh0REAyyuUzujf6WfZCqbHVqWDCseUjZNBp1imtZrvl25
         Tle8IyUp3iiK6T7rSedrQcl9c/h0UQVa4ff4523mpAef4KYGb1TbGvy3lfGAL4G4Ooqr
         TH0f0Xw5heidYTCEKZrSbgx6eXucck48D1PdG9bQqnHF3xFKgaR12HFK4qLWfYdcBAaW
         hyr06oXivq4GX87hiZVUip/cxW8DPPmY1DWSzEzAGLteKQgqOmlnE0Fzbh+eO2i8dmuO
         d0czzqQ7InLmIRWHjnUfTxiVsP9Xg6prNyjUDIVMDnnmk947ZrGB8bNv0YUysQL48hVn
         bE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hzu6WTfZUrCey1J7m6mzu3SyuG3mlb0cV5bc4AfptPs=;
        b=d0cIis9Mko34Zp0IlvOsoKr3bi2VUpNZWugc1JiN8PkZX1YkQ2PBSDCAiUtW6SjGvc
         P5PwCGOgui0BO6HyrMFiHQlWbVJX0p2rpeapHe6srSJ6mKi4ZMQh3qXi3Ym1E4X5q7cu
         s0KE306Q154iaVRi3qd+LpVF1WMI0N2ebBhD8wl/wv8Phc8srsxpBRodTKRbrS/VyVv6
         MBYeRLc6O095iza6EeGkX98xA1zOf6ln4XMCiPNL6c/Sb9pldw0SNgxkZCJQj8e4Ev9S
         IdTJCma56ivGQDGACuwqyzrkKECaGoh5/Q9CCmuYmqQG7ZfS1faHz6T4wkzGC5LLVpzs
         fVGg==
X-Gm-Message-State: AOAM530gzAqidGvSbeuZuHUm8TadUJgzfM6RRO9MTeWPiIsbpHmIPh9h
        ufOy3Ks/oUIL73gV2Sd5419veGej41QOlY8BtOLBhw==
X-Google-Smtp-Source: ABdhPJxeiX5ifpjvIOpWVxQMDUuHcOe3OIdJeR8Imw/gLHmEQwl4x/JiO/uU+o3bH9o5PQYkURGBJLUFMItHEKRZD78=
X-Received: by 2002:a17:902:a50f:b0:143:7dec:567 with SMTP id
 s15-20020a170902a50f00b001437dec0567mr2776615plq.18.1637636093077; Mon, 22
 Nov 2021 18:54:53 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de> <20211109083309.584081-4-hch@lst.de>
 <CAPcyv4hzWBZfex=C2_+nNLFKODw8+E9NSgK50COqE748cfEKTg@mail.gmail.com>
In-Reply-To: <CAPcyv4hzWBZfex=C2_+nNLFKODw8+E9NSgK50COqE748cfEKTg@mail.gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Mon, 22 Nov 2021 18:54:42 -0800
Message-ID: <CAPcyv4g=KgKZR6JF8_=mTs7Ndgq7DSU+5_sTJ7gQuwUgC5dRYg@mail.gmail.com>
Subject: Re: [PATCH 03/29] dax: remove CONFIG_DAX_DRIVER
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

On Wed, Nov 17, 2021 at 9:43 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > CONFIG_DAX_DRIVER only selects CONFIG_DAX now, so remove it.
>
> Applied.

Unapplied,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
