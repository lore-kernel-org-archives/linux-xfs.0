Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31203D544;
	Mon,  9 Jun 2025 04:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749443090; cv=none; b=P6HTNG4MNvbcOgl0FvfpTM54hPH1yp4Sejt2PFhW9v8PYLATCrJvEadxWJJo5hb7evlRWh8tJ0vCG8ZKkpjCZ0L79V69Ia4h9QhILp8teS7tvPIlxxNbSwCUd2ub0Pu70Un43Z0pJcTeMmiZStMN8a4Qi6G+SJIRyJPwCLQUlfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749443090; c=relaxed/simple;
	bh=l2L6GHlrWoPBibQkBWsIpHpOXT/8limu298tzfvvLwU=;
	h=From:To:Cc:Subject:In-Reply-To:Date:Message-ID:References; b=cyVczVObk9eNE1oBoZx1ZQNRCBdSVo5vWNB+LUERgDWLEnrydKsE/cEwNzqEtjI2z+pZDcfQZjNUBxL0lRpxfqIftLWhxBHx8sUgy+gNT4RYRK4os79Ux6C/HeMb0UqH0U745HytFYAgIEi8fb2QNk/Get+He19ry/p7BKn0XKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BX4ie98m; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BX4ie98m"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-74264d1832eso4454569b3a.0;
        Sun, 08 Jun 2025 21:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749443088; x=1750047888; darn=vger.kernel.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=h5hw1X/Bp3Ok5p6bqNmTa1I9H//Ca5M5727JN2HKSqw=;
        b=BX4ie98mw4CYyJaQ7XxnA6hjvze5yUNbg3v0xuetFCOtlek1zeZ+36IJDcFcq/Dr4E
         42PksFGR/h2M0wXmmkwcfGxiy11hW8OoeedvuX/HtWmo4KExJlUD98p07l6h/Es74Di9
         pHNL0iWwCe1umBhvw9/8OuxeHbtFwO+RlMLYH6XicRw3O5M1bCxWkzI5stqRoV8V97YH
         ajfhPS9sKXUEJx3J3FeDpxn54vGMdW2ZuIide1fk91zeqpqX/SsU9DkcdiR+T0pWiUPy
         8RWQNiuHcrv20AEx9prAxqFZ5Sjg9rgK8n/K176ssgq4aeZ2+lu4zmveN+tx3OTl1WAm
         JTpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749443088; x=1750047888;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h5hw1X/Bp3Ok5p6bqNmTa1I9H//Ca5M5727JN2HKSqw=;
        b=L8AF6aOAFmt93dq5X5GxVbfaAH1loKYx+nrhFk5R+7e4ciCFF7NN9UpdyG+cuJQugg
         4h6kRu5VUtkHMGEP9zfteUjfnnIH95fYMSdtSWg6TeJalsn5yLmf/w990aXOdtudRGZ4
         YOqTQcoBr7iJJRg/FiMMHFN5ff46Ya3bmVEA3Zg77bBv13uJMJkuq0fs41bTkoIe3eM7
         AEHclTK4ul3uo121E59KIH0K0OT474bFzXU+HDzmB6l2warFmyroA5iS7vSvT+RQpzWk
         K734hog6bVnRp/yTpob/+YbF7IOfVq8q6O+XyW20iHVWVknd8mBwhd+gvT5oOIYO4qGH
         Blmg==
X-Forwarded-Encrypted: i=1; AJvYcCUDf4EuehVqAvNrLomheyqyv0zC7eHXrREorDxRhjRyqly1dHyC0GlOVU0/Da6r+ZvkGawAjhZw@vger.kernel.org, AJvYcCUwNg0w+1FvgSvZrQULPgYap9wbQKxtNVKpeyZOD8ktaeiX5OlHDVyO/0lYteKCzqjSH5vsv2P5GNOU@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1d69pRe9V8UcPw6FLzZZ7d84PEgBOKQlo24NOMvP3rlbMmIjU
	jc8C5+txJ0LdH5AJlABR6Q55+DqTIY04YJ+aBocg946TkKOKDieiuQR8
X-Gm-Gg: ASbGnct0WNEmFXASrS61czbINP7dPKcEInylWiell8lhPDntZnIbA51jWF+1kJQ1NK5
	F1/L8P/mbQBNKk0/Nn1Wh57QZH0LKu+aOjOTEkANrAdzQG7C3TyxgXCL8IBKv2z3UhO2HmsAUXW
	iVHjUDRaMY/wr9hgQssD88HpUXClxEHDl0EuX9QhW5XLRqmBfYenaRuRI0WQr9ETZ2HE2zwDpwL
	r2cD+Un3kFpBfBryYda86BLz+MTWP60MbMg0AuM9Lrhc2xzsSa7r0hWw5s78fDw9baVcRdOD9E1
	35ZEdBXKjkUHV8ZSpNQLXWktfA0vbgwRtv1tdOwMM7gpmVIOOShG1A==
X-Google-Smtp-Source: AGHT+IHIpX9hMqg8kwh8CODPzrjTeZKsfj3+sVvLgdoxG45tf4H6Bpxgl/LHPmoMafUNmeUXZGdahw==
X-Received: by 2002:a05:6a00:18a1:b0:742:b3a6:db16 with SMTP id d2e1a72fcca58-74827f3315amr16614371b3a.20.1749443087900;
        Sun, 08 Jun 2025 21:24:47 -0700 (PDT)
Received: from dw-tp ([171.76.83.10])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7482b083a9bsm4814137b3a.77.2025.06.08.21.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jun 2025 21:24:47 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Catherine Hoang <catherine.hoang@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, ojaswin@linux.ibm.com
Subject: Re: [PATCH v3 1/3] common/atomicwrites: add helper for multi block atomic writes
In-Reply-To: <20250605040122.63131-2-catherine.hoang@oracle.com>
Date: Mon, 09 Jun 2025 09:53:25 +0530
Message-ID: <87ecvt4k76.fsf@gmail.com>
References: <20250605040122.63131-1-catherine.hoang@oracle.com> <20250605040122.63131-2-catherine.hoang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>

Catherine Hoang <catherine.hoang@oracle.com> writes:

> Add a helper to check that we can perform multi block atomic writes.
>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  common/atomicwrites | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/common/atomicwrites b/common/atomicwrites
> index 391bb6f6..88f49a1a 100644
> --- a/common/atomicwrites
> +++ b/common/atomicwrites
> @@ -24,6 +24,27 @@ _get_atomic_write_segments_max()
>          grep -w atomic_write_segments_max | grep -o '[0-9]\+'
>  }
>  
> +_require_scratch_write_atomic_multi_fsblock()
> +{
> +    _require_scratch
> +
> +    _scratch_mkfs > /dev/null 2>&1 || \
> +        _notrun "cannot format scratch device for atomic write checks"
> +    _try_scratch_mount || \
> +        _notrun "cannot mount scratch device for atomic write checks"
> +
> +    local testfile=$SCRATCH_MNT/testfile
> +    touch $testfile
> +
> +    local bsize=$(_get_file_block_size $SCRATCH_MNT)
> +    local awu_max_fs=$(_get_atomic_write_unit_max $testfile)
> +
> +    _scratch_unmount
> +
> +    test $awu_max_fs -ge $((bsize * 2)) || \
> +        _notrun "multi-block atomic writes not supported by this filesystem"
> +}
> +

Looks good. Please feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

-ritesh
