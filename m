Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4550C43334
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Jun 2022 14:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbiFFOGN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Jun 2022 10:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239523AbiFFOGI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Jun 2022 10:06:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 087A931D0C2
        for <linux-xfs@vger.kernel.org>; Mon,  6 Jun 2022 07:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654524356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EU00yDDZsEorExiuVqxr2YxnhVxuZzqOdLfLQ73hQLA=;
        b=JmEK49MDZeueSyVNMr8vpDWZT+pNQkDJBfF8jH1/5Ma5bnM+MsEsJAxxB2NPvJH+R2WXm3
        Q4KkLRkcCjqGt2U/6Nf1sz2r/XF4EQlYGeVlgSVxhTeW6YUS6nY0ObGcfnRslg/XJu1ixS
        uNAhzZPKFTuJ7OpwBImFHbbaxNamg/Y=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-cFLixQx2Pq2RYt0jRXYQKA-1; Mon, 06 Jun 2022 10:05:55 -0400
X-MC-Unique: cFLixQx2Pq2RYt0jRXYQKA-1
Received: by mail-io1-f70.google.com with SMTP id y2-20020a056602164200b00668dc549adbso6294790iow.18
        for <linux-xfs@vger.kernel.org>; Mon, 06 Jun 2022 07:05:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EU00yDDZsEorExiuVqxr2YxnhVxuZzqOdLfLQ73hQLA=;
        b=LBVhWnMBucdDtXipSdmRsrVQXP5/xv4zAyQiXBG0qVABWaBn00PBv88fylm0dfksX3
         aatm32j/5eWBZ07Xwijb+d9D0pRQginXxWr3WU+9xFvgwcsfnzffgZZ22ph+YDjObEX3
         e2dLNvoZ9nMCXQjnPYbBNIw57sjVwx1FLT+2OVvBte7ZpzTaXi09Ql+Ykv1ITMmPPEgL
         7np40pcDh3RAlu7qEmh2zBOGhhG6LNZJwai+/EUGV2l2ih/FPNX7ttcAQe8TMo24UrP5
         AomcOq3pRslInSbtEuGJ+8bUYd4flZMnBBntN4pr+iI7dF06KIY0c0Ln1susvWMs8yym
         cV5A==
X-Gm-Message-State: AOAM533ZDPgV9tWj3ffUbavQpsBRF020F3a/myi8ZTnqt4E0yWxXRG0y
        Km8jXsCCvop5JD5Zfe/qbdJcgSRc3ZCFH9cu1+GtTS+QwAZvsDcXeF1xeVQhTIA6LiROKCOY1Zp
        fEAsmXK0OiAlgeJgLaGea
X-Received: by 2002:a5e:820a:0:b0:649:5b8:d02c with SMTP id l10-20020a5e820a000000b0064905b8d02cmr11745851iom.50.1654524354498;
        Mon, 06 Jun 2022 07:05:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtZQaq2zxsQ0+dv45xgVjdUEDy+QZ3MPq4nRnKP96pg/39eGdhjbzr/ZPO8bPZQK1YuFMmqw==
X-Received: by 2002:a5e:820a:0:b0:649:5b8:d02c with SMTP id l10-20020a5e820a000000b0064905b8d02cmr11745835iom.50.1654524354144;
        Mon, 06 Jun 2022 07:05:54 -0700 (PDT)
Received: from [10.0.0.146] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id q12-20020a02c8cc000000b0033147b20404sm1557765jao.127.2022.06.06.07.05.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 07:05:53 -0700 (PDT)
Message-ID: <9399aadc-2d80-5da7-d190-3582a08ddad2@redhat.com>
Date:   Mon, 6 Jun 2022 09:05:52 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH RFC v2] xfs: Print XFS UUID on mount and umount events.
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>
Cc:     Lukas Herbolt <lukas@herbolt.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-xfs@vger.kernel.org
References: <20210519152247.1853357-1-lukas@herbolt.com>
 <781bf2c0-5983-954e-49a5-570e365be515@sandeen.net>
 <YpqofakhfvHIBWK/@magnolia>
From:   Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <YpqofakhfvHIBWK/@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 6/3/22 7:34 PM, Darrick J. Wong wrote:
> On Fri, Jun 03, 2022 at 11:14:13AM -0500, Eric Sandeen wrote:
>> On 5/19/21 10:22 AM, Lukas Herbolt wrote:
>>> As of now only device names are printed out over __xfs_printk().
>>> The device names are not persistent across reboots which in case
>>> of searching for origin of corruption brings another task to properly
>>> identify the devices. This patch add XFS UUID upon every mount/umount
>>> event which will make the identification much easier.
>>>
>>> Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
>>> ---
>>> V2: Drop void casts and fix long lines
>>
>> Can we revisit this? I think it's a nice enhancement.
>>
>> The "nouuid" concern raised in the thread doesn't seem like a problem;
>> if someone mounts with "-o nouuid" then you'll see 2 different devices
>> mounted with the same uuid printed. I don't think that's an argument
>> against the patch. Printing the uuid still provides more info than not.
> 
> Ok fair.
> 
>> I, uh, also don't think the submitter should be required to do a tree-wide
>> change for an xfs printk enhancement. Sure, it'd be nice to have ext4
>> and btrfs and and and but we have no other requirements that mount-time
>> messages must be consistent across all filesystems....
> 
> As you pointed out on irc, btrfs already prints its own uuids.  So that
> leaves ext4 -- are you all planning to send a patch for that?

I threw one together, need to actually test and send it, but sure.

> (Otherwise, I don't mind this patch, if it helps support perform
> forensics on systems with a lot of filesystem activity.)

Cool, thanks.

>> Thanks,
>> -Eric
>>
>>>
>>>  fs/xfs/xfs_log.c   | 10 ++++++----
>>>  fs/xfs/xfs_super.c |  2 +-
>>>  2 files changed, 7 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
>>> index 06041834daa31..8f4f671fd80d5 100644
>>> --- a/fs/xfs/xfs_log.c
>>> +++ b/fs/xfs/xfs_log.c
>>> @@ -570,12 +570,14 @@ xfs_log_mount(
>>>  	int		min_logfsbs;
>>>  
>>>  	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
>>> -		xfs_notice(mp, "Mounting V%d Filesystem",
>>> -			   XFS_SB_VERSION_NUM(&mp->m_sb));
>>> +		xfs_notice(mp, "Mounting V%d Filesystem %pU",
>>> +			   XFS_SB_VERSION_NUM(&mp->m_sb),
>>> +			   &mp->m_sb.sb_uuid);
>>>  	} else {
>>>  		xfs_notice(mp,
>>> -"Mounting V%d filesystem in no-recovery mode. Filesystem will be inconsistent.",
>>> -			   XFS_SB_VERSION_NUM(&mp->m_sb));
>>> +"Mounting V%d filesystem %pU in no-recovery mode. Filesystem will be inconsistent.",
>>> +			   XFS_SB_VERSION_NUM(&mp->m_sb),
>>> +			   &mp->m_sb.sb_uuid);
> 
> sb_uuid is the uuid that the user can set, not the one that's encoded
> identically in all the cloud vm images, right?

Uhhh yeah I think so, and "sb_meta_uuid" is the internal one that remains
unchanged but I will double check because even though I wrote that, it's
un-intuitive. :(

Thanks,
-Eric

> --D
> 
>>>  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
>>>  	}
>>>  
>>> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
>>> index e5e0713bebcd8..a4b8a5ad8039f 100644
>>> --- a/fs/xfs/xfs_super.c
>>> +++ b/fs/xfs/xfs_super.c
>>> @@ -1043,7 +1043,7 @@ xfs_fs_put_super(
>>>  	if (!sb->s_fs_info)
>>>  		return;
>>>  
>>> -	xfs_notice(mp, "Unmounting Filesystem");
>>> +	xfs_notice(mp, "Unmounting Filesystem %pU", &mp->m_sb.sb_uuid);
>>>  	xfs_filestream_unmount(mp);
>>>  	xfs_unmountfs(mp);
>>>  
> 
> 

