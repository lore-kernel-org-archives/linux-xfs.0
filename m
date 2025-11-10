Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CAD13FEE
	for <linux-xfs@vger.kernel.org>; Mon, 10 Nov 2025 07:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762758322; cv=none; b=usvfse61jjPO1yXg4nTJvXe0wDVflBU88NGK1rR20RyebyU6/a6nCgPv/fCnDi4k5rZvSHEnuQD0U/fbJJANJ5CHRMGA/pLVFK7LX+CKZ/cBxZjnrGCshyJPSOBf/qaxd4d275NN8idLmPN2DM3kcGxkU8xTMbDmboUqZhRZb5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762758322; c=relaxed/simple;
	bh=wpL5KWGb0039Sr9UQHi3F2lcrtsh1qdmABHLkX8vNFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AgEowJEGQv5S3x7ndH4OKCcb1h4bdNVFRDW+IfTbAh/slsV18pebPSffzAT+CeOvvU15Zpg/b0FzLfMP/c+TLZHSI3jJ4XIJHu+mO2EoJvoHC4dgV6ESJpaEb4uHQyYBuIbDpxXFyio2JiALug2Q925c1+uXPwvdcKbwhtAL0AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CaOL7eKN; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CaOL7eKN"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-781ea2cee3fso2080791b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 09 Nov 2025 23:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762758320; x=1763363120; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k99idx7SpElIVO+5obOGRQZaAqg2b1tpGB7ljX2G6xQ=;
        b=CaOL7eKNWh3njp7HQJOTS0G5CErG9s19TB0Z85ITBYMdxYC8r3+vpeSnR66vEU3Tbx
         PbMmtQqMgEMKroz1h4ILROe+jzfFAL3Ix4VgOPGuNolnzGGnPqR6btoJngliQG4nFI+k
         3KQx7DZ86kE/thQmZzdqqaP7fNkhtfSIR/xM1IxfiNWp7YUbDFHZeL6OK8tcV0lAXcZi
         s59sI5W/LdKCU3wxV0ifbocotQWuPaVK4WR8zBH6dpmSwYoXGDW+fIz3heWYul4DNnKa
         QWnE9UMtObAzo+d1CDD8JfU3t4/oShWDhVfIKFf5Jk/alcy7VB9Ni6xerfmJLIv/dUu3
         YqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762758320; x=1763363120;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k99idx7SpElIVO+5obOGRQZaAqg2b1tpGB7ljX2G6xQ=;
        b=g3bXBWL6dANxgHXZ3VL2hBn7FTP5A/2OA6BYfSIFqtOYamL4lw+YKp1iuPtFBkCfIO
         s3OQCMzEJ6g9+/6BXW+WvfSo7SIY4KqRPvhdokMY0YLBRLiQfCDzV7DrwRlOApM/5nUm
         5KndOudLDIEMexXY3jskSbjyD1wNx3EQUU3vDtj60FaKMkhQW8/LvG0rx2RwANI8zOA3
         GOhk6ZDEJ3lErpgsavvZJ6/Ko3AROPJv9CqWpN1sIirYDDIH0qa7ZhzI9pnva6J02QXq
         e8cDotCkiM+BovjM7Q3UmIXM3WOh7BNFQk5kuSUK/3z7qM45YQ7F8rIVkY9YfND4VWBC
         9DBA==
X-Gm-Message-State: AOJu0Yy5udNChdoK5v5fTMGbxrPjJGeS94kcJQaXIK6su6kjAxhTqyM4
	p8S8Srj6jXI6Bn+KoURBYLV1lspMM6Ukt0jLbJwWA8uis5ZG7zcBKUXXYoylFQ==
X-Gm-Gg: ASbGncvifZKUIpzw4oGf5+m5Hb13G2+g11BDj3yg5EvtrYCmNf7lfahllwumc6FuNYR
	cvAb8TiBBkShYKgvWsBmtyJF4Cze/R5++2iEHJw5pLtW2N8XtBNsEdqrOCEBpvOz5prFpMN4rrr
	m15sB5gNo+g6M00L7yjc2PFYPeZ9oJ2sR5ghcr2jFssLLmhA6RJwzNKwhbfs0RfePEjFzTrpYEo
	GB/JjcIjuuQ/ROMyJNMJxTci7LeF3Vvyi8WgcTK7dlK0Ed0p5gXnVkHeuZumV6u3vqdSiCTDxHq
	K0uHmDH3VEEp7g8EIKc5PR6ZI+j2vXhZNy1Ie8xyCaVREl4UDAg1vGU6S+ilYtulTlLPU28n+Kx
	cTrwrdpT21Q+LwBmpFrN06KX/7jztEdBzGjpG+5NltirWuXozkVWVh2vOJ8/kpG1lx31G516r/Q
	I2QqOdjw==
X-Google-Smtp-Source: AGHT+IEPQGYHeZVf5fsdBCkb7v7aDiNVnYuheaV0x8EKaCfVSjAnvgrUlVi8DeqJrpUShj1n7iYfoA==
X-Received: by 2002:a17:902:e888:b0:295:1aa7:edf7 with SMTP id d9443c01a7336-297e56be1c6mr82098745ad.30.1762758320006;
        Sun, 09 Nov 2025 23:05:20 -0800 (PST)
Received: from [9.109.246.38] ([129.41.58.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29651c6f797sm134160375ad.56.2025.11.09.23.05.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Nov 2025 23:05:19 -0800 (PST)
Message-ID: <e3f0a7cc-8828-4ff6-b399-36dd98d313ad@gmail.com>
Date: Mon, 10 Nov 2025 12:35:15 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V3 0/3] xfs: Add support to shrink multiple empty AGs
Content-Language: en-US
To: "Darrick J. Wong" <djwong@kernel.org>,
 Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
 bfoster@redhat.com, david@fromorbit.com, hsiangkao@linux.alibaba.com
References: <cover.1760640936.git.nirjhar.roy.lists@gmail.com>
 <aPiFBxhc34RNgu5h@infradead.org> <20251022160532.GM3356773@frogsfrogsfrogs>
 <aPnMk_2YNHLJU5wm@infradead.org>
 <24f9b4c3-1210-4fb2-a400-ffaa30bafddb@gmail.com>
 <aQtNVxaIKy6hpuZh@infradead.org> <20251105191320.GD196370@frogsfrogsfrogs>
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <20251105191320.GD196370@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/6/25 00:43, Darrick J. Wong wrote:
> On Wed, Nov 05, 2025 at 05:12:55AM -0800, Christoph Hellwig wrote:
>> On Wed, Nov 05, 2025 at 01:26:50PM +0530, Nirjhar Roy (IBM) wrote:
>>> Sorry for the delayed response. So, my initial plan was to get the the
>>> shrink work only for empty AGs for now (since we already have the last AG
>>> partial shrink merged).
>> For normal XFS file systems that isn't really very useful, as the last
>> AG will typically have inodes as well.
>>
>> Unless we decide and actively promoted inode32 for uses cases that want
>> shrinking.  Which reminds me that we really should look into maybe
>> promoting metadata primary AGs - on SSDs that will most likely give us
>> better I/O patterns to the device, or at least none that are any worse
>> without it.
> I don't think we quite want inode32 per se -- I think what would be more
> useful for these shrink cases is constraining inode allocations between
> AG 0 and whichever AG the log is in (since you also can't move the log),
> and only expanding the allowed AGs if we hit ENOSPC.
Makes sense.
>
> (Or as hch suggested, porting to rtgroups would at least strengthen the
> justification for merging because there are no inodes to get in the way
> on the realtime volume.)

Okay - in that case, I will start working on expanding this present 
patch series to be working with real time groups as well. Thank you for 
your suggestions.

--NR

>
>>> Do you think this will be helpful for users?
>>> Regarding the data/inode movement, can you please give me some
>>> ideas/pointers as to how can we move the inodes. I can in parallel start
>>> exploring those areas and work incrementally.
>> I don't really have a really good idea except for having either a new
>> btree or a major modification to the inobt provide the inode number to
>> disk location mapping.
> Storing the inode cores in the inobt itself, which would be uuuuugly.
>
> --D

-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore

