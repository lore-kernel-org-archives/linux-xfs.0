Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619EDC7EE2E
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Feb 2023 01:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjB1BCL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Feb 2023 20:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjB1BCK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2023 20:02:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539FC29E00;
        Mon, 27 Feb 2023 17:01:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD4A460F85;
        Tue, 28 Feb 2023 01:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CFB1C433A1;
        Tue, 28 Feb 2023 01:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677546115;
        bh=EkQcNS9ff+s73/ftmm+esj3kNcGvM+iC7iMN8fE5iBM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MLg4vfi/I+uvxuMwP620rcv1pbGUJ6mV1XVBXK9Np1oCy6z7cZcB/ZqVzikOZNK2K
         /vYd2S4lZjCqj6TJRc7qvJhBTuxI5Goh6YntGHn0kCKqlVsZnean1Q1wWELql6Zy7i
         IQjumfC8dwyXHW92IDIGlMkIVJ7sszKBJEQLyo9MbT4BxS3jJzI7Q3uBnTUb8NRORk
         8Fgse5NOIExS22jJkbafSXkEGbE6foMx/WNytDQSR43bVaLB5KmmIEjuiZdYeGSfNq
         eo8nGVLSQZFp4kZuvP+YOKUkKT3cubSpl/q48qJy4AmsyrwufC7AV6VAkVU6sPw1dk
         3yfVPORjIE7/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B67FE68D2D;
        Tue, 28 Feb 2023 01:01:55 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH] MAINTAINERS: update fsverity git repo, list,
 and patchwork
From:   patchwork-bot+f2fs@kernel.org
Message-Id: <167754611510.27916.9240415450147336075.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Feb 2023 01:01:55 +0000
References: <20230116232257.64377-1-ebiggers@kernel.org>
In-Reply-To: <20230116232257.64377-1-ebiggers@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fsverity@lists.linux.dev, linux-f2fs-devel@lists.sourceforge.net,
        linux-xfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello:

This patch was applied to jaegeuk/f2fs.git (dev)
by Eric Biggers <ebiggers@google.com>:

On Mon, 16 Jan 2023 15:22:57 -0800 you wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> We're moving fsverity development to use its own git repo, mailing list,
> and patchwork project, instead of reusing the fscrypt ones.  Update the
> MAINTAINERS file accordingly.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> [...]

Here is the summary with links:
  - [f2fs-dev] MAINTAINERS: update fsverity git repo, list, and patchwork
    https://git.kernel.org/jaegeuk/f2fs/c/ef7592e466ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


