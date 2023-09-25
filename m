Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0396BCE7A81
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 09:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjIYJJE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 05:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjIYJJE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 05:09:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5EAD3;
        Mon, 25 Sep 2023 02:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Hkw5Z4WC4lZYGudn69KXiB2GzJT82+Vg3Fjbl4SJmcE=; b=iiUjm6m8MGxdB9L8trqvgJ8WBl
        ObzxX+7oIE0Y+Vebxl+OvHiShNxJcXXfKijJpMoJPdR5HWaiu/JtRx4Cm8fx3JUCDYmhdM8H91ghU
        IQ/sEMzAbYYbga1MciFamNNoeCz5m9H3vdvyLFlmfwpayRIOLzYA5tRmGUIBnhTHN5MjmAlL1Nnf9
        8i7QLW6PuJLmWWr1LBqD09H9N+/OFe4Xu8e2JohBcgkVHSZ8nUE4ogaQ4Eb/hAf9OOq54aNixqWnI
        XqrLZ9BnB+EuoJB0PAvAekuv8TjtX6jOmDhnhy5PsBRd5GRrosj1kmpjT3XcTVckNi08jTRKg+q3x
        lkY2MrMQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qkhaF-00Doex-29;
        Mon, 25 Sep 2023 09:08:51 +0000
Date:   Mon, 25 Sep 2023 02:08:51 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     syzbot <syzbot+1fa947e7f09e136925b8@syzkaller.appspotmail.com>
Cc:     axboe@kernel.dk, brauner@kernel.org, david@fromorbit.com,
        djwong@kernel.org, hare@suse.de, hch@lst.de,
        johannes.thumshirn@wdc.com, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, mcgrof@kernel.org, nogikh@google.com,
        p.raghav@samsung.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [block] INFO: task hung in clean_bdev_aliases
Message-ID: <ZRFOI/TUQwJEw5/s@infradead.org>
References: <000000000000e534bb0604959011@google.com>
 <0000000000001486250605ad5abc@google.com>
 <ZRFKBxoRjVQclPS0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRFKBxoRjVQclPS0@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

#syz test: git://git.infradead.org/users/hch/misc.git bdev-iomap-fix
