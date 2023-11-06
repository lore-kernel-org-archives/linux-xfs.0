Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F6D4C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 21:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbjKFVqN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 16:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbjKFVqM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 16:46:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B93DA
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 13:46:10 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C4BC433C8;
        Mon,  6 Nov 2023 21:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699307169;
        bh=WDOmQOkMc+Gj7ptXUPgZy1bcfMMk4MdAR3pL9kPICxI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jUfpKQPBUJvjogLDv5Tvj35AJX30RaaApQpCggKuHeqbq/PMaTiDtZ1JI6knMLusi
         Yut9FtGaGNLFajKqTyu8OXK4OSN1AFNYKY6hgCDfGkE25rS19nfE3cG8jVfwHYAGFT
         2EECEUFME/ZG/Pam7x314vtVv0M4QarjPestXoPfyloRWOz1ScOP0vhxPCtqkGHEon
         M4Pqtrt31Fv9SuensrK0Z6mQiB8eWHM22FvtHgLQ8KW4Mhz/9X1VsjvOOXQOtZI/U7
         cvjGOfSZ2D4oRWaaym0YKqPe8fTsnleb/LJ9MjTm+9y5ZdPiwjOqqk+htf0Wm5d8KH
         AARHYbeIJvm3A==
Date:   Mon, 6 Nov 2023 13:46:08 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Helle Vaanzinn <glitsj16@riseup.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Using User/Group `nobody` in systemd units is discouraged
Message-ID: <20231106214608.GH1205143@frogsfrogsfrogs>
References: <20231106213004.45a1e105.glitsj16@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106213004.45a1e105.glitsj16@riseup.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 06, 2023 at 09:30:04PM -0000, Helle Vaanzinn wrote:
> Hi,
> 
> The xfsprogs userspace utilities have a systemd unit called
> xfs_scrub@.service that references "User=nobody" [1]. Ever since
> systemd version 246 using User/Group `nobody` in
> systemd units is discouraged [2]. It is advised to use the more secure
> `DynamicUser` concept [3] instead.
> 
> I couldn't find an easy way to report an issue / offer a PR for this,
> hence this message to the mailing list. If there's a better way to
> report, please advise.

Known problem fixed by
https://lore.kernel.org/linux-xfs/167243871504.718298.11721955751660856262.stgit@magnolia/
https://lore.kernel.org/linux-xfs/168506074549.3746099.6129822996056625257.stgit@frogsfrogsfrogs/

But the community has not merged that patchset or any of the subsequent
repostings due to insufficient review bandwidth.

--D

> Regards,
> 
> Helle
> 
> /--
> 
> 
> [1]
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/tree/scrub/xfs_scrub@.service.in#n15
> 
> [2] https://github.com/systemd/systemd/blob/v246/NEWS#L106
> 
> [3] https://0pointer.net/blog/dynamic-users-with-systemd.html
