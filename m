Return-Path: <SRS0=fGHA=XF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 433BCC3A5A2
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 12:28:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2165821019
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Sep 2019 12:28:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729475AbfIJM2j (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Sep 2019 08:28:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33156 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728902AbfIJM2j (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Sep 2019 08:28:39 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 268697BDD2
        for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2019 12:28:39 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id f11so8893976wrt.18
        for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2019 05:28:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=4RWHXL9/gbiM6vmUPXxh27DXi1ckX6AbK12xWt7jNys=;
        b=IF3lkjMCIS0rIlLK/hM+joR3oxFrKcmaI3P4NfF1fEWmAhyMIVPVY5OT1T4kVc9Gvm
         ntkKk5T7jPbGJw6833CFjK/4NLll2vr+1XPr5ClE0NMRHueqPG1KmVJQj+9zEinYm9xL
         wcIXsYJu5aoPCtc+8v4XYb1zOxwnPay9YYkGnbNDqE6+xXdiURThHSY2mcfkoYg2P+4E
         A3laNJl0G4jx2wNUU2wII0IEyWiEgiskJuv6G/7NhGicbCMghUm/HvmMNNvrdHQTNsDH
         3k0nW4PVFp/oBRHjApVXxbSgC0PCFBymFy5tMdikV4bZu+s8LZGyAI1SHsMpY3nhJwJy
         oKWA==
X-Gm-Message-State: APjAAAXgq9jsCKYYCZo8ZYZuMVxuZ94gLAEvUGA/NhGr5QTepCXHBuYY
        1wh0Ajpfub69NpMBBPSZEgfDhO02VHCAJcKXTFacU5/45nabsqbymCBUZ++ptM6h55cyrT7KWN7
        eiBzC2micxv8f1OUch26O
X-Received: by 2002:adf:9c81:: with SMTP id d1mr9447109wre.123.1568118517933;
        Tue, 10 Sep 2019 05:28:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzubYcyuJaAC6s9VNWxbs5qpUy9BsAJyCHh0j1+v3i3fNzmIAJsqX7bk/tWRiP0+3lgFtzMbw==
X-Received: by 2002:adf:9c81:: with SMTP id d1mr9447085wre.123.1568118517752;
        Tue, 10 Sep 2019 05:28:37 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id q25sm3123104wmq.27.2019.09.10.05.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 05:28:37 -0700 (PDT)
Date:   Tue, 10 Sep 2019 14:28:35 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-fsdevel@vger.kernel.org, adilger@dilger.ca,
        jaegeuk@kernel.org, darrick.wong@oracle.com, miklos@szeredi.hu,
        rpeterso@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] Use FIEMAP for FIBMAP calls
Message-ID: <20190910122833.jsii3us7rhwc5l2p@pegasus.maiolino.io>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,
        linux-fsdevel@vger.kernel.org, adilger@dilger.ca,
        jaegeuk@kernel.org, darrick.wong@oracle.com, miklos@szeredi.hu,
        rpeterso@redhat.com, linux-xfs@vger.kernel.org
References: <20190808082744.31405-1-cmaiolino@redhat.com>
 <20190808082744.31405-9-cmaiolino@redhat.com>
 <20190814111837.GE1885@lst.de>
 <20190820130117.gcemlpfrkqlpaaiz@pegasus.maiolino.io>
 <20190829071555.GF11909@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190829071555.GF11909@lst.de>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hey, thanks for the info.

Although..

On Thu, Aug 29, 2019 at 09:15:55AM +0200, Christoph Hellwig wrote:
> On Tue, Aug 20, 2019 at 03:01:18PM +0200, Carlos Maiolino wrote:
> > On Wed, Aug 14, 2019 at 01:18:37PM +0200, Christoph Hellwig wrote:
> > > The whole FIEMAP_KERNEL_FIBMAP thing looks very counter productive.
> > > bmap() should be able to make the right decision based on the passed
> > > in flags, no need to have a fake FIEMAP flag for that.
> > 
> > Using the FIEMAP_KERNEL_FIBMAP flag, is a way to tell filesystems from where the
> > request came from, so filesystems can handle it differently. For example, we
> > can't allow in XFS a FIBMAP request on a COW/RTIME inode, and we use the FIBMAP
> > flag in such situations.
> 
> But the whole point is that the file system should not have to know
> this.  It is not the file systems business in any way to now where the
> call came from.  The file system just needs to provide enough information
> so that the caller can make informed decisions.
> 
> And in this case that means if any of FIEMAP_EXTENT_DELALLOC,
> FIEMAP_EXTENT_ENCODED, FIEMAP_EXTENT_DATA_ENCRYPTED,
> FIEMAP_EXTENT_NOT_ALIGNED, FIEMAP_EXTENT_DATA_INLINE,
> FIEMAP_EXTENT_DATA_TAIL, FIEMAP_EXTENT_UNWRITTEN or
> FIEMAP_EXTENT_SHARED is present the caller should fail the
> bmap request.

This seems doable, yes, but... Doing that essentially will make some
filesystems, like BTRFS, to suddenly start to support fibmap, this was another
reason why we opted in the first place to let filesystems know whom the caller
was.

We could maybe add a new FIEMAP_EXTENT_* flag in the future to, let's say,
specify a specific block may be split between more than one device, but, well.
It's an idea, but it won't change the fact BTRFS for example will suddenly start
to support FIBMAP.

-- 
Carlos
