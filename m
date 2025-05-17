Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4CE84D13;
	Sat, 17 May 2025 03:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747453404; cv=none; b=T0CpMVVvvIs9BB8jypYvFqwwit9mtaDdugdmOmzHG1IW318HlHfIlrqNoX5x28wvXmiwhOMz0FAV4XlL0JIvdUUb4tVXHErQWwMOsIdvxqjL4pJKJvc8mb6Dd7oM+jmqIONqV0UE/FQkZN5VDpvK7kao4m7v2uVs4jKMNkdlqfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747453404; c=relaxed/simple;
	bh=fE59lLSyOa5h1AmZZMZuoAksvzXpGw2wA57fCD7QMWE=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=SyO+p7KhO2SCVuudPHaexb387260dZWWCme7YQZj7oezFYdYywcePeEBzfE9iGJ+EKQ/DlLMptjVt7A5h59DSHG/su11u3g97kevBRjJ80F6SmFEtprepAhZBfJ3WMncWmou8beSHoTAufLLW/otI5ExEKCfJQOZzFgYA+IOx6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fwkeYl50; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fwkeYl50"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22d95f0dda4so28936645ad.2;
        Fri, 16 May 2025 20:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747453403; x=1748058203; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=toyDpFokfS43DR4cJPSZLR51eDs5cBQSQyh5Uwv6NKo=;
        b=fwkeYl50djPF0YcDm//ZZYO3dAgbMSigYZPK0ASE6ZIoLn4a7TAAf0xad7zJc8aCXV
         BgL0KhBlCbzvyYEeiKoybJED8cGj/ENUursJ6tSsxTABYhD+mvVxzvKXHPotx7ly1CRB
         F791lOgtgLHMalm3RaBag2nBVDKoAEzLQT/JnokEKP+kj7uPymO68SagMzoG6+4wO2dq
         Kw52LoVAHAQkYeveLwA1asUTiMuhZ7p6L2ruV6poF3sWVXdEMoesjEE6C+ZLh3gkzoT4
         S3f1c83pq0rYYl5c0/6LkDmBaYnuXKDwrjpYPY3u29O+pAIso+mJOVP1uPY4MGcumMO2
         qw9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747453403; x=1748058203;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=toyDpFokfS43DR4cJPSZLR51eDs5cBQSQyh5Uwv6NKo=;
        b=CK1c8uWK0iRa8nIGSpYAu4lTceB9FLh2XgDmgXhHOSl6ygxjWrydVO9JJJGDBInfSI
         GTL7kPvCysuMEORxRFSypHAvvI56cYBxl5UUn4RHx3DE7FZ3CzU4jzyGrHzE+DpG7y/4
         Yprr7Ik+c2LsdKLyojFAlzdJJWERwHmksgIg/MoCbf14d1hXj8XAB/39gUMlRaVOVbL/
         D6TGJchLU3BjamHT3PaMtz2AcwUkL1O0yHfQKu80Wz/s2LEMioWS7EiuClSzSP5GP7BT
         S7d/ZDb6tUkCE1QCx65BwNwKZ/fGtmbKtce4YUtVQRYphLRyuebaELtnwZMjfn/TTzq+
         iPnA==
X-Forwarded-Encrypted: i=1; AJvYcCUAz56Ov9nTZy+NXudyRDAc4P8KXscYojb3UEON0vvPmd1fsjlOTIeMXoGSPgMP6WC0yCgl/gGEss7A@vger.kernel.org, AJvYcCUi0yWOo2mCUPmUR0vQoAMMD00/lw1lC4lMnYuP56jgu8un4sjrHMqK7nWkmDbXc8EEiil1jLjW@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4CQe5eVcsJtq8s4IUSLM6FZI9cJuEca9XPA8hfd2bZYqq4Yfz
	3it2usMvN9NZgK+C4h5nIgPGGcoNzrJduDTvNdntkxmIAGfnRGqmtoP7FI5FGg==
X-Gm-Gg: ASbGncvSw4Hju8S0QpAqvucpF7hqgQ1pZCIbWEm9JBVZeqoShSD/jbXoA8FDRzpp5Un
	6gzmui14hCFES8/RWliCt3SE9d2j/yYYM3w3ZPxO00c+VAFECZgxlefMnVWaN91NSJYmPmk0wFC
	++ZDHf3iUITTJ4JxBsBcYoCOMeds9H0WwfEVUjA9yq+KtzLyFIo3B250PkBO8onFQpb/0khih4v
	K9wwNkx/kUfL3gpsmxX2Z4s/jS0TNrD1j28VWbZ+8VZUJvprb9pAEAyMvNhMsQ9io4ymXoQJfC3
	4pCvy5gMMoWyOR1v6AmaqoM0+E94HKK4hZvXcI0uUEo=
X-Google-Smtp-Source: AGHT+IHKrMt80BvlpDvtxy23l8Fgwetxou6EY9ToRsH/BfBraifE3ws7/EF+DZk2F40Ht/+X3VTpNQ==
X-Received: by 2002:a17:903:2342:b0:223:90ec:80f0 with SMTP id d9443c01a7336-231d4516a4fmr83532265ad.22.1747453402623;
        Fri, 16 May 2025 20:43:22 -0700 (PDT)
Received: from dw-tp ([171.76.82.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-232044a0a23sm3324945ad.112.2025.05.16.20.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 20:43:22 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com
Subject: Re: [PATCH 2/6] generic/765: adjust various things
In-Reply-To: <20250514002915.13794-3-catherine.hoang@oracle.com>
Date: Sat, 17 May 2025 09:06:13 +0530
Message-ID: <87h61jx61e.fsf@gmail.com>
References: <20250514002915.13794-1-catherine.hoang@oracle.com> <20250514002915.13794-3-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Catherine Hoang <catherine.hoang@oracle.com> writes:

> From: "Darrick J. Wong" <djwong@kernel.org>
>
> Fix some bugs when detecting the atomic write geometry, record what
> atomic write geometry we're testing each time through the loop, and
> create a group for atomic writes tests.
>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  common/rc           |  4 ++--
>  doc/group-names.txt |  1 +
>  tests/generic/765   | 25 ++++++++++++++++++++++++-
>  3 files changed, 27 insertions(+), 3 deletions(-)
>
> diff --git a/common/rc b/common/rc
> index bc8dabc5..3a70c707 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5442,13 +5442,13 @@ _get_atomic_write_unit_min()
>  _get_atomic_write_unit_max()
>  {
>  	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> -        grep atomic_write_unit_max | grep -o '[0-9]\+'
> +        grep -w atomic_write_unit_max | grep -o '[0-9]\+'
>  }
>  
>  _get_atomic_write_segments_max()
>  {
>  	$XFS_IO_PROG -c "statx -r -m $STATX_WRITE_ATOMIC" $1 | \
> -        grep atomic_write_segments_max | grep -o '[0-9]\+'
> +        grep -w atomic_write_segments_max | grep -o '[0-9]\+'
>  }
>  
>  _require_scratch_write_atomic()
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> index f510bb82..1b38f73b 100644
> --- a/doc/group-names.txt
> +++ b/doc/group-names.txt
> @@ -12,6 +12,7 @@ acl			Access Control Lists
>  admin			xfs_admin functionality
>  aio			general libaio async io tests
>  atime			file access time
> +atomicwrites		RWF_ATOMIC testing

NIT: I wish we could have a shorter name for this? atomicwr or awio (Atomic write I/O)

Either ways, the changes looks logical to me. It's good to have these
various atomic units in $seqres.full file for later debugging.

Please feel free to add: 
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

-ritesh
