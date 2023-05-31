Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C7EC7EE2E
	for <linux-xfs@archiver.kernel.org>; Wed, 31 May 2023 12:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbjEaMzY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 May 2023 08:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236055AbjEaMyw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 May 2023 08:54:52 -0400
X-Greylist: delayed 77 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 31 May 2023 05:54:30 PDT
Received: from out-2.mta1.migadu.com (out-2.mta1.migadu.com [IPv6:2001:41d0:203:375::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8721BF
        for <linux-xfs@vger.kernel.org>; Wed, 31 May 2023 05:54:30 -0700 (PDT)
Message-ID: <05aee65c-949b-20e8-5bcd-b8bbcc055c88@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685537667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7/wLbEP5pngLR8edcWd7vsDKHEfi97/Ys2rGdOFJfdk=;
        b=dtc+I/H2EPdu3vws5BXo90wW2l0+z66ad4DtoPKAcLdivGzieEGO40EvX12pPT4gWolAja
        dW1zuKb/aD6VPTYOFieSS7yvF7oRauPABs0V2wSYgEuPt2QUdy9A5iKVE4iaSp19P7vUUi
        Ozc0f7SwAPpVb8k+yEQ6+F9BYKBJF6k=
Date:   Wed, 31 May 2023 20:54:21 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 5/8] fs: introduce struct
 super_operations::destroy_super() callback
Content-Language: en-US
To:     Christian Brauner <brauner@kernel.org>
Cc:     akpm@linux-foundation.org, tkhai@ya.ru, roman.gushchin@linux.dev,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, djwong@kernel.org,
        hughd@google.com, paulmck@kernel.org, muchun.song@linux.dev,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Christoph Hellwig <hch@lst.de>
References: <20230531095742.2480623-1-qi.zheng@linux.dev>
 <20230531095742.2480623-6-qi.zheng@linux.dev>
 <20230531-pikiert-jobaussicht-87bbd3da0de5@brauner>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20230531-pikiert-jobaussicht-87bbd3da0de5@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2023/5/31 19:19, Christian Brauner wrote:
> On Wed, May 31, 2023 at 09:57:39AM +0000, Qi Zheng wrote:
>> From: Kirill Tkhai <tkhai@ya.ru>
>>
>> The patch introduces a new callback, which will be called
>> asynchronous from delayed work.
>>
>> This will allows to make ::nr_cached_objects() safe
>> to be called on destroying superblock in next patches,
>> and to split unregister_shrinker() into two primitives.
>>
>> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   fs/super.c         | 3 +++
>>   include/linux/fs.h | 1 +
>>   2 files changed, 4 insertions(+)
> 
> Misses updates to
> Documentation/filesystems/locking.rst
> Documentation/filesystems/vfs.rst

Will do.

Thanks,
Qi
