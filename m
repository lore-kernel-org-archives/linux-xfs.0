Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD0A1D88B4
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 00:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774397790; cv=none; b=PXeqxenpGW9jQYwHGSVWYBe0k7ajrKcgmV0a9WPAlxTU2zXI0AiLAZmPSyYqOso9onIu/imJxUrtFO+n833LEJFv5dmU6lp1JZ+WNLftOk22+sPvMlDf1LxN1yCKPdw4qwqQa462vtevBGmaAtanDVUSqem4F0wubLnAsK4S2Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774397790; c=relaxed/simple;
	bh=MoLrdbwuxoKO2kYMSDxtCJV83ayachj6VWNdw0sH+RA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MpE9dRUwUCraCnkBlqoabExhQXANFPCw+5rC1821QmJHbMShnC+YRzgBxdUIsXAATwq+oUTRDVVsv5ZiprgtL27x+Tygp5I5Vsi8hql2oP5K3mBM3g8oGRipDWMRAj8UIjlSsbdqR0XUTthxrjL2dL/AqrbWcy4mQHDWxo2s7Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SYf+r95P; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SYf+r95P"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-67bb3fe55a5so1740690eaf.2
        for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2026 17:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1774397785; x=1775002585; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nUE46PPV8ZBQbSpBMaJf2P+/9B1olmom1CQ0qLARqFs=;
        b=SYf+r95PWmYPO1n7S4yEVApA92diDLGXIPneKoub13/8urv4UW65pHpy7F4JHtAEA+
         R3f6hdyMDSGmO4Tds0VFrI6pYtW1NpIleRv/oF2T8YQ1Jp6AqGbv/XCOrOSrNczV5suz
         9iE9z43zJrEnfAjpMIB7FaHArsxFNos4nItFpJpck7uyg2uxuK+9jdOrln9Suas8Xval
         tHEm5QRW2F2e3q50poeKOANZlSGPwVDmqSL68vwYQG2QhaZ/JMUle7UINTpSYr5n7s+g
         81OjuIAGSa/zmgMtPh0FDm+q6funlL2oOySjo0rg8pqUQNFLDkWQX67oymjyKZOpSoDF
         LFRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774397785; x=1775002585;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nUE46PPV8ZBQbSpBMaJf2P+/9B1olmom1CQ0qLARqFs=;
        b=N6BjeJMtEl50/l7E2OEEK/SE7ubR1DJb+qjGgqWi4Lqguqd5lXRdrFPt5vFUVBVB+m
         EA9qEcVRSEXdxLGVw1Of4mvLJ2eLd4RtvedJbMd9jXHKOlLxH7CxXD8eMa0nLBCEsnqq
         xM1RtMu5AlQmi318yNtAhcjo9dBFg8GzgAcj8WkWAYjD3eeIbgmfr22b+oF4X3cWVQga
         pn3Ec4g9SueI0CQR0+8wIjZn4GoK9tyMd8DFxiWIUFRlOlQIN9qftrzpt6QBvYc24N+4
         Rp6KE3ug5LXlNCJuNzQ85ZZnZ81YKHjwddhO9nvn6xaz+ARtSRq9jw0YijXtwxl9hLM0
         CRTA==
X-Forwarded-Encrypted: i=1; AJvYcCW3ylQQuE3YMAPzafab5e6B4mlSUV2rA4UmmIZ62iv35RmFRae62T9Homkmf75a3r6CPsYob3WIBug=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWBlv9X2McP2NZUats/NfNOM03YLMQtdlsa7ZN+cXRcM5ksr8T
	AkyGlbgDtUOH8Uvm6iWkhFlYkv1QRvyF5FOCKvEJt6mDlI6IznM2emCv1JCMWyvak/I=
X-Gm-Gg: ATEYQzxN7aTzb8tvjgoKuro1ZR8Lqw1KVvkhH0G+aYC1SR9LB34Q+iV1FLeg3cHQCCf
	UkxQfdimX2QfPNPRd4gU16Bw968lkFQAK9WP6/O6TPghQMbH50T04Rz731AdijxgPPmcW9JqMrk
	WejLamYNOUXDHxtKLd2kTVwzmY19YMxFx//oSSa9l6oqZbeFNW+hz3wPVngU8Q0XDkn978G9gGX
	t6LUrlEOE8sptdPti1CQlI8T0qC5bR6bH/zTqFmZXAWSW+AtyjO1nJhrw4iqRYKA8AQqVZ5nSi+
	4ztE603J2GnYu/rD275WkJhmROHsAztk55wZJVDnKHl0jETEjaQHYN9jPuBE4kdBZyIxTX/FBQl
	KjVaZQgsaBcMgiyQTtBRPJR7BganpBUufob86nfyyF0aWMCQw7vEHJA2M8cOM9cwWa5L0a+b5n9
	OezkCZlBC48TJopIlAkTZIlTov0sijBAi9J0yHoAfnyzyLzLPFOSRU8g11+7/YhtX9Rk8Yj8W5X
	KeyMvfkyQ==
X-Received: by 2002:a05:6820:206:b0:67c:2bab:bf54 with SMTP id 006d021491bc7-67dff5f7978mr793373eaf.62.1774397785456;
        Tue, 24 Mar 2026 17:16:25 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41c57bdf2b0sm9253351fac.7.2026.03.24.17.16.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2026 17:16:24 -0700 (PDT)
Message-ID: <1ec0b46f-a1b2-43f6-98ae-43bb87d0e59f@kernel.dk>
Date: Tue, 24 Mar 2026 18:16:23 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iomap: fix lockdep complaint when reads fail
To: Christoph Hellwig <hch@infradead.org>, "Darrick J. Wong"
 <djwong@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Zorro Lang <zlang@redhat.com>,
 linux-xfs@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>,
 linux-block@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20260319194303.efw4wcu7c4idhthz@doltdoltdolt>
 <20260320163444.GE6223@frogsfrogsfrogs> <acDbFtQw0mom798e@infradead.org>
 <20260323152231.GG6223@frogsfrogsfrogs>
 <20260323210017.GL6223@frogsfrogsfrogs> <acIrtFpASaBmFZPU@infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <acIrtFpASaBmFZPU@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/24/26 12:14 AM, Christoph Hellwig wrote:
> Please reword the subject - your are not fixing a lockdep complain,
> but the underlying issue of calling code from the wrong context.
> Lockdeps as usual is just the messenger.
> 
>> Zorro's diagnosis makes sense, so the solution is to kick the failed
>> read handling to a workqueue much like we added for writeback ioends in
>> commit 294f54f849d846 ("fserror: fix lockdep complaint when igrabbing
>> inode").
> 
> The code looks ok, although I'd much prefer generalizing it.  I guess

I'll take a stab at it. This one is fine since it's an error handling
path, but previous tests I did with this kind of approach for every IO
hitting this path have been utterly terrible.

Once done though, we can swap stuff like this too.

IOW, for this one:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

