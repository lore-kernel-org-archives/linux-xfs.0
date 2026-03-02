Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7EA368287
	for <linux-xfs@vger.kernel.org>; Mon,  2 Mar 2026 13:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772458224; cv=none; b=rYn4yqvmOwtcmOlN401zaCF4Jr5QwDL8y4SonvHtDxkax74aTVPP3SPi1tDh12ZeGsTAHPMk6yf5WwetcBHXA7l0Tbqjtqsxug7cZsQyhXLeq75bRWyMiIegsvge186t62rUKaBYKuGo9rjehA1QT8vmLH86NKpC0DLjkhnU8WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772458224; c=relaxed/simple;
	bh=Rq7RfAq1tZwnyavsjnkK9wmAf48OHY+TrmeBnY75gVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VyfKrLeVmpo/JUacEdTMD5tDH47iJ7cc9gcHAr6axJXPyfNeMNZxR8mTCVI0whi123lKghhZAbHUZ4SjYx0K6GV5lwCtLiYBtjsHEFqEztGMk4y57TuFqXbh/UxGq4iDkMVlqmb0LjL+oMzzUeHC2Psd1V2+9WGkDcXiRb183m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QliuqGlh; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QliuqGlh"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ad21f437eeso33027135ad.0
        for <linux-xfs@vger.kernel.org>; Mon, 02 Mar 2026 05:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772458220; x=1773063020; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s24i19n8lKIqVIDIL0pIocUyXuHdTYTMYpJQeikEDx4=;
        b=QliuqGlhM72zAOFK2QwkQ1LbtSPrJdHcPPOCXJYqpUcpGXOCZJcRCbvBWdT8BUuq3v
         bUQx6IaUTLOfZeUkEgGSzREw56LuGVkdDUwOhkjPuEjO87GZNWEXTGzcm3FqJzUTSiEB
         hSUzGmc+N18g9cpKr86DaCf6/gLVfR1syAwTeH7odxYnUIQD0w6zQk9zKAyqNX7VGnS1
         6j+jhjCCLv7Z351U9BAWsWqYhNZoigqcOVIp0LO6probde+f95GaH8BF+NiVK06ulphS
         C2A+A6+ix2/DRDb63ftTR1A7znyW5Dej6xPIVEmaTGIivy8k+zZOTtowp3XM6wYdW+4Q
         kGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772458220; x=1773063020;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s24i19n8lKIqVIDIL0pIocUyXuHdTYTMYpJQeikEDx4=;
        b=PDUpB7QrttXDQZ0nL0l1aBtoyl/ONN7oYYn14RLH3KuffZsdS2CIexKQm9Hb8NfqrI
         je/ZTiOAgBQ8/vPLr9/erXWx7OnWOS5bmp1FF89jvN6oSj3fk1pnnppLeGxc619x/m2+
         atYKyD/D8Hl993Jv6t7pCqXp3ck2yCfaHeipZcew1sTvuX9bBQHYJyyBvD+ZKGs7M4qK
         luFtvYNVGR1Al5tZRrPCy1iQDmtdMx7D+0O92CB7BVZ1IggMXu5EEzcIcxtpoo4n8z4+
         R34EDLwIbgKX5ygz9t7QOk0jbrtdJ5rjy1WR1zpZkcICDbYt2IaH7rZEjuhUHT3/xVeZ
         H5vA==
X-Forwarded-Encrypted: i=1; AJvYcCWwAWWPtonLh6H2JoJ2RDWQJiV5V8WCpy+m2GF57+ePnL6xzZfFOtF60QShOs5QxkDTiKHEhbcOvp4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK3nYJOlXtLxCo4y3T2o9SlzTUQxUsFosGy/Qqx0Fr3fJmWOH+
	gYk7V6QfbmMrqZzc8IuiFym4ppbdskgtx3YyqYuwPBE5Q4Shfu62KXLR
X-Gm-Gg: ATEYQzxGuYMF9YSCWDOcygCyanY6cT/1TPMA7CNtkW8g3crTsCXWte3Y4DXohHAjFVT
	dOr6+w3zHp1ham6epFRulsFi99jjHP++Oq6oYX3Nl/bf/wtaF0dPyBW1qHx52fpo7jYATyiS4wF
	7V8a8KXbN3P+3gXbrzkaSqnf4dty6UWNiXMngzs8bK6w8FJhtip0vtvOXPEOIZHajkTMR2YXzIw
	itscV9As8eCCKdT+fIJlxdaXgOxwd0V6vbYMEFxIcwzmQWJazcxuqkSNCyOebuJUjJcRbo01nWQ
	upZSwu1mALo2c9b2yZGktcaleDQpGZb8bs4x80zdosAs+FlGGgei97yaHrZpH+9KsP3FsAItRid
	ipFBlTt0myaKJ7q1TD4Kh1THZkXR1ILGJ3zG7wZTSrApRVEhxbH6qFGC2niNiu5NNr8RW6aZc5P
	go/QcRu5afMKLdIVBTuCv1cM7bOyfYLrJT6j+/ug==
X-Received: by 2002:a17:903:19cf:b0:2ae:4ad5:b76c with SMTP id d9443c01a7336-2ae4ad5ba05mr48823935ad.10.1772458220205;
        Mon, 02 Mar 2026 05:30:20 -0800 (PST)
Received: from [192.168.50.90] ([116.87.14.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae45b5201fsm55018345ad.87.2026.03.02.05.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 05:30:19 -0800 (PST)
Message-ID: <cb136241-ca7f-4c64-a6b3-3f86688240f3@gmail.com>
Date: Mon, 2 Mar 2026 21:30:17 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] fstests: verify fanotify isolation on cloned
 filesystems
To: Amir Goldstein <amir73il@gmail.com>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 Jan Kara <jack@suse.cz>
References: <cover.1772095513.git.asj@kernel.org>
 <b54dea5e72585db5f5c3d74ce399f9d839965821.1772095513.git.asj@kernel.org>
 <aaQ8CB7C4FjDuedR@amir-ThinkPad-T480>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <aaQ8CB7C4FjDuedR@amir-ThinkPad-T480>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


>> diff --git a/src/Makefile b/src/Makefile
>> index d0a4106e6be8..ff71cde936a7 100644
>> --- a/src/Makefile
>> +++ b/src/Makefile
>> @@ -36,7 +36,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
>>  	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
>>  	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
>>  	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
>> -	rw_hint
>> +	rw_hint fanotify
> 
> Check if you already have fsnotifywait installed on your system
> most likely you do. It was added to inotify-tools quite some time ago.
> Could save you from adding a custom prog.
> Not 100% sure about fsnotifywait, but quite sure that
> fsnotifywatch --verbose prints the FSID of events.
> 

I missed that command. V2 switched to using fsnotifywait.
V2 is not sent yet, I'll wait for any further comments.

Thanks for the review.

Anand

> Thanks,
> Amir.
