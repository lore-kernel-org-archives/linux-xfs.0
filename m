Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F3DC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 17:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34CBF22CA1
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Jan 2021 17:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436594AbhARRhW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 12:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436603AbhARRhM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jan 2021 12:37:12 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE04C061573
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jan 2021 09:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jdoJIv/lnB5Cs6DtF/pHTjYP84lUOpa20Tsa9Bprz10=; b=ad+j5Jpqo6bFzm8NDVo2N+l9is
        bZsSa5Qsw+a6W/ONW1JJEaPezhZxKSXFEcPHyw3vb2GsY4T78O5SziWdz5tmEUXqCe/DBKgjhl1hA
        eve0DxsQME3O/mJmOqjAv6lIGJqPlTDvgGaVieSK1pnJ9v4Zxcz4Y3w3u06jn4hlG75f0VgXHZxI5
        WyjW/wlrPyffcdMiSyCFvqM/JJKikKHrbRUDXbb+FAVcZ0JAGEKFHnoLvsb3dGbJDYuZR5mPgARKp
        eyD88LTeIbO1L8Uhn5hrtk8HLxiY1c2KV+wZzyBqIMpFIi9L7+Fr2QBkYAg4kQPnMROUkT93RD2UL
        iCCS/hhQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l1YS4-00D9st-1g; Mon, 18 Jan 2021 17:36:28 +0000
Date:   Mon, 18 Jan 2021 17:36:28 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: increase the default parallelism levels of
 pwork clients
Message-ID: <20210118173628.GB3134885@infradead.org>
References: <161040739544.1582286.11068012972712089066.stgit@magnolia>
 <161040740189.1582286.17385075679159461086.stgit@magnolia>
 <X/8IfJj+qgnl303O@infradead.org>
 <20210114213259.GF1164246@magnolia>
 <20210114223849.GI1164246@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114223849.GI1164246@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 14, 2021 at 02:38:49PM -0800, Darrick J. Wong wrote:
> There already /is/ a pwork_threads sysctl knob for controlling
> quotacheck parallelism; and for the block gc workqueue I add WQ_SYSFS so
> that you can set /sys/bus/workqueue/devices/xfs-*/max_active.

Hmm.  A single know that is named to describe that it deals with the
expected device parallelism might be easier to understand for users.
