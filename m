Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB73BC4167D
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Nov 2023 17:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345846AbjKJRoH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 10 Nov 2023 12:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345943AbjKJRni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Nov 2023 12:43:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C35250B4
        for <linux-xfs@vger.kernel.org>; Fri, 10 Nov 2023 01:48:33 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E54C433C7;
        Fri, 10 Nov 2023 09:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699609713;
        bh=JLpAE5Xqr2YZU5rW/WSCsnbf8d5vt1ZBMI4QsYZQUwI=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:From;
        b=E2L96A8kN1AMVVwVSCTsZNYTZ8DhkGLjrfWSIroDq+Gf8y79UX73uE7L+Bk9S/epK
         FYaiaa8vEEsnsp1l69OlyJXfzBRH8jdamWfmmslmSgqNCItsJkhUsRxYg1/o0UHwUP
         psjfYwbnTNvpHYY8gwq+n+lF9JHB/cotdenETN6caNk6tgBh6+nP0Xo8RGs3fQD5om
         8WdEHCNAikST00jvYWTg6zt/4gmhY88HpJxUeX/5i1rdgH+UDa0HSZIB64Mx5I+3ST
         P31yUe4jovzkGmRpIQeBX1SaNIokNyWYYUEvUPY4KvB+jJotFrKkv8XH1vT/5/m+AA
         Ws0E1iHSBC8pQ==
References: <20230731124619.3925403-1-leo.lilong@huawei.com>
 <20231107133607.GA560725@ceph-admin>
 <87jzqr9jm8.fsf@debian-BULLSEYE-live-builder-AMD64>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     Long Li <leo.lilong@huaweicloud.com>
Cc:     linux-xfs@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
        yangerkun@huawei.com, djwong@kernel.org, david@fromorbit.com
Subject: Re: [PATCH v3 0/3] xfs: fix two problem when recovery intents fails
Date:   Fri, 10 Nov 2023 15:16:16 +0530
In-reply-to: <87jzqr9jm8.fsf@debian-BULLSEYE-live-builder-AMD64>
Message-ID: <87jzqquefl.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 09, 2023 at 06:18:48 PM +0530, Chandan Babu R wrote:
> On Tue, Nov 07, 2023 at 09:36:07 PM +0800, Long Li wrote:
>> On Mon, Jul 31, 2023 at 08:46:16PM +0800, Long Li wrote:
>>> This patch set fix two problem when recovery intents fails.
>>> 
>>> Patches 1-2 fix the possible problem that intent items not released.
>>> When recovery intents, new intents items may be created during recovery
>>> intents. if recovery fails, new intents items may be left in AIL or
>>> leaks.
>>
>> Hi Chandan,
>> 	
>> In this patchset, patches 1-2 [1][2] have already been reviewed by Darrick,
>> and are not related to patch 3, is it possible to merge patches 1-2 in first?? 	
>> Patch 3 seems still has a lot of work to do.
>>
>> [1] https://patchwork.kernel.org/project/xfs/patch/20230715063647.2094989-2-leo.lilong@huawei.com/
>> [2] https://patchwork.kernel.org/project/xfs/patch/20230715063647.2094989-3-leo.lilong@huawei.com/
>>
>
> Sure, I will queue the first two patches for 6.7-rc2. Thanks for notifying me.

Darrick's email address mentioned under the RVB tag is incorrect. I will
update it to djwong@kernel.org when commiting the patches.

-- 
Chandan
