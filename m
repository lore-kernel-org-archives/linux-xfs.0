Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC1CCC77B7A
	for <linux-xfs@archiver.kernel.org>; Wed, 31 May 2023 13:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbjEaNCd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 May 2023 09:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235864AbjEaNCb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2023 09:02:31 -0400
Received: from out-2.mta1.migadu.com (out-2.mta1.migadu.com [IPv6:2001:41d0:203:375::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A3BE60
        for <linux-xfs@vger.kernel.org>; Wed, 31 May 2023 06:01:59 -0700 (PDT)
Message-ID: <a6449457-2dc6-e6db-2fe9-2a12edf934b3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685537575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ShbrEgfZy4By4UohTrcklSg54xQgs+3EWdpTAp00z8=;
        b=dw0p9yEqwoJ68IFZtmHffnZ4wp5USwQvnVqn94n4syCGENhdaRtT6IT3dXPhuhB7GeFZby
        EAm7yyWAoZ/WouPfjlyTwCg8ijHHlTofAXILbmW8dr+3eq6i1kiBqjx+Bf12QjXhBPbBb7
        iUpHJKOu/PagvVxpglm0N+Kntq3mIHM=
Date:   Wed, 31 May 2023 20:52:46 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/8] mm: vmscan: move shrinker_debugfs_remove() before
 synchronize_srcu()
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>
Cc:     akpm@linux-foundation.org, tkhai@ya.ru, roman.gushchin@linux.dev,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, djwong@kernel.org,
        hughd@google.com, paulmck@kernel.org, muchun.song@linux.dev,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>
References: <20230531095742.2480623-1-qi.zheng@linux.dev>
 <20230531095742.2480623-2-qi.zheng@linux.dev>
 <20230531-notlage-ankommen-93022623b74b@brauner>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20230531-notlage-ankommen-93022623b74b@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2023/5/31 18:49, Christian Brauner wrote:
> On Wed, May 31, 2023 at 09:57:35AM +0000, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> The debugfs_remove_recursive() will wait for debugfs_file_put()
>> to return, so there is no need to put it after synchronize_srcu()
>> to wait for the rcu read-side critical section to exit.
>>
>> Just move it before synchronize_srcu(), which is also convenient
>> to put the heavy synchronize_srcu() in the delayed work later.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
> 
> Afaict, should be a patch independent of this series.

OK, will resend as an independent patch.

Thanks,
Qi
