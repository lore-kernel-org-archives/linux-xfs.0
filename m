Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F6AC07E96
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 18:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4EF661C6B
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jul 2021 18:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhGFS0q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229954AbhGFS0q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jul 2021 14:26:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B804761C69;
        Tue,  6 Jul 2021 18:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625595847;
        bh=WtabYL7wjqWpuR/V6oB5EVR7BkOlqTTUla2s1ZdiHU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rSLnM7bgd4Es9evcRil5px25Qjt0m9kPsm4wWKCmtlkZ9lb20rmx4gLoVQmTPIbIu
         VjeP5ChIMKYlQtp/KUAaOl6abjjAwXsIhA8XnUklgsJm4TmCa6oFxex5Z7bPMgZZ8q
         cuJQUfYExnNquXXp8dWNQm6UyE5yuKCeDTS1JWIuB/7FfI7GcTky9hYFp9W+ZGpC/t
         0JlXYCC7eghEYA20yNmMzGn32kE4zdTCWYiBWP9QHSK4lsA51IUmAqVb+tIK1Q92hS
         dsm+N0f+89666GSblV7QuJprEjdGnN432dht9bafLj4Tb9d/EBJET4X9as7lyqsUG2
         dJH/42w6jYpdA==
Date:   Tue, 6 Jul 2021 11:24:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs_io: fix broken funshare_cmd usage
Message-ID: <20210706182407.GB11588@locust>
References: <162528107717.36401.11135745343336506049.stgit@locust>
 <162528108265.36401.17169382978840037158.stgit@locust>
 <YOMiWq61o4GNlNAV@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YOMiWq61o4GNlNAV@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 05, 2021 at 04:16:42PM +0100, Christoph Hellwig wrote:
> On Fri, Jul 02, 2021 at 07:58:02PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create a funshare_cmd and use that to store information about the
> > xfs_io funshare command instead of overwriting the contents of
> > fzero_cmd.  This fixes confusing output like:
> > 
> > $ xfs_io -c 'fzero 2 3 --help' /
> > fzero: invalid option -- '-'
> > funshare off len -- unshares shared blocks within the range
> 
> Ooops, how did this manage to ever work?

It "works" (in the sense that fzero and funshare issue the correct
fallocate modes) because add_command copies the contents of its struct
parameter into the internal command list.  The braindamage is limited to
any subsequent use of fzero_cmd, which (afaict) means the only way you'd
notice is through the help screens.

--D

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
