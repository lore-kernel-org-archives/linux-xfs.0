Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32F02561D1;
	Tue, 20 May 2025 02:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747707263; cv=none; b=COoBQnXiVSDYBzYLs07vNbLrOOC9nSFBsqOSQ9ofFAUp+sqzlhFQAVPDMol03peHUijQrKg9fZ6X3RLCpxyr/uW1tuUxriZgq5BxPbY2CODgCeG+iQyz/qOqB2ptMHMQltE+il9HDgBpp+m9EH4ZfjKo5g2vSiMD0fvGISLH0j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747707263; c=relaxed/simple;
	bh=cNLw3TqP9jSp3NSXHOOZsEj9QogwctG6OzKt43jS6fA=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=O+B2wDzTjzXGyJYVUQOXM99iASAkwnYJZTSZF4H7g8yfsmy7MALA0NiODehN/Ah6ytzxkKAtBGzoP3Q0QbsGkH3GsLSQhKDxNcsXP+KEE6J2/4FgTpKEI7KyGA9lSf/G/RLfIz28+UbxEhUS4SIKNXs1s5FlhdOd9FXREzkcdck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I8fa6hi8; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I8fa6hi8"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-232059c0b50so22723845ad.2;
        Mon, 19 May 2025 19:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747707261; x=1748312061; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BZpIQr+WzCDvPHqdvlJ0XvywAtp7dlQqdtEmFeNu0BQ=;
        b=I8fa6hi8akVWpwGDI37ZK4+dXRU7V8F1XHxo++RnSinYR7h741oEf6fJZFbL1xfbQN
         xcZLwLUuZFjkTY/zJQDjZrKigGrSsaOl1+yBU5wKdfH4cnp80jym3aF6LYYFtm9UNKnl
         ou4Bm1S60AqxdHEkjBrXVeNJdB5d8G66xfL1hQud2S6pZxWJs1Tt0LWpTiy2enpEER1s
         XA8Snv3ghLRPkO6KeeJjE554s+W+DcRkerx40caNA8L9zAdGC5haHTjc3in4C66LvdrX
         hfmhI4sS2c0S5fgY7nxZgvRVI7YWobHTcyI0mAsxohglHnraWyG7OY3xxRmWQlddZ7q9
         GYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747707261; x=1748312061;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZpIQr+WzCDvPHqdvlJ0XvywAtp7dlQqdtEmFeNu0BQ=;
        b=cFWiUWhD51ebcru6XW2kV75jOBirgZXf1KG6e+9ZM6UqqxKedDxYbrdWaqBJJwR9Ib
         Nv32hM9a+8XREZs1UX6r3VxKC49XTnl6bgPHYKtA1zktv04dzw/u9bQNceSLyj7kjAt4
         cBb8AXO0RQdASiehCIlhjMCZb2VgJCeiZJKUXiTpTKXPOeBga9soAb8YPNPyhDtkF59n
         S6LioXDlPNr/kIkWhUFDEFEDcoR/X+HpjkWS904WbCcOITc3nsbZmq28sGUbx7os11aK
         aK2X1iP0fSt6jqy1f3degVKnUuj9zLpSc7mJfzKMs3kx8/mVJVBORJHsnYGcD8uKwkaZ
         Z2jw==
X-Forwarded-Encrypted: i=1; AJvYcCVpP9CrMorPcRRQh+vAGlKaq5mYEsuVR8dzYM7+CqA3ZU46ar2ohEBwoj0hzglHpJgs1cfm/J3dzR8L@vger.kernel.org, AJvYcCX8KNuoBpW/1irRkE5UfIOmHbZchVNTWLe9uF9P7Xn6BCu/toAP53UaRK7KeZyM3H9JXQTDpJQ4@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/b9Z4FNDlG462QnW2dyagYDFtyPCQzsWMO+CIpX0p5kKVbeMo
	lLzBwxNweQtedIZ8moPRIjFg32G4+iNVieu66WTbVvaepV8jzj+N4i5v
X-Gm-Gg: ASbGncvDOSSjv0b0loqFZFIy4S7AgGl4lda//BG5sl7WosTyuF8NRFEXlAalwKNY6ms
	Da7XESdKBhvD4ZRxw9vLxmkaWdmnPtjeTwEJ+FAIp0+kMZm29Qjl1iIXu7grX5k59ZvUF4Bzexk
	oi+ioDAyrB6L+6Dx8aTy9+jbkPGFrnR+fAehU5dJSsMDv6rtG0wyMoIIgqC23xV8aSkvPoZQTK/
	RXKyqgeiqA/RDx1oM2E8qNMQktcY9NjvWcAM+uZa6KV7Rdx1wf+laqzUc2Ml1Axt94L78M8xaHK
	AqgEWnqCT2h4Jh7/t/uKlvqp4TZV49Kf5p/2cHK5BZDofhszIaQBpA==
X-Google-Smtp-Source: AGHT+IFu/bqYhGyjNisTNWYtSOVptKRelgwD8PaoIsKy+ZM86t3mm8TI6va1Nn5kRPutCEVuZoYVJA==
X-Received: by 2002:a17:902:ea12:b0:224:584:6eef with SMTP id d9443c01a7336-231de370161mr226630045ad.41.1747707260809;
        Mon, 19 May 2025 19:14:20 -0700 (PDT)
Received: from dw-tp ([171.76.82.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4ed897asm66501185ad.250.2025.05.19.19.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 19:14:20 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH v2 1/6] generic/765: fix a few issues
In-Reply-To: <20250520013400.36830-2-catherine.hoang@oracle.com>
Date: Tue, 20 May 2025 07:40:53 +0530
Message-ID: <875xhwvxoy.fsf@gmail.com>
References: <20250520013400.36830-1-catherine.hoang@oracle.com> <20250520013400.36830-2-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Catherine Hoang <catherine.hoang@oracle.com> writes:

> From: "Darrick J. Wong" <djwong@kernel.org>
>
> Fix a few bugs in the single block atomic writes test, such as not requiring
> directio, using the page size for the ext4 max bsize, and making sure we check
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

Thanks for fixing this for 64k pagesize. 
Looks good to me. Please feel free to add:

Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

>
> diff --git a/common/rc b/common/rc
> index 657772e7..0ac90d3e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2989,7 +2989,7 @@ _require_xfs_io_command()
>  		fi
>  		if [ "$param" == "-A" ]; then
>  			opts+=" -d"
> -			pwrite_opts+="-D -V 1 -b 4k"
> +			pwrite_opts+="-V 1 -b 4k"
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
