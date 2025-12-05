Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1555347FDE
	for <linux-xfs@vger.kernel.org>; Fri,  5 Dec 2025 15:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764947221; cv=none; b=d4KolGy5PVha9YdyZIOxSB3A/Xfo0J+y8qcpX9S7FRAd34+j4WI8kcI5ZglPXBN3hAYaD7BIbcPKRsDzZI37xKFInpPNKo1wVhNuaJsgn7K5shQvEblO7EajkSQo0lkVMmR7y05QQGm60b1zGg5G+9uZVERX+gb8DbsuGcsM1QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764947221; c=relaxed/simple;
	bh=ObQ2X9ThdBrjKR7wJuZMnmGuUGrVagP55M6+38I/80Y=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mk8EvOK4HQMhNcYdJfBCV7BB+P6ytBVGODVMckuMcrJZGtiFqQP6hCmeyTCUE0sDqfmrvTOtZSwKQTqs/Z3G9EdSTU3sTGyVCBvlNuEubqu5UDYLGJlruatSIa2LaqX+KnVC321hBg8FufCs/91hCstvO6iuzEzqd6R5Oij6Q50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AawMen6f; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=W9VWRlC4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AawMen6f";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="W9VWRlC4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764947217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGnyO8y3nti4MaZashmhkl/6VE1hWdw//hZw52s3X+w=;
	b=AawMen6fdMFe3nCFTRMf/JtTBFYyZ5Dr7W4haDwcqMCkrqC/BvoWQNN3HOOo1qMxRCRhD5
	l5WyEwOZphoYSeJrJrdc+raDd6FeRh+nkCf2zTIgh7eUg0IRSaMkMu5Vzu3H7pCCBP6JTV
	/vvwlC24eUEwE8fRwBssBh16xzuOSWY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-lv622QisNh6cgQERXlR87A-1; Fri, 05 Dec 2025 10:06:54 -0500
X-MC-Unique: lv622QisNh6cgQERXlR87A-1
X-Mimecast-MFC-AGG-ID: lv622QisNh6cgQERXlR87A_1764947213
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42e2973a812so1354233f8f.0
        for <linux-xfs@vger.kernel.org>; Fri, 05 Dec 2025 07:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764947213; x=1765552013; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGnyO8y3nti4MaZashmhkl/6VE1hWdw//hZw52s3X+w=;
        b=W9VWRlC4JcArhyBlk+cH3qNxT9Dpp7MW620IfnYHGqlx0Jz/0mDcSUNv0uur+LLjZ2
         oPjdqaUAXK9Ta1f581J9nvQMlEqVGoNAQcdS+ugoTBwhurdUQcqarc0eoBGpUbUlvmXD
         jG94/LFuciEgaw/2sLMxUZZETdun7HdUegbH7Q0wMij+Z5EuqRiy+Dqtw7vR9F4OAqJa
         lscN+PZoSu/kg+Hubxtj70Txa+i9wwPhdIC+bjrHBShH7HELBIsFxF95e8irwiUelEb2
         RUFkmJ5d8980+JGsLHVjtqDiB/PCo3GNEtoMEEeApl4gs+Xj8Tte6wRjNCqPO957KcLU
         74eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764947213; x=1765552013;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eGnyO8y3nti4MaZashmhkl/6VE1hWdw//hZw52s3X+w=;
        b=bwqLcJUwNUQmu6Ixyi/+lF3fctF1vlPi7su+ab/Y44QTU1Dt+DLM+7Ep40ii1KOCce
         INjbwYNuQZVhqqSIWwHx6I1d5a4kyaMzVDH/WPSKXP9+OjyImSB4RZhxTEElF82vUvgW
         0nPd8+MJ8yxpuybF9bss+bOHftwOR6UKSFOUxABst+lQl6NfkP5Anhi1W5nvvaszmhsk
         2CGYEW2S+5Dttz4XvCfw1sjf5oQ0ezax57lFukqYqN6DrpMUPVdK25/k9k/QkMHofSGW
         q3wlTOGud82Ad6MFuM24WYiLg8CYqx1vEmp3dfasrBkNwL/aOSpGoDj9QUXL9QDNBzm6
         1Q3A==
X-Gm-Message-State: AOJu0Yx15HbuYpcxo9fyts1DOUUnlswGxT63Rp5aIEx/omCTkxHBbIH2
	gVYBPbf+iMtggmPR0rKivfxFqLtMRHDqpNnI/nNeHAyIbpHGSbPTn2JUmpzUclOxwCMlgjNVLNc
	y4Qh0ZRJ2aBTUR26HdrRPrqbHzYWYuT5gbaxG87LlvLEnGFRKHlQNYUW0nuOfLt+bbXH4bn8KSW
	eVk41ABFf5ZrFiS/nj1tS2Z5mkgNre1jmDIV3DC5epLH2U
X-Gm-Gg: ASbGncui7bEuJNKF3JfS7gPrQCvMRfBhzRbH3lmNJ40C3jhuki4GEPiSbOsMd18T3A5
	9vMzk7scMYFnEMumx+HUYE4QwAWNbcYHBeqF+Qv6peR9Nz6zMIGxYOnbKLIUNNtTNB2AweVYEvP
	IypML6Lzn0VQvdwejhFDssFP3PTWxlfCaAQkDQ8cIm6IOLBTtugfyZfKHcUcW9GpSqSvpmW2Bnw
	KQFx1SZSf9eok36fk0lMT0X/R2WtrqAUW+5DdOG0hAc3aY5PVlxeJjImqvWzrLb7mNNfEs/Di8x
	mogDE3O2UH48keVdkYhbDyVrftdJ+MwgU4B7W4ZqJ6id+NuGbI9wuJwp6Nm/KxNtobOHqXd8qvg
	=
X-Received: by 2002:a05:6000:18a6:b0:42b:2eb3:c92a with SMTP id ffacd0b85a97d-42f881e51dfmr531431f8f.12.1764947212576;
        Fri, 05 Dec 2025 07:06:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFYOLVd+858ZiJt1LBIvzlQse8WPFZ5D2t4TBmoxBGVAoI34ouHl+XC0uLPA6BvTrHoHWKQHA==
X-Received: by 2002:a05:6000:18a6:b0:42b:2eb3:c92a with SMTP id ffacd0b85a97d-42f881e51dfmr531369f8f.12.1764947211956;
        Fri, 05 Dec 2025 07:06:51 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbe8f85sm9393061f8f.5.2025.12.05.07.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 07:06:51 -0800 (PST)
Date: Fri, 5 Dec 2025 16:06:51 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: linux-xfs@vger.kernel.org, arekm@maven.pl
Subject: Re: [PATCH] libfrog: fix incorrect FS_IOC_FSSETXATTR argument to
 ioctl()
Message-ID: <5i6vygbgclhg2u25yjmfzl6oac3l6mohvjqwszosj3s7av23pi@gjylrkdzcevs>
References: <20251205143154.366055-2-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251205143154.366055-2-aalbersh@kernel.org>

ops, git didn't use From:

adding arekm@maven.pl

On 2025-12-05 15:31:48, Andrey Albershteyn wrote:
> From: Arkadiusz Miśkiewicz <arekm@maven.pl>
> 
> xfsprogs 6.17.0 has broken project quota due to incorrect argument
> passed to FS_IOC_FSSETXATTR ioctl(). Instead of passing struct fsxattr,
> struct file_attr was passed.
> 
> # LC_ALL=C /usr/sbin/xfs_quota -x -c "project -s -p /home/xxx 389701" /home
> Setting up project 389701 (path /home/xxx)...
> xfs_quota: cannot set project on /home/xxx: Invalid argument
> Processed 1 (/etc/projects and cmdline) paths for project 389701 with
> recursion depth infinite (-1).
> 
> ioctl(5, FS_IOC_FSSETXATTR, {fsx_xflags=FS_XFLAG_PROJINHERIT|FS_XFLAG_HASATTR, fsx_extsize=0, fsx_projid=0, fsx_cowextsize=389701}) = -1 EINVAL (Invalid argument)
> 
> There seems to be a double mistake which hides the original ioctl()
> argument bug on old kernel with xfsprogs built against it. The size of
> fa_xflags was also wrong in xfsprogs's linux.h header. This way when
> xfsprogs is compiled on newer kernel but used with older kernel this bug
> uncovers.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  include/linux.h     | 2 +-
>  libfrog/file_attr.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux.h b/include/linux.h
> index cea468d2b9..3ea9016272 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -214,7 +214,7 @@
>   * fsxattr
>   */
>  struct file_attr {
> -	__u32	fa_xflags;
> +	__u64	fa_xflags;
>  	__u32	fa_extsize;
>  	__u32	fa_nextents;
>  	__u32	fa_projid;
> diff --git a/libfrog/file_attr.c b/libfrog/file_attr.c
> index c2cbcb4e14..6801c54588 100644
> --- a/libfrog/file_attr.c
> +++ b/libfrog/file_attr.c
> @@ -114,7 +114,7 @@
>  
>  	file_attr_to_fsxattr(fa, &fsxa);
>  
> -	error = ioctl(fd, FS_IOC_FSSETXATTR, fa);
> +	error = ioctl(fd, FS_IOC_FSSETXATTR, &fsxa);
>  	close(fd);
>  
>  	return error;

-- 
- Andrey

