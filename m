Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E15C433FE
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 16:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6105F61175
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Nov 2021 16:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhKAQYF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Nov 2021 12:24:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32187 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232645AbhKAQYF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Nov 2021 12:24:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635783691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E9idZ9g7Qiy202IHm24WOcqzjkMEWV4Amwu/3bidfKY=;
        b=f4bsCOdDAAhujZ4j1fSDR7ZELhloZEKDLzj5eM071qbYhh5lg/GLr1ci82+F3RoEP0sOoa
        TmWsLiTR/6iG4YdjXrVjyfpqIdsQa/cAGIuGrAVRCrq2EAI/H8tLttPnPMdyNA4zVLR+dd
        H5afDN7EQwGOmQdZfv2nYbO8wXevYuc=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-pJ59Ez-NM6CQekQbc17CSg-1; Mon, 01 Nov 2021 12:21:28 -0400
X-MC-Unique: pJ59Ez-NM6CQekQbc17CSg-1
Received: by mail-qt1-f199.google.com with SMTP id n13-20020ac85a0d000000b002ac840c2829so1603884qta.14
        for <linux-xfs@vger.kernel.org>; Mon, 01 Nov 2021 09:21:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E9idZ9g7Qiy202IHm24WOcqzjkMEWV4Amwu/3bidfKY=;
        b=5M2kLX+JtqKYbUOD25AOjcMRCugWmqftqTWf8OzHMal1GHK1y8AOugNsVacDcnJubt
         904lNhyH3fKULQ8QSF6G1lMa++gJ9N7+reD791duVuKZkBjwkfQhO2cmrkHmD9ZGy3Jf
         jZy8U4bARmQxgqOG06w28Gi5zKZMtZzfM6gqRj4H59j+OWR6toBY8EKh7xoxigVBPrwq
         5MtRtyiJsNSFoLZaL4uZSJtLnnPWpq6PgSxIGDkeC8+rVhjVAKziwLt9YGAXJZw7zNSG
         Q5z+eJyAnjK3Nl9WTnsrNqFzIac5v4fXVoQcPHOqSMSlOBWH7/tDbbJDI/9hjJmOaevp
         1dxg==
X-Gm-Message-State: AOAM531APfpB2+dRd5SArDMrXJOgMTi6ev0bfz+FLLQiSKhXTouf+q1A
        Oso+7vNpFajC6Dj3JiP5jSE3RxJnVdXhmySkAspjEzaZlBUX85WZytVfT6eDnqGP5jlHAo42t8V
        TWnKB/0TqH8U/0Jloyz8=
X-Received: by 2002:ac8:7d04:: with SMTP id g4mr30472028qtb.183.1635783688227;
        Mon, 01 Nov 2021 09:21:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXhGf8N2V91WU2Co6WJDyYs4GGgkn9JXnS/oEwWuG4J0RZNo7zMUQJUBh2KgjI9ZclpX5QJg==
X-Received: by 2002:ac8:7d04:: with SMTP id g4mr30472009qtb.183.1635783688071;
        Mon, 01 Nov 2021 09:21:28 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id bj3sm2670847qkb.75.2021.11.01.09.21.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 09:21:27 -0700 (PDT)
Date:   Mon, 1 Nov 2021 12:21:26 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ira Weiny <ira.weiny@intel.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-erofs@lists.ozlabs.org,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 10/11] dm-stripe: add a stripe_dax_pgoff helper
Message-ID: <YYAUBkiPlRCVPnyv@redhat.com>
References: <20211018044054.1779424-1-hch@lst.de>
 <20211018044054.1779424-11-hch@lst.de>
 <CAPcyv4iLbbqyAsy1yjFXT48D3Ssp+jy4EMJt+Sj_o2W-WMgK9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iLbbqyAsy1yjFXT48D3Ssp+jy4EMJt+Sj_o2W-WMgK9w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 27 2021 at  9:41P -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Add a helper to perform the entire remapping for DAX accesses.  This
> > helper open codes bdev_dax_pgoff given that the alignment checks have
> > already been done by the submitting file system and don't need to be
> > repeated.
> 
> Again, looks good. Kind of embarrassing when the open-coded version is
> less LOC than using the helper.
> 
> Mike, ack?

Acked-by: Mike Snitzer <snitzer@redhat.com>

