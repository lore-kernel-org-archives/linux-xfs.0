Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CB62FF16B
	for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 16:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756138094; cv=none; b=FK/iCILLGZLHtoudG8inQjBk88IFadu1BIF+Fn2hb1SMEbUlImFmnLiFC48vh9iCikBCWztqgkDPo7QZ+p+t1puY7t970DX6GFcMWRPL6VbIlpaoBMclG1GfYpHaALCY9hFQjmEGJJWmIIIN433TAtR5Cz8XJOzLrDlIcn7JRuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756138094; c=relaxed/simple;
	bh=lx8unmZZotH1lOPOwGBWaz+oEXYueOAZnio+N2QuHm4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TRAGxZwHAwQmpqVo1gYsMflUhZvqe5PzZ6p8dVzmTbO/cVpGNh/URsOMuZRITB9Zsj/6BnoloaOTPhT3zseDZ9to/hriiAk/5UmthYzVfdohVMeHBWZ8gxnkjfZxeBtTMbWS3Vz2yUDkTkHKMoCSkmiDic995jD0HUOY6UlVu0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aAPKs58T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aAPKs58T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756138092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S26mrjD5N2pdJld3xZ+GOHAoTX+ohujbOU33KruSQAI=;
	b=aAPKs58TzQhtc0je8KghmU6FG7wRafWB4AGY8weOP8zAbxYb0TF3sExski+kWOl8W+xlov
	fUvXQGTV7ozNqmD5bIYi8UsUNUmxDIa9WuMeZGp2N40+vIHlGywFpRPDgHxta1y0RitEX6
	q1CeGy98OEfonk5mMOO+QjlAprNL8ZU=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-EdeWY5eTN-Sm2m9D-TYLxA-1; Mon, 25 Aug 2025 12:08:08 -0400
X-MC-Unique: EdeWY5eTN-Sm2m9D-TYLxA-1
X-Mimecast-MFC-AGG-ID: EdeWY5eTN-Sm2m9D-TYLxA_1756138087
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-b49de40e845so873535a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 25 Aug 2025 09:08:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756138087; x=1756742887;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S26mrjD5N2pdJld3xZ+GOHAoTX+ohujbOU33KruSQAI=;
        b=Njo77CjIKcp5Kwp3nJ1Q0NYUXQlHgMT3zrPu4bjC9RkOnaJi2iap92Gd81IgguQ6NV
         m+z9nf/b9p8w1A2r4jt9aMr2DtNC09YsS+toIr2aRss1QJ48ZUHoHAi/8Ar7Kn5l7uXt
         +WmEdSxZ6llOUVVJUWbXCeV36flfsh0Tqr+pcQ3mpnnIBojRWGGxP9LCugDPGn+0hFQH
         5HrEq/jgeN/lRBafoogWMhA8/fe2apIFr9MsWlFjKG2lJWl/1YN35or78+OxB/KG1v5L
         YryO8fW0S6t2rW7xjZfuHn+X1EaoyRlmkOzyAKXXDsJX+KQ+QYWTJO5KvVwsKU3Zw9Dc
         HW6w==
X-Forwarded-Encrypted: i=1; AJvYcCVOi5rCNgiU5GzYLPMmDt3xMatbyLpCLqG+SqWZxQUKUhX/ShcHv2H5BfNkRumJLkGujmcuLGqc1+E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoFQJ1QY2o5kQFcpucPBiVCwMLPl3YKODeGCFgyM95Ggg4Jzh+
	FuNqv124QHfTZFXe95ReDAL8W95r1FkfuT+sYRDV+lAEPJ0fF5NfAm3nBn0GBbTrob3/Da+QEDl
	lt/BQZxSRNULVsT6W1cbBreDb+gfA3Nlk0LmOOhEXf6R0/5zRAAeRgBBsiPEUQg==
X-Gm-Gg: ASbGncvGxkzV7WdJAQupinQcC8+E5oG0YODidWf/7tbCZzvCJU1ESC/O2ZZr5cPl59z
	GDdoZ9e0vnmSIybth/kqLvki2pYyWU/8IcWozf6crNKLeWNFM6ZcwNfvGE2f/S3eXp2JGzWaO3E
	RJUGjSgGLIr61mMb40K/hts9lBIFTMQQQVa6qFEgA8EslqVQuawKfcbaOMPfVj8ZQOLRU1Pvz+N
	eLwZ72Ba/MkZ4qBktuCT9KxcJ+vzu+c1hfu1Mw8IYff3VtLdIPAEc2dDuM+tRV5u4agUtUAIsJc
	67429Tmv6xYwkAubTm4GY4KfGpibZsvSsTeIplZbUvEHsizpQWiISIO6p70ab7NN8cX4Rsx13qJ
	y+FjT
X-Received: by 2002:a05:6a20:7fa7:b0:220:631c:e090 with SMTP id adf61e73a8af0-24340884ecfmr17792504637.0.1756138087328;
        Mon, 25 Aug 2025 09:08:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFuGQjcHakFAYSJasLNIwmwH5AbB+ig9C8K1dte2zhi+ECS9Vuy2ZlNckCYG18AokysGYZ0Zw==
X-Received: by 2002:a05:6a20:7fa7:b0:220:631c:e090 with SMTP id adf61e73a8af0-24340884ecfmr17792475637.0.1756138086873;
        Mon, 25 Aug 2025 09:08:06 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cbb7c09fsm6956388a12.26.2025.08.25.09.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 09:08:06 -0700 (PDT)
Date: Tue, 26 Aug 2025 00:08:01 +0800
From: Zorro Lang <zlang@redhat.com>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: fstests@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
	djwong@kernel.org, john.g.garry@oracle.com, tytso@mit.edu,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [PATCH v5 02/12] common/rc: Add _require_fio_version helper
Message-ID: <20250825160801.ffktqauw2o6l5ql3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <cover.1755849134.git.ojaswin@linux.ibm.com>
 <955d47b2534d9236adbd2bbd13598bbd1da8fc04.1755849134.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <955d47b2534d9236adbd2bbd13598bbd1da8fc04.1755849134.git.ojaswin@linux.ibm.com>

On Fri, Aug 22, 2025 at 01:32:01PM +0530, Ojaswin Mujoo wrote:
> The main motivation of adding this function on top of _require_fio is
> that there has been a case in fio where atomic= option was added but
> later it was changed to noop since kernel didn't yet have support for
> atomic writes. It was then again utilized to do atomic writes in a later
> version, once kernel got the support. Due to this there is a point in
> fio where _require_fio w/ atomic=1 will succeed even though it would
> not be doing atomic writes.
> 
> Hence, add an explicit helper to ensure tests to require specific
> versions of fio to work past such issues.

Actually I'm wondering if fstests really needs to care about this. This's
just a temporary issue of fio, not kernel or any fs usespace program. Do
we need to add a seperated helper only for a temporary fio issue? If fio
doesn't break fstests running, let it run. Just the testers install proper
fio (maybe latest) they need. What do you and others think?

Thanks,
Zorro

> 
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
>  common/rc | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/common/rc b/common/rc
> index 35a1c835..f45b9a38 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -5997,6 +5997,38 @@ _max() {
>  	echo $ret
>  }
>  
> +# Check the required fio version. Examples:
> +#   _require_fio_version 3.38 (matches 3.38 only)
> +#   _require_fio_version 3.38+ (matches 3.38 and above)
> +#   _require_fio_version 3.38- (matches 3.38 and below)
> +_require_fio_version() {
> +	local req_ver="$1"
> +	local fio_ver
> +
> +	_require_fio
> +	_require_math
> +
> +	fio_ver=$(fio -v | cut -d"-" -f2)
> +
> +	case "$req_ver" in
> +	*+)
> +		req_ver=${req_ver%+}
> +		test $(_math "$fio_ver >= $req_ver") -eq 1 || \
> +			_notrun "need fio >= $req_ver (found $fio_ver)"
> +		;;
> +	*-)
> +		req_ver=${req_ver%-}
> +		test $(_math "$fio_ver <= $req_ver") -eq 1 || \
> +			_notrun "need fio <= $req_ver (found $fio_ver)"
> +		;;
> +	*)
> +		req_ver=${req_ver%-}
> +		test $(_math "$fio_ver == $req_ver") -eq 1 || \
> +			_notrun "need fio = $req_ver (found $fio_ver)"
> +		;;
> +	esac
> +}
> +
>  ################################################################################
>  # make sure this script returns success
>  /bin/true
> -- 
> 2.49.0
> 

