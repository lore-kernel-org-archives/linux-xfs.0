Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B9149E5EE
	for <linux-xfs@vger.kernel.org>; Mon,  5 Oct 2026 14:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791209580; cv=none; b=H+UWpQOLJ9yGvZE0fTvhdEd4d8Rv2rpFlXuVxwnBhZoeaJjgaTu3wItSnwLwycWXtBUCISsc6w5pZsDuWEJyjsBEfDCeQY1sIkWVAKR4GxLNaK/V1WWvkAmy14itSzOfINgptZMeoAUaoN2DIQqHEDuJ4V87LMKytn++uGnlH3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791209580; c=relaxed/simple;
	bh=JyJxjoJmcADIxqjCnqGI51oCW4MiJkgCsEAYAswXxdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mlnfx9rT+YBiJIDCHIzTnNqS3lvQPIZC5Wm70GTmwh30olnTW66StSw8AxFZ8PS5sjV8bmljHeVpdHwp2y3E0mZbb3XB7zbmbjAe/dCmfWhnwdoOpS6h9jrSQG8C7poUbNoPqfXtkD+o1wXQeO2ZpGckdEOPCNn2f6Fk2BYXY2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E2pWvef1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=t6nz2v6w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E2pWvef1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="t6nz2v6w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791209572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/r4TJZgGxUJi7gCuXt8KYeWx/eDdi2+KKOv3LyaR1RI=;
	b=E2pWvef1q1V0kznbROWAD+4MwmFAvB1aWb82KbwblPzaEgU9+6VAMpVLlUwDn0IALxFcyQ
	Ne+9gCOUI/9I+ATPXLZm3OZNMsV3axWeXdu0qFv7HBq0N/KW6l62Vjc+Al0BaD5WCCVdMo
	fsFGA7Nsfa6xEsXMVqS48MnmvoEPJSM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-Ds_XIl_uPPO8LOjhkdtSOg-1; Mon, 05 Oct 2026 10:12:50 -0400
X-MC-Unique: Ds_XIl_uPPO8LOjhkdtSOg-1
X-Mimecast-MFC-AGG-ID: Ds_XIl_uPPO8LOjhkdtSOg_1791209570
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-917b7dd3f1dso32455666d6.3
        for <linux-xfs@vger.kernel.org>; Mon, 05 Oct 2026 07:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1791209570; x=1791814370; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/r4TJZgGxUJi7gCuXt8KYeWx/eDdi2+KKOv3LyaR1RI=;
        b=t6nz2v6wbG5BLgqAM/cuUnlY9+xjev54y1T1/a04EFIZD+DwqLXbGDxC7txpQUIuRI
         z10fas1MUB4ClycVf5xOQwzqXQTM/zf8QdYS7bSwpd1PgUzDQaF6ZgU2ub2G5yz5amlO
         F03KNTt9EID4WTb5KsGQWFxm5iW6M/NJKoI710et8siNiEJpIxzEMxkoFlEm4ag4/5Jr
         6C/QVtl4cQIVcVY9YbNr/Ei3DDVRk9jft0C1+Yd0j++uXrssWZO4j/6JnBGprwN1Tsol
         wxDmjBiKqxGjErE3kMU8BMVgOvM+HsiS9eeP3EvrGni9rwBjj3G75S4d4KuPUr+p3zQq
         YxIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791209570; x=1791814370;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/r4TJZgGxUJi7gCuXt8KYeWx/eDdi2+KKOv3LyaR1RI=;
        b=A3YsjJ64HHtPlcqfKsMHQJSJfy/8zagaq3dAWdI3atdSDKtYhQY5nc5OGKpmeHLZR0
         jgs7nWu1YCkE72cyn5C6iz5K3IT/UZxEDXDEQXmykLHpZqkxWJ/hfWqC0f1OQyiHNjK2
         jsLytoQ44dioJjgTxHBSdPQaCWcuWr03tDwUaUpyVQ36G1ZaaaNo/Uvnoz+3xdxScLQM
         t4gEAQDvG807P0aAF3lepamtTi8Hyw4UYnmYMLAGrzeCRt8SCTxngY44B+oxbKJ9FvO9
         6n9UrbUZvxZ57DupW2ZngNRLFn9UMUkfsaTFbGTZYl4XC3sWQfeHNFLGTV3kAxHo4EJZ
         q13A==
X-Gm-Message-State: AFuF++kjoIOiE+pbNZCwMY1Jdk7QSqNJlgFq/xu9BXEhm+YTboJPXKlK
	4rgOSccnhk9ztBYT/I60Uw7IcWxmLoip/MF47BHwtLgk8lpYHgtpxPfD1UZSw+IvGPEu0epTxqL
	jFHSL+zaAGMcbP2VQ+54wih+O9GVR+kI2MMLpTIFzVaMhxXJPi2L0eis5MYgU5A==
X-Gm-Gg: AYBFou2sN6iEyHvpRt4qV348Z4HEHuUHRnYqjwyDueow2QrKQyus9iPgY00plRoZMIl
	o6KSISp+4n2iFC+0hlhzVSXw/LSowfMxVI35+5X5WCMj518wy7SWSeFJ6HLfii2wFvUbmQ3hIy2
	83k3dLnp/8XJHPrlvNdSnmTBzhyl0nSwBaSUCTyadFQWC9vD9C+h/W4170NVUqLA+bpPhhYR9fT
	b/OiHXzCenl2uMI/J8ZCKbS4yhdWex487oQ1H/ZPUBmB3pZoc2CS/Uvk4+qpp+oPT05Fxf2S+lr
	VAabND5udjYmFOYxyGtRr1ksUwFKtzaQXFslcKf2j9ZTC1l+D0uKSkS7Tu5SerFcy5sC5ifU8x4
	qc6UfY4xtuibCbxl5lUze1GAzD/sqmVaXGT5Q9Dofc5KePQ==
X-Received: by 2002:a05:620a:40d2:b0:93b:d7a2:dd2a with SMTP id af79cd13be357-93e510f55edmr1377496685a.58.1791209569901;
        Mon, 05 Oct 2026 07:12:49 -0700 (PDT)
X-Received: by 2002:a05:620a:40d2:b0:93b:d7a2:dd2a with SMTP id af79cd13be357-93e510f55edmr1377489585a.58.1791209569329;
        Mon, 05 Oct 2026 07:12:49 -0700 (PDT)
Received: from [10.0.0.209] (97-116-156-223.mpls.qwest.net. [97.116.156.223])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-917e0c3c3bcsm88127436d6.46.2026.10.05.07.12.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 07:12:48 -0700 (PDT)
Message-ID: <dc00c2d9-7752-42cf-a78f-5bbd814330c3@redhat.com>
Date: Mon, 5 Oct 2026 09:12:47 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] xfs: factor out xrep_reset_fork_to_extents helper for
 scrub/repair
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-3-sandeen@redhat.com>
 <asOXG8ePgukShDRq@nidhogg.toxiclabs.cc>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <asOXG8ePgukShDRq@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/5/26 8:07 AM, Carlos Maiolino wrote:
> On Fri, Oct 02, 2026 at 04:08:10PM -0500, Eric Sandeen wrote:
>> The open-coded 8-line series of steps to reset a fork to empty extents
>> format is repeated 3 times; factor this out into a helper to eliminate
>> cut and paste.
>>
>> +/* Discard the contents of this fork and initialize as empty extent-format. */
>> +void
>> +xrep_reset_fork_to_extents(
>> +	struct xfs_scrub	*sc,
>> +	int			whichfork)
>> +{
>> +	struct xfs_ifork	*ifp = xfs_ifork_ptr(sc->ip, whichfork);
>> +
>> +	xfs_idestroy_fork(ifp);
>> +	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
>> +	ifp->if_nextents = 0;
>> +	ifp->if_bytes = 0;
>> +	ifp->if_data = NULL;
>> +	ifp->if_height = 0;
>> +}
> 
> Why not also move xfs_trans_log_inode() here?
> Sure it will need to use a different flag depending on the fork type,
> but then the whole reset and log will be contained within there.
> 
Hm yeah, could do. I don't know if hiding the logging in the helper obfuscates
things or not. Any others have thoughts? (I can see if there's precedent for
whether logging should happen in the main flow or in a helper elsewhere, too.)

Thanks,
-Eric

