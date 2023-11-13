Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15F76C4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 13 Nov 2023 16:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjKMQeC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Nov 2023 11:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjKMQeC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 11:34:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CA2F5
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 08:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699893192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=piBNyP7tee/G8Q4ojFtNG1V7mWtPgCoS38iqBVr8EtM=;
        b=aFgCVSmkt+aQ64Ca54QA4ook+c/+U6YlMgLQ2ZpBUIhc5+Yi3lvB8/EmMR3pVklsh8Bt32
        SGhieSmwat1jgR/34kuxeZEl/21oYDGD0iGuH0frthmaPrWrG6eX+5wWVkB/08Ih+OTf+S
        M6gorD/ETntbQWSGD0Xe2MH7XjxmyiY=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-X4vZBJh9O1OScQmTfcmnQA-1; Mon, 13 Nov 2023 11:33:11 -0500
X-MC-Unique: X4vZBJh9O1OScQmTfcmnQA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-35ab629a843so15397135ab.2
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 08:33:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699893190; x=1700497990;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=piBNyP7tee/G8Q4ojFtNG1V7mWtPgCoS38iqBVr8EtM=;
        b=mD8H17HuhKzVuW0O6H9xSgXs+N9jLg6qcbVHNCk0KzJpvCofcIFomU3LikSbQ1F7+D
         wWjLkN8GNsRcSOyxfnVnOYNoDwu3sXPAgId8mNeA8jXFDp8d0D+OgIiBslAkFfNdUSYl
         hG+nlsDr6TwV/oWgraTbwTq9x+vKWLZ+PKb0IDB1qpGqqPl6QouXRhlPNKDnBeTTKxd3
         R52i1UpFhWK2DJ2E/7ueIKrLltkgSgRWRPyC939DsTyWq55onr13HJpbRNBKTmsQYpVJ
         6SSeGa2hYq6yygk2D6gRNrOly0TNzuEL+fc4lgwbreZJ/fCjpMjR1Wc23xFgSpPsNrOy
         3w5A==
X-Gm-Message-State: AOJu0YzFdMHYtVrhNvwG6hW2z9a8LjIz1RJNtRZC302302yYZMbj8q+E
        +UTOnZTNbecQEqJJSuKp4igXpdc7i/OO4fl2JeISA5RQEkWkSSvZxdPewRr04WeNXyRdwE7NzLb
        Lr2gFfSAXlIOh3fWscdzCY3qopXPmWtg=
X-Received: by 2002:a05:6e02:160b:b0:359:417b:50de with SMTP id t11-20020a056e02160b00b00359417b50demr12941878ilu.15.1699893189910;
        Mon, 13 Nov 2023 08:33:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGnohZ9bpth1y5dS5Q9pIKoBGopeImCjJSOpofpOejJvhJB23sYliqo3iHxEMfyfxCOa7FyGQ==
X-Received: by 2002:a05:6e02:160b:b0:359:417b:50de with SMTP id t11-20020a056e02160b00b00359417b50demr12941865ilu.15.1699893189689;
        Mon, 13 Nov 2023 08:33:09 -0800 (PST)
Received: from [10.0.0.71] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id y13-20020a056e02128d00b0034e28740e35sm1738329ilq.78.2023.11.13.08.33.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Nov 2023 08:33:08 -0800 (PST)
Message-ID: <bc77af82-654a-421f-a30c-24ec4c69bc49@redhat.com>
Date:   Mon, 13 Nov 2023 10:33:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] xfs_repair: notify user when cache flush starts
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <3ca21cbc-fbe2-4c43-b8af-50bc7467b9cd@redhat.com>
 <20231110194022.GM1205143@frogsfrogsfrogs>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20231110194022.GM1205143@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 11/10/23 1:40 PM, Darrick J. Wong wrote:
> On Fri, Nov 10, 2023 at 12:22:30PM -0600, Eric Sandeen wrote:
>> We recently had the opportunity to run xfs_repair on a system
>> with 2T of memory and over a billion inodes. After phase 7
>> had completed, xfs_repair appeared to have hung for over an
>> hour as the massive cache was written back.
>>
>> In the long run it might be nice to see if we can add progress
>> reporting to the cache flush if it's sufficiently large, but
>> for now at least let the user know what's going on.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
>> index ff29bea9..5597b9ba 100644
>> --- a/repair/xfs_repair.c
>> +++ b/repair/xfs_repair.c
>> @@ -1388,6 +1388,7 @@
>>  	 * verifiers are run (where we discover the max metadata LSN), reformat
>>  	 * the log if necessary and unmount.
>>  	 */
>> +	do_log(_("Flushing cache...\n"));
> 
> Does this new message affect the golden output of any fstests?

Ugh, yes, 6 or so. I'll add something to _filter_repair().

> 
> Also, while this /does/ flush the libxfs b(uffer)cache, I worry that
> the phrasing will lead people into thinking that *disk* caches are being
> flushed.  That doesn't happen until libxfs_close_devices.  I suggest:
> 
> "Writing dirty buffers..." ?

That's an excellent suggestion. I'll follow up w/ that change and a fix for
xfstests, thanks for thinking of that.

-Eric

> --D
> 
>>  	libxfs_bcache_flush();
>>  	format_log_max_lsn(mp);
>>
>>
> 

