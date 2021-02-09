Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37786C433E9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2BD864EC2
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 09:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhBIJU7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 04:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbhBIJSr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Feb 2021 04:18:47 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF64C061786
        for <linux-xfs@vger.kernel.org>; Tue,  9 Feb 2021 01:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uH5qxKFMK6zK2kg9Wsp8yqb+0sAT+2I7o/nTJsNxRCM=; b=XB2DfH7ZdL0vQqdQyQITkgmQKO
        +ZoTYvnRH3IFVjpTnSmh9n39QTQ3i+l9X96g9cMWFdmpDFJWUR+owORDLaXQbLfoHVSiouxqaVz4U
        GA/A/o6ldn+JiyYHu+9ayRHfg/uA8jm58q6pIdrY5xtS+FwOEWo4b4dqLwv5j4KAliaVOQgfDtOhD
        FpjtYuR5BbZ/06Iqe0lH55FIW13CnbpMOWfdLGDs6dsw4yovAC3AV/ZnWzPSOO416GzxEdmrBkTCo
        3w10bBhtgwrFYExOYXzoiFcUag9EjajczUnL4DLyafEGG1tyIAsXFiENRg1LalZR9Pr9Qjj5lfEk3
        P0vMXvvg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9P9l-007Dkp-CQ; Tue, 09 Feb 2021 09:18:02 +0000
Date:   Tue, 9 Feb 2021 09:18:01 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 10/10] xfs_admin: support adding features to V5
 filesystems
Message-ID: <20210209091801.GJ1718132@infradead.org>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284386088.3057868.16559496991921219277.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161284386088.3057868.16559496991921219277.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 08, 2021 at 08:11:00PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach the xfs_admin script how to add features to V5 filesystems.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
