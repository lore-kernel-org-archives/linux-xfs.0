Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF8ECC41513
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Aug 2023 15:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232440AbjHBPNs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Aug 2023 11:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbjHBPNr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Aug 2023 11:13:47 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6190A30D7
        for <linux-xfs@vger.kernel.org>; Wed,  2 Aug 2023 08:13:36 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-790b9d7d643so29718239f.1
        for <linux-xfs@vger.kernel.org>; Wed, 02 Aug 2023 08:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690989215; x=1691594015;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFN0yTkYJmRYBxe8C0crI4IHgD1XQCao320E85C1eJo=;
        b=kp7n9nNtSk8/5HElDyrHrxdGYt7rv/xOLxBpQU+qG5wUj+aPhHFt7hOsgBNU+OETht
         KWYQgN+RSSEkCSHwBiuIn2wqCn91pIcH/6WpiiodnA80qHVCbrbi7a5F7VrS1AWocpGX
         lkpINsr9WOQxcFPAY8112JHDHuJNcmJ6kzBmZcak+HGIKh1mUfZlmlGg/fFYiljja8Iw
         hOStezDZIgh7VUM+4wefm3ZdGRsulRhaUdKProubNLnmpS5r9xd7/3JvspGQR7Qmuo3D
         jGBr6kX71aa/Ip9kVb1+ByoY7pLHM2YwhbYEQr92yRmJOnBOGLIpP3nmoti+KebJ98IT
         YNZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690989215; x=1691594015;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aFN0yTkYJmRYBxe8C0crI4IHgD1XQCao320E85C1eJo=;
        b=g4zSp9Ef5ifwa4NDuh6xF8TVkRHqPaYv/QsIeJLsTyb+WER2eE5VMkVaUTq1QcFsgr
         rKQG8KxPJbrW02sEJ2aQ/tpLkX9+/fT5ACrzFli3KV3XvBfqGbEVqUqCSnKHioZubxMk
         4BRzZr9C7nXVgLHKStp5sX5Edvib6eWMsFF7ih9kYwWQ27TdgMI9lYSvtnXvFpSGGvEx
         izY84UWGrMJxZR54Tw6xNrIRM8nDJN6VadYqFw0j0bwoNTB/oQrmOp5Q3zeskpyfR9Y0
         ZUpXVL+NDPWutXCo1XLOPo+8b5CkUW/W5srnoXCcIB2rjcGJ6reghy4dLxxSU5iFovFQ
         FRlA==
X-Gm-Message-State: ABy/qLY1whF97XQyXICh4wVF5kjNatkDsC3rP4+lvFEV1eVv2YEhRMU3
        HkerGmcF+i0/ndwP9mICHmRW9Q==
X-Google-Smtp-Source: APBJJlGV0GWnRqN4nUuY2j+yBlsWFiPPK/hRERx9kc8EMoqN+d2kaqg0kL1v4ktlNGSiEvEAkXeswA==
X-Received: by 2002:a05:6e02:4c4:b0:345:a3d0:f0d4 with SMTP id f4-20020a056e0204c400b00345a3d0f0d4mr12930279ils.3.1690989215175;
        Wed, 02 Aug 2023 08:13:35 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id y8-20020a02a388000000b0042b46224650sm4293136jak.91.2023.08.02.08.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Aug 2023 08:13:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Christian Brauner <brauner@kernel.org>
In-Reply-To: <20230801172201.1923299-2-hch@lst.de>
References: <20230801172201.1923299-1-hch@lst.de>
 <20230801172201.1923299-2-hch@lst.de>
Subject: Re: [PATCH 1/6] fs: remove emergency_thaw_bdev
Message-Id: <169098921438.7183.18231196765480619399.b4-ty@kernel.dk>
Date:   Wed, 02 Aug 2023 09:13:34 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On Tue, 01 Aug 2023 19:21:56 +0200, Christoph Hellwig wrote:
> Fold emergency_thaw_bdev into it's only caller, to prepare for buffer.c
> to be built only when buffer_head support is enabled.
> 
> 

Applied, thanks!

[1/6] fs: remove emergency_thaw_bdev
      commit: 4a8b719f95c0dcd15fb7a04b806ad8139fa7c850
[2/6] fs: rename and move block_page_mkwrite_return
      commit: 2ba39cc46bfe463cb9673bf62a04c4c21942f1f2
[3/6] block: open code __generic_file_write_iter for blkdev writes
      commit: 727cfe976758b79f8d2f8051c75a5ccb14539a56
[4/6] block: stop setting ->direct_IO
      commit: a05f7bd9578b17521a9a5f3689f3934c082c6390
[5/6] block: use iomap for writes to block devices
      commit: 487c607df790d366e67a7d6a30adf785cdd98e55
[6/6] fs: add CONFIG_BUFFER_HEAD
      commit: 925c86a19bacf8ce10eb666328fb3fa5aff7b951

Best regards,
-- 
Jens Axboe



