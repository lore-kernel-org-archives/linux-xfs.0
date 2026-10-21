Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792585009;
	b=cBO4meUijb63Qu+1TJcISBH0BijnHYqg632GGzvsyfs9xCC8DIDD+PLbjUP35j3LZ/VP
	 BH61cJjDnb+8tZ1kgGyMpw4bKuhOSPKDmF46tFf5zb8JwQK/fyyyDK1QOWGOAC8NVhlQP
	 08Wezilq95LjXW8tRA/jK+jQdHehZevPVjQdgfqpUmVxfGoWPClTkLLrH6Z+arpWEwY/c
	 PxCYMln/gIItERUjic6xTlW7cRJJMsHMhIkSfyX0aSWH54tE5950k3mOLkzvhYjhN98TA
	 EdRM+vhCWFuwFaioy1WB8UN/1CPraBuMXLYobWxZr9vvaPcw9dXlgv1JYO0mWgaisgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792585009;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=JPwqD2eIlMlxyWUMv/ZpOKyRK2YgBM6m8Hk+/yjZl10=;
	b=f510efVoW/sl7nbOExXuWmOMCdT3bMKcyIsoHY+NMwUOkiVHOoDxfaq5vA2QyPyASQG5
	 SUm3vJkmAH3Qs3q2qkKm2X16L2Vl17GgabGHaOXeDwBECBwJR/He59W1GNcgViKrI1Eq6
	 6xYQbeEYzBRz0AOiiZiL4Tf6+aVuMloaQvGC3s+oxuSGo69O1nX25Fyf3ISazkWC///E5
	 2j/d1nD8lmjP6cjClUm67aWHIgiv6XQ04h9GIa1w+83ASZ7iVYaJEhowJftclXZcDjrV3
	 /f5PS2tzLsupTm/Bb0lGKeIqFbtiQJCnhsUxkiScZw4iwiUJhXfkVpaxB5PzTxby00w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SOpsIbgu;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=fpJRCOW4;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F37C606A32F
	for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2026 12:16:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F37C606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=SOpsIbgu;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=fpJRCOW4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792585006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JPwqD2eIlMlxyWUMv/ZpOKyRK2YgBM6m8Hk+/yjZl10=;
	b=SOpsIbguosRstswnCWoDx+9mp7dY1ql8609F0lCV6FAus3c7UaoTJnfRTnvRzMRFm3KdhF
	LM8/rUFNWrIQ5GHT9BOk8LHA+NlihmxLFBNuPnLQLpCe0xaQFxY1rANPZQxjAKh9v9oiJl
	WF8JjYTPufSvpPG2RA5n6yHHjLjesBg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-gvEmyhMiMECdL6D0CvmynQ-1; Wed, 21 Oct 2026 12:16:42 +0000
X-MC-Unique: gvEmyhMiMECdL6D0CvmynQ-1
X-Mimecast-MFC-AGG-ID: gvEmyhMiMECdL6D0CvmynQ_1792585000
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48b01a74792so462539f8f.0
        for <linux-xfs@vger.kernel.org>; Wed, 21 Oct 2026 05:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792585000; x=1793189800; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JPwqD2eIlMlxyWUMv/ZpOKyRK2YgBM6m8Hk+/yjZl10=;
        b=fpJRCOW4nUecgi1cZebwvVaFAsvbb/XG7Ud1uo4EYiDwJiRW43Gk3OQY+0gcnOh9jU
         L8oPsZCOtD5op/pSa0DpBbJEysGfC/IUplTZgBnhydcYruQnkRT6anpMgAjuzp5ACj+f
         Z+0mc1U7+60dRuVlYkHjNewvEx0hyAolbHa3GYnaqsYDAM5VMvdGJB2ZkOk5840pcXVp
         F9JgEV0Jp5+y7N1oBcLUpINTBtQ1dLDMQHisoM1gYumpI7ZYHioA4VfY+EcmPGhz3RZM
         6TXSvu14Mo4v/tR1p+18scWKvquP5jk6ysp2Vl11Yh7cvUQ3wY0XizkXpnthmhE/PgHK
         C8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792585000; x=1793189800;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JPwqD2eIlMlxyWUMv/ZpOKyRK2YgBM6m8Hk+/yjZl10=;
        b=EHysX9lOE++ZRaQ1U8VeBlpxsJAaJYmOP40p9DUlNQDo36FwTaV6sBfiscoENFfhmd
         S7PleEgul6uvzuzpb1gNC77Vpr95ujjYt6YRhsp6tKp9XXeoBNEq33yadBkKDMrvjN5v
         g5IGoCBoV9oE3jF6GCjT9gq3ictkedZPGTaAbnpZtx73xpjdgOdmXrqfPYUwrmJF0C77
         NX+qjzOhYkP8vSANPjqdjPJ8uQNbNf6+/pDAKAFgxMTHcBOP3HZVxK/JGfwwl73+9shg
         mh0FQSTc6HGR4p2/zJVK2KAK5jpjTLKRrqbVksnTOLeXESuqRRvx+bzfxcWVOxfNCfBz
         fgEQ==
X-Forwarded-Encrypted: i=1; AKwUvBx0KL3bf5kIfId69D448Imd6FURD/w1r4DejdH150hRCJERiXHzfWNgJj6hEMFoFduFZev0PeY1aUE=@vger.kernel.org
X-Gm-Message-State: AFq9FYKb+/uZUb8Tyy5Nc78GZAHPIIdHrExButBukU80v9V1fGTaQ/UX
	9EEbpavtunfbeV765QZnpBhVYSOpTqQNBhXx/OPOqLTzP4KFFOTewKpzlbd+Bot4fwQN0jcZR/H
	ZSbKdFm+mXQ9okvHF6aA7g9aDvF2pd5cJwbOh8aTCtxI+T/okk3enfJtBu2LGvcs21doA/w==
X-Gm-Gg: AYBFou08Hfobp1guwQ2qcbjsq6FhzQRO6hjWTVSNiRQAWIvubMyJPQg0vb1AElw6tGS
	Lr6MXZ+Uc5eEGJLIVD7J+sIB8BheSJQkPLkRm/TM/s5uS7OMN/Xs8WZ9tavQqX1MqiagW8OAep4
	1q63QfqVA9ezo8QGJNzzmzyfhm4Gzf2XYEEzPBjKjr4Lp/3WK6kHRNbYu7wtoMvnyaMN+g7Cr1s
	dCQ7nPS9Oa7lgjuU0+Yd+4S7srK2R5MVCzHlFqPCnP5R+0fqxoD24Kkl9/1HmCJ6CQuqJt2GNA7
	6SCPweuxaSozNQLK/MdNOPu5TJtfAMMt21muFxD4xbyqy7m71Uo8e/fUYcGdvIJ1uNOCqaEBspo
	a884TbgllBQDJEVEpq7vqdPfRWaDVUHRg98G0SQ==
X-Received: by 2002:a5d:6f11:0:b0:48b:9d80:53a5 with SMTP id ffacd0b85a97d-48e2649399cmr3984207f8f.10.1792585000432;
        Wed, 21 Oct 2026 05:16:40 -0700 (PDT)
X-Received: by 2002:a5d:6f11:0:b0:48b:9d80:53a5 with SMTP id ffacd0b85a97d-48e2649399cmr3984131f8f.10.1792584999918;
        Wed, 21 Oct 2026 05:16:39 -0700 (PDT)
Received: from [192.168.100.149] (gw20-pha-stl-mmo-2.avonet.cz. [131.117.213.219])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2583e25asm5358822f8f.46.2026.10.21.05.16.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 05:16:39 -0700 (PDT)
Message-ID: <a9a66879-daae-490b-bddb-3d1e785c6fc0@redhat.com>
Date: Wed, 21 Oct 2026 14:16:37 +0200
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libxfs: remove stale xfs_trans_mod_sb() declaration
To: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
References: <20261021085921.56883-2-aalbersh@kernel.org>
Content-Language: en-US
From: Pavel Reichl <preichl@redhat.com>
In-Reply-To: <20261021085921.56883-2-aalbersh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Looks good to me and fixes the issue.

Thank you very much!


