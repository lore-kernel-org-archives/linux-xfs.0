Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D31C07E96
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 18:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2FB461C40
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 18:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhGFSdD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbhGFSdC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 14:33:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DAF761452;
        Tue,  6 Jul 2021 18:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625596223;
        bh=yAke+Z/3biPtjopkGn3MKDtcrgrWq3bCgH6uIGeuoPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XXMenDTe4ZK18Tj8qzRDle6tylY215vLjNidIBGGpJ+v6WG0IMBOFyV7XNIMnCxov
         ZHJqGZgmOiiaiJjytNC+aZ2NSvIqVYH6FKo6XCBo1IQ4oruAfbguLeR4tcl/VLVEYG
         KIQXkmvDJa2jRMFt42ghdlBIFFJO0thilhFewuGkAJfAgdWetuXbTkAtIOkQb6bPCk
         iERXRmm+dvuKfIKw4S+jjWOovS9rJe8i/cG9jRvC9gjRF4n+ZnBOQu28Z6aJAQQ8Rt
         AxN4aPtLWBNBA9HHzeOKYp6lcAEaxKIMxku3oVjzYcPNmSgu0/r85wuoW13+VcLXUS
         IdiAKdBGWvUCg==
Date:   Tue, 6 Jul 2021 11:30:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs_io: don't count fsmaps before querying fsmaps
Message-ID: <20210706183023.GD11588@locust>
References: <162528108960.38807.10502298775223215201.stgit@locust>
 <162528110051.38807.5958877066692397152.stgit@locust>
 <YOMkZyxoSJpG+rur@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOMkZyxoSJpG+rur@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 05, 2021 at 04:25:27PM +0100, Christoph Hellwig wrote:
> On Fri, Jul 02, 2021 at 07:58:20PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > There's a bunch of code in fsmap.c that tries to count the GETFSMAP
> > records so that it can size the fsmap array appropriately for the
> > GETFSMAP call.  It's pointless to iterate the entire result set /twice/
> > (unlike the bmap command where the extent count is actually stored in
> > the fs metadata), so get rid of the duplicate walk.
> 
> In otherwords:  just keep iterating over the records using the default
> chunk size instead of doing one call to find the size and then do
> a giant allocation and GETFSMAP call.

I'll paste this into the commit log, thanks.

--D

> I find the current commit log a little confusing, but the change itself
> looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
