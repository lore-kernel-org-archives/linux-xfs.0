Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63347C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 24 Apr 2022 05:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbiDXFc3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 24 Apr 2022 01:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238299AbiDXFc0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Apr 2022 01:32:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52DA6506E1
        for <linux-xfs@vger.kernel.org>; Sat, 23 Apr 2022 22:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cFlQZamfd7B9OlKhMn5oqvqSpTYXaXow0tvz3+fFplY=; b=kGnsPlKAVUnj6opnFmxVbEHEum
        eQFhSYrpcbL2KVqHDZveQXXHS+Cfx9QPZfBBxP/9XM8ip/oHUyNaBegJ5DL3ERzQ/mqFeOf4ZIodW
        XTCyEOZ07IhZQCadwvlbdvfnRS5ra6I8zRzDszj3z9KS8EveRvdXArTAvJ35I/qDwAvPH6wxWn5HP
        Z5QeUINsqjtgshRPCYdxCCC9NEQJASPuDzK03UNmTwHqAsNSQwkBX8y6dq8SOIuknDcKA3AJe1TFr
        qLO/iY7dmvsfQgdPxkvxrxeZvVtS3rsJDhNDKhWZ6PWzPK90H7oY5beS3oloaPPl3ti+07ywuVdWN
        LdAnS5pQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1niUoI-005qAq-RR; Sun, 24 Apr 2022 05:29:26 +0000
Date:   Sat, 23 Apr 2022 22:29:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Andrey Albershteyn <aalbersh@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 3/5] xfs_quota: separate get_dquot() and report_mount()
Message-ID: <YmTgNnlxkdy0JKAg@infradead.org>
References: <20220420144507.269754-1-aalbersh@redhat.com>
 <20220420144507.269754-4-aalbersh@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220420144507.269754-4-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 20, 2022 at 04:45:06PM +0200, Andrey Albershteyn wrote:
> Separate quota info acquisition from outputting. This allows upper
> functions to filter obtained info (e.g. within specific ID range).

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
