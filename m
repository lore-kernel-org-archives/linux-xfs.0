Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63D71C43381
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 16:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 112C164DD9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 16:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhBIQ4Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Feb 2021 11:56:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232860AbhBIQ4M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 11:56:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8893864DD6;
        Tue,  9 Feb 2021 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612889730;
        bh=GuB7/A0HPsYo/C2I1f/h1OHN9zr+swzlt0VDUB0STDc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jAKvf90w0J9RO1Ua+QhRctHx1CtM3FmIXEz07Epy6u8qVuxNRXMm37tX2jm1eEQv+
         n+raNlBDBgz3PmDBTyT2vwf6UuNItvk3QVaESlzrbawPcONCC6e780qdlMhGsGFhow
         011NwggjzLer11aRKg/UJ6RpUpLXEbIfMbZq31fpYUhDj/Eqmjlb6Th+Dlt4oU5d3+
         vZKP+oMWVTkEnaDhd7l8FyhsuehYcamTs/UiMAdW8aPZlgd3a0if2NHxxZI88HFyCg
         CwrAIzzttKlkOniqlhSe8w/CaxwON19v7LkDa9G9PU7mr0If91T7hVbr9B9va+zCsQ
         ndmghMqEGdElA==
Date:   Tue, 9 Feb 2021 08:55:30 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        chandanrlinux@gmail.com, Chaitanya.Kulkarni@wdc.com
Subject: Re: [PATCH 5/6] xfs_repair: check dquot id and type
Message-ID: <20210209165530.GG7190@magnolia>
References: <161284387610.3058224.6236053293202575597.stgit@magnolia>
 <161284390433.3058224.6853671538193339438.stgit@magnolia>
 <20210209093114.GQ1718132@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209093114.GQ1718132@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 09:31:14AM +0000, Christoph Hellwig wrote:
> On Mon, Feb 08, 2021 at 08:11:44PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make sure that we actually check the type and id of an ondisk dquot.
> 
> This looks copied from the kernel code.

Yeah, it might be time to refactor the quotacheck code into libxfs,
though I suspect the biggest hurdle is that we'd have to port at least
some of xfs_dquot along with it.

--D

> But otherwise looks fine:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
