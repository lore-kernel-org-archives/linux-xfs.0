Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446283B9606
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 15:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770133404; cv=none; b=qGFHJxZT4Sr7A81Cnq8ZAfqjvEvVqKRAxonPbZ4CyfFaulgJ8sjrxfWl1Xy/+FwlSlcCnvKHCz0F85swLYt5P6qpxmpTLNUzjAjcQKngQ1FJu409VBZvEBGKRpuBPA16A04mNCqvFgc+J0XYWB3jn1P4kLNNz/nET2dD/61nkrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770133404; c=relaxed/simple;
	bh=xhDp7mfzOUqItr4fjWQ3P7OPqmrMXIBcJ5bvAe6AFZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mqyHnyVW2xuHdJuZGh0Ix6d4v2TD4r9xTf6PHjWH29a+UzS4NqiiJuq4/VsS+YmHT/9a67lNOmiyS0VbRP+s6DDnlNwOzIubp5r7nJv6mLak88prT6lVnfPBdZy29+5NlLWfj5iV2IDBIgtTO6JKWGoueF5TOkPi+szMmEHCXSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XmZ3ki4h; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XmZ3ki4h"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a102494058so4967745ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 03 Feb 2026 07:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770133402; x=1770738202; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3sXBIvtvsyfi0OGWmtiO87fapBJ+F72/kCPuAfqTDwI=;
        b=XmZ3ki4hhC2gH2NPmxlQN7Kj5Xrd6YOUiVggZn80jOFs2+Uy2KcFAOnM+qq3S479PY
         fqVKY+OGwOsHxun0zGq7oKAilprB39dv3lactqk80jvZbGQyRNBTfmjGclwDk2kU7qAM
         c9SuEoeU+ueiZsiWnGyrVfcyqmTsQn3QtGJID5EhmDo/i855xPhaT9ryPDooSy17nmzf
         8W4Hgwx7sDeZtVbmDlvHQ9o7im0idIAKthdfRukRq65yQCPbtRqgdCMp3KTJ2yN4KE4r
         8foYd3YMfMW+QUZ6J94cs2MW8PUXiT8xdwXfUEOjyPIjVsQu2Kw6hxnoe+STFIL3Fk4r
         scUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770133402; x=1770738202;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3sXBIvtvsyfi0OGWmtiO87fapBJ+F72/kCPuAfqTDwI=;
        b=kzQpJPe855lSmaP+8RRvj3F0ByefMY9UX7BKlDQ6IahA/lpzTTn7Fs+Lv1+iH7T/yl
         YBqx4XVoHIVfl3Ga4xNDLissGxF2Ry71OactdsMXLhfG7ixLtas+F0+oiCxuxYtiNuj7
         l+GrkjZp0mYIhC9l24rvWrnSIBgjw4vMNNHGmYPYxS2YtM+k1xXe1UWtjNAp2hbp+XwZ
         sOkpvwjfy4wu3j9hILdoxq+xxoT/sMsvbjUClw58saHkwzeunEUkkwRNtcJBEJ7CJf6S
         s85RZaF1OdfbQ9MtxF26f7IUHQl/ROKyj5EcKmz9poytFA3NTan7QKAX1qDPMSXUQmGc
         jq4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVR0Bu15tRX/p+acDbOh++asx/8gYPqvBX1GPWrppkWCHa5qqo6ABj7kurKgfHcLlxxOt3gHysnaXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzB9j3EKaxowYOhLtBN75JhqxYTw1L7/v+YHDuOrceS25RnsS2/
	n+cIjskq0mS8YH6ZD6qOdzUcrs7DkHonkt3hYbjqZtA0c23IAUFYrVEdjMsGqg==
X-Gm-Gg: AZuq6aKa+VLC+GsbKVtn1uskZATwQf3gAGSA15x/lSr+uLx2naVpQhnN/1eCErPNURq
	FHeEBK8PsuDK04jjGxpwspZzNJqHlebIZSoJcFWtGPuL+f6tIhD/2ksH0sU1alft0PI4jlU7QuQ
	my867Wl2fzWaDT+b268cYs7HwvXWa/17DZ23fK/kAlOES8w53Tfr29J1kJDt8jIijlK4vqrqL/g
	0xin+ZA41lz73VCF7aXkAlJ87dVKrxlePL8Mb+qwlYePSVGW+4csxd3DD1gSB0UhERdFYX9f30s
	NiBSQtrpQrfDuLD2KSGWI456HRvR2bHIbPy7GLua94yXEY24hvdyzS4wfeHK6ultiDMMTeaQcCX
	BpfaaKQ58iNRcnDMzaMYl8luO6PeBy2uK8nXcMZVqyFUzA8kRIZ4m2kK9BW8nH1Qa6kCNTBqB6J
	vVr7bxh39n5komgy61GKAtKg==
X-Received: by 2002:a17:903:2f4d:b0:2a0:99f7:67b4 with SMTP id d9443c01a7336-2a9245b9468mr33628135ad.8.1770133402385;
        Tue, 03 Feb 2026 07:43:22 -0800 (PST)
Received: from [192.168.0.120] ([49.207.208.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379bfd729sm18282898b3a.44.2026.02.03.07.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Feb 2026 07:43:22 -0800 (PST)
Message-ID: <5b424a45-f385-45b9-a605-dede57ecfc19@gmail.com>
Date: Tue, 3 Feb 2026 21:13:17 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch v3 2/2] xfs: Fix in xfs_rtalloc_query_range()
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@infradead.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1770121544.git.nirjhar.roy.lists@gmail.com>
 <40bb6291838c95582ae967f3e35980923129d7b7.1770121545.git.nirjhar.roy.lists@gmail.com>
 <20260203153453.GN7712@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20260203153453.GN7712@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/3/26 21:04, Darrick J. Wong wrote:
> On Tue, Feb 03, 2026 at 08:24:29PM +0530, Nirjhar Roy (IBM) wrote:
>> xfs_rtalloc_query_range() should not return 0 by doing a NOP when
>> start == end i.e, when the rtgroup size is 1. This causes incorrect
>> calculation of free rtextents i.e, the count is reduced by 1 since
>> the last rtgroup's rtextent count is not taken and hence xfs_scrub
>> throws false summary counter report (from xchk_fscounters()).
>>
>> A simple way to reproduce the above bug:
>>
>> $ mkfs.xfs -f -m metadir=1 \
>> 	-r rtdev=/dev/loop2,extsize=4096,rgcount=4,size=1G \
>> 	-d size=1G /dev/loop1
>> meta-data=/dev/loop1             isize=512    agcount=4, agsize=65536 blks
>>           =                       sectsz=512   attr=2, projid32bit=1
>>           =                       crc=1        finobt=1, sparse=1, rmapbt=1
>>           =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
>>           =                       exchange=1   metadir=1
>> data     =                       bsize=4096   blocks=262144, imaxpct=25
>>           =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
>> log      =internal log           bsize=4096   blocks=16384, version=2
>>           =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =/dev/loop2             extsz=4096   blocks=262144, rtextents=262144
>>           =                       rgcount=4    rgsize=65536 extents
>>           =                       zoned=0      start=0 reserved=0
>> Discarding blocks...Done.
>> Discarding blocks...Done.
>> $ mount -o rtdev=/dev/loop2 /dev/loop1 /mnt1/scratch
>> $ xfs_growfs -R $(( 65536 * 4 + 1 ))  /mnt1/scratch
>> meta-data=/dev/loop1             isize=512    agcount=4, agsize=65536 blks
>>           =                       sectsz=512   attr=2, projid32bit=1
>>           =                       crc=1        finobt=1, sparse=1, rmapbt=1
>>           =                       reflink=0    bigtime=1 inobtcount=1 nrext64=1
>>           =                       exchange=1   metadir=1
>> data     =                       bsize=4096   blocks=262144, imaxpct=25
>>           =                       sunit=0      swidth=0 blks
>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1, parent=0
>> log      =internal log           bsize=4096   blocks=16384, version=2
>>           =                       sectsz=512   sunit=0 blks, lazy-count=1
>> realtime =/dev/loop2             extsz=4096   blocks=262144, rtextents=262144
>>           =                       rgcount=4    rgsize=65536 extents
>>           =                       zoned=0      start=0 reserved=0
>> calling xfsctl with in.newblocks = 262145
>> realtime blocks changed from 262144 to 262145
>> $ xfs_scrub -n   -v /mnt1/scratch
>> Phase 1: Find filesystem geometry.
>> /mnt1/scratch: using 2 threads to scrub.
>> Phase 2: Check internal metadata.
>> Corruption: rtgroup 4 realtime summary: Repairs are required.
>> Phase 3: Scan all inodes.
>> Phase 5: Check directory tree.
>> Info: /mnt1/scratch: Filesystem has errors, skipping connectivity checks.
>> Phase 7: Check summary counters.
>> Corruption: filesystem summary counters: Repairs are required.
>> 125.0MiB data used;  8.0KiB realtime data used;  15 inodes used.
>> 64.3MiB data found; 4.0KiB realtime data found; 18 inodes found.
>> 18 inodes counted; 18 inodes checked.
>> Phase 8: Trim filesystem storage.
>> /mnt1/scratch: corruptions found: 2
>> /mnt1/scratch: Re-run xfs_scrub without -n.
>>
>> Cc: <stable@vger.kernel.org> # v6.13
>> Fixes: e3088ae2dcae3c ("xfs: move RT bitmap and summary information to the rtgroup")
>>
>> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Nit: no blank lines between Fixes: and the first Reviewed-by:.
>
> Some peoples' commit scanning scripts only look for git trailers from
> the end of the commit message backwards to the first blank line.

Noted. I will fix this. Thank you.

--NR

>
> --D
>
>> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
>> Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
>> ---
>>   fs/xfs/libxfs/xfs_rtbitmap.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
>> index 618061d898d4..8f552129ffcc 100644
>> --- a/fs/xfs/libxfs/xfs_rtbitmap.c
>> +++ b/fs/xfs/libxfs/xfs_rtbitmap.c
>> @@ -1170,7 +1170,7 @@ xfs_rtalloc_query_range(
>>   
>>   	if (start > end)
>>   		return -EINVAL;
>> -	if (start == end || start >= rtg->rtg_extents)
>> +	if (start >= rtg->rtg_extents)
>>   		return 0;
>>   
>>   	end = min(end, rtg->rtg_extents - 1);
>> -- 
>> 2.43.5
>>
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

