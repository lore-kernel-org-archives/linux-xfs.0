Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9732C236B
	for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 22:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765407082; cv=none; b=d3euaxO585MgHbQvGvJbJizsT824ygQLhO/NywgTK04LVRC0n8/J0VTBx1WlU0hZDWBXoXesTXhSYVCWe3e8b6fMxuWT0lPKCaVaSw4FmYDfKGeCtGG04rw/462xA9Ht86Zlymaf8m8d/KcBApROS5hkgK9/xWVwnGGYhbeLW5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765407082; c=relaxed/simple;
	bh=exJHbaxdK/MsRM048rGe5MokmGXSEZZ4zaAYw06cZG8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XThVgd3a1hxoJFCUgK4GgYO2RVB4dg0k69FgiAwX2GOKPDz10uCspkYqZrsf7d3H6DzaElxtaN+TfZXMmFqmWyovXsJPTYd15agbIS85RfcBEIW5cMx3R9JEcZZPP4NK0sYPcplI8SBl2xEn3gf4hSJGZCflqIEk3oRQXm+Q988=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H+/gJoER; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nRrxzWz2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H+/gJoER";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nRrxzWz2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765407080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sfGt0kZTy1oSWc/9yXuGuY0HC5OpMM6HjYeYgFfHkes=;
	b=H+/gJoER+I7avCAtNTMo+0I0Iac9kuIdeSv24xcTvWBcWVxMKeW2Kf2OCsMEJ6IbDf0k1I
	s8/vpZ5Pw7zZHS7OaU2DQdeGnrw+xAz/DuJpKiO4o2snTH9cw1qewGBIeP3BPdvdrbSGTd
	nXIhUN0bBhi4zRpGnejK6oAmkZc74kI=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-MekY0Q5sPZ6ratrA27Sjlw-1; Wed, 10 Dec 2025 17:51:18 -0500
X-MC-Unique: MekY0Q5sPZ6ratrA27Sjlw-1
X-Mimecast-MFC-AGG-ID: MekY0Q5sPZ6ratrA27Sjlw_1765407078
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8b2e19c8558so90977285a.2
        for <linux-xfs@vger.kernel.org>; Wed, 10 Dec 2025 14:51:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765407078; x=1766011878; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sfGt0kZTy1oSWc/9yXuGuY0HC5OpMM6HjYeYgFfHkes=;
        b=nRrxzWz2DbI4y3s1IknFB5OHmOwB4VHNvEWcQPnfQ+fdBzD+Yn3w5UtF7H/YYM4ljl
         v1D8rKBVnhD8zzj7uRBxWeVUv3JmH76ILU2j6VIvnO6HVgnPfQ1NgGVj/ILPgJnjxGeR
         fn7wQWql8ooNYYsJQhkSoBgjnBIO/zfHE0j174JbWlCLdHA6JH76/r1slB7bqgeznv4r
         /au2nsFYoFEJ34fTiJ6H1QpUVmOkm39GoroiH77Jp6v2k1CxcxpTLuuUGViSv64ZfKJJ
         msxm9C98ysH0Bse0QqadaxoyHieGGGkeiyWb0IaNz102/h+DmiCKdQWzbKXmuh5eIuXM
         X5MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765407078; x=1766011878;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sfGt0kZTy1oSWc/9yXuGuY0HC5OpMM6HjYeYgFfHkes=;
        b=fyKvzxgit4dCtbHl8bDVmgpCLUpV791bhtFk+RbCRD/J7YIWga7OXa8OIVo+AH3ZpS
         /e1RROM9JzGiiJ7uvQ1qn6rMnRBh4hehk85Waaz/tJUUyFm0cMOxz4TNJNWUvzfBFq+7
         YItcMXLptrR2+ais1yGnfyMEzQ+pgKWgEJhEGDmmS2wzI1MTnlxW1/w3HzPkDcXLK3Wg
         tULsKhvetmma0wWXjSHwT5yIhRoNhycMxtU+KNgbMNgIyLu3UmXGnYsPYFhYCE5PubfF
         Qev+JdYPdETrec8YrK0XZKkCQYaB0/RaDwLQMHS1nFSbbHruY6KqB4oPDLcxakKpsz4F
         2XBw==
X-Forwarded-Encrypted: i=1; AJvYcCW2mJt9ersnM3WXBbNwJbnLrNtWOcj/9dlE5mbMqp4mnqmv39+b/Joei5N03mHq+lG7ZOCEP/jGLF4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuPln4OWrocDlg9eSuy4Kjjl0EkE54NNjqO6UTcxTXrqSvsZ4/
	V9zqQLGqM7pGesP+TvzJWTijPaIjPLuE5UCGIdnhFQuow0s8BFTPigK2C+I4nuqsRzoJS3Ed+FS
	M0DfGGkvoQd2E/IDSfjL29qcYbFpr+FiWBPEadaSviJ6F/9a2tstR8iiGjKgSfA==
X-Gm-Gg: ASbGncstqU9NMh2kxYQr+KE9gc5gkFuQaEJf6xjo+4mF/5FrWRdrRi0747wuP6ulCJh
	bHMb1bz7NDnMn15Eu5Dxafr7qvzfY5Mfh7B7AeQhXNs9dFdYNvI93T7smbWCt+a2pmgzpMpDYL6
	2qqlFZkkOqoioPW7S/DCkYBIsdd7h4Z4hAn2wWXFM4K8pOp3mnNQicBFoeEX5hVN67mpSSdQxlH
	9sGSOYJIpBrhpUtwQv7tVC+QuuLHPQTVGRGKKxtKUojGUHMGDP2+tkZEDVRR0TjqFI0rz1i3oHc
	vH4GCNH+KoZzX8yq7TtmI5P2lP446uSUSYHx4FicrWPbK/d9VVaSn1yxGoLmUfYjmtzIrnQV8Bb
	ir5N2LyhiPE2chkHuyHxk/47TF517B1H7+HhGyw5uajQcvoO+HKs=
X-Received: by 2002:ac8:6f1a:0:b0:4e8:b4d1:ece2 with SMTP id d75a77b69052e-4f1b1a50733mr48016821cf.18.1765407078330;
        Wed, 10 Dec 2025 14:51:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFH/v2FUJz2Xneo2jAP5plJf261kiG0anIVPVxavFAT98zWxcBDwWZNf1Tyk04eu/KlT4BSxA==
X-Received: by 2002:ac8:6f1a:0:b0:4e8:b4d1:ece2 with SMTP id d75a77b69052e-4f1b1a50733mr48016641cf.18.1765407077919;
        Wed, 10 Dec 2025 14:51:17 -0800 (PST)
Received: from [10.0.0.82] (97-127-77-149.mpls.qwest.net. [97.127.77.149])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8bab5c3c77asm62088585a.27.2025.12.10.14.51.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 14:51:17 -0800 (PST)
Message-ID: <a3d76365-d256-42f6-8251-659fc578cdec@redhat.com>
Date: Wed, 10 Dec 2025 16:51:16 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Good name for xfs.h/libxfs_priv.h in libxfs
To: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>
Cc: Carlos Maiolino <cem@kernel.org>, Andrey Albershteyn
 <aalbersh@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
References: <20251202133723.1928059-1-hch@lst.de>
 <aTFOsmgaPOhtaDeL@dread.disaster.area> <20251210060848.GA31741@lst.de>
Content-Language: en-US
From: Eric Sandeen <sandeen@redhat.com>
In-Reply-To: <20251210060848.GA31741@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/10/25 12:08 AM, Christoph Hellwig wrote:
> Trying to bring this up again.  I want a common name for
> xfs.h/libxfs_priv.h so that sharing libxfs code is easier.
> 
> My initial proposal was xfs_priv.h, which Dave didn't like for a valid
> reason.  His counter proposal was to just use xfs_linux.h, which is
> fine with me.  Another option would be xfs_plaform.h to be more system
> independent.  Both are fine with me, as is any other reasonable option.
> 
> I've added our regulars to ask if there are any strong preferences
> or dislikes for any of the names, or a suggestion for an even better
> one.
> 

I also have no strong preference. linux.h sounds a bit redundant, so
maybe a slight preference for platform.h.

-Eric

