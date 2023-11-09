Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDB52C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 12:49:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjKIMt7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 07:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjKIMt6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 07:49:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E2E210A
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 04:49:56 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96575C433C7;
        Thu,  9 Nov 2023 12:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699534196;
        bh=1pZ3DNVFXVL9gVc/r6PoKA+oXpMcVK5rp+lnUX4ReAw=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=cDYX9ydABot5ppPERyq8xE0H7qhEyDW4q7/Bwpdjx3Hk66PjqLeskS2LgF+fjuWt6
         kyCaG6PN5Pnm62kQ1QQYgZmEON8F9p9ErOukhEmkephnQfu8GGv5wksdA9jfsRAeGR
         pGZ+kFpPHo6QlY+Nqi9rJoUmn1eP/bjn++cPuyfLY7RzrnkWo17hfbeSGt/XxHD0RL
         MkUlQwyACCfMLNThAxhZpu53bL7aL6CBG3RWMl0I7qENRUw3RbitbLaQYNKBmD+y0Z
         zpJJUm0qyUjh9vetw9Uzna59NnEmApXlyVqEBvKWuvykdO/K0qVt2D/1lBS2K7MUke
         N0FM5sLIgtdgQ==
References: <20230731124619.3925403-1-leo.lilong@huawei.com>
 <20231107133607.GA560725@ceph-admin>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     Long Li <leo.lilong@huaweicloud.com>
Cc:     linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
        yangerkun@huawei.com, djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v3 0/3] xfs: fix two problem when recovery intents fails
Date:   Thu, 09 Nov 2023 18:18:48 +0530
In-reply-to: <20231107133607.GA560725@ceph-admin>
Message-ID: <87jzqr9jm8.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 07, 2023 at 09:36:07 PM +0800, Long Li wrote:
> On Mon, Jul 31, 2023 at 08:46:16PM +0800, Long Li wrote:
>> This patch set fix two problem when recovery intents fails.
>> 
>> Patches 1-2 fix the possible problem that intent items not released.
>> When recovery intents, new intents items may be created during recovery
>> intents. if recovery fails, new intents items may be left in AIL or
>> leaks.
>
> Hi Chandan,
> 	
> In this patchset, patches 1-2 [1][2] have already been reviewed by Darrick,
> and are not related to patch 3, is it possible to merge patches 1-2 in first?? 	
> Patch 3 seems still has a lot of work to do.
>
> [1] https://patchwork.kernel.org/project/xfs/patch/20230715063647.2094989-2-leo.lilong@huawei.com/
> [2] https://patchwork.kernel.org/project/xfs/patch/20230715063647.2094989-3-leo.lilong@huawei.com/
>

Sure, I will queue the first two patches for 6.7-rc2. Thanks for notifying me.

-- 
Chandan
