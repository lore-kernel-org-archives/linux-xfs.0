Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35E8ACA0FF3
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Sep 2023 16:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350916AbjIEQZR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354541AbjIEM1G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Sep 2023 08:27:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158081A8;
        Tue,  5 Sep 2023 05:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eVxmERvkhRQsWzv7hKcub8nBL8Ebk3iyCYi7oJyr1Qk=; b=y1nZcAesjx2xv+SqYWukES/nxx
        qxVnUugSjtZ7Rv+bkJJ6GZIdmJGlCLcs8CZEB+opdncPZkN8ySSXTFFA9n3825sRirzrtgHedCb6Y
        xVaJXXjwPg3j1NrmFUhs2YDq66bVYir9KESsctaZ/K7zI5iJ/7/Syy9Tjm4oJ53hAypHgRYapUnBI
        Du1mmz4gZGYHfNXUaeRFE1/vD4OBuZO6WRSug9LrHMCZd+Fxeo+r5eEjX0DEnDHXqjQn/VtktT/OS
        lT97QzO09PtP3N5ZNy00mxVHFBt85fKdar8/4wc/er2Bx8o3t5+AcoVG2flc6LAz8j2jfr7gmohWf
        LJKCN9qg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qdV8x-0060Oq-0K;
        Tue, 05 Sep 2023 12:26:55 +0000
Date:   Tue, 5 Sep 2023 05:26:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     syzbot <syzbot+4a08ffdf3667b36650a1@syzkaller.appspotmail.com>
Cc:     adilger.kernel@dilger.ca, djwong@kernel.org, hch@infradead.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        nogikh@google.com, song@kernel.org,
        syzkaller-bugs@googlegroups.com, tytso@mit.edu, yukuai3@huawei.com,
        zhang_shurong@foxmail.com
Subject: Re: [syzbot] [block] kernel BUG in __block_write_begin_int
Message-ID: <ZPcej+rJjg+6SgzK@infradead.org>
References: <CANp29Y65sCETzq3CttPHww40W_tQ2S=0HockV-aSUi9dE8HGow@mail.gmail.com>
 <000000000000d9daf4060499c0c9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000d9daf4060499c0c9@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 05, 2023 at 03:04:32AM -0700, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in __kthread_create_on_node

Well, that is


 a) a different issue in ext4
 b) just a warning

