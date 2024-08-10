Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA5414B090;
	Sat, 10 Aug 2024 08:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723278586; cv=none; b=kblH26VwVkVS35wD2nrlYQVCCDj6bnjvtoKnPFa+29FKqZkEBukVRbToBi7qvHxvlTXaPxRSxwZEBOr4F6Mv2/BS/IBgU/VVL8sUzujo2w0gJAbiGDTX3TGFcux49MywFtGR1h/hWNCHFaJAKFkv/d7WZx0ZKRxx6bE6KRq+1AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723278586; c=relaxed/simple;
	bh=+U/WSWoZiq1NNzQuvc0HgFuRNc2G7WpQvVR3KrAg8Hs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bdrN2c+KUvFu6AV9o/ErYvzWyiXNNE9t8L8aQVeujykfXTmONhnMw3FQ2o+kp9O62+wiOlRGrtsfPMoC4OvIRC/WCfHgo+/QyGSUZCbCCgBvtSJr5pNa0oGbqmQlOKAWZ1zG7AmybQSkHY5Y2gZBNvQafxHrTQRA2mOJFUnvCHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fdo3H4Zi; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fdo3H4Zi"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52f01b8738dso2506202e87.1;
        Sat, 10 Aug 2024 01:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723278583; x=1723883383; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YeCuEGx9luAQ2+Oji6MqCQGLfxWCFImTTTV2T41ZgRY=;
        b=fdo3H4Zi889hAzJxVkUISYDaVOqVT2qTm7CntDkpJBiJ2MunaETy/9fWFgcpNx8ZLr
         bzouM6DittwEOtH58oEyzqbfPs+tvHMioHmCAtDQZ9cOA2GWPRzt/boOs/hffU1xZ5p3
         ohcqRGTlwIPYV0txK6zvhfxeOAq8PxG42QPm3/LA6QrKpkLCG7SKqyFIbg3AHFXbK45X
         juVNRwX/A0EJ0tZjQiABT43qWH5YEqkWI+0lfvzKYI5YaLRIHWNNMxMvlLXOdwOMYyYM
         OwH5vtm2S0t/zjtR8MpMUk04nI0+g4b2WptSDBnVdO2fEtbAIFp8nFfYUCb/BkfIaeA/
         CrwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723278583; x=1723883383;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YeCuEGx9luAQ2+Oji6MqCQGLfxWCFImTTTV2T41ZgRY=;
        b=Ht7ffBFbmUJ50InYWxK1uGhLepEinnLIBSlEN5qCQxQwE6CJuLK9n03+LHup1AFmAs
         gq/p+nMb+Wa7RHIcOKQJAuudlugj52CwzDJxVjubQ4XO3ukWyeQPB9Mdl+kNa0OkuzOi
         q8WkIieLnkZlfLDzkQeaY06CAuvrQUHBUv6SgmSxZeu/xlYjbfGntOagytpoqQeEoQ9W
         yY7/R/lauQVN2Dce69TsWMN3nwG+zH6BximIKQDxsCCrTsGzvcyavySRh2oyyrV+uohT
         eMVgEkXU3QhhgDdjF4fUx71Y6ADGYiLztQW73qHPdcrbWiYvTiOwI4ZALGZIUAdcpYlQ
         XfhA==
X-Forwarded-Encrypted: i=1; AJvYcCW9w9txDsFYokN7jqKiXpZl66LXk/XawkYtan2X3TbiUAQ9/xSMuKawIz+LnIZyPO1IzMZbLLkUNjoL9hv/rHY3Od90y/5XD4MU5CSy
X-Gm-Message-State: AOJu0YzAhmUjMlPfQVgcuHUbg4Je9vGrW8yIUIZIjUq9RJGus36clEdn
	BJQANs1UlOotxKb6mPs45zmHmtECvnbQ8QVqyyzc8weHjIapB1FvBWcEkYi7
X-Google-Smtp-Source: AGHT+IEggfPN1vpAkp1UUJNnkvfUddZErKWbv9eoFdy7YFz5CcS1LQPJJ3y9I9mzmTWhnHYifmZYBA==
X-Received: by 2002:a05:6512:108d:b0:52c:e00c:d3a9 with SMTP id 2adb3069b0e04-530ee96c74cmr2789858e87.1.1723278582755;
        Sat, 10 Aug 2024 01:29:42 -0700 (PDT)
Received: from ?IPV6:2a00:801:56b:e722:f008:fe67:227a:e9f4? ([2a00:801:56b:e722:f008:fe67:227a:e9f4])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-53200f42271sm152991e87.255.2024.08.10.01.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Aug 2024 01:29:42 -0700 (PDT)
Message-ID: <252d91e2-282e-4af4-b99b-3b8147d98bc3@gmail.com>
Date: Sat, 10 Aug 2024 10:29:38 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: XFS mount timeout in linux-6.9.11
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Chandan Babu R <chandan.babu@oracle.com>, "Darrick J. Wong"
 <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <71864473-f0f7-41c3-95f2-c78f6edcfab9@gmail.com>
 <ZraeRdPmGXpbRM7V@dread.disaster.area>
Content-Language: en-US
From: Anders Blomdell <anders.blomdell@gmail.com>
In-Reply-To: <ZraeRdPmGXpbRM7V@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2024-08-10 00:55, Dave Chinner wrote:
> On Fri, Aug 09, 2024 at 07:08:41PM +0200, Anders Blomdell wrote:
>> With a filesystem that contains a very large amount of hardlinks
>> the time to mount the filesystem skyrockets to around 15 minutes
>> on 6.9.11-200.fc40.x86_64 as compared to around 1 second on
>> 6.8.10-300.fc40.x86_64,
> 
> That sounds like the filesystem is not being cleanly unmounted on
> 6.9.11-200.fc40.x86_64 and so is having to run log recovery on the
> next mount and so is recovering lots of hardlink operations that
> weren't written back at unmount.
> 
> Hence this smells like an unmount or OS shutdown process issue, not
> a mount issue. e.g. if something in the shutdown scripts hangs,
> systemd may time out the shutdown and power off/reboot the machine
> wihtout completing the full shutdown process. The result of this is
> the filesystem has to perform recovery on the next mount and so you
> see a long mount time because of some other unrelated issue.
> 
> What is the dmesg output for the mount operations? That will tell us
> if journal recovery is the difference for certain.  Have you also
> checked to see what is happening in the shutdown/unmount process
> before the long mount times occur?
echo $(uname -r) $(date +%H:%M:%S) > /dev/kmsg
mount /dev/vg1/test /test
echo $(uname -r) $(date +%H:%M:%S) > /dev/kmsg
umount /test
echo $(uname -r) $(date +%H:%M:%S) > /dev/kmsg
mount /dev/vg1/test /test
echo $(uname -r) $(date +%H:%M:%S) > /dev/kmsg

[55581.470484] 6.8.0-rc4-00129-g14dd46cf31f4 09:17:20
[55581.492733] XFS (dm-7): Mounting V5 Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
[56048.292804] XFS (dm-7): Ending clean mount
[56516.433008] 6.8.0-rc4-00129-g14dd46cf31f4 09:32:55
[56516.434695] XFS (dm-7): Unmounting Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
[56516.925145] 6.8.0-rc4-00129-g14dd46cf31f4 09:32:56
[56517.039873] XFS (dm-7): Mounting V5 Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
[56986.017144] XFS (dm-7): Ending clean mount
[57454.876371] 6.8.0-rc4-00129-g14dd46cf31f4 09:48:34

And rebooting to the kernel before the offending commit:

[   60.177951] 6.8.0-rc4-00128-g8541a7d9da2d 10:23:00
[   61.009283] SGI XFS with ACLs, security attributes, realtime, scrub, quota, no debug enabled
[   61.017422] XFS (dm-7): Mounting V5 Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
[   61.351100] XFS (dm-7): Ending clean mount
[   61.366359] 6.8.0-rc4-00128-g8541a7d9da2d 10:23:01
[   61.367673] XFS (dm-7): Unmounting Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
[   61.444552] 6.8.0-rc4-00128-g8541a7d9da2d 10:23:01
[   61.459358] XFS (dm-7): Mounting V5 Filesystem e2159bbc-18fb-4d4b-a6c5-14c97b8e5380
[   61.513938] XFS (dm-7): Ending clean mount
[   61.524056] 6.8.0-rc4-00128-g8541a7d9da2d 10:23:01


> 
>> this of course makes booting drop
>> into emergency mode if the filesystem is in /etc/fstab. A git bisect
>> nails the offending commit as 14dd46cf31f4aaffcf26b00de9af39d01ec8d547.
> 
> Commit 14dd46cf31f4 ("xfs: split xfs_inobt_init_cursor") doesn't
> seem like a candidate for any sort of change of behaviour. It's just
> a refactoring patch that doesn't change any behaviour at all. 
> Are you sure the reproducer you used for the bisect is reliable?
Yes.

>> The filesystem is a collection of daily snapshots of a live filesystem
>> collected over a number of years, organized as a storage of unique files,
>> that are reflinked to inodes that contain the actual {owner,group,permission,
>> mtime}, and these inodes are hardlinked into the daily snapshot trees.
> 
> So it's reflinks and hardlinks. Recovering a reflink takes a lot
> more CPU time and journal traffic than recovering a hardlink, so
> that will also be a contributing factor.
> 
>> The numbers for the filesystem are:
>>
>>    Total file size:           3.6e+12 bytes
> 
> 3.6TB, not a large data set by any measurement.
> 
>>    Unique files:             12.4e+06
> 
> 12M files, not a lot.
> 
>>    Reflink inodes:           18.6e+06
> 
> 18M inodes with shared extents, not a huge number, either.
> 
>>    Hardlinks:                15.7e+09
> 
> Ok, 15.7 billion hardlinks is a *lot*.
:-)
> 
> And by a lot, I mean that's the largest number of hardlinks in an
> XFS filesystem I've personally ever heard about in 20 years.
Glad to be of service.

> 
> As a warning: hope like hell you never have a disaster with that
> storage and need to run xfs_repair on that filesystem. It you don't
> have many, many TBs of RAM, just checking the hardlinks resolve
> correctly could take billions of IOs...
I hope so as well :-), but it is not a critical system (used for testing
and statistics, will take about a month to rebuild though :-/).

> 
> -Dave.
