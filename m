Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A752EE5E1
	for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 09:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755767821; cv=none; b=eAuQB9iL3OA2QrMLs27/0/wWpzdlQqDUDD3gTFwwEQYFSiG2OhcaKYMTm4QOi/APhxavcmiUEJ2cXUcjBjtt2aFJZhpsCur5SXWJugc/is3WGb1K/KZuml5qyy2/HjSPRB5V9sv4vAyFV8rAxQpOuu6sBfW9Pyjyirfaol28RLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755767821; c=relaxed/simple;
	bh=XT04g/WAWbfvAnOtNlzZVog09LFxLejry5gXzUyCcRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UP5CeMgHFrriylwcRlzoioGLHS1xweYTC+O8Edyp7AwG9RN2n57R9DJbt5RBNN4n1dsSTkvfBF0UwccICRwG2SeuohrA4MRPG8JGuwg8Ta4lpYptMl7/n1RCf3elw6UX5K3E8x5LISbQsepzNabKnRMaj69NtdBD0W7ETxAy0k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hPH0DtWV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hPH0DtWV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755767819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=seGpHBa2/yFpud2kL4m6Vf0sOQ/ckvuHb7fq5t3V+L4=;
	b=hPH0DtWVOXp344JYJ956PHzTuU/q419WTvyBo2Qj2cOFdzYTDpaM0MFe8pR+psvPjLC353
	r7MNIbtKVES0RRVWf1GbmcDzgsV1vgT09SWlbw1bJX5nJ5pdZ3QLiNoJJmXq/U8YcivMvD
	sWTwyLH6A4QucwSau2k0TZ2QJIGEb84=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-3-VFwPIXEROvq3VTVNpMX7uA-1; Thu, 21 Aug 2025 05:16:56 -0400
X-MC-Unique: VFwPIXEROvq3VTVNpMX7uA-1
X-Mimecast-MFC-AGG-ID: VFwPIXEROvq3VTVNpMX7uA_1755767815
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b4704f9dfc0so1720567a12.0
        for <linux-xfs@vger.kernel.org>; Thu, 21 Aug 2025 02:16:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755767815; x=1756372615;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=seGpHBa2/yFpud2kL4m6Vf0sOQ/ckvuHb7fq5t3V+L4=;
        b=Wqum1tVGi4kXjhzfQ3Px5AZYi5OSv2tXLzQC1dg1rO4FmFb2oWaxhlFahzjz6fdMO+
         QwzZu5qBDV2FWBeC6Efsinvi2CVw+6Fu6gGFXyiKZemSaBxSoYYRGP0SKiN3/4EpUu94
         3hvUYSm8CR3vR+iDHS9CuRihgJAKThmPMNq4aYg62n79KAu21HKOWIUIJGaX51Z++AcT
         Rx93Bh+Y4QEOLTqPBtbHEvbWWyaOH61jAUEOZ0bY3iKPswfjUfAunD9XH4Vo+LOjMq1X
         LVyMkkJZIWDfHwfsXHdyBoECQzk9y8wVmpMRU8hFXSTewHKlkNfZ+0WwWUwQrdPmRFKO
         UDOQ==
X-Gm-Message-State: AOJu0Yw/84llm8WR82+ypPwtQkW7N7S+0Vs9hsQheebLubWNs3ZjTE97
	d1/Y3xTDeOiSwN2lAtc7PV2UZ3YCYpWudSuUEkw3r1CqQscNB0piGUTpVdRaiCCiYvK3Rdp/sRu
	/aee2zIjwcXwoh9sEXBeybjL6K2ap/m8F95cohMPwFdb3SQxB6aBj5mnVkLMnC2kcCCvwPw==
X-Gm-Gg: ASbGncsl5BcAA2+rmXovAKcTkycjAnm9Yzi6NhPtds8KwpUbIlF9hOPE0NPIyymJ41v
	DYLvzaPviaZXWxrfEnnLbY3lBDDAiglJhgzzkjX0rgb/OmrEhtNBoXJ89lheQ3js+wQQN/GSnjW
	+Oc06AwdBjldWKdSGFhG4aGYsqPy6olIv+c7mAEQGFcvWLztOkItG0tzK7Pw5nZyVXZRA3lZvHe
	njPi471GuuREXGbxVspgKYkFGHpmgqC575AGW1VDY275vd3P5WPhRD591Wx/LA2xXRHdZg/jn9Q
	ftzI0gI7Sz9Iqxfy17Eov5Ci3AoxiVu57e9Cs1sEMQQG9h5rGo1wgP5DNWg9Vx0nulZ1FnhOuIn
	Z9uInxQ7NSps=
X-Received: by 2002:a17:903:2303:b0:240:3dfd:99a2 with SMTP id d9443c01a7336-246023c7a29mr20808785ad.10.1755767814828;
        Thu, 21 Aug 2025 02:16:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZxfBn0vRuI52H5n2exsbSbWzGg4FOsNBH51E4lavSDWnsY0d+MuR0KaZUZ6hEjV5FiUQWvw==
X-Received: by 2002:a17:903:2303:b0:240:3dfd:99a2 with SMTP id d9443c01a7336-246023c7a29mr20807705ad.10.1755767812860;
        Thu, 21 Aug 2025 02:16:52 -0700 (PDT)
Received: from ?IPV6:2001:8003:4a36:e700:8cd:5151:364a:2095? ([2001:8003:4a36:e700:8cd:5151:364a:2095])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b476408fed8sm4278920a12.36.2025.08.21.02.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 02:16:52 -0700 (PDT)
Message-ID: <85ac8fbf-2d12-4b2e-9bfa-010867a91ecd@redhat.com>
Date: Thu, 21 Aug 2025 19:16:49 +1000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] xfs: remap block layer ENODATA read errors to EIO
To: "Darrick J. Wong" <djwong@kernel.org>, Eric Sandeen <sandeen@redhat.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <1bd13475-3154-4ab4-8930-2c8cdc295829@redhat.com>
 <20250818204533.GV7965@frogsfrogsfrogs>
Content-Language: en-US
From: Donald Douwsma <ddouwsma@redhat.com>
In-Reply-To: <20250818204533.GV7965@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 19/8/25 06:45, Darrick J. Wong wrote:
> On Mon, Aug 18, 2025 at 03:22:02PM -0500, Eric Sandeen wrote:
>> We had a report that a failing scsi disk was oopsing XFS when an xattr
>> read encountered a media error. This is because the media error returned
>> -ENODATA, which we map in xattr code to -ENOATTR and treat specially.
>>
>> In this particular case, it looked like:
>>
>> xfs_attr_leaf_get()
>> 	error = xfs_attr_leaf_hasname(args, &bp);
>> 	// here bp is NULL, error == -ENODATA from disk failure
>> 	// but we define ENOATTR as ENODATA, so ...
>> 	if (error == -ENOATTR)  {
>> 		// whoops, surprise! bp is NULL, OOPS here
>> 		xfs_trans_brelse(args->trans, bp);
>> 		return error;
>> 	} ...
>>
>> To avoid whack-a-mole "test for null bp" or "which -ENODATA do we really
>> mean in this function?" throughout the xattr code, my first thought is
>> that we should simply map -ENODATA in lower level read functions back to
>> -EIO, which is unambiguous, even if we lose the nuance of the underlying
>> error code. (The block device probably already squawked.) Thoughts?
> 
> Uhhhh where does this ENODATA come from?  Is it the block layer?
> 
> $ git grep -w ENODATA block/
> block/blk-core.c:146:   [BLK_STS_MEDIUM]        = { -ENODATA,   "critical medium" },
> 

I had been working on a test case for this based on dmerror, but It
never successfully triggered this, since dmerror returned EIO.

At least it didn't until Eric got creative mapping the the error back to
ENODATA.

I'll was in the process of turning this into an xfstest based on your
tests/xfs/556, I'll reply here with it in case its useful to anyone, but
it would need to be modified to somehow inject ENODATA into the return
path.

Don



It should work with a systemtap to map the error, though I think Eric 
was considering alternatives.





