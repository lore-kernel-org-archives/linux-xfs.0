Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A59C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 00:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiEKAHu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 20:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiEKAHs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 20:07:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F5AA5FD9
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 17:07:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C2CB619A5
        for <linux-xfs@vger.kernel.org>; Wed, 11 May 2022 00:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9385CC385D2;
        Wed, 11 May 2022 00:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652227666;
        bh=z9AmQnu1R0KKrg4Cb9xTE9wXgzE7u0804pVr8N0EF9w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d/YmH1DxfcFA2o6Ea4V3Kr15g2aYPuyw4UZsj2miv4Yz8BLcfO4xNWzZVpbNByHN2
         LSvYD/3p7ZgOoTGQk47LHTFvaQlqbsJO27+Ze211zyPz210W85rA4x3w5Kk6PwYkYf
         ivFEa0hQ0a7vYx6WKqLMkYxvA6yP7PgBtj/CliLdNiBE+vAhfmC8+89sbKANWoDfJv
         LAW6fR3NaqKTtfYfp7dgITQojgjELZqfEL8/nPPU+fFzPaq6lVcndGqUSWnRwAGfHR
         G/DbC8zDbaQu4tOS+I5fcM50sExEz0pZlnxVMakXDZKjvi37pePusKLAC16qMvVUss
         sL2bRx08BI8TA==
Date:   Tue, 10 May 2022 17:07:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs_repair: check free rt extent count
Message-ID: <20220511000746.GZ27195@magnolia>
References: <165176668306.247207.13169734586973190904.stgit@magnolia>
 <165176669425.247207.10108411720464005906.stgit@magnolia>
 <Ynpf+KLA1jD6P5vF@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ynpf+KLA1jD6P5vF@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 10, 2022 at 05:52:08AM -0700, Christoph Hellwig wrote:
> On Thu, May 05, 2022 at 09:04:54AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Check the superblock's free rt extent count against what we observed.
> > This increases the runtime and memory usage, but we can now report
> > undercounting frextents as a result of a logging bug in the kernel.
> > Note that repair has always fixed the undercount, but it no longer does
> > that silently.
> 
> This looks sensible, but can't we still skip running phase5 for
> file systems without an RT subvolume?

Yeah, I was of half a mind to make a separate function phase5_nomodify
instead of burying that in phase5_func()...

...but OTOH, I suppose the dinode inspection functions will flag errors
if the superblock says sb_rextents == 0 but DIFLAG_REALTIME is set on a
regular file.  So, I guess that could be a separate check_rtmetadata()
function that lives inside phase5.c and gets triggered in the
(nomodify && sb_rblocks > 0) case.

--D
