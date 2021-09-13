Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993F2C433EF
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 13:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8546461A71
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Sep 2021 13:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242416AbhIMNkc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 09:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242698AbhIMNhM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 09:37:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28ED7613B3;
        Mon, 13 Sep 2021 13:28:01 +0000 (UTC)
Date:   Mon, 13 Sep 2021 15:27:59 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/13] sysfs: refactor sysfs_add_file_mode_ns
Message-ID: <20210913132759.ukk42fhihocmfvfh@wittgenstein>
References: <20210913054121.616001-1-hch@lst.de>
 <20210913054121.616001-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210913054121.616001-6-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 13, 2021 at 07:41:13AM +0200, Christoph Hellwig wrote:
> Regroup the code so that preallocated attributes and normal attributes are
> handled in clearly separate blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
