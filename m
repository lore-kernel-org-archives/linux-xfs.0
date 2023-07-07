Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDAEEB64D9
	for <linux-xfs@archiver.kernel.org>; Fri,  7 Jul 2023 11:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbjGGLa0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 7 Jul 2023 07:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231950AbjGGLaW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jul 2023 07:30:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0F71FF9;
        Fri,  7 Jul 2023 04:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UZlj2Ou+FC8/RTVVHCLVA+4rI3cHaPQJB4OBx15VFGk=; b=dLyytecDHZE34VhkPmaGM30fCu
        JHb3BFJX7iPZL57mVZW8u5y5+a4tMnxGgKhzSW9fjHaNyrJmxAZHvnJSzuEnT5w2ICznYUFyfWQWZ
        0RgxpxIsvMqup4hGMnwzTpe02oTkUd73MOWifiv5pqcivv4PBU6qSJnO3bbDMR0wFUn9QLMggZGPn
        EtE8tgzDjJGuoiT0AAt231mL0+NVvxjikg7sEl3YNL54Fd5/+Gs3ZQpJREUbCph2jBFfRHt53avcZ
        ks/3BTKt6H1x/9zNvZPdXCFRYq1+4Gm42G9QPO6mgFuNM0PCrz6NyuW9/5p6UP5tY9MgPLadWn+MQ
        hzk92zsw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qHjfJ-004W9r-0n;
        Fri, 07 Jul 2023 11:30:21 +0000
Date:   Fri, 7 Jul 2023 04:30:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@google.com>,
        Ted Tso <tytso@mit.edu>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexander Popov <alex.popov@linux.com>,
        Eric Biggers <ebiggers@google.com>, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH 6/6] fs: Make bind mounts work with
 bdev_allow_write_mounted=n
Message-ID: <ZKf3TccOhDhyNRK1@infradead.org>
References: <20230704122727.17096-1-jack@suse.cz>
 <20230704125702.23180-6-jack@suse.cz>
 <ZKbj5v4VKroW7cFp@infradead.org>
 <20230706161255.t33v2yb3qrg4swcm@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230706161255.t33v2yb3qrg4swcm@quack3>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 06, 2023 at 06:12:55PM +0200, Jan Kara wrote:
> Well, this is exactly what this patch does - we use dev_t to lookup the
> superblock in sget_fc() and we open the block device only if we cannot find
> matching superblock and need to create a new one...

Hah, that's what you get for writing one last mail before getting on
an airplane without reading the patch.  This just sounded like a
workaround especially being at the end of the series.
