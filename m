Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1038CC433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 16:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC8702312F
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Jan 2021 16:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbhAFQkH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jan 2021 11:40:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58448 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726661AbhAFQkG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jan 2021 11:40:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609951120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xL2edJmjQldEFEFp83BVhalB7pDU33Bc7WJ+iQeFlBI=;
        b=HYRz4KdAgNrIzxBfZ7HPeUWplZwQaBbIfzAk9OumjwuoSKzpqkLhwZut0rXf+vMvilf0U9
        s6K32UuzxkTC0Yk6GJfNo2HOxe3Fs/33VtBXGcsr68nLkeiyFwhKCo9RLEF8ZANa+Jayjm
        0052P/pbLYPT8obm3HJEsTQgF+tCn+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-mdS4pXVqNVGa_VhVno1tFA-1; Wed, 06 Jan 2021 11:38:39 -0500
X-MC-Unique: mdS4pXVqNVGa_VhVno1tFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3456A190A7A0
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jan 2021 16:38:38 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EB0885C1C4;
        Wed,  6 Jan 2021 16:38:37 +0000 (UTC)
Subject: Re: [PATCH] xfsprogs: cosmetic changes to libxfs_inode_alloc
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
References: <a06e071c-be56-2e7d-cceb-82030f55e1f3@redhat.com>
 <20210106145701.GC361175@bfoster>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <f25a81a3-61d2-f9e8-4b87-090e47a0ad3e@redhat.com>
Date:   Wed, 6 Jan 2021 10:38:37 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210106145701.GC361175@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 1/6/21 8:57 AM, Brian Foster wrote:
> On Tue, Jan 05, 2021 at 04:02:18PM -0600, Eric Sandeen wrote:
>> This pre-patch helps make the next libxfs-sync for 5.11 a bit
>> more clear.
>>
>> In reality, the libxfs_inode_alloc function matches the kernel's
>> xfs_dir_ialloc so rename it for clarity before the rest of the
>> sync, and change several variable names for the same reason.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
> ...
>> diff --git a/libxfs/util.c b/libxfs/util.c
>> index 252cf91e..62eadaea 100644
>> --- a/libxfs/util.c
>> +++ b/libxfs/util.c
> ...
>> @@ -559,25 +561,25 @@ libxfs_inode_alloc(
>>  
>>  	if (ialloc_context) {
>>  
>> -		xfs_trans_bhold(*tp, ialloc_context);
>> +		xfs_trans_bhold(tp, ialloc_context);
>>  
>> -		error = xfs_trans_roll(tp);
>> -		if (error) {
>> +		code = xfs_trans_roll(tpp);
> 
> The subsequent uses of tp no longer refer to the right transaction after
> this roll. FWIW, there is a subtle difference with the kernel code where
> this call passes &tp and then updates tpp on return, but we could also
> just update tp here if that's still good enough to facilitate the libxfs
> sync.

Whoops, now I remember meaning to go back and check that, thanks, I'll
take a closer look.

-Eric

