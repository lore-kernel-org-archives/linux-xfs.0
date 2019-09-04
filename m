Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15E8C3A5A7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 11:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 900BE22CF7
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 11:46:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbfIDLqg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 07:46:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37252 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726010AbfIDLqf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Sep 2019 07:46:35 -0400
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 906AF8763B
        for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2019 11:46:35 +0000 (UTC)
Received: by mail-ot1-f72.google.com with SMTP id c1so12271779otb.22
        for <linux-xfs@vger.kernel.org>; Wed, 04 Sep 2019 04:46:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tp/gMW5v4pRlyKiUIDPuxfxvbFDJhPkzWLdm0oGHyVo=;
        b=iG5mnSYfT/zjgwU8E5CEjx2+0vclWtNNAZb5qsElF2lGjHPCoke73S6Ked0whg/1DA
         7e6V47F06BhYxYifvikh7kXwi4ixSzFcCKMhTre3X0+YAyZeQyMQt2ojOtaJ8pEUXLMH
         gzDCnVnOn11G0einOyaG2wl4NWdU5FvxMMjjPlHbwcwRnpkErlz1MDhVuhYNZnvPJY8A
         QS0jq4PfVcUMUwRiySMS09mmE0Bzxef+lQthqz4jy/BdqklLPxMa9GFU/74CdRqQ/N7a
         0RR613eTQJH3fb6H+4BIyHfmSpazCgb9Y61CAoM7HbmCvqye4N1yksQPlgMmFXnV9UFL
         ye/w==
X-Gm-Message-State: APjAAAX4oJjvDq8UI/1sBKR9l9FjTEpTN84qQtICfKhaK9DJo6DwqJBu
        c9VyMs2dz+qe2VuV/QIPG++5C6/DpmP8PUJ2FtMPpH3IZEaTRb12rizkAehelQzekftU+84g/8C
        gmej/OCD8sznJDTXaEITBq6KtDI3gqH02zvCz
X-Received: by 2002:a05:6808:183:: with SMTP id w3mr1672970oic.147.1567597594999;
        Wed, 04 Sep 2019 04:46:34 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy9/OmGWIzNj7/oNV2D+qH0GsqfH+nNIlG264im72fFSE+LZi5x7kKnT+39cyWeIYPXVV56F9ZSFe3zo3LwHYA=
X-Received: by 2002:a05:6808:183:: with SMTP id w3mr1672956oic.147.1567597594780;
 Wed, 04 Sep 2019 04:46:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190903130327.6023-1-hch@lst.de> <20190903221621.GH568270@magnolia>
 <20190904051229.GA9970@lst.de>
In-Reply-To: <20190904051229.GA9970@lst.de>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 4 Sep 2019 13:46:23 +0200
Message-ID: <CAHc6FU42hsk9Ld7+mezh6Ba++5yvzJk30AyJzHOq3Ob7YASDgg@mail.gmail.com>
Subject: Re: iomap_dio_rw ->end_io improvements
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs@vger.kernel.org,
        Matthew Bobrowski <mbobrowski@mbobrowski.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 4, 2019 at 7:12 AM Christoph Hellwig <hch@lst.de> wrote:
> On Tue, Sep 03, 2019 at 03:16:21PM -0700, Darrick J. Wong wrote:
> > The biggest problem with merging these patches (and while we're at it,
> > Goldwyn's patch adding a srcmap parameter to ->iomap_begin) for 5.4 is
> > that they'll break whatever Andreas and Damien have been preparing for
> > gfs2 and zonefs (respectively) based off the iomap-writeback work branch
> > that I created off of 5.3-rc2 a month ago.
>
> Does Andreas have changes pending that actually pass an end_io call
> back to gfs2?  So far it just passed NULL so nothing should change.

Right, we don't currently use that and there's nothing in queue in
that direction.

Andreas
