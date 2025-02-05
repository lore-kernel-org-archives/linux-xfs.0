Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A13747F
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 00:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716845; cv=none; b=SvD971ik2krTYp+8R/VBN3qKX2ETEMQr7EuyN/lgrtVCIzF9b2CIAUJAZwvP5JbkKMooAZnPR2duAxjAopsk4ZanPy/f2Utld1M0MBHFNoeM/5G2j+WY6w7eAs03yM0yjZdAJYCvc/0jxah7CMs901WPJNYL+PUCE9cmuqNdOXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716845; c=relaxed/simple;
	bh=+/yXL1wJjz02eN3Kdm9jfohg/apEqr1UJyYMFxthR5U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=auzIn9QcyKwkp4VXlmGU2w/FgRPzJs1Q5tYSIdYIKqWMGI17eIJfkSrhMb7osTUsz3NpUxzsHymBVbw2T77SgGYhl5ZuqmnRnh/K8TXnEH4W3Y2VPuuHjOCIFHz10AvG3PyR68Y0b2/1puAIAjoN7w5yDx+yi6b1t5ZCpaEPanM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=qlup3tLQ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="qlup3tLQ"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2161eb95317so110721405ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 16:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738716844; x=1739321644; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5WPDP7sJdW1xJL8Urv0i9q5ki8dF4HNWDbOOYdyAh0o=;
        b=qlup3tLQ3poHgmpm9B7AuJYUeg/boBLd1R8aPFzSlK1bPDbEQMIHyj6bHaxA8NkAus
         9tf5xTrsGWBvivMY1wz/+Pf4ReIQGcXYiNR6vn/uqOYjw5kqx08KBbX0If2PtTIv6NUE
         yLD2vfRO0DpB4MtMUaGWLNj94MnOP4QQ2ofjmzQlqYUQsuP1p+K2RuVLOY+7hWDGVCxt
         mh7Jp/DgL89FcJmLuu3y4ZnfCuXVS6UQdqKLV9DI/Ad8K4VoTxNbJmBW8u+HRwWOzlQL
         Xj426MGRjZjwF9sUJz8Qq2Z04g5KsheZyvGqt8DIxkVeA7LZB+HZV/4+iUrQ6ZUVqLLu
         GI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738716844; x=1739321644;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5WPDP7sJdW1xJL8Urv0i9q5ki8dF4HNWDbOOYdyAh0o=;
        b=sYjGltGhH5jtRgwCZtWXAVZ4qN9FAMcbh23hEfBbXrha8MnkcwsIjgqX/f/LsO690E
         65/+zucg4YNITOYnub6vidKEUy74kSXngXN0OsDAyqI4sDmVYnqckKJ2lCceAkXGeXWN
         j10lG/6AAVp2r/6rXnM/vbyv1e60+ih0OsOttYBajQEDo0bwuEwsWVnV0VCxyYK65pXB
         eYxBJhM6LCNuJAFGrlpDdBn2CFeo9a92WrJA9niIPPPTuJlCzhKgaPeC4ftQimruY60H
         YlxYsUcYyzxW1tURMJocaGndCQycDazFDIYsTVgeWsahZ821WDI7vuQNHnHLQmUsso8y
         8sYw==
X-Forwarded-Encrypted: i=1; AJvYcCX02hPaCBt7EVOaucm078WLE0bWfFfMoYmZQdxh2mkAEwtzbfGJYgCkE9CslHMJIaGF/kLDKHx5Mps=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlhBNARV7j7MTYjy+bUScXQAW348hsM+HMfw0Rd/WY17VjrAPW
	t3b9e+rb5uFjW+pQJ81xUOF8xnDLyH5Rhb8N1JHsKOxgBPstMjZH8kII1WIQmb4=
X-Gm-Gg: ASbGnctm7GwK8mG/xnY40SMWWO+NTA8vB57kiQ2SlHCFDAODhlUpXjuPvCvKSrsAsEN
	utTM+tU47HZ1oLao1KQBWM4zSAZeCAQdsr8rUz0IE9Z/B16QFl1Bg7gX7No3DYVOsMf4NizHRle
	TtecTD2OrqqXVTNuaKYkXxgPUGRMZ01KFTDEl3s87xa3okGqWLXfdbR0VMbvA2A8Tb5l8d5c9vT
	tY8A/dlv45akERau7Ilw/OjZ/T0f5qc01RTTV9L4tBeuwCzqshjiUapBeFC6deqbQMtQZ44dI2f
	L4XgMdlHqIt9weP2TAjmd5i06uqhXTzW51Q2ZfkN7hMW3MihFt1F04IP
X-Google-Smtp-Source: AGHT+IEt8BHfdLB1kFIXC6sxuzMiU8rE28EguFSG/rsOx2Vu09UfWIviVCPiXWtqDz2h95NhKkPZ5A==
X-Received: by 2002:a05:6a20:9d8f:b0:1e1:bd5b:b82a with SMTP id adf61e73a8af0-1ede88d589cmr1640894637.40.1738716843703;
        Tue, 04 Feb 2025 16:54:03 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-acec0477a9dsm10661363a12.50.2025.02.04.16.54.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 16:54:03 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfTg0-0000000EjUm-1fay;
	Wed, 05 Feb 2025 11:54:00 +1100
Date: Wed, 5 Feb 2025 11:54:00 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/34] fsstress: fix a memory leak
Message-ID: <Z6K2qJO0cHZu0gmB@dread.disaster.area>
References: <173870406063.546134.14070590745847431026.stgit@frogsfrogsfrogs>
 <173870406549.546134.4341905130116308600.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173870406549.546134.4341905130116308600.stgit@frogsfrogsfrogs>

On Tue, Feb 04, 2025 at 01:29:52PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Someone forgot to free the iovec that readv_f allocates.
> 
> Fixes: 80499d8f5f251e ("fsstress: new writev and readv operations test")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> ---
>  ltp/fsstress.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> 
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 9e8eaa6d8656da..14c29921e8b0f8 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -4652,6 +4652,7 @@ readv_f(opnum_t opno, long r)
>  	}
>  
>  	e = readv(fd, iov, iovcnt) < 0 ? errno : 0;
> +	free(iov);
>  	free(buf);
>  	if (v)
>  		printf("%d/%lld: readv %s%s [%lld,%d,%d] %d\n",

looks good - writev_f() frees the iov, so this now matches.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
