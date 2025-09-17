Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240CE2D7DD3
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 14:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758118738; cv=none; b=EizEY2pL3neI6jEmoI8x0fiuYTBwV6dv9/OcWLYlgaM3lt4Qd0ubta9N2I3H3lBM+eKWU0Dr22xWYxNsfXoDN2GEvl5GiS24qcdYqsXQs2z5smkcsj7UGvEl4Qq/PYqdkOpyhLSn+HLXyg7jjZL+0GkwGrC1jfGeXU4tqj9P+2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758118738; c=relaxed/simple;
	bh=qvPmqnT0GuwUtOmZwK9Z04OkVVWN3ZAbCb5Yyg9H46U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DuF8HOG/NRW62hkVHQM6Qo9G1+qKl6oETXtfTTNsxzNbLcizBRzp98IGJcyJxEzzXMOxBwbLEajQn+0VSi0FeQAu1kZ9SwylRyfRTMxvGn00iqW3spSfzffynKdpBHQaCKsgq6ASZDpKNUta5HIAdREpncsnPiAE7soZWLihr0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Qx3lqok8; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Qx3lqok8"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-88432ccd787so400638139f.0
        for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 07:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758118735; x=1758723535; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DA3VMHiGzzibDL6pUIUYW3tloC3K1AfAFuDtTzpA7b0=;
        b=Qx3lqok8daad6D7UmMoXWjGnWkEJe+mZgMbbvxDGdJVHHzrv372rY58P5XP3mZrp6M
         mNT4ruARxZsCJdCSHvf/Pz0jaQVnHf44AAaCrIvv9R+dRBIgpzKGePvZT+Ya5UJBJKDZ
         oyrvd+Iyfee+XEuXETjiRULFNiZzLvVoXekpGke9jYqjmxOi4sh9M5lnCp6GllDPw7nZ
         2iq1jg9W3tUPYz1XhLGIh4UDfWA0ENbgkwQnmCzElkNw4CBDEu7nRYTWP/0hAszi91AI
         9KNqv1XXSxdo1axzyfOFGr+CuetDBgnoL39Vv9uhDrfWe05AePHG1ziqSr9OCw1X/ZGl
         TOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758118735; x=1758723535;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DA3VMHiGzzibDL6pUIUYW3tloC3K1AfAFuDtTzpA7b0=;
        b=McrWmEy35BGvcfielKodaLhtyg1BSVr9MLrwrBYculdOCpANbFHIz4jgMbdSC/eiUx
         MfXsK65c1DrAikq9rQ16xQTfl2CRix4xzEci8/wa80sTrIOvEeuqDVHcv2Khkb/GWqNk
         Oh059/RDVh3V6FkWT+f/pP46wmsABgoA7EmMHfmLsQ/JlM7ZTvvOrRK7ek9HwEZ/vXHg
         T49HxjwFGD44KsvXmeneaBdgpW/FFjXMsnkUnuPNP42t6LRFM1LNZeFudfiNG0gBFTRB
         M3qZwsaKu4+jIalecds3uSlMfLlyR9Ae+k/x4jZ6CTGBhbh8ecXJxSYx90UQq/rMqQHu
         hhvw==
X-Forwarded-Encrypted: i=1; AJvYcCUgTH56I16m+fghSeldbnq+mpe4dUwens2Bdyol3I1tOOqURPG1nXNIO5RQy+KU4zDisPs0cbQW+oQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzomqS5FeEMizYzBtfjJaFvwtRGoeH19vzaHb7QD0OPubM6BFV6
	D0vO0BV82dBGaGQmwny363zzbWemeSZOTXx2xRiyA8vpcVG5kgW0TAUnDPfiB4RtnUg=
X-Gm-Gg: ASbGncvzJGhrBLqK+2XpQKfNK4RWuPku6DDbzBi145iP/nVL6NL6iIkKpHUUI7pzYtt
	RD85H6z9ulkNyY8ZVXh3E+JN9GCiWMT+7I1bSgu8gPV+Vwn9cWt/Csay/c7AtX0MpOQCQK8qDfC
	lA6ocJcn+uupqlqYpWuhN0gYnLi2hEQtpyKkqhnG8JdKwhcl3rsLSx+BwWMw4HyIu8RiNuC/dDr
	gTI1/9PLNAN6hqmTuCpOrsP7mo9GfHlWWj/uIa7QNCS+GFHU+RbO2oz9f69Iebvmh5/fy4rkooc
	NB22Okb8wmP8eYPLojRT3qONIJYXc/qbomkKlXoHpeQFfrSUbV2hH51BcgLCEAEPYlF6LG02hTH
	hoLslqxmscjvPRZGUlV4=
X-Google-Smtp-Source: AGHT+IETaw7JxR4yD/B5BU++ndtz6o4tEdapBtyWCAqX6xlI0Emapaz/9BDEIacwy+P0KtLmhs7TOw==
X-Received: by 2002:a05:6602:2b14:b0:887:1b58:4e69 with SMTP id ca18e2360f4ac-89d1d4b1c12mr380124439f.8.1758118734932;
        Wed, 17 Sep 2025 07:18:54 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-88f2d0bfed6sm657283239f.2.2025.09.17.07.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 07:18:54 -0700 (PDT)
Message-ID: <c69b070f-2177-4b8d-80d0-721221fe0c49@kernel.dk>
Date: Wed, 17 Sep 2025 08:18:53 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/10] io_uring: add __io_open_prep() helper
To: Thomas Bertschinger <tahbertschinger@gmail.com>,
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, cem@kernel.org, chuck.lever@oracle.com,
 jlayton@kernel.org, amir73il@gmail.com
References: <20250912152855.689917-1-tahbertschinger@gmail.com>
 <20250912152855.689917-9-tahbertschinger@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250912152855.689917-9-tahbertschinger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/12/25 9:28 AM, Thomas Bertschinger wrote:
> This adds a helper, __io_open_prep(), which does the part of preparing
> for an open that is shared between openat*() and open_by_handle_at().
> 
> It excludes reading in the user path or file handle--this will be done
> by functions specific to the kind of open().

Looks fine to me.

-- 
Jens Axboe
