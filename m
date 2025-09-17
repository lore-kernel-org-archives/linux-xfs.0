Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB82C1607AC
	for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 14:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758118493; cv=none; b=Qnv8OX9mGdCpdzGRQ6bDc6PDvJLFFUzF7VU2b/MKbnlxkQ7KfOTXOyMWP6pt9qP5oUYttSq02l5FfByqJgiDkifGczhcLN4y5TOd7jWiHe+u3QcL/C+EaEwONOyrWRsC9OihvHvmC3WRgGuCVaiU+jQO7lH91Um20b6Uds4xvpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758118493; c=relaxed/simple;
	bh=harHSZQvgtC/E59IHZNwu3Rm04386V4hmH8FCVWR3Gw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=E8n3mY6bWps70Xl1piGxqfzWc1zHDGpVSAbIB/TdVtu/5QlK/pjYhq16DhY2QHA8l06UD9sTHbxMeUk+y1/vp6i7mGc/vII2yXlqwkJARXWitL+pLEE4nSaJf5n6Qf6469cysNEYCFJ9iBX6bY2WpH84nuJTF29NVSsimkCZbL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=e/73JgnG; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e/73JgnG"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-423fc1532bdso52721785ab.1
        for <linux-xfs@vger.kernel.org>; Wed, 17 Sep 2025 07:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758118490; x=1758723290; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JVpavbXISEVtm5+aGDVVijQFcplhsQrG94O8tBhG3f8=;
        b=e/73JgnG7wi1No9isfCJRrLkeUMOzf19k9Qhx7mhgIiH2ws19oii/VU87LNDV8fbZu
         tBKqzAWaahxMBcyqP/vfwspCAMZ2WVnMItSKV2QzaWTNcLIH3OPsibFOYIq6CxeKJXnh
         TrIMArKR1/M3gwvMBzJeTqQtu4iGUyqQg0GFQfrP6+TsOzeIdcZ9jZTdjVYUmiOvsBOQ
         hW5LTtrWtyTM5Rt2a6Zls9f5I2kajM9v/cXW8uEcjBgi/LG+RB6rNPlQ6VAYAXbj4BWz
         j5O8ynXUbom3tJkGIiHSuf3XqMVuhJYDPnFHNUJwloZMvE89h8TsQYSknce7L5oOBBYu
         RP8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758118490; x=1758723290;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JVpavbXISEVtm5+aGDVVijQFcplhsQrG94O8tBhG3f8=;
        b=riDg6MHwUbh/OjOLJza50JtjuYQNdpip8MamJLSCGJ8YtghxST7G+k94/WEL/JXoD4
         QVCQU46aibGh+aPubPN2LTcs6O0vR6hnTAiWBTdkKFkz81lXwRicuvTdkU6MK3jF9fXA
         rDX+Hy9rggTreEhAAboFx1lDUqcWUqyqVzrfHdzvQuIJUEfFp+3NvtIpRSkxdHziMXhR
         1s54yFM5wCj++1KwMb0N6pZERBb4toRFaiqDaIvCbF7TzeuHezCzoODfw3TUHGIGo0Uj
         uYdeJgjrx8LxhqxesI2PFMvR/0x/HjsLbvGcVThXo67NZdOCbWNJQv95f56iX+7x9v0I
         RIpg==
X-Forwarded-Encrypted: i=1; AJvYcCX8CkczrduqRhe9oPfajHaWxYKLm6bn6QTmjGciBKTz1hBaM+9So2fy15zlYasZYq0moyq1Ops7Gkk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxllKiuxmTdap1rBJQ13JEYO1DYyYlJ+lqGQRj3eh358jzXlVa+
	4BhznAE4QDBYVGkQkycUvt0TooGwNY7frVvlHeTDqmlr7LEYNN4xBNBJHkJokmL1Y2E=
X-Gm-Gg: ASbGncuxHYEao9K5axWpNViQwhR/cOmSo5jrfoGaHU3wFHOf3pq7CXTwmsjaFvwHfeG
	nUmeerbw3d/qOwxgEh0NSnSWzi1JOfc/6Wl+2zQbw2mnQ+mLylueIcPE+Hc4jMK7nMlCBmgqEMd
	ojBPOIIk55RULgrwAFvj3/NTESLfPRdytd0IhEdKAS5yELYP33Q45j2Kheteku1gG2wUbPLmgHA
	xLoZurr6+6ftDd6P4JNzS8EqXLByxqoKXiFrufHOO9Y+mX/VTmhV0ms2Vu+G+MEpDznIT27/Nqr
	jz0E/bmfwEbxPo40g7guYOwyxvfXpVuc3ofKsGbNpYIUj0iiN8OCiCS6k44dCe7kmHtw2gikp0T
	iC0CzGjVSkM122PrVOZQ=
X-Google-Smtp-Source: AGHT+IG8yW/XVL3oFIv432faotyl5by5gpmLB7mgov/ka8Ly2XOQKV7hnuxEJv0X7nDEg/FPrFM5yw==
X-Received: by 2002:a05:6e02:230a:b0:424:a30:d64b with SMTP id e9e14a558f8ab-4241a5297f5mr25322155ab.19.1758118489895;
        Wed, 17 Sep 2025 07:14:49 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-511f30cd025sm7033209173.83.2025.09.17.07.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 07:14:49 -0700 (PDT)
Message-ID: <eed1186c-4213-4bc3-9529-42a213083019@kernel.dk>
Date: Wed, 17 Sep 2025 08:14:48 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/10] io_uring: add support for
 IORING_OP_NAME_TO_HANDLE_AT
To: Thomas Bertschinger <tahbertschinger@gmail.com>,
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 viro@zeniv.linux.org.uk, brauner@kernel.org, linux-nfs@vger.kernel.org,
 linux-xfs@vger.kernel.org, cem@kernel.org, chuck.lever@oracle.com,
 jlayton@kernel.org, amir73il@gmail.com
References: <20250912152855.689917-1-tahbertschinger@gmail.com>
 <20250912152855.689917-3-tahbertschinger@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250912152855.689917-3-tahbertschinger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/12/25 9:28 AM, Thomas Bertschinger wrote:
> +#if defined(CONFIG_FHANDLE)
> +int io_name_to_handle_at_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_name_to_handle *nh = io_kiocb_to_cmd(req, struct io_name_to_handle);
> +
> +	nh->dfd = READ_ONCE(sqe->fd);
> +	nh->flags = READ_ONCE(sqe->name_to_handle_flags);
> +	nh->path = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	nh->ufh = u64_to_user_ptr(READ_ONCE(sqe->addr2));
> +	nh->mount_id = u64_to_user_ptr(READ_ONCE(sqe->addr3));
> +
> +	return 0;
> +}

Should probably include a:

	if (sqe->len)
		return -EINVAL;

to allow for using that field in the future, should that become
necessary.

Outside of that, this patch looks fine to me.

-- 
Jens Axboe
