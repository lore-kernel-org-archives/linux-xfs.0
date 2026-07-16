Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720B636D9FE
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 07:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784187872; cv=none; b=cwZtwa1aPhTl9pgl1FTZIMIgwGoGX1D3da/fomHQbKHFF+0hLITUY71qR7lUNaqXdmYec5CPEclmfsz5zfsvST6eJIRfAidR7+DMb/O6EgblxA1cPnwibzE61KGQRnNc6bY4FmiWmtsc9wuamS3FRtwg/aVTp+2d6fqTFa+YJb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784187872; c=relaxed/simple;
	bh=IR+jtVJX2scsq8jWmpB30Pz2CIoyk8jj/go5OrMLtq0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IFVoKBnras57pDMA2E0LLyGvVHCeS5awf0Y4ohlt5s2fUSoGFkjYVEIYyFmf+R8NidkThwkY6ETxuDckR5sW2HzHQrRjON/pqWzbq9EeomUqLWcRbUY1JKZP+nQuZrj9fINPrzfRzTk64mAypWsOPZTREBDSJipwVVZyMdeI1ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aZCw9Ek6; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aZCw9Ek6"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-495437bb891so1260985e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 00:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784187870; x=1784792670; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+HBEsx5T2h3R08SldZt1UnBFoW4+mtYHD4rZE3cOQZ0=;
        b=aZCw9Ek6GGEJPst20w+Eym5ayQucUy5ebo+1X11TYxYVDurQrcLYW9+plhjk0PPBLg
         L5bGKclg2OEorwCyPY6mzXBDVANjz6s5hpJPwZ+iADu07gQSPTgKFczdiGH4cDjOhxl/
         UjoSV1fF5E1coMCsSYYCxXuII9ioslC/PVYaFVgHnO0SrwPtCCLlXCb1eO1V622ktt/L
         z4vsoUcNbsQxxnk63py44xOEGmYk96DSU+GjVfTvN7TW6sETRLTmor4DIVtaoqSgL3on
         zfY2pHdJi4F2tdt+U9YsmiUPbs32cnwAPP5jrpvHe4MXNSossvB0s56RoKr2vKjXu4wk
         +30w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784187870; x=1784792670;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+HBEsx5T2h3R08SldZt1UnBFoW4+mtYHD4rZE3cOQZ0=;
        b=hwA7YWJi5i1x+Yoh68yYuqV3PMGYuEeSFFq6/VcPyAqfB4ABDgJAKcJEsqYolY8l8O
         zeNi6yEOag/bpqmy6byPxJk2C2ieyf+BspOxDTktjrGxegjAqBz8ngGuuGE6MFPfARWf
         ewP5EQVxY3wx+gt1ShgZGrgDSCehKqL+Wnd9JPphzgPOLsjWPlDekHEAfaqHMUXfOt+q
         TPptMIyLzQhLeGDu78GI3tp6xVt6XA5WFUfA0yyJad/5Gw9ATBgfr+tAHpmXBAP158NF
         o1vQYzOQ2bURP8grq+d/735omREMPLisczBDX9HEZy4ond6AryvdNyjbqC4Hs3uh/r8L
         RjfQ==
X-Gm-Message-State: AOJu0YwPd84eCNXDRWmKHY+Mk7tbWkYIpjNhKHpLaBKE3m/lJlUwVNAz
	J6igQVQExq9Q6H9wBPSQYPNI+GhMk1ijcaqRZALZLBtlzpRdzxoGmqFhzmp1YtLB/Y4=
X-Gm-Gg: AfdE7cneG2ZjNkhahLOUN0UzhWPIVy1bOO/g3/9kc+8XjhOkZO27GPklRlpyjrMomTf
	OqmlPpl4ESnmQznpUOLhAkvSRDyo4BtGauP5SxyvqPAqAcUO5/Bw2W2QxM3b6E2KJvIBF1/Pn3b
	yOQt/XLt7o4m33oDLhxLtXc9/UfZ4yzxBuYYDSqbZpui9MGnlWm3tcZ5FQn7B+RqtcWS3xSu3X4
	vEr4971izo3ngiLUO3xwa6IoDEHhZRwRTGdviUOOKuI8AfczhRhf+LeqJlUGMLqROoeTlZoRH1c
	mJ2OxzwpI1fF1Q6ZQnPjAaa+e7eFtnPWgEz+6b3FwmFCn/snRXsYvkZIo3Ww95HAJVYPixXLpxc
	Qhc4JDfZBZ638AoLwSOUk7xIDLT4YpBu8ehMnazt6/ZWxS4wDCln8QwSE9NYbVpR6HNixtqQ3xd
	AGgFf5UCf21maBec2f4v/bd8EFBKr38A==
X-Received: by 2002:a05:600c:8b78:b0:493:d117:18a8 with SMTP id 5b1f17b1804b1-4954288030fmr13903705e9.9.1784187869605;
        Thu, 16 Jul 2026 00:44:29 -0700 (PDT)
Received: from ?IPV6:2a07:b241:1004:8300::1000? ([2a07:b241:1004:8300::1000])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541e9a7bbsm38107655e9.13.2026.07.16.00.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 00:44:29 -0700 (PDT)
Message-ID: <3d71046a-2fab-4eab-8f0d-d97c3a5bab88@suse.com>
Date: Thu, 16 Jul 2026 09:44:28 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] libfrog: make cmn_err() emit each message atomically
 to avoid torn output
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, cem@kernel.org
References: <20260715173114.359368-1-avinesh.kumar@suse.com>
 <20260715190949.GP7380@frogsfrogsfrogs>
Content-Language: en-US
From: Avinesh Kumar <avinesh.kumar@suse.com>
In-Reply-To: <20260715190949.GP7380@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Darrick,


On 7/15/26 9:09 PM, Darrick J. Wong wrote:
> On Wed, Jul 15, 2026 at 07:28:21PM +0200, Avinesh Kumar wrote:
>> From: Avinesh Kumar <avinesh.kumar@suse.com>
>>
>> fstests xfs/033 fails sporadically with a spurious blank line in the
>> xfs_repair output:
>>
>> - output mismatch (see /opt/xfstests/results//xfs/033.out.bad)
>>      --- tests/xfs/033.out	2026-06-24 15:52:51.000000000 -0400
>>      +++ /opt/xfstests/results//xfs/033.out.bad	2026-07-14 18:54:46.582495041 -0400
>>      @@ -103,6 +103,7 @@
>>       Phase 3 - for each AG...
>>               - scan and clear agi unlinked lists...
>>               - process known inodes and perform inode discovery...
>>      +
>>       bad magic number 0xffff on inode INO
>>       bad version number 0xffffffff on inode INO
>>       inode identifier 18446744073709551615 mismatch on inode INO
>>
>> Root cause is in cmn_err() (libfrog/util.c), which emits a message
>> and its newline as two separate writes to unbuffered stderr.
>> xfs_repair's threads all share stderr. If one is preempted between the
>> two writes, another thread's line lands in between:
>>
>> (snips from `cat -A 033.raw`) -
>> Phase 3 - for each AG...$
>>          - scan and clear agi unlinked lists...$
>>          - process known inodes and perform inode discovery...$
>> Metadata corruption detected at 0x445dd3, xfs_inode block 0x80/0x4000        - agno = 0$
>> $
>> bad CRC for inode 128$
>> bad magic number 0x0 on inode 128$
>>
>> which should be like -
>>
>> Phase 3 - for each AG...$
>>          - scan and clear agi unlinked lists...$
>>          - process known inodes and perform inode discovery...$
>> Metadata corruption detected at 0x445dd3, xfs_inode block 0x80/0x4000$
>>          - agno = 0$
>> bad CRC for inode 130$
>> bad magic number 0x0 on inode 130$
>>
>> _filter_repair() strips the noise line it glued onto but not the lone
>> newline, which then fails the golden diff.
>>
>> Make the two writes atomic.
>>
>> Signed-off-by: Avinesh Kumar <avinesh.kumar@suse.com>
>> ---
>>
>> Hi, please give feedback if this should be fixed in a different way.
>> Thanks!
>>
>>   libfrog/util.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/libfrog/util.c b/libfrog/util.c
>> index 5bae5bab..3b6df917 100644
>> --- a/libfrog/util.c
>> +++ b/libfrog/util.c
>> @@ -116,8 +116,10 @@ cmn_err(int level, char *fmt, ...)
>>   	va_list	ap;
>>   
>>   	va_start(ap, fmt);
>> +	flockfile(stderr);
>>   	vfprintf(stderr, fmt, ap);
>>   	fputs("\n", stderr);
>> +	funlockfile(stderr);
> 
> I think do_error() in xfs_repair.c is going to need the same treatment
> but otherwise this chunk looks ok to me.
> 
Thanks for the review. I can send a follow up patch for do_error(),
or do you want these to go in the same patch?

Regards,
Avinesh

> --D
> 
>>   	va_end(ap);
>>   }
>>   
>> -- 
>> 2.55.0
>>
>>

