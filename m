Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FCFC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jul 2022 04:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiGLEvC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 00:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGLEvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 00:51:01 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A6C32DBC
        for <linux-xfs@vger.kernel.org>; Mon, 11 Jul 2022 21:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wm6y27GnFEPJDaT8W1cGaQhpR0t+Efl5vuMwQH7WTMs=; b=epde2cVQMYAlE8aML3HvbJEHNW
        1zrUDHlGKqA0s9p+vD2iwKSNvpeo4BUVpg0Z7zoTbVCsBx3hTZ9K9la2MOMJetjykDBUEdhgaQqxy
        7youZlKnfVavTJQ+fJGG9vbSK3ZORzwtkAzEp6yCMmcl76d6lCU91ShGMbUgB5/zBjzSa0JSJkOvA
        il9G82jAgFgsZf3bkkxSuTywvI4YakvtW21RNVpkINzsJ4cD66mH4AdZGRPR4oQHEWV8Y3TOj/6sQ
        d4t9uKuiEdIUWxHGbV0c9/4W5KBA4XULX9ZILcoxyTTmq/WbPVGF34X61V3UW8H3adzjY+xGjnfuI
        o3iHa8gQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oB7rJ-007WWK-Vf; Tue, 12 Jul 2022 04:50:53 +0000
Date:   Mon, 11 Jul 2022 21:50:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, allison.henderson@oracle.com
Subject: Re: [PATCHSET v2 0/5] xfs: make attr forks permanent
Message-ID: <Ysz9rbbTU8/tzrXI@infradead.org>
References: <165740691606.73293.12753862498202082021.stgit@magnolia>
 <Ysu0V1mQovrXQiEo@infradead.org>
 <YszUMHbqe+vCAdYx@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YszUMHbqe+vCAdYx@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 11, 2022 at 06:53:52PM -0700, Darrick J. Wong wrote:
> On a freshly built djwong-dev kernel, it's now 976 bytes:
> 
> 			976 bytes
> Order	Pagebytes	Slack	Objs	Slack/Objs
> 0	4096		192	4	48
> 1	8192		384	8	48
> 2	16384		768	16	48
> 3	32768		560	33	17
> 4	65536		144	67	2


Yes, we're getting at a point where the xfs_inode size starts to
really hurt. It's all the small incrementally and very useful changes
like this series or the in-memory unlinked inode list from Dave that
keep growing it.  I have no really good answer here except that I'd
need to dust off some of my project to reduze the size by removing
fields that we don't strictly need.
