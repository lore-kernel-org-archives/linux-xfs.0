Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319AFC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 19 May 2022 18:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243543AbiESSCC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 14:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243515AbiESSB7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 14:01:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8055BE64
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 11:01:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E2AB61A07
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 18:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58129C34100;
        Thu, 19 May 2022 18:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652983315;
        bh=n3qPIfX+Y3j8NLR2g/+ez6KVA6oUP3ZTqLuVoI22I7k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l5guU6f4ftz36GygtljFhQsXrv1E2R7NxE3MRSye6JToSB8FFnEocoOefQ3sUHpPC
         FgqHsonev+CFXQ50lO/NG5BcQY+F9WiqoE463OjkaYT4UG+uRuHOO+1+qNqtha4XUK
         KQtEnAXR9oplcSC/PyWFyXNlBczWcTn9lRySKAswSATHCbSJM5HAWovXahU+3V7Vp7
         iDDyLATDwiRhD3SVJUH2m9CY6bhMqBDiULd/evOSgcSYjY2/U7D415mJBdZvjky7nM
         uxKpcdSHEfhIEbFkFth6B7rUz+8do8drwbWtpYC5SiiDnE1GF6uSTg9UQ9/5fgDxoa
         gzN8UsGpo1wCw==
Date:   Thu, 19 May 2022 11:01:54 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: refactor buffer cancellation table allocation
Message-ID: <YoaGEieXNAt43KtA@magnolia>
References: <165290012335.1646290.10769144718908005637.stgit@magnolia>
 <165290012900.1646290.13406779783177992762.stgit@magnolia>
 <YoYBbg59ktNdM2qJ@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoYBbg59ktNdM2qJ@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 19, 2022 at 01:35:58AM -0700, Christoph Hellwig wrote:
> On Wed, May 18, 2022 at 11:55:29AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Move the code that allocates and frees the buffer cancellation tables
> > used by log recovery into the file that actually uses the tables.  This
> > is a precursor to some cleanups and a memory leak fix.
> 
> While you're at it, I'd also move XLOG_BC_TABLE_SIZE and
> XLOG_BUF_CANCEL_BUCKET to xfs_buf_item_recover.c.

Ok.  There's a bit of debugging code that will have to move too, but
that's not a big deal.  Thanks for the review. :)

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
