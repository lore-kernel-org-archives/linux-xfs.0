Return-Path: <SRS0=kQBn=WQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE73C3A589
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 13:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50F6822D6D
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Aug 2019 13:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729024AbfHTNBX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Aug 2019 09:01:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15686 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbfHTNBW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Aug 2019 09:01:22 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5490FC00A170
        for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2019 13:01:22 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id f9so7008674wrq.14
        for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2019 06:01:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=JyfdeLkkR8GtG7vbX84FfM/uenohypR3GvPDvYTRWXk=;
        b=uJ97YTiswWWXwGJCpKg4DOtMdHMJpEmeB7f3+tKBqaxjraOLSSV5ClpcHNez78Dvdk
         yhPMTd1g3IuiW337oGXONJcGtapQN9+yR1o33ldVONe5sng5zoGJ6KM2rabn/Ub7g8US
         DF3XSWsXptqPSOpmUAy3XBpaekgNbVj7j7O4RiDs0Al6UlJMuzxnNu3uq3eTIOftRbnn
         EXqiZyVK4JgTORziKL9wBa661sQRYF/DejnNj6d9YLxEplYh5O+L2RGgnlF5JC1f0tE9
         zqZ1nPwP5NLVCijEVKcjDG54ez6KJMwcM9Irl6QBWpSIbi6uggv+dofuvxrYha32NrfE
         5hLw==
X-Gm-Message-State: APjAAAWgERSHIkWPajakLPlW5s7YIMkMGDlAOyCKPs6T7yHJTRUNMFut
        h4liF0tqQDwI+4x42n3av81Qql2LwjmIdElAe1ZgA7W0BQ1/7oK3Bg38X5AXP5AByivjNK3/68/
        HdZUtUoTYk5P1rQrBaoEa
X-Received: by 2002:a7b:c019:: with SMTP id c25mr17215540wmb.116.1566306081128;
        Tue, 20 Aug 2019 06:01:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwW/Mm7Yp1DuKc2DpARm+BXm2IBc4i04bqTY3rcNb283e8Tyj6owuE5dBd43XuSSQL15LjkMw==
X-Received: by 2002:a7b:c019:: with SMTP id c25mr17215522wmb.116.1566306080906;
        Tue, 20 Aug 2019 06:01:20 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id a19sm58231285wra.2.2019.08.20.06.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 06:01:20 -0700 (PDT)
Date:   Tue, 20 Aug 2019 15:01:18 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-fsdevel@vger.kernel.org, adilger@dilger.ca,
        jaegeuk@kernel.org, darrick.wong@oracle.com, miklos@szeredi.hu,
        rpeterso@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] Use FIEMAP for FIBMAP calls
Message-ID: <20190820130117.gcemlpfrkqlpaaiz@pegasus.maiolino.io>
Mail-Followup-To: Christoph Hellwig <hch@lst.de>,
        linux-fsdevel@vger.kernel.org, adilger@dilger.ca,
        jaegeuk@kernel.org, darrick.wong@oracle.com, miklos@szeredi.hu,
        rpeterso@redhat.com, linux-xfs@vger.kernel.org
References: <20190808082744.31405-1-cmaiolino@redhat.com>
 <20190808082744.31405-9-cmaiolino@redhat.com>
 <20190814111837.GE1885@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814111837.GE1885@lst.de>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 14, 2019 at 01:18:37PM +0200, Christoph Hellwig wrote:
> The whole FIEMAP_KERNEL_FIBMAP thing looks very counter productive.
> bmap() should be able to make the right decision based on the passed
> in flags, no need to have a fake FIEMAP flag for that.

Using the FIEMAP_KERNEL_FIBMAP flag, is a way to tell filesystems from where the
request came from, so filesystems can handle it differently. For example, we
can't allow in XFS a FIBMAP request on a COW/RTIME inode, and we use the FIBMAP
flag in such situations.

We could maybe check for the callback in fieinfo->fi_cb instead of using the
flag, but I don't see how much more productive this could be.

Maybe a helper, something like

#define is_fibmap(f)	((f->fi_cb) == fiemap_fill_kernel_extent)


But again, I don't know how much better this is comparing with a flag

Cheers
-- 
Carlos
