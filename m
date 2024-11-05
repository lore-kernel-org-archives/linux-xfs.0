Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BA81C4A18
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 08:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730796922; cv=none; b=Et8glZ//T0B0fJq/EKMlkesVLlr8/aJwWDJpsBV5Kv96iy3eGZyXORmlljS1Zx/J9vPgp1rxqeVLIPWXFKw9GTayEi3nTh1jHED5y46TJJ6DyNZ7HAADNDC4GMBsO9o/TiFbC6KokAnXz9B291YfgG5NYxQHdwlQRmpxHHYiVto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730796922; c=relaxed/simple;
	bh=gBD73+rs58WaA56HUWWB7X/+5TCT6P6jpdbKvrvc8jE=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=YDnILHPS558maxjNkM7vZwqGwoqi2JGxsSI0/5vrWOI6RlMLXoUbM9c64JBQLEnB5GidTjbx/vh0Me2gJ48oPEOJDkoFQpqKezIzlb+BYzDVG9V/tldoytif05HRlrv77bB/J80I9WR6B9xsIL5BC3JCHmRC/lcG2ar+FK94xIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=P/d6p3ak; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="P/d6p3ak"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-37d447de11dso4036095f8f.1
        for <linux-xfs@vger.kernel.org>; Tue, 05 Nov 2024 00:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1730796919; x=1731401719; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:subject:references:cc:to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=p4UvfouWCkHUWP5HGQ2ye9958/aqMmQk6U4iphXEDfA=;
        b=P/d6p3akYLrtULvaRWslMCNSe1GwXII/mMakMSt3k4YF3QaEHbYeDXWfz9z/MMk1cS
         UtN9fW0BQ2rP05cYXe6XrU7EQt2PL5rFruJpB7pW64d8Y8bVCtmjowl1OTMQlfScZDj4
         gDQFsvKmMQxkz6t2Dags+rg44z5iajp9d1UxA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730796919; x=1731401719;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:subject:references:cc:to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p4UvfouWCkHUWP5HGQ2ye9958/aqMmQk6U4iphXEDfA=;
        b=NlSEqjCorWOU2WH521jwgpCFFGPJ722Z+nMuDnglnzpY24Cy75sS79NokO6HeqV/Zp
         Bn1XOc51fZjUHMo6g09WbxTAsxaMAEUllrW9+0pyeoCl70s0huWbMY6UT/clohHf4LWl
         5aEZHHPDrOfbBoRjQxaUfRRpDcKiseUwwZmaBU4/+JhkjRooX7o5cXjkryMRN0PnIA23
         AOBUHzN5xfvUsU4iWSnw87PlBOXD/dDSEwMmRG9Rf5V1xx0N4TFRvdlgZY5nMGWEGVqn
         2BTd7sMe3uN8Prj9tMJOWdLpg2v8ElcY0UgYMc0wctMb8aRDTjlzpcY5C9eeqFgrllIo
         SAUA==
X-Forwarded-Encrypted: i=1; AJvYcCVxXCweiBmHS3G/kxrysz2QL90EvTDjv1d35LrkWr8QDoUCmDR75hQJC6Lb8cja3d4KG38IYTOGcj8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyAeFHcy6ks5MQ1gMK/b6Y2CcLRaoTdWX4ijseY3Q1gT9cLRlFN
	5JvYU0Ys+jJCkv7qCxuAv3KMD4kMLVpCcsBmajgsGrszWXB117kosFdee2nX6+I=
X-Google-Smtp-Source: AGHT+IF8VlwGgWqiwroPsxJFw+dSpwTQ2rpVvDGp5lHiW5OEXRUn1/2O4Ya1Ng1nN/UB11UFkDbbAQ==
X-Received: by 2002:a05:6000:2a1:b0:37d:4e59:549a with SMTP id ffacd0b85a97d-381be7c7350mr16245589f8f.16.1730796918968;
        Tue, 05 Nov 2024 00:55:18 -0800 (PST)
Received: from [192.168.1.10] (host-92-26-98-202.as13285.net. [92.26.98.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c116abc0sm15389137f8f.94.2024.11.05.00.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 00:55:18 -0800 (PST)
Message-ID: <df10f269-0494-46d9-be8f-7e5dc9cd3745@citrix.com>
Date: Tue, 5 Nov 2024 08:55:17 +0000
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: arkamar@atlas.cz
Cc: david@redhat.com, gregkh@linuxfoundation.org,
 linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, willy@infradead.org
References: <202411584429-Zyna7RpVesXAiTBM-arkamar@atlas.cz>
Subject: Re: xfs: Xen/HPT related regression in v6.6
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
Autocrypt: addr=andrew.cooper3@citrix.com; keydata=
 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
 6+ahAA==
In-Reply-To: <202411584429-Zyna7RpVesXAiTBM-arkamar@atlas.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

>> At least years ago, this feature was not available in XEN PV guests [1]. 
> Yes, as I understand it, the hugepages are not available in my Xen
> guest.

Xen PV guests are strictly 4k-only.

Xen HVM guests (using normal VT-x/SVM hardware support) have all page
sizes available.

But lucky to find this thread.  We've had several reports and no luck
isolating what changed.

~Andrew (Xen maintainer)

