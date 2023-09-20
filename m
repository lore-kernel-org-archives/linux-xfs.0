Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C9CCE79C2
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Sep 2023 10:31:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbjITKbS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Sep 2023 06:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbjITKbR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Sep 2023 06:31:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFACEB4
        for <linux-xfs@vger.kernel.org>; Wed, 20 Sep 2023 03:31:11 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407AFC433C9;
        Wed, 20 Sep 2023 10:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695205871;
        bh=YOvM1ixHjlpAMYn+2lyWcLU+6fFXsjcSofqXaVFFN9U=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=lXoy83k0MUYpZSVghaLaHTVI0LUOkSMhYO1AFPyJCS46Q4IVvlrs9za/V1pbDnYBa
         ZJWhFxxHhQZD+Rg+YgdXVWJYB5bel//NdYdFX2vAhVn2wsyE3eUCtio+YI1jWtynMT
         BB9K5ZbeNxfxb42h1Ng5j7VTtN/IZOtrQiuBSNEgoxiDoJCRONZq3cA/4GjjR24Pf4
         pkTFMzatbjjnUBG9lgQIPYEMJVdfoqRctdj4eCfEXTU4L5DZzF+Jy4QeBcQVYE5O8e
         rut3rJH1zN/lYRFTkvq0RSj3bx67qlyNXdIDY6jZPH4NyWqupgokRL4ck1nb7oHSdK
         LPGUnfzBG8VBA==
References: <169513911841.1384408.4221257193552110896.stg-ugh@frogsfrogsfrogs>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@gmail.com, david@fromorbit.com, dchinner@redhat.com,
        linux-xfs@vger.kernel.org, peterz@infradead.org,
        ritesh.list@gmail.com, sandeen@sandeen.net, tglx@linutronix.de
Subject: Re: [GIT PULL] xfs: fix ro mounting with unknown rocompat features
Date:   Wed, 20 Sep 2023 15:50:04 +0530
In-reply-to: <169513911841.1384408.4221257193552110896.stg-ugh@frogsfrogsfrogs>
Message-ID: <87jzsl6sri.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 19, 2023 at 09:01:42 AM -0700, Darrick J. Wong wrote:
> Hi Chandan,
>
> Please pull this branch with changes for xfs for 6.6-rc2.
>
> As usual, I did a test-merge with the main upstream branch as of a few
> minutes ago, and didn't see any conflicts.  Please let me know if you
> encounter any problems.
>

Darrick, Unfortunately applying fix-efi-recovery-6.6_2023-09-12 tag pulls in
the older version of "xfs: fix log recovery when unknown rocompat bits are
set".

I think it is best to continue having the older version of "xfs: fix log
recovery when unknown rocompat bits are set" patch i.e. I will include the
current version of xfs-6.6-fixes-1 tag in my pull request to Linus instead of
replacing commits from fix-ro-mounts-6.6_2023-09-12 with
fix-ro-mounts-6.6_2023-09-19.

Sorry about the noise.

-- 
Chandan
