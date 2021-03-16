Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC84FC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 07:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A288964FAB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 07:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhCPH1h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 03:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhCPH1R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 03:27:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A129C06174A
        for <linux-xfs@vger.kernel.org>; Tue, 16 Mar 2021 00:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=E+kzGxGCgx7gJgKs/VDfyx8menDNX1pMUCvTBUT5uts=; b=siRWOqumGlmk0CoroOsiacA9vI
        uufGHWMWYNsB+AYwJ5iQIS3iA9KslLjj+iJLpfYie3Gt0GAnqRE6c4dGom8qJx8e0/+wpG76l1Rme
        TpBGYkZyx00zK+ZcITnBC0QhLIVTeCDYomY81bns4yNyokxY8uu7EtXd1pJLL5XO67nwhLgUEfQ7M
        ZKppt5iWqwOLny/FNiJMPlabFDwXuvT+l6kfq6De9NSkBSRrUNOYI3WvS5Z7nC+FJ8nk4azWe0ptX
        Qjabq+K33iEv27hJ6aSnIKxpI4zwVDqqfYshNCIeAOi3mqC2d9iRC3yS//0RNQ9CC9USQNAD+gUdS
        nk+oMIwg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lM46g-001ZuM-W5; Tue, 16 Mar 2021 07:27:12 +0000
Date:   Tue, 16 Mar 2021 07:27:10 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: deferred inode inactivation
Message-ID: <20210316072710.GA375263@infradead.org>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543197372.1947934.1230576164438094965.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161543197372.1947934.1230576164438094965.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Still digesting this.  What trips me off a bit is the huge amount of
duplication vs the inode reclaim mechanism.  Did you look into sharing
more code there and if yes what speaks against that?
