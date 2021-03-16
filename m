Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF7FC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 15:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE6CB650FF
	for <linux-xfs@archiver.kernel.org>; Tue, 16 Mar 2021 15:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237330AbhCPPr7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 16 Mar 2021 11:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237308AbhCPPrb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 16 Mar 2021 11:47:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E52E650F7;
        Tue, 16 Mar 2021 15:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615909650;
        bh=CzHBK9t8WkZRNjfVtjh+7XFIKyAKpjwGeUOd7JVf+sQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tk9/84GPfrLe/vSr7YXPxjuk4AwK8SOqh/OCtKG/99D4hPQieYay0kynJMvSsrVwC
         muQvXsMIA+ZiwPfPKg77hN0qwZL23BHmdHdjbEjVzJCAKpoQwfn35+JwKSlP4Pwdcm
         d6OcCMVs2JAqxOmyhdKfs8QBzxl4zwlMoXe1uSWSqOLVB1AgJiGmbKuvAGP/uD9XW8
         0CAalXW51dFc9hrs98yBKAeSiZStwZBtw9ew74zJ7POqzyI1Mt/qMYcLMGGDRZFxR/
         co0RSGi83fQXQQ+mFv4sCGn9ZiFRdrf+ZLhWSzLaf/CYVObg9WxB0M17OUTsof12Zg
         1/18jcUnnpZow==
Date:   Tue, 16 Mar 2021 08:47:29 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: deferred inode inactivation
Message-ID: <20210316154729.GI22100@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543197372.1947934.1230576164438094965.stgit@magnolia>
 <20210316072710.GA375263@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316072710.GA375263@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 16, 2021 at 07:27:10AM +0000, Christoph Hellwig wrote:
> Still digesting this.  What trips me off a bit is the huge amount of
> duplication vs the inode reclaim mechanism.  Did you look into sharing
> more code there and if yes what speaks against that?

TBH I didn't look /too/ hard because once upon a time[1] Dave was aiming
to replace the inode reclaim tagging and iteration with an lru list walk
so I decided not to entangle the two.

[1] https://lore.kernel.org/linux-xfs/20191009032124.10541-23-david@fromorbit.com/

--D
