Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE3AC7619A
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 04:59:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjDKE66 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 00:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjDKE65 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Apr 2023 00:58:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F7F1BCA
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 21:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=J/7KGWoTvS/MwmGjbMTSLfv9H2/uRBr8ddFFA2r2OtA=; b=buxRTveqEXGVPnlo5W3KFWT39L
        ldZIFuOWK6MScL+sQwGancoVsaPA8czzw1ofNGlPk4uVj0n6q01lOsXOWRk64osnFneJTZy+//Js6
        7I31/XndzhafhXgEmJ7vWYRBSsonkit7XBMqeK7B47HMB4iRGjvZUn8UZ6KuxzUvLdUM4zI4bVeKe
        kyPtWXCb80CIpSAp9pnyHDeehk4vHT3aEQQUpp2JQX51hS/lul1vN10PBSgkbHUO6FMtenQECGE6c
        ij+8VrTGuxMUxjd6GNe6kGcJzg30M2xsxA4w+b34nu05zl424IvKnUwguI6fdJsTK6sFfBgHeD3OI
        3xr14otw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pm65e-00GQKH-19;
        Tue, 11 Apr 2023 04:58:46 +0000
Date:   Mon, 10 Apr 2023 21:58:46 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     cem@kernel.org, linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 4/6] xfs_db: fix metadump name obfuscation for ascii-ci
 filesystems
Message-ID: <ZDTpBtMlSsxRJjRh@infradead.org>
References: <168073977341.1656666.5994535770114245232.stgit@frogsfrogsfrogs>
 <168073979582.1656666.4211101901014947969.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168073979582.1656666.4211101901014947969.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 05, 2023 at 05:09:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we've stabilized the dirent hash function for ascii-ci
> filesystems, adapt the metadump name obfuscation code to detect when
> it's obfuscating a directory entry name on an ascii-ci filesystem and
> spit out names that actually have the same hash.

Between the alloc use, the goto jumping back and the failure to
obsfucate some names this really seems horribly ugly.  I could
come up with ideas to fix some of that, but they'd be fairly invasive.

Is there any reason we need to support obsfucatation for ascii-ci,
or could we just say we require "-o" to metadump ascii-ci file systems
and not deal with this at all given that it never actually worked?
