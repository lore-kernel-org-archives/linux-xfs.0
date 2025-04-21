Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D880119F127
	for <linux-xfs@vger.kernel.org>; Mon, 21 Apr 2025 20:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745267064; cv=none; b=YiR2KP5mhILmjzmYtTwZjV2EvAxXgCjvz+n3nKmv2rBMjJpgM/wdMl3lh3ikF8NIPyJxfOV8ylbBZhJJVj/i5TUXkdWJATjSoGNPTgp7hc9xhO3BoLrDRRlpWFf4rlr1G1IcWYgjS3GCpP8zufuy+kKvh8IxrAryV/IyYYILlr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745267064; c=relaxed/simple;
	bh=mxCB9SUZBeClGFXURnIsA1QlVo+SMxflm+QReL1PuJA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=klgRfgrgX8xU3+zDfgGG1n8MWlBnQi8oVhy9SG960aeouK0DNbbDCZ7NbwlJq+xFYM7hIJ7PJ1UgPoGsB06rvwJTlOPbA21FaMPweFn7gW9faxZVRG25ZoOXp1sRfgSs6NA0LoeDKEtEkVDUKVzQomWEIjuLk5y5fuIub1iMaPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BSGpcK1E; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BSGpcK1E"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d4436ba324so38064685ab.2
        for <linux-xfs@vger.kernel.org>; Mon, 21 Apr 2025 13:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1745267062; x=1745871862; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W5maUrh0KQzV6aymom/1/wBhMZfCX557JEuH/6UWgEI=;
        b=BSGpcK1E9kehKVWeS1u4FrvaxcbpR70yuBIt8ZKzz6wfAgr615mX+SiGvKb1JZTPNW
         pcMqoEudqnyrHyP1Izrcu4X220W5mjiXnrxBAlLI4FnHbWaadFYHKOKW6Hkl5gbBa+lW
         7V6Zo6cMa4jdKRiZGysOSlRfc2RFkt2oEbpDL84EuGDWKvEFasItc030PONi02fhAVcO
         +v1ly+9UXuz+fKh0TXN8PBAwAAoEk/6fxRuwbai8kuMMHJuOZ0njEtWBpUE+4LLJGBkW
         Vyh4MGJ1CJKqfEvKKPpGPzMuYk8r6TzKIHBXGBOuNOKys72mVlcCYNb47xq5HyMG+IHh
         dlRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745267062; x=1745871862;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W5maUrh0KQzV6aymom/1/wBhMZfCX557JEuH/6UWgEI=;
        b=taoHVNULSInGL2DAo9dQg2B3asFx2m6nOqWPfIWiFIOFll4SzdWy+43Can1//y+ml6
         vrf70Fy03JU1JV45kJvLbDdGhMicR3fc7QrJRg3gYuDbav/8PEChcrL/WYXeU9Je1MLz
         IM1aRB6uJRkSvaGHfb5OsHyCfy5IUe+3pG5UsAhCIlBn6mq1Yi5ibgW6Sg6b2e+1pJEt
         BtvbnpBfjZhvVkiLU4cePAOOml3p0rLl5+SKR2p4QdWv4+TNlghHWYJ1P6CD9CF2ySaZ
         3+libofFtmqgdPP+voKUhYNkYNDBDiLiMfa7A7jWGBeRo5WwXbFP+QFkK1hH/OUHDeR8
         WlrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLelNXiMGfBUckvxBJEZpnomDg0vvK/qkU7E4nWvgn9LE0TjVBtwOxKRNZN+tA5ujerGt6A1F+Vx0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJ6x6xiymYjFUa33PtInaEvpQMmoexy3cQrWXkZkhd+hz8QNJw
	bBGDGeGohh6wvilW1KYAUL2kU+nfmJNZ8J+jb6Vq/Ijz5iCPk819KXvbWrEVxew=
X-Gm-Gg: ASbGncs10vlG5a08qqtiDoa2jjX3hoZ0o7XSJ1g1xHooVGrsuffBJ/llvUVQF1cdJHO
	x38yusMv3zb5pde2U1Rk+FQGzMzbk9oksQTD5thoqfDV6GKS0pJsXI463zrjc0cSnyTVPkvjI2Y
	8E1CL/0ZyWNQY+vK+jBCBlYFTk2o21W1NcmvSvw9Z7UW1O0ymiK06HcfrsZpreeXZILiTNxn6ZK
	29nPaXkmVYplFduQl0EAnCT8mqXCeuLf9xENcUsLnEM4v2Pda7uiklTpOqqNqo1PdwB4SB3iZfi
	m71gaDWaAkbDgPnBfNfvCTb5CYnxR6QBPve7z3jVzzttNhw=
X-Google-Smtp-Source: AGHT+IHcj28bFOGSxDo4d9yAdQ8hZG+yV0Gef12wOsVNjjXhehkX2IN0lP6ew3bv1S7erAzJ8u78cw==
X-Received: by 2002:a05:6e02:1b08:b0:3d8:1f87:9431 with SMTP id e9e14a558f8ab-3d88edc33f1mr125756165ab.12.1745267062043;
        Mon, 21 Apr 2025 13:24:22 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f6a383345bsm1909134173.61.2025.04.21.13.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Apr 2025 13:24:21 -0700 (PDT)
Message-ID: <8cb99c46-d362-4158-aa1e-882f7e0c304a@kernel.dk>
Date: Mon, 21 Apr 2025 14:24:20 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET V2] block/xfs: bdev page cache bug fixes for 6.15
To: "Darrick J. Wong" <djwong@kernel.org>, cem@kernel.org
Cc: hch@lst.de, shinichiro.kawasaki@wdc.com, linux-mm@kvack.org,
 mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 willy@infradead.org, hch@infradead.org, linux-block@vger.kernel.org
References: <174525589013.2138337.16473045486118778580.stgit@frogsfrogsfrogs>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <174525589013.2138337.16473045486118778580.stgit@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/21/25 11:18 AM, Darrick J. Wong wrote:
> Hi all,
> 
> Here are a handful of bugfixes for 6.15.  The first patch fixes a race
> between set_blocksize and block device pagecache manipulation; the rest
> removes XFS' usage of set_blocksize since it's unnecessary.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.

block changes look good to me - I'll tentatively queue those up.

-- 
Jens Axboe

