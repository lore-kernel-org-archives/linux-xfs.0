Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA7E142624;
	Mon, 12 Aug 2024 19:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723492296; cv=none; b=IUMnMYTY7E43UDvzXaOcJWMCKHGPeLhgILAvK+Vv6kWQL6G/IYqCuu3zzxsV8iBtmZ6u4IbU+vwlpufofvLJuB0brpVg+0yBToLOQ641btzfcm193/dhK8lb375bpgqFUCI28tq0Fo2rwakcjg2LXrlCByNqbOoiBjIk87yH1N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723492296; c=relaxed/simple;
	bh=gP/bpLciLkpKGzlsU8ReLBZJrv7PGYAYC56gE4RpCC4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=REbG6mGhFQxQ1lXquiVEVhqACItmuAGIlm2SSl0KxsFhJw0++AI4BoO9xh55IVvhR/i+ygZmZJ49WJEXBIWfUcTBhwrn/MHu0lUIIs/00xbeS2R8VYMCAvSOr8N3Hq20iRZAkmcPTEzH8G9nJu6qsNhis0n0e8sDNKkogtFGLqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XS172KtA; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XS172KtA"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-710d0995e21so3002543b3a.1;
        Mon, 12 Aug 2024 12:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723492295; x=1724097095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mgYfPRF3ACLx0CsT/FH9HD8nnUJcsRM2/FyE/YVJdNI=;
        b=XS172KtAGU6vUEFDhr9KXFu6prf3XjL4AFPsis1j8p6XPswYQWKq02YZJvb+TICabB
         3NOpXs8/m+cFMbsxkLpRI0wHzxciQESYcH517TVzCNh+JsThyI64/b7SEggVRErfzzPZ
         HOARkz8H6CWuh8bIpJKqhSNsjeTqOI4WkfEA7onYrJR3uKbbmb8kwGOwmtHmGmxwT82E
         FE8DmOjtw7lvOvg6AKfCkgOOP6OSRDKXoltsQqTi0TvKET+BFvZpAMu9WZvLB9UYmNrv
         GrQbpGd1tpOWUnJE9u472GF03AfS3hlMZ8dSCpbkD1RSgmUvHsRVuWYJE9xO0JcvYJWU
         lMaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723492295; x=1724097095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mgYfPRF3ACLx0CsT/FH9HD8nnUJcsRM2/FyE/YVJdNI=;
        b=D3ZgeGEwGrLAYXsj2YNbsOAKUqoOO185pj8Jj1o4Vmno2Jz8YPSuOANvV54aKNvh13
         RiRyZI4iexFtiAGEKOdLpLYqO3nFPuDTLX34TQW+ByoKWETvG+Of0iDPJn/mkxoZRzHB
         ZIy2KripQlW9wo8WvNkiC5IIBPbhQxNxbzvtFP9e917RkquWWXlB0qkuWc82m1z0u/di
         E8ljZNIMc0LbGokGK6avXFxPnH3Si8BGHRXzjjPUxoGU6llLN3xSs22+ZPnzBAafM5SU
         NTprNx9J6v8aOurVV79uKD8jVwCf76b6iwBbTMs05bJT0aJ2Wy29smnYr0PK5R0RO/GJ
         GZ1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXgiiSU+ECJVfJsVdnOdJhZMtIP18nBa3N5urGQg25+eWCvFKK3CeYbRh5JeWy0tSUjoSHdpUt42LgoUhC7PsDTF3SVlR96tOZrbqmfko504LZidTAFZHOJiztiOauZcmSpf3B4wujZpeSm4XymJHRv7yWjViN8lV4apTqAtXcZ
X-Gm-Message-State: AOJu0YyfgAYzJOcEfmcx3VceOFkDX093hTPvF7TRe0qpE01Coc3WKBgq
	XVhj+RTaAFWrdSjRCzglYYdfT3GzG5aOF4F8Bo+L7uMOLUKirc/c
X-Google-Smtp-Source: AGHT+IHr2FUt5tB5Z8XWeM8c2KYnSWU7w9shzsRAxJkX4+Ub8pDm7QbwkM9TXEr1DXgbHPKFzk2v/g==
X-Received: by 2002:a17:902:ec8f:b0:1fd:67a8:845f with SMTP id d9443c01a7336-201ca136e0fmr16415265ad.14.1723492294790;
        Mon, 12 Aug 2024 12:51:34 -0700 (PDT)
Received: from dev0.. ([2405:201:6803:30b3:3671:7e47:70c8:c710])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1a947fsm595505ad.140.2024.08.12.12.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 12:51:34 -0700 (PDT)
From: Abhinav Jain <jain.abhinav177@gmail.com>
To: gregkh@linuxfoundation.org,
	chandan.babu@oracle.com,
	djwong@kernel.org
Cc: jain.abhinav177@gmail.com,
	leah.rumancik@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	stable@vger.kernel.org,
	syzbot+55fb1b7d909494fd520d@syzkaller.appspotmail.com
Subject: Re: [PATCH 6.1.y] xfs: remove WARN when dquot cache insertion fails
Date: Tue, 13 Aug 2024 01:21:28 +0530
Message-Id: <20240812195128.1095045-1-jain.abhinav177@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <2024081244-emit-starlit-dd23@gregkh>
References: <2024081244-emit-starlit-dd23@gregkh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 12 Aug 2024 16:40:13 +0200, Greg K-H wrote:
> You lost all of the ownership and original signed-off-by attributes for
> the commit :(
>

I will work on this to understand how to avoid such mistake moving forward.

> Please work with the xfs developers if they wish to see this backported
> or not, that's up to them.
>
> thanks,
> 
> greg k-h

I am tagging XFS maintainers so that they can confirm the same. If there
is a go ahead, only then I will submit a v2 retaining the original
signed-off-by attributes.

Thanks,
Abhinav
---
