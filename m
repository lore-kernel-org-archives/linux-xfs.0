Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C94F205E00
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 01:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744765701; cv=none; b=N4yqlEz/84aVCfSiyNFl+eKunE4buSTXQdPWuL1KEjQrvFHgk7TPJ3uMTTF+jgxG7p0YcTVxOp9KegIxbBzWS9Thg7lqHr+bQrD8XZp6YFAlNyrnXX74udfumMv13jv5ERDQ4DzIQdC5uwE1oAdQTleCWAu+pNXJWiffqeKX57E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744765701; c=relaxed/simple;
	bh=3HmtPQNozIuwYDhBJTfIyeNL126DKm7MX5GQHACXdUw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Hx11BnQS60ESvaPJARUsMEl7hzWXA6ShMGaTIQ7e8acZ/PVS6HdmoilfnHnIE+xMS9hiFFhfEoS+BLHbkGZZ69VLZ7LNQClkbadckjP+bzrpn1iynF6lmQwpDhEDj502P493mL1INEOeeAYBqPNKsXzcbkL3smOxTCCI+fcZr+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cfsrc/CH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cfsrc/CH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744765697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PnUD6o8LkfuSlz5weQQkvz1iOTi4TbDFUvt1UAY4edw=;
	b=cfsrc/CHkKDx2yqiE1Lp9X/iMJhP/5pDneVsYzPqUMUrSRlf0JNEvjpzH4XQ73S3ZevCWe
	9gjpZkWKOKBb6COshX9+GHCijDIPRa9XNQIYcJpeFnFJaSmy3Z9xQb4hV4WDmnaCSURjL6
	Wv/UGDxiMe1/jO6P4PpmfXVRsQB7qaA=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-36-lUa4yZQfN3a8sHTi486g5Q-1; Tue, 15 Apr 2025 21:08:15 -0400
X-MC-Unique: lUa4yZQfN3a8sHTi486g5Q-1
X-Mimecast-MFC-AGG-ID: lUa4yZQfN3a8sHTi486g5Q_1744765695
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-849d26dd331so21054139f.1
        for <linux-xfs@vger.kernel.org>; Tue, 15 Apr 2025 18:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744765695; x=1745370495;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PnUD6o8LkfuSlz5weQQkvz1iOTi4TbDFUvt1UAY4edw=;
        b=MpH3v5oW6mzw+589aEabmmiGiY6eS+wrtlV9hggfTS2hyGqkh9co6umRyW85d/QOe6
         JofVuyOhgsHxrfxnHJeScs3xP3hmj1NrojBOmtVIbz5OEBfO0q+F0zK5a7jzH/6iAKTD
         eqDdIWMIF+oWLk4u5fZMGjlZdm8BGdZ7l9tef2DcUtbn0EM2wAskmnhC9IiFMajowr6B
         5patxGEuvCzYo+p2drLCjBoF8RII+I3xgq8oPUrj3Gxhv5Jf1BAyexeWKT4TY9CkD+VC
         buHb3OXzbUMNmZDbOwH6oZvN9IQrnr5UpI3f+uZdOhsXYgOYdS5QDJTUxPnLv18zqlwr
         ZTTA==
X-Gm-Message-State: AOJu0YwtWuTcyQqSjEssnddS9bnqahMxZ9etUj1h1LzDFmYxm6PEPaaf
	hCoGAt/nsb7hqv0O5P/cc4l7Usk0J6jxnYBi7EvH833T1hH8B83z5g+IbeXkATEQ3W2/2dx9SFD
	/8ianSKSqGCry2GRXkQjzhL5K+UigThLz+9iYsZ8ItZSUj3J9vAwpFMY4Ag==
X-Gm-Gg: ASbGncvRzlJmnw/2mlOx30B1lJXFLxnUZDjrHIQPWc4UYCbwIDFOfMVquMawHxK8Z5T
	2qfKzsKrrQlf/VTqoylYoh7dY0MT4lhYp+wnkkHrjGFU6XcF8aHlJoCX35E1kSyxvufVvjYgV1/
	SFpVli6HtF8Kg4BCHg0/CS77Rtwn6Nvp4PTfuQnHDs1arKY6XcfNhF3Vx70XL+VGesHiw3PG0sj
	gMDGV5Ww6bdT4vaHqGHj+8GM9Vzo1qw9pJixZ5A/eAFooVoYoc+HbSpCbcCHegxfc8jzobpvFUP
	H4EMNxPUN8tSRfvZWLrt
X-Received: by 2002:a05:6602:4015:b0:85b:4cb9:5cf6 with SMTP id ca18e2360f4ac-861bf575e96mr187848539f.0.1744765694830;
        Tue, 15 Apr 2025 18:08:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmBbM7oGnkrU390jVkDSj1WU3WVXh2he4wCf1ddH+hgPZBq9yNUjrgkTQk+ItcOcm5czui6w==
X-Received: by 2002:a05:6602:4015:b0:85b:4cb9:5cf6 with SMTP id ca18e2360f4ac-861bf575e96mr187847139f.0.1744765694510;
        Tue, 15 Apr 2025 18:08:14 -0700 (PDT)
Received: from [10.0.0.82] ([65.128.104.55])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-861656e176csm278223839f.42.2025.04.15.18.08.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 18:08:14 -0700 (PDT)
Message-ID: <5c60155e-baa6-4a6c-a872-587397cf677a@redhat.com>
Date: Tue, 15 Apr 2025 20:08:12 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH GRUB] fs/xfs: fix large extent counters incompat feature
 support
From: Eric Sandeen <sandeen@redhat.com>
To: grub-devel@gnu.org
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 Anthony Iliopoulos <ailiop@suse.com>, Marta Lewandowska
 <mlewando@redhat.com>, Jon DeVree <nuxi@vault24.org>
References: <985816b8-35e6-4083-994f-ec9138bd35d2@redhat.com>
 <0e47cb04-542c-460a-a5b9-e9b0f3ef6c1f@redhat.com>
Content-Language: en-US
In-Reply-To: <0e47cb04-542c-460a-a5b9-e9b0f3ef6c1f@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Can I bribe someone to merge this fix, perhaps? ;)

On 3/27/25 2:48 PM, Eric Sandeen wrote:
> Grub folks, ping on this? It has 2 reviews and testing but I don't see it
> merged yet.
> 
> Thanks,
> -Eric
> 
> On 12/4/24 7:50 AM, Eric Sandeen wrote:
>> When large extent counter / NREXT64 support was added to grub, it missed
>> a couple of direct reads of nextents which need to be changed to the new
>> NREXT64-aware helper as well. Without this, we'll have mis-reads of some
>> directories with this feature enabled.
>>
>> (The large extent counter fix likely raced on merge with
>> 07318ee7e ("fs/xfs: Fix XFS directory extent parsing") which added the new
>> direct nextents reads just prior, causing this issue.)
>>
>> Fixes: aa7c1322671e ("fs/xfs: Add large extent counters incompat feature support")
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/grub-core/fs/xfs.c b/grub-core/fs/xfs.c
>> index 8e02ab4a3..92046f9bd 100644
>> --- a/grub-core/fs/xfs.c
>> +++ b/grub-core/fs/xfs.c
>> @@ -926,7 +926,7 @@ grub_xfs_iterate_dir (grub_fshelp_node_t dir,
>>  	     * Leaf and tail information are only in the data block if the number
>>  	     * of extents is 1.
>>  	     */
>> -	    if (dir->inode.nextents == grub_cpu_to_be32_compile_time (1))
>> +	    if (grub_xfs_get_inode_nextents(&dir->inode) == 1)
>>  	      {
>>  		struct grub_xfs_dirblock_tail *tail = grub_xfs_dir_tail (dir->data, dirblock);
>>  
>> @@ -980,7 +980,7 @@ grub_xfs_iterate_dir (grub_fshelp_node_t dir,
>>  		 * The expected number of directory entries is only tracked for the
>>  		 * single extent case.
>>  		 */
>> -		if (dir->inode.nextents == grub_cpu_to_be32_compile_time (1))
>> +		if (grub_xfs_get_inode_nextents(&dir->inode) == 1)
>>  		  {
>>  		    /* Check if last direntry in this block is reached. */
>>  		    entries--;
>>
>>
> 
> 

