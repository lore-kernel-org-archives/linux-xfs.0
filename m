Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E328C38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 05:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjARFnq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Jan 2023 00:43:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjARFnp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 00:43:45 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D19577D4;
        Tue, 17 Jan 2023 21:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=fxEKEN+/Ci3UEZisJd2606inXJaRH6/XkW2CcOD4vLE=; b=m9ABFkVcSn2dqtiIgA+Bgx4Za5
        MlDXQJuI842YszURd5UDMoa/0BgA+FbRaUl4xhJgVgWuwGXe9OUosyNj6ep0kpN4m/64GhDYakFJq
        IJuOF8EECdsIsnMIDl/h2qujUdMHfF6g5eUuHFn91nocM5Afd/Yor8g0lI9jq+wm8VDy6zzDGYTWA
        PnkErXtHsNbE9wjJYfufMUIFkSSAG9WghryrYu2qv5N5fTUPUutv6qCN831M73ceznfRPKpSQ+4sm
        95eVzPwWyX/u8bla8825+35XtUgSvACx3bPo5cdHXNIU+P/agJYwz54FgE3bePg0vHMGVET6GCAjv
        k596Gdhw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pI1EQ-00Gzyj-3I; Wed, 18 Jan 2023 05:43:30 +0000
Date:   Tue, 17 Jan 2023 21:43:30 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/3] xfs: skip fragmentation tests when alwayscow mode is
 enabled
Message-ID: <Y8eHAsHvypUv3IuT@infradead.org>
References: <167400102747.1914975.6709564559821901777.stgit@magnolia>
 <167400102759.1914975.16224258103457998795.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167400102759.1914975.16224258103457998795.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 17, 2023 at 04:43:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If the always_cow debugging flag is enabled, all file writes turn into
> copy writes.  This dramatically ramps up fragmentation in the filesystem
> (intentionally!) so there's no point in complaining about fragmentation.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
