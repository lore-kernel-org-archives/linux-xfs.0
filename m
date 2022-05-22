Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6979C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 22 May 2022 07:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343884AbiEVHfA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 22 May 2022 03:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240870AbiEVHfA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 22 May 2022 03:35:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8816238792;
        Sun, 22 May 2022 00:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WBuaIM5SKIXkLPP9GWovDc27LNx1rhfUlIGL8EkGrgs=; b=EwTBzO6RfBEUY2QPJdzOnVRXd2
        +nQXck0mDSvWFS2pFxxni3O1VHw2qB9PX7111rCqBQGS2xHtBuNbsHRUzhLAhtomICYUikAecEc0H
        dRmnAYjm01u7kqAHYjfyU8sH0WZE/rysNjFbFvUnwzlijdOSoGaWMsZvQVwDE2jx4p8FWq6fkPc+v
        JCwDLtUzftgDrjbJWOdj73kOmWRKpX93IezC97pC7wOleWdut3zk1eo/btvhKupXJ0cOAiK/EpEzI
        CuW8xYYIMUsDYdAnQE7jk/3D6uIJuCxceN4f4LxDvCTNZHQZpS8GawlLeI9/vl3m9Mo8Ay77+85Hw
        dL3pBZww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsg78-000oB1-JL; Sun, 22 May 2022 07:34:58 +0000
Date:   Sun, 22 May 2022 00:34:58 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [RFC PATCH v4 16/17] xfs: Add async buffered write support
Message-ID: <YonnogxhDz2jeFBt@infradead.org>
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-17-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520183646.2002023-17-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 20, 2022 at 11:36:45AM -0700, Stefan Roesch wrote:
> This adds the async buffered write support to XFS. For async buffered
> write requests, the request will return -EAGAIN if the ilock cannot be
> obtained immediately.
> 
> This splits off a new helper xfs_ilock_inode from the existing helper
> xfs_ilock_iocb so it can be used for this function. The exising helper
> cannot be used as it hardcoded the inode to be used.

Actually this should also be a prep patch - but the please try to
follow the rule that standalone enablement like refactoring or new
funtionality for helpers is one patch, the actual use of it for a new
feature should preferably one patch for the whole feature.
