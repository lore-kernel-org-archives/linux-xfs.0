Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66756C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 21:32:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4684D60F92
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 21:32:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbhJLVea (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 17:34:30 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52754 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbhJLVea (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Oct 2021 17:34:30 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CE2CC1FF6B;
        Tue, 12 Oct 2021 21:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1634074346; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g7HK2Kf8c4mJukZ0Mo4rZUFzKfAvYTuMEdKV03E7+Ik=;
        b=FpSMq6bMGmBtf+GXUgoy6QUKoqjS1iGl/eQaDcISbQN+vLEzbaRikq+rrgGfXAgkENuWNX
        Dcvkx6oUYx9HNZqBEH7kuaqzeciKuFaOm+4Zsu3R2zfthgtWdfdUs1tvqTUyxUByoGZvsG
        kngIxSaiHdr0h5zCvzrVVfnmhoaEf8M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1634074346;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g7HK2Kf8c4mJukZ0Mo4rZUFzKfAvYTuMEdKV03E7+Ik=;
        b=Ge3Os5wqd0rcf6HlPW9CMrCK6lYZBkjzDchFjPg2nqQ83OzMXRU5UZJJ+t2Ug47uFb3LXV
        Sr/bd6t3aQGi6uCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 81E3913C8A;
        Tue, 12 Oct 2021 21:32:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3n1HHur+ZWFqNQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Tue, 12 Oct 2021 21:32:26 +0000
Message-ID: <9db5d16a-2999-07a4-c49d-7417601f834f@suse.cz>
Date:   Tue, 12 Oct 2021 23:32:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH] xfs: use kmem_cache_free() for kmem_cache objects
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        David Rientjes <rientjes@google.com>
Cc:     Rustam Kovhaev <rkovhaev@gmail.com>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        cl@linux.com, penberg@kernel.org, iamjoonsoo.kim@lge.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, gregkh@linuxfoundation.org,
        Al Viro <viro@zeniv.linux.org.uk>, dvyukov@google.com
References: <20210929212347.1139666-1-rkovhaev@gmail.com>
 <20210930044202.GP2361455@dread.disaster.area>
 <17f537b3-e2eb-5d0a-1465-20f3d3c960e2@suse.cz> <YVYGcLbu/aDKXkag@nuc10>
 <a9b3cd91-8ee6-a654-b2a8-00c3efb69559@suse.cz> <YVZXF3mbaW+Pe+Ji@nuc10>
 <1e0df91-556e-cee5-76f7-285d28fe31@google.com>
 <20211012204320.GP24307@magnolia> <20211012204345.GQ24307@magnolia>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20211012204345.GQ24307@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 10/12/2021 10:43 PM, Darrick J. Wong wrote:
> On Tue, Oct 12, 2021 at 01:43:20PM -0700, Darrick J. Wong wrote:
>> On Sun, Oct 03, 2021 at 06:07:20PM -0700, David Rientjes wrote:
>>> On Thu, 30 Sep 2021, Rustam Kovhaev wrote:
>>>
>>>>>>> I think it's fair if something like XFS (not meant for tiny systems AFAIK?)
>>>>>>> excludes SLOB (meant for tiny systems). Clearly nobody tried to use these
>>>>>>> two together last 5 years anyway.
>>>>>>
>>>>>> +1 for adding Kconfig option, it seems like some things are not meant to
>>>>>> be together.
>>>>>
>>>>> But if we patch SLOB, we won't need it.
>>>>
>>>> OK, so we consider XFS on SLOB a supported configuration that might be
>>>> used and should be tested.
>>>> I'll look into maybe adding a config with CONFIG_SLOB and CONFIG_XFS_FS
>>>> to syzbot.
>>>>
>>>> It seems that we need to patch SLOB anyway, because any other code can
>>>> hit the very same issue.
>>>>
>>>
>>> It's probably best to introduce both (SLOB fix and Kconfig change for 
>>> XFS), at least in the interim because the combo of XFS and SLOB could be 
>>> broken in other ways.  If syzbot doesn't complain with a patched kernel to 
>>> allow SLOB to be used with XFS, then we could potentially allow them to be 
>>> used together.
>>>
>>> (I'm not sure that this freeing issue is the *only* thing that is broken, 
>>> nor that we have sufficient information to make that determination right 
>>> now..)
>>
>> I audited the entire xfs (kernel) codebase and didn't find any other
>> usage errors.  Thanks for the patch; I'll apply it to for-next.

Which patch, the one that started this thread and uses kmem_cache_free() instead
of kfree()? I thought we said it's not the best way?

> Also, the obligatory
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> --D
> 
>>
>> --D

