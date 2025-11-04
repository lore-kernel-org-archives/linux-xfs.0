Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E26242D88
	for <linux-xfs@vger.kernel.org>; Tue,  4 Nov 2025 17:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762275647; cv=none; b=fqWoSJm88htrOMibnJS9D6JQ1XRKUziobCDdkrnZxl/IdvE54c3+t7kfNyeQ38HGd2KRkA5eyDw6Wis2QyuhY3nTC1DldR96EKe8LN7qJpWdIQmgNuo3N3lGxIworc42MuiK56hn1tQOgyKxw/VsgqwOgPTeeg195Hlx3iHDadc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762275647; c=relaxed/simple;
	bh=Vrr/uSwlry0nKvIcHU9NJV1yfDPOHC8rt2Mzqj3YkMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Al29iecUn6NhSzMF+NGx9ZWrKYcCLZvjxpZfqQxrXKfYXp9PpQExT7YKe9mqYynj9MUptCTKK72vXYxt87BnuDG558oKPN68eiMeglsmRO/0mMn4hPvLIz+yreXS/rLd1FjRtlUrGWZL9YE9NSzr/nEfuZOtbiWXc/LPyPFgAtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=avXZX9aA; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="avXZX9aA"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47721743fd0so31276445e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 04 Nov 2025 09:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762275644; x=1762880444; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3Yfb6FFNpXCK7ISYxIM3MD/neK2yEBhzq7eFojyB94A=;
        b=avXZX9aAcpzUa9I1hrWCfY1uDIXVzvsm96b3e989zv9xRnpG2QiR04Zf8+svaSVG4X
         D22/wjc4aF3fyhqIz/AUWEX0+KmQogEsA33WUtv55SVWftTftxAdOg+4Ou0C8oxZE/zG
         9+MJMucOkLaNRx/5CPeHKlp14RB1zmqzmuTPe4F5RZ3FwdXwEA959Mjaauht8Uolql6g
         I8E23kYw0E4Uyvk18VEv5K7/qkr8UVZ/0kFbpJaiQ2YozPLNrl2tYSzuN1iZnuhmrBtE
         tbWcjckPkkWCTyI0NH5C9h7ghn68WiQsV7CyludR/889SrWK1viNfIwJNKXnRIslOXfR
         OnZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762275644; x=1762880444;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Yfb6FFNpXCK7ISYxIM3MD/neK2yEBhzq7eFojyB94A=;
        b=Y0Gm8Ih4dCAC07iAG4kCFpOGYvV2HdvPE8+RZnteUug/+bZ+FCFt7AtxAXks0frWeF
         8eKG8mQ1LF0bMus6NZW0LYxW/hFMALMbnE3disELhB+xa5lTK0Tt8GwoFFQ/hFyLtWvM
         rzYWI/Ls4dpbnDl2bYF3HcfhRd6/clu1sJDBBGex4JCsrdkJrlW2Q24WPjw5NYJwNVTA
         /KD4ArFPiAuciJggM8iMYxj217NBaQcogMDW/tYYB/F+4rGzVDZREuenLEOa2nIF7kEx
         GUxMhjbIXPim2p8xNsYv+URZmPIRUuwYLPV6FVjsErzSw9r98i0/uxE4xN1vdgCR2wj6
         veFg==
X-Forwarded-Encrypted: i=1; AJvYcCXlG0GRFzCvk55ad1H8FvOdL/ilLPvVVtL3D2AGo2TUAvrA15KD06JSOCq3HzQuuMfMIynqo/75sEM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh5xjDgjXeVDipAgm98sXkiMigQbzWqo4BnCyxbnWw3oeT1gNf
	Ru1nRRqnUhL9QcWqnMlyieD/QKxo40Cd3k+N+oRNR0/tBKuOpbgGD2FU
X-Gm-Gg: ASbGnctzJ12wJckqoPie4vazFt9S6a/5lCMAhZNFmOKdFgzxxzF67qF+6MHRy7lS9Ca
	YjWoQLHgvHRF+h8YXCsDrYK36llvYfAlduEx1ejQ76RGl+SyqxvwKSAve8+QHuv8dMSGul1ZGwu
	IOEvhOfmGPRNf/x7ULTVkIQP1Ogk0hlD6qqygEowALeI5jN2re5SmFIJgyUbPmJzMp0nARDdP+k
	k6jxlK53/mI00sFUQjEwTdySNqF/ujA6MW3aAKTCPu4AX6KY3Fj1qWd0JQw6JMS4q+UmfhcY9HD
	qnvPLzJUo3rEXmhsVE+p8hnc9f+EnOyNSvGzLJaP2K3cmp6bo6VNjFY+bW117r8mRj5NJOKomcF
	swJLL8I9WYZS5V4w6zIQeAdT0UhZbwLeGHBPGpDaoNeewlx7GAPphjNrE/bBVatWqmZfVcDnncP
	kQJ0diDkpfnSR3h1deQewxZeqqjCoB1WzcPmTlGuX9TcpCAA==
X-Google-Smtp-Source: AGHT+IH5aMD7dan6U5/w/UZRzVLH80Ar+ql1ErXcMyhqQ50Z13gZ06dshwL9yRzd5Se8p4waVSOTRA==
X-Received: by 2002:a05:600c:8b88:b0:45d:d97c:236c with SMTP id 5b1f17b1804b1-4775cdf54d6mr106665e9.21.1762275643762;
        Tue, 04 Nov 2025 09:00:43 -0800 (PST)
Received: from f (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775cd45466sm685245e9.0.2025.11.04.09.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 09:00:42 -0800 (PST)
Date: Tue, 4 Nov 2025 18:00:29 +0100
From: Mateusz Guzik <mjguzik@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 4/8] btrfs: use super write guard in sb_start_write()
Message-ID: <cxrp3a7wu5lz5o6fiwleqiqwqm6xyevdjiega77mwxy5aekeab@522tt37vnwip>
References: <20251104-work-guards-v1-0-5108ac78a171@kernel.org>
 <20251104-work-guards-v1-4-5108ac78a171@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251104-work-guards-v1-4-5108ac78a171@kernel.org>

On Tue, Nov 04, 2025 at 01:12:33PM +0100, Christian Brauner wrote:
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/btrfs/volumes.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2bec544d8ba3..4152b0a5537a 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -4660,7 +4660,8 @@ static int balance_kthread(void *data)
>  	struct btrfs_fs_info *fs_info = data;
>  	int ret = 0;
>  
> -	sb_start_write(fs_info->sb);
> +	guard(super_write)(fs_info->sb);
> +
>  	mutex_lock(&fs_info->balance_mutex);
>  	if (fs_info->balance_ctl)
>  		ret = btrfs_balance(fs_info, fs_info->balance_ctl, NULL);
> 

this missed sb_end_write call removal
