Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA8330BF6C
	for <linux-xfs@vger.kernel.org>; Tue, 28 Oct 2025 11:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761652210; cv=none; b=Y5U5/MFWZxhK2oKw2rQP3NfC5P4o0ltwZeIN7vjDSKqenYrgbumzDiVq9LBHydGlSouoJ0eUu/TrmXTq0B5D1TGx6ZOyk75hM98bm7sq40t7MGAe2VIjasl9YEDGJfoH1hV1KtYzYOgEFbutQ4CCZUqrBu4Zb0NYPizzRNCIuF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761652210; c=relaxed/simple;
	bh=dU4zVFHKW2O4QpCbJtTeOJxYp+cQxgc03lfH59F0Ox8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=raCA5UQh7P3FaVYMQYkz7BmdbmoDmTfVt//2lGTxb+cJGjRUvi9I2W1vY36W12RsloHTlMhLZgTqF0ccJZXa5ULJW1SLT+x4Zj0hVEfl6jahzUmXMwcJGDdvJ2d3l1vyBW10UgKKjgl4BrDdioGaxgmeBK3IdG4HbbY0wkp0am4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ChnWjv/0; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ChnWjv/0"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2897522a1dfso53568955ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Oct 2025 04:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761652208; x=1762257008; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dU4zVFHKW2O4QpCbJtTeOJxYp+cQxgc03lfH59F0Ox8=;
        b=ChnWjv/0JuqPzHXfJOz//zQvwNYUNA1aZjae518yz5Q4AYhQ8VNHbzWAtFussbWMXa
         RshpvQEwcAkjhtUOKUEv10kTr37jCyPuwZbujqe4MVBjgCcxiI1UNefXN+/ZvkW20gw+
         7I1b4M5ezSeR+SF7vWgaltbQ/+p7hTXUlzr9GrFDi4PZKODcY30rND5Ge236ARc+GRNy
         n2XEpxs8DA7Gbv3rp7At2kD/HtAAaxEuFdZKRT1Wm+s1uNqXRVStLDSbQvHDj8RSQBAc
         KmZG9I/Hp7bW2uqj6MLov7IKhn+7+slEhyfBQQYrHjrIR4gZTI+tkT78NoC5mtnGpvIW
         iePw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761652208; x=1762257008;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dU4zVFHKW2O4QpCbJtTeOJxYp+cQxgc03lfH59F0Ox8=;
        b=KNp/eY7dpQ3Bi4olKfKFwEUc9SsWsZ5+4kPexQBvtETpC7WgZo7Zoabl8ACRhsUfz0
         onb5aopjXnXoLcP1LnB19esa5MRovyuCJdYvwXXtpIEMDGJeIHYan8BeBZRgPow2NtUO
         5K/+CZwSQs1m+fmm5qWInhYFXWd9qjzXdwx95hOIswXH1jEThrFog1EdHP0BSbDmfRdy
         gvIijjxLqkKpBRs5XUvy1NbbD+cLvl08wRalahKkphsYEFcCO0iqrSpqX6rLu4wQPNhT
         Ac+jlWOEpnWkDek/6pNoq1Bq52hbj0FoIDfQyI5xlf1DkVgL6drLurOW/s/4rdRcu3LS
         UK0Q==
X-Forwarded-Encrypted: i=1; AJvYcCViH/h+SnDgKf93K+DGNi78XGpEKlxbB2D2mPf2ZnoaiLA5WoecxPNJWFR+D8otR30oilTu67Da7rQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFqSWfAf4LUdrxfb3ks+F0ITskbiIGI0Kx5rcyi5F+NO+smDwt
	uMIqEBp7+EtFakp9fCKZuoIA8XwQv/Z/hRrydlxF6P4iWFuYzuyYmZJ9
X-Gm-Gg: ASbGncszOP/WD359k7qhhJ+dK/qydNZFd/ft8VrAMO1Ck0VVBJLlbkl4qhqCsJl+NG9
	S3wuPtieBt1SiOi9APBtle4HsZniVwzIujdcglyNAUehKb9NV6R97c0tp3ZlzNwwvEZwoeUc8TS
	5fco/Q/ZPXTtVuG2Wiy7phZrAI6h3QoO2VbQtRi6Gf7rC7TqUtzY2cX73lQix9aGBd5Rf7wuUZV
	Yx4GRQ/4mIviZSQTUZHLhxaUXuMK3pO0b55uZjrTThlbzbB1fDw8AIRXmbbUmEOulXfhH85Y4D/
	R6ThVm2MVUG7Pb4EcfIsCh4bDgfA3jyKytLg1Ar5+arEo1VqaHEC1llrI9pXwcABTcKq/aNyQr8
	dJePHUL1GcieJKVJOm7pbVPFnK64SbaWFjQKfRd6XcrL0nUQRBgfN+xQunEX9qXHr3LeFsQlCgN
	M5Dv4vOJ4E3wXnrs8=
X-Google-Smtp-Source: AGHT+IHP1cVhD8F4dyZ7P8z0EmhNkVZ3pwTL9LbVmVnwsMVkY7U34z4WsYnpeZSVPdy2RXMWC2141w==
X-Received: by 2002:a17:902:f545:b0:292:fe19:8896 with SMTP id d9443c01a7336-294cb674766mr40940405ad.52.1761652207657;
        Tue, 28 Oct 2025 04:50:07 -0700 (PDT)
Received: from [192.168.50.87] ([49.245.38.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf49easm116300265ad.9.2025.10.28.04.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 04:50:07 -0700 (PDT)
Message-ID: <ed6bcb1a-e0bb-4211-951f-500a8fd7787b@gmail.com>
Date: Tue, 28 Oct 2025 19:50:03 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/3] common/zoned: add _require_zloop
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
 Hans Holmberg <Hans.Holmberg@wdc.com>, linux-xfs@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
 Carlos Maiolino <cmaiolino@redhat.com>
References: <20251022092707.196710-1-johannes.thumshirn@wdc.com>
 <20251022092707.196710-2-johannes.thumshirn@wdc.com>
Content-Language: en-US
From: Anand Jain <anajain.sg@gmail.com>
In-Reply-To: <20251022092707.196710-2-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


Reviewed-by: Anand Jain <asj@kernel.org>


Thanks
