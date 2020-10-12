Return-Path: <SRS0=uuBg=DT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29016C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 21:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4D7D2076E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Oct 2020 21:02:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="igPfg7yB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731690AbgJLVC6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Oct 2020 17:02:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730845AbgJLVC6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Oct 2020 17:02:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602536577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NqopduvVUZr01m2juIKmSfhXQezsvdNTDBDCsLwSNXY=;
        b=igPfg7yBPMiikva5INJZRBmCQgSQwzJ6rzHxQ7QhmkL8k+T09DFniIgSn/eiYSRjMtTQql
        MPQqubfXX/qdz9nalC56oh9x0l+8BH/qJwX7hiSIcNCu8yyAbw6WD+6zk2x1YBFIOTer1O
        xpba3vzhw31z39vmMzsi9kC7D12xUfY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-e8SOSo2rNOec3zNk5ORnAQ-1; Mon, 12 Oct 2020 17:02:55 -0400
X-MC-Unique: e8SOSo2rNOec3zNk5ORnAQ-1
Received: by mail-wr1-f72.google.com with SMTP id r8so2497505wrp.5
        for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2020 14:02:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NqopduvVUZr01m2juIKmSfhXQezsvdNTDBDCsLwSNXY=;
        b=nMGkjMVL6SgqkKMIzmZD3r0wUsPln0pjNJH7xxfw082tInDhmDv+5gkF+zeBmC99mg
         sLO2BroX91MAFlEt0rMiJbOwTRPPMG3zQrGMCjGn4jlefZJB+o/Gd2VKLxIW0pmlYt85
         coKsLD7E5C21SocUWiSj6CF+yREzv+YIpiKOTN8jXp2X1A4Vn9c0QlsFfYWF6fP7a312
         unTlSkmVx1ftYuGzPY/qN7n69lKPs1LJm2OAzCDgzi5qdwtOVk/SI7O7F+vqdBzqcrAO
         nmlfzwc3MaHnD6KgwZPXRQ2jRHhNB7VJnLoKQ9X2bxz53CcbK8d43iDdFLqUpeHCN0aZ
         4ojQ==
X-Gm-Message-State: AOAM5330sbcT+Zq8QOoqvJgaFmo2E62P5Byby+hiPHfKSCgYuHICMGta
        pAOv5WyCnG83wOjwIaUvw52uZYm90Ceb5LqdKN2RTTZM4SE5uVgaJ2N7GKe4iwBRnv0AGAmJ7PQ
        7o2lJYPBhmQxixXH3vWoW
X-Received: by 2002:a1c:2b05:: with SMTP id r5mr12387813wmr.179.1602536573675;
        Mon, 12 Oct 2020 14:02:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzsLRoPPxhJyHC7ujUV+9qqoTSakR3jAnaA4ZsVb8+J5E6kvkugsqJq7/zknBPz/gV9bCDDoA==
X-Received: by 2002:a1c:2b05:: with SMTP id r5mr12387806wmr.179.1602536573482;
        Mon, 12 Oct 2020 14:02:53 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.81])
        by smtp.gmail.com with ESMTPSA id j5sm20657244wrx.88.2020.10.12.14.02.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 14:02:52 -0700 (PDT)
Subject: Re: [PATCH v11 4/4] xfs: replace mrlock_t with rw_semaphores
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201009195515.82889-1-preichl@redhat.com>
 <20201009195515.82889-5-preichl@redhat.com> <20201012160412.GK917726@bfoster>
From:   Pavel Reichl <preichl@redhat.com>
Message-ID: <a6afba10-64a2-a30c-94de-e99a324a6114@redhat.com>
Date:   Mon, 12 Oct 2020 23:02:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201012160412.GK917726@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


> ...
>> @@ -384,16 +385,17 @@ xfs_isilocked(
>>  	struct xfs_inode	*ip,
>>  	uint			lock_flags)
>>  {
>> -	if (lock_flags & (XFS_ILOCK_EXCL|XFS_ILOCK_SHARED)) {
>> -		if (!(lock_flags & XFS_ILOCK_SHARED))
>> -			return !!ip->i_lock.mr_writer;
>> -		return rwsem_is_locked(&ip->i_lock.mr_lock);
>> +	if (lock_flags & (XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)) {
>> +		ASSERT(!(lock_flags & ~(XFS_ILOCK_EXCL | XFS_ILOCK_SHARED)));
>> +		return __xfs_rwsem_islocked(&ip->i_lock,
>> +				(lock_flags >> XFS_ILOCK_FLAG_SHIFT));
>>  	}
>>  
>> -	if (lock_flags & (XFS_MMAPLOCK_EXCL|XFS_MMAPLOCK_SHARED)) {
>> -		if (!(lock_flags & XFS_MMAPLOCK_SHARED))
>> -			return !!ip->i_mmaplock.mr_writer;
>> -		return rwsem_is_locked(&ip->i_mmaplock.mr_lock);
>> +	if (lock_flags & (XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)) {
>> +		ASSERT(!(lock_flags &
>> +			~(XFS_MMAPLOCK_EXCL | XFS_MMAPLOCK_SHARED)));
>> +		return __xfs_rwsem_islocked(&ip->i_mmaplock,
>> +				(lock_flags >> XFS_MMAPLOCK_FLAG_SHIFT));
>>  	}
>>  
>>  	if (lock_flags & (XFS_IOLOCK_EXCL | XFS_IOLOCK_SHARED)) {
> 
> Can we add a similar assert for this case as we have for the others?
> Otherwise the rest looks fairly straightforward to me.
> 

Sure we can! But do we want to?

I think that these asserts are supposed to make sure that only flags for one of the inode's locks are used eg. ILOCK, MMAPLOCK or IOLOCK but no combination! So if we reach this 3rd condition we already know that the flags for ILOCK and MMAPLOCK were not set. However if there's possibility for more locks to be added in the future or just for the 'code symmetry' purposes - I have no problem to update the code.
 

