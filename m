Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11C6FC5AD4C
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Nov 2023 01:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345647AbjKQBu4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Nov 2023 20:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345644AbjKQBuz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2023 20:50:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B2A195
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2023 17:50:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700185851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lGSuWJO7S6MXiDolxtjA6VeW24nPdThcsXKHEAmIP+w=;
        b=WHEANKxgDZ6Z3J1Ph5A20k9ymvREDSQ00tUqtTu7kQJyCLl0gxe91MK4azTn0tfxIPe2NI
        +VPl0d2itKfa57ETRBFdyBJJRM1b0NoKrgGrEeAHuz81iCx3QJzRQlkA3J0cicvcpNIJck
        cv4rQp1VbxhESTScBXjOHfO/rZCV1oc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-491-ui6YRq4tMsWqkVFVbd65CQ-1; Thu,
 16 Nov 2023 20:50:46 -0500
X-MC-Unique: ui6YRq4tMsWqkVFVbd65CQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 225753803503;
        Fri, 17 Nov 2023 01:50:46 +0000 (UTC)
Received: from [10.22.8.82] (unknown [10.22.8.82])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 976A21C060AE;
        Fri, 17 Nov 2023 01:50:45 +0000 (UTC)
Message-ID: <767ce2df-6f9b-40a3-b40b-e9e7a593e3b2@redhat.com>
Date:   Thu, 16 Nov 2023 20:50:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] locking: Add rwsem_assert_held() and
 rwsem_assert_held_write()
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Chandan Babu R <chandan.babu@oracle.com>,
        "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Mateusz Guzik <mjguzik@gmail.com>
References: <20231110204119.3692023-1-willy@infradead.org>
 <20231110204119.3692023-2-willy@infradead.org>
 <52f481a3-bf4f-85ae-9ae6-10a23b48c7c5@redhat.com>
 <ZVPmCoLVXyShSrkN@casper.infradead.org>
 <72dced0f-6d49-4522-beeb-1a398d8f2557@redhat.com>
 <ZVY/cAMFbkuKJF/Y@casper.infradead.org>
From:   Waiman Long <longman@redhat.com>
In-Reply-To: <ZVY/cAMFbkuKJF/Y@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 11/16/23 11:12, Matthew Wilcox wrote:
> On Tue, Nov 14, 2023 at 08:17:32PM -0500, Waiman Long wrote:
>>>> There are some inconsistency in the use of WARN_ON() and BUG_ON() in the
>>>> assertions. For PREEMPT_RT, held_write is a BUG_ON. For non-PREEMPT_RT, held
>>>> is a BUG_ON. It is not clear why one is BUG_ON and other one is WARN_ON. Is
>>>> there a rationale for that?
>>> I'll fix that up.
>> The check for write lock ownership is accurate. OTOH, the locked check can
>> have false positive and so is less reliable.
> When you say 'false positive', do you mean it might report the lock as
> being held, when it actually isn't, or report the lock as not being held
> when it actually is?  The differing polarities of assert and BUG_ON
> make this confusing as usual.
It means there may be no active lock owner even though the count isn't 
zero. If there is one or more owners, the count will always be non-zero.
>
> Obviously, for an assert, we're OK with it reporting that the lock is
> held when actually it's not.  The caller is expected to hold the lock,
> so failing to trip the assert when the caller doesn't hold the lock
> isn't great, but we can live with it.  OTOH, if the assert fires when
> the caller does hold the lock, that is not tolerable.

The second case shouldn't happen. So the assert should be OK.

Cheers,
Longman


