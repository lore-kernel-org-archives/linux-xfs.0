Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C17E629E5;
	Tue, 23 Jan 2024 15:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706024405; cv=none; b=lpfWfGykgn4xyx7HmBDsgIbcviij96cYV/BQoy2KNlg+sAyX9YTWoD+r5byVKr1AlPdmKEKDm3jfAGycBfX6+yBUfxS+q14djhzU2LXJPHmfHUf+Fr5eSOB1RsoqPvevhEd5GJgQf7PptLqb8tmkr8JYvWlXeGocT+QFnVUrHNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706024405; c=relaxed/simple;
	bh=cSv5kpizfXuvWKtM1iXvaKotp+mhbL+Nyhew9JA5j6U=;
	h=Date:Message-Id:From:To:Cc:Subject:In-Reply-To; b=mUe7r0rZxE+RR23dh2sxQeRk9krOeLKoydbrFpM9ZlJlPA99G4/qSY7GBxj6maIuoqzrHQ/xdEYuW4KdTgm9h/PvG6ezFSmP0BteI2HozbnN1Ul7NgzVyPDOaKuDguiExY3rh8yDQgr7XuoZ8grt1vwlS/krXC9HBs+nNTh6brg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cDscQt2Y; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cDscQt2Y"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-53fa455cd94so2160437a12.2;
        Tue, 23 Jan 2024 07:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706024403; x=1706629203; darn=vger.kernel.org;
        h=in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZEUQdRI8Gd/0gbLGZyLX0bHbCBzzLj0tCPidR6gQAKs=;
        b=cDscQt2Y04sbTEUdPe26f6jxEF0UZI5UGCJd98X1lVHaAEzmGRVxXLEcGg7ZnxD6vc
         dNxE7tJ2J83HwbSIxii0uM2Oi6QKlQrEeYYIGOs1BBfAAtpPLvlZQEq356hjsL7C4qYI
         HoyTi26hI8wRPD5zHy46PJy15Z/+uDDsv7GctoHNBsKC2h9ysjx3Ozg4vQqksGE/pxS6
         kYDLgi+86aV8nWnMfYA8CRK8sISlkYE8mHjjxEMjzn/dzNILCL9mdGxp2uvyjofSD4ob
         YFpNBxrwVXfl3t3TRlRO/pXo9tbdZ3OCMmlzuCNlKtoriF+xKANoPOF2RHm3PTz32//0
         1s4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706024403; x=1706629203;
        h=in-reply-to:subject:cc:to:from:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZEUQdRI8Gd/0gbLGZyLX0bHbCBzzLj0tCPidR6gQAKs=;
        b=Qv+ugcm6DFEGG86WNd2ZJ6UdIY+zRSZaHsyUVCcmKBSk1sDXaLFqswcHoSbuvgQNTx
         iDEIC//jj4t9lll8Ns+lFgLUkuHzl2IXmkuffslQWZrDoNe1tlytjghEjXVt9ibLt20e
         8wNanZ3ioMevi+adPQ631WBt5SzY8gdl6S+F3BtT4+FrQlumV6EkkvAU/VCEklTf2tNZ
         3RZCvl8XvaZIKI9GM1TN6tYswAHSw83CVwKn91NZveFELRcgHFTU14B81OA6CoZECdth
         yy8rGv/Z3D2aBuyeFYYeJJY9tXU87nnDODOHnXn7l/PmXPyD8L6WUEmtJxn2EBkm7mk0
         nNmQ==
X-Gm-Message-State: AOJu0YydN6NuiX8F2/fn8Fe5Dql4M1zXJ0wL5QngZBJvffIQqqQK6wJR
	N/8kGSgtCoh2pdfU1PLF31eJeKs4Kv9TSU9HauxQua8o61yJvkBXlMJLBlU6
X-Google-Smtp-Source: AGHT+IGCV4H7DLGiuA7H1eY5mBBg6lm4Ys3Or4xgrb6CUsUiFupgi50J0lwgoiSIotg/H+c4p4RB7A==
X-Received: by 2002:a17:90b:815:b0:28d:baad:aa41 with SMTP id bk21-20020a17090b081500b0028dbaadaa41mr2765736pjb.18.1706024402695;
        Tue, 23 Jan 2024 07:40:02 -0800 (PST)
Received: from dw-tp ([49.205.218.89])
        by smtp.gmail.com with ESMTPSA id cz4-20020a17090ad44400b0028c8a2a9c73sm11912941pjb.25.2024.01.23.07.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 07:40:02 -0800 (PST)
Date: Tue, 23 Jan 2024 21:09:57 +0530
Message-Id: <87il3kjbxu.fsf@doe.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Zorro Lang <zlang@redhat.com>, Pankaj Raghav <p.raghav@samsung.com>
Cc: Dave Chinner <david@fromorbit.com>, "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>, fstests@vger.kernel.org, djwong@kernel.org, mcgrof@kernel.org, gost.dev@samsung.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] fstest changes for LBS
In-Reply-To: <20240123134310.6mrzqdvs64ka6o6p@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Zorro Lang <zlang@redhat.com> writes:

> On Tue, Jan 23, 2024 at 09:52:39AM +0100, Pankaj Raghav wrote:
>> On 23/01/2024 01:25, Dave Chinner wrote:
>> > On Mon, Jan 22, 2024 at 12:17:49PM +0100, Pankaj Raghav (Samsung) wrote:
>> >> From: Pankaj Raghav <p.raghav@samsung.com>
>> >>
>> >> Some tests need to be adapted to for LBS[1] based on the filesystem
>> >> blocksize. These are generic changes where it uses the filesystem
>> >> blocksize instead of assuming it.
>> >>
>> >> There are some more generic test cases that are failing due to logdev
>> >> size requirement that changes with filesystem blocksize. I will address
>> >> them in a separate series.
>> >>
>> >> [1] https://lore.kernel.org/lkml/20230915183848.1018717-1-kernel@pankajraghav.com/
>> >>
>> >> Pankaj Raghav (2):
>> >>   xfs/558: scale blk IO size based on the filesystem blksz
>> >>   xfs/161: adapt the test case for LBS filesystem
>> > 
>> > Do either of these fail and require fixing for a 64k page size
>> > system running 64kB block size?
>> > 
>> > i.e. are these actual 64kB block size issues, or just issues with
>> > the LBS patchset?
>> > 
>> 
>> I had the same question in mind. Unfortunately, I don't have access to any 64k Page size
>> machine at the moment. I will ask around if I can get access to it.
>> 
>> @Zorro I saw you posted a test report for 64k blocksize. Is it possible for you to
>> see if these test cases(xfs/161, xfs/558) work in your setup with 64k block size?
>
> Sure, I'll reserve one ppc64le and give it a try. But I remember there're more failed
> cases on 64k blocksize xfs.
>

Please share the lists of failed testcases with 64k bs xfs (if you have it handy).
IIRC, many of them could be due to 64k bs itself, but yes, I can take a look and work on those.

Thanks!
-ritesh
