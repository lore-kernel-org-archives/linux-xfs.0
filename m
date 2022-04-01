Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05834C433EF
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Apr 2022 12:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234336AbiDAMIo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 Apr 2022 08:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbiDAMIo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Apr 2022 08:08:44 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A17A276FB0
        for <linux-xfs@vger.kernel.org>; Fri,  1 Apr 2022 05:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ZUXMt+vHy1v5aeRyPvhUNaWViXdotH1msNi5UvEH37g=; b=41iE0IOAxkzrHAnS4FJyLrJgQ4
        PMzUmyYMnhEs2VRXKASBXjhf8dJrp5RcRTXIvTj/JT4vN7cDZdPu/wU99djOPdNBslVFt5r418y6s
        hJKZrv+MP4KXgHxSuA9qywLMscjfyrM4Su7VZfnhlOfNsUY5oe5HCvrm2KB0ufO7xB9EYhpmxqLr9
        C7AFfbHO9Cb77G8ttMiinppHOQ6rbufj1yn0PmBGaVZL+QDLqg3v/HHqG9DSqp003Rl5kMGj+JvZA
        7ZtVWRstGBeyaXvwEv6nxbgqBqy0VXW0Na3fWfgyLN0YaZ5TDhiecfI22feuHy8cX1fHVfQsSuXQl
        2pDhTQdQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1naG3K-005aE8-Mg; Fri, 01 Apr 2022 12:06:54 +0000
Date:   Fri, 1 Apr 2022 05:06:54 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/8] xfs: drop async cache flushes from CIL commits.
Message-ID: <Ykbq3knPPKCywtqJ@infradead.org>
References: <20220330011048.1311625-1-david@fromorbit.com>
 <20220330011048.1311625-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330011048.1311625-9-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

(although due to the bio alloc API changes this won't apply to
mainline as-is).
