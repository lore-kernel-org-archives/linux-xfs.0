Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799DA3A380F
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 06:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785221440; cv=none; b=p8g5wKEE+rtPb3B3tnPFjrzrVx/pNC2FwXCzVqLLrxq5i8fL6KgTkVwlcvDqawufdLj4T9pv/Mu1g/oYaQM2JVBKuD/JR+g/jKZRpuXre9FoJg83OSsB5P9yeafvf25LyzMsKw1ToRIM7Sgu5i/Y4GCyu3lJA7Dnb7BrLecDsVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785221440; c=relaxed/simple;
	bh=5L0zKFrAkf8pmGjCwvUJFaZVrLTIBTFBT+2mzOyn/PU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J0aV3GC03HQnsFCsofnrgh0PUj3HP7OxF4u8DE2JRThY7qci3xQp06leNFqo7EfhRGC9CnmIIEM4JOYOuG7BDzbdQGzKiaZwPCpZM4LtM7rFy92JB24rAyTYvGg8F/G6cneh2qRJ263peis9b4Wk+QDC9iGvheR9w7JcW/Lm2X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=obf60L/0; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="obf60L/0"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ceaf8a1265so42435615ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2026 23:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785221439; x=1785826239; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=u0WpJIoshG3z5CwgpXaTZV+mQkF9k5x9f64UzMVLTGM=;
        b=obf60L/03gEbaZ5RooxzdxaeNrg5ry7Xu/jgbCt3VkOI63dtd9dL5jaKty2eIK3HL7
         EAVfa6e92trWu/9UcZ9sYi9qGPWYQiyx8Wixm5KZjI9hcGTTRvHsMR2SxiSG13nK8Ew8
         DbFlZwY3aJPgOxKqThwhl+PKipuMvV3/5AJ0QVQsisba+efvhq8IpxlQ3Q11eYM4I5G9
         24xIzFtPg4bLQ4ws5uCg5ofxv07Eh1+H0aUPdArCaXn0LV0lmtzmOjFHKAXUYL4wowVo
         KxO3Bg1TCjRvAs5XzrTsqhUbJz756+QwZynYKogonGNlKI5jBpWxIaoSTeeappMoWSUo
         aHjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785221439; x=1785826239;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u0WpJIoshG3z5CwgpXaTZV+mQkF9k5x9f64UzMVLTGM=;
        b=IbBvt+9nMWLwP+vGMfvt8sGbVNVBnks127DZyU11FoNu5FJNxTyZ0A6x02IO+jQAwz
         fxXa68Y3huL6/8Gxz2B3FwO+UQ4lCEGoQBV85V8lW18Rom+OiG1/eu9yejja4b9s3ZEl
         Xpnu/CpvKBfEJgtSzJYh9f1egFEXopzMmguGQrZuE2Xe3kd92AlAHVaz6Sx0QRxI/yzF
         /lbkXY5tPNGyJHEOgWiYYepLq1Qkg/L030dG8o6hxCfX1n05x7fIzufoUSPC0Cu/0ZJi
         taDSEfzubxbDOuc/yIJF87txoCCT6uKgLdVCfZp47JiuzsaPg0qTx6Thf9WeghGkVM7a
         QlWw==
X-Forwarded-Encrypted: i=1; AHgh+Rrn0EHhoyhZYNP4aAxywT3sOX4PB3SSIILOpV8HcOoqTYi9sbtekJrZHiGK/zyzeqyy4hFep1TF9U8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxL8utRSGbGodCI6it4VbJa8cVyFeFBKugLtmWiBi84LXU1tMas
	0opfSP1Ml0grl6MBWTLK6EhH10FyUKgHdedQMQTudT1rY0TcNzB7iqAD
X-Gm-Gg: AR+sD13G9tCTjlWfqjDnuNvb+WOoLcXegGyXGeEhOrQObKjprhBg6X2jtS+I0y72DtU
	fZfNuw5JVdEzpHRO5lzJsippCjvvc/FJtsk8c3OQWQicfUMpoLKp+YZpPk0q2gRpkf2VJhxIoil
	fjhphi3NC9dzkgRVtzMn7/sUyZOjbaUCMovAWuVfVp7FoqVbmvr9jn0dDl84VAW7V9Lw1izqnCa
	vR91HiDfsEOippbLRKCdJ4jscoMChXD29gAw0CXKTqcZ/aSFFTjne8PXxV6mPc52NcMedbwMZHA
	4AYUHYcB+SAxOJwEKGhxxCiBY+iVsxeTAgGgGok9j5Dd9OF+X0385UsB0h2WckK5QPdcxT0/9OP
	UCKOLHIrinKFfsMVsq/rEBsY/m5iiYyqqDSGoum5faE1kejIfTQJ1ou9MAdXPWGp3z/our57XN7
	vA4tJxrYi67AT+nG/k2YsH+M0gZmaKBxNFjin9p002WSA=
X-Received: by 2002:a17:902:f789:b0:2c0:e5ee:f554 with SMTP id d9443c01a7336-2d015ac7080mr13757635ad.8.1785221438608;
        Mon, 27 Jul 2026 23:50:38 -0700 (PDT)
Received: from [192.168.255.10] ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde7ee6b0sm46545865ad.63.2026.07.27.23.50.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 23:50:38 -0700 (PDT)
Message-ID: <b17cab0c-3804-4322-90f8-b163686f76cb@gmail.com>
Date: Tue, 28 Jul 2026 14:50:35 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] xfs: fix exchange-range reflink flag clearing issue
 with INO1_WRITTEN
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, stable@vger.kernel.org,
 djwong@kernel.org, jiapenglin@tencent.com
References: <20260728022310.99955-1-jiapenglin@tencent.com>
 <amgekiNKKoAdACnc@infradead.org>
From: m00nb1rd lin <ljp1205831794@gmail.com>
In-Reply-To: <amgekiNKKoAdACnc@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/28 11:14, Christoph Hellwig 写道:
> On Tue, Jul 28, 2026 at 10:23:03AM +0800, Lin Jiapeng wrote:
>> When exchanging two full-file ranges, xmi_can_exchange_reflink_flags()
>> can move the reflink inode flag from the file that currently has it to
>> the other file, as long as exactly one side is marked.  This assumes
>> that the file contents, and therefore all shared extents, are exchanged.
>>
>> That assumption is not true when XFS_EXCHMAPS_INO1_WRITTEN is set.
>> xfs_exchmaps_can_skip_mapping() can skip hole and unwritten mappings
>> from file1, so an exchange can complete without moving every mapping
>> that the earlier flag-swap decision accounted for.  In that case the
>> post-operation cleanup can clear the reflink flag from an inode that
>> still owns shared written extents.  Later writes then take the
>> non-reflink write path and may update blocks that should still have
>> been protected by CoW, which shows up as data corruption between
>> reflink-related files.
>>
>> Fix this by disabling the reflink flag exchange whenever
>> XFS_EXCHMAPS_INO1_WRITTEN is requested.  The contents exchange can still
>> proceed; the conservative outcome is that both inodes keep the reflink
>> flag.  The regular reflink flag cleanup path can drop the extra flag
>> later once the inode no longer has shared extents.
> 
> The fix looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Can you add a test case to fstests for this?
> 

Thanks for the review. Sure, I'll add an fstests regression test and 
send it separately.
