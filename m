Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4374310785;
	Sat, 17 May 2025 03:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747452039; cv=none; b=CKV0iGogfWpta5EulYMVw2M3lCFlqEey+ah/Jkb4PJPkJ0bkq9o3y/K/SgTWQxAZ0AEzRyzdMl1LT1Onxz7QTaeHK1tz6Qq3LBGBJXpQUN2aSksFZw4/wf3Ov9As5SPsFkYSPwTD8A3TQ2FNrBG5Q9yUG1FNl2mep2Yi0N6dj9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747452039; c=relaxed/simple;
	bh=/kxuF7iEy+qR+aUNvEHc3MT1sSG14HH49CRlBQ7XkfE=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=tfhUmu7oFEna9HptBLFxBbgVWFu2rjlec+OQ/wBu7bb6RoJc6KTcjHYjWMyA0BMDUw4hM7gpdQ3s+zxME1h6M5W5mYJ22htLvVGZ+XWAs5WPz4Z1g2zQAOBzNmpQivPzVscdvEyKKro0ZqvvZ7kyeLSPXL9ZYy9a9BSrA1v0kTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hJtj/Ui1; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hJtj/Ui1"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-af5085f7861so1829058a12.3;
        Fri, 16 May 2025 20:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747452037; x=1748056837; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ybgiKoRpwoEyTx8F1urPsFYaMNJQTkV8K/ndEgniD8Y=;
        b=hJtj/Ui1x/cj9ZQRYQenFAt6dD+NV5gsnlX2r8ICdiPB0FJ9xFzGTmugp63+J6G14Y
         2iUvNQDo8Yu86thBs7SZzXYTI3S0FzYhmOokhLfW91v+St510KtND/uiipkJlgMhQTBW
         NI8E7HrXoSOd1um2yP0Lt1lQT+Jkj3XSrHzBnDezXtegJvrOyLJ9eIq98Zim+Oamvhbj
         8Gpp/o98n+Zk2Vuv1PLtADO3nElPmLIdKX9LdAsN6pqLkmANCGaOa4IK6rtGokj1/3wZ
         QUgdjM+/pQwbeHgtLxuDfKBrG5fxaXRYfKmXPFI8+pKkpCvnCjtHSxebRHFZZxP0m4ah
         nK+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747452037; x=1748056837;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ybgiKoRpwoEyTx8F1urPsFYaMNJQTkV8K/ndEgniD8Y=;
        b=UFIkEcyad3CyaCjVAbb/N4ySE6wLU4amChaFbHrV5AiMQb34pbdn/au3fXgA4rKwWb
         Go78eX3gaXFAhQVseByghtdBKMa4Vk1f0wd++IBkW50ITzAOLLzmsZ4kp7s8rq9aFCHm
         fLhXspbPxxv2KUFjiofpelfeYJP9bXjIm6bccRa/fNX7WBBaSfBKwKeCiYUsw4gsQFrn
         QGqBVpHJ3QlAmKgjG3QLoWtUSxI5rNv81aJi1JGDpmJjjs8QQmDCsbaRwwul6xD6mWaE
         jAEkiscUgFej67fZln5zuaUA+mcYfAROBiddqNvrtzIxcTgqt4sjJO8Rx6zPmLWqjzjB
         SSFg==
X-Forwarded-Encrypted: i=1; AJvYcCUJdMtp2KpToxfQjqRLqjsECTPiz5XKW+Z0OuMc5ey4wm9gFGwRMu9Kz5Y9IvQXc1uTkd5SfpLE3Wm1@vger.kernel.org, AJvYcCVXPPC5PR8PEL7FqG+MuRCWKcR0fakyzKeJxHT0XquNnwXcWkD6GhU7O710Ad5BN7PdRTGdUucD@vger.kernel.org
X-Gm-Message-State: AOJu0YwEg+S8N2J/CHjtisB6bEdVTZ5y9OZVO8GmNPxn3sco1xlIDvs3
	Yjs3k5GP7Xo5gHhgWYmVUnG5Xfyy9qV7wKtZ5JgJ8l0DQDFUWi7bBIpxoP0O1w==
X-Gm-Gg: ASbGncsxxkaCTxNEtdtuEj/mJethZ3kydncvWT5SzJr6+ufdugvChAbhZHcNK6bj4l0
	6jq7GjDnDyACYpU5jSrn7O4i5U17Os+I1k7GhUnTC1dIPvIaiBGIdwZjcoztcxIGjwsn/B7RuK9
	E0P/ojZnO6zSzutsG2c1kh9mud0HmyWHxmPR8OamSrGsRUbnUA7HY+VT6LhkNNczUpQMIVOWwsQ
	ulgQphshg8/SVAX90Pi1b6hO3I8E/SEMlIgds5PF2jHqDOTdipvwSIssMcPvyffwRXrrKIC+IzV
	xAt0axUaGBpc9wkIDYHGDr0hG2MNFRnm4uozKff59Ao=
X-Google-Smtp-Source: AGHT+IHxzNoEUtBRszGRYGQaOsGGcP+6ul6stey53vEOSDY5sWLmK0zHzJrjhqtsadzRKVyRIm0loQ==
X-Received: by 2002:a17:903:230b:b0:224:10a2:cae7 with SMTP id d9443c01a7336-231de370f6bmr74750585ad.40.1747452037228;
        Fri, 16 May 2025 20:20:37 -0700 (PDT)
Received: from dw-tp ([171.76.82.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4adbf5esm21606245ad.64.2025.05.16.20.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 20:20:36 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 1/6] generic/765: fix a few issues
In-Reply-To: <20250514002915.13794-2-catherine.hoang@oracle.com>
Date: Sat, 17 May 2025 08:47:29 +0530
Message-ID: <87ikm0vsc6.fsf@gmail.com>
References: <20250514002915.13794-1-catherine.hoang@oracle.com> <20250514002915.13794-2-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Catherine Hoang <catherine.hoang@oracle.com> writes:

> From: "Darrick J. Wong" <djwong@kernel.org>
>
> Fix a few bugs in the single block atomic writes test, such as requiring
> directio, using page size for the ext4 max bsize, and making sure we check
> the max atomic write size.
>
> Cc: ritesh.list@gmail.com
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  common/rc         | 2 +-
>  tests/generic/765 | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/common/rc b/common/rc
> index 657772e7..bc8dabc5 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2989,7 +2989,7 @@ _require_xfs_io_command()
>  		fi
>  		if [ "$param" == "-A" ]; then
>  			opts+=" -d"
> -			pwrite_opts+="-D -V 1 -b 4k"
> +			pwrite_opts+="-d -V 1 -b 4k"

I guess the discussion already happened that this needs fixing.

>  		fi
>  		testio=`$XFS_IO_PROG -f $opts -c \
>  		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
> diff --git a/tests/generic/765 b/tests/generic/765
> index 9bab3b8a..8695a306 100755
> --- a/tests/generic/765
> +++ b/tests/generic/765
> @@ -28,7 +28,7 @@ get_supported_bsize()
>          ;;
>      "ext4")
>          min_bsize=1024
> -        max_bsize=4096
> +        max_bsize=$(_get_page_size)
>          ;;
>      *)
>          _notrun "$FSTYP does not support atomic writes"
> @@ -73,7 +73,7 @@ test_atomic_writes()
>      # Check that atomic min/max = FS block size
>      test $file_min_write -eq $bsize || \
>          echo "atomic write min $file_min_write, should be fs block size $bsize"
> -    test $file_min_write -eq $bsize || \
> +    test $file_max_write -eq $bsize || \
>          echo "atomic write max $file_max_write, should be fs block size $bsize"
>      test $file_max_segments -eq 1 || \
>          echo "atomic write max segments $file_max_segments, should be 1"
> -- 
> 2.34.1

Otherwise the changes looks good. Thanks for fixing this!

-ritesh
