Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43BB272E72
	for <linux-xfs@vger.kernel.org>; Tue,  9 Dec 2025 08:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765270169; cv=none; b=pFqaHQ+8sg5frXqyxCAuNzI+fFyPzn3kUhyJW6QmDRVXbIApAUuZtDsi/N1ksuWkjShAjDzuZu/jMQQyEG4xaADsd/EUpCPw/lvZMzS7NM9WrqC7Iqqq7xQHxm5CJA1q3ZPNDg107q/xN2VuyADv1qu44VC09g+ytHOPKrEp3So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765270169; c=relaxed/simple;
	bh=DdEIRs5cc4Yq7d82Ls7uwak7TLMkFnF/1I/Y4+BeWCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B7CKDwroxyj0r8is/l/X6aJIa8spKUD+MvV9Dp0pIGTp6Nh1AiR0rQ3G9xhmywgDiw94Y7Jdqg8yVH70ghn4ulBdjpanVuHMfjyZ2HrwLZDqDxnZTEYYWE0O1Dt2MTUbtX0jExKwuU92eWDq5s8Cqwi3sKIF/5sb7H0YXSF89cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=maven.pl; spf=pass smtp.mailfrom=maven.pl; dkim=pass (1024-bit key) header.d=maven.pl header.i=@maven.pl header.b=G1mkOvmN; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=maven.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maven.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=maven.pl header.i=@maven.pl header.b="G1mkOvmN"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-64162c04f90so9538578a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 09 Dec 2025 00:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maven.pl; s=maven; t=1765270165; x=1765874965; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1uYDc9y5n11WDXtPR+BujeeLnepm+eU2IuJpvOyCwBg=;
        b=G1mkOvmN7k2qoMnFWpEHuOT+MbOsht6pVsNaHP9auOws2KBDIlUPN7HJGJBcVjyxxq
         7XJKI8je9EZvDjTsyF/p6JsWVy3FF7QphyayI4mCH64YN+FyNxNh/h2mrqWsSF3di3wW
         1fFkmZgu2oHe0WzDRMYA/rGYqjYGgErLcqNp0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765270165; x=1765874965;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1uYDc9y5n11WDXtPR+BujeeLnepm+eU2IuJpvOyCwBg=;
        b=K31LUr7ytVIJfkqiIaMzY6lBkZzcOFQbrU4zTAvLKi6jCJ+CTVxxbQctDgJUoRkmgG
         e2G4h/tICQ4lcDVhiJJhOlHHA/OnTQbYfS74J4hJnU6YCWkFfG7+2jbZ6zCPu/algigA
         7pTWOX//dPftx0YdeZKM9DFN9ZjHG792oNh9jHJt+to+h3gpb6oz2g9qTjFYpDJbkVtZ
         4qb2uYpfASnhLXhv1Xqctq1Xgu3Kvn7RQSydfZo/K6WHTGjN+0LvkwXPa1PijjGZzuYy
         08lrHx1ZrqLkdsJYvOnHFFBidv3hhg32gD2lerRVebcABrdSLL/ke0j4z+Y4LWkO92Fo
         hBTw==
X-Forwarded-Encrypted: i=1; AJvYcCXFZEns/3d0tGF+P1Gf7dzi2UX7t0alYHaczCh3mjgtcKVr6VWzq3LrKfoyf4IGf9lZ32Mk0i7RHVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAEBz5lZqivdM5MRn7pcKkhlzpKFb4AvirrvsmdUPHLccbrzs4
	UIC7RkEiOpvDE95mQFh1L5FBShN7+Alqnm5k+YnvJUw1rBCgViQ/HJ1U+iuxauHMu6fxpI3dj2I
	rIkXW
X-Gm-Gg: ASbGncuV6v1oLwhB9M+YbSW3hub31pcdLXqKDlgzGJB+ZFMozuPH1gGh1aWUyvOAxXa
	1ADgohYbJivcqUe02DbR4VBgqRx/giffDTqiCC6tAV28Zr4o6CqT8KAH7+C42MSKkh6etJ8vdaV
	Ps8+84Qy7cY2SYUIfqPa3AveJlcW4fPJVmHE+XZ4tdVunEal9uex05GDpqm1njJNgGBfi78rEuQ
	5uGqh19mSj6V31SdeO8SiADSVoqRHUm4mKz5RBrbLdsw9jjXzGfW1DvMh1wAvyY2EspN6J1p70/
	m+MT9fz5m6xEA6SOZ8kUNYCWOqEU7IAOMzaCSDcqGREfsmppw5zpivqTGTMrtyhd2KSSCTLUj5A
	ZyzRQPlIb5f+ynQKSHZezRcylKIwsi4+0fTEjbMKlNnULByaeqfRKFlSRKdPoZ3DhABfejcA85a
	EQvclDq+M8qYo70XUk4sertxWMLD+UyRCDnfluyCsZuZB/iOwCjiD/RWmj3kaX6Ax6R8xjN0gpf
	aimKw==
X-Google-Smtp-Source: AGHT+IHwhJBZCFiYYMvTnLjP0h6naHGYK8m5LL2HdsU6D9a7lKUu+B5ebFL11BbnuRQYd/AgWhSWag==
X-Received: by 2002:a05:6402:2813:b0:645:cd33:7db5 with SMTP id 4fb4d7f45d1cf-6491a819f4emr7760864a12.24.1765270164255;
        Tue, 09 Dec 2025 00:49:24 -0800 (PST)
Received: from [192.168.68.100] (user-46-112-196-157.play-internet.pl. [46.112.196.157])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647b2edd772sm12963000a12.12.2025.12.09.00.49.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Dec 2025 00:49:23 -0800 (PST)
Message-ID: <ec17ae31-e6d0-4ed3-821b-6ac135bbf06c@maven.pl>
Date: Tue, 9 Dec 2025 09:49:22 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] libfrog: fix incorrect FS_IOC_FSSETXATTR argument to
 ioctl()
To: Andrey Albershteyn <aalbersh@redhat.com>, linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
References: <20251205143154.366055-2-aalbersh@kernel.org>
Content-Language: en-US, pl
From: =?UTF-8?Q?Arkadiusz_Mi=C5=9Bkiewicz?= <arekm@maven.pl>
In-Reply-To: <20251205143154.366055-2-aalbersh@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/12/2025 15:31, Andrey Albershteyn wrote:
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

Signed-off-by: Arkadiusz Miśkiewicz <arekm@maven.pl>


Tested here briefly - works.

> ---
>   include/linux.h     | 2 +-
>   libfrog/file_attr.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux.h b/include/linux.h
> index cea468d2b9..3ea9016272 100644
> --- a/include/linux.h
> +++ b/include/linux.h
> @@ -214,7 +214,7 @@
>    * fsxattr
>    */
>   struct file_attr {
> -	__u32	fa_xflags;
> +	__u64	fa_xflags;
>   	__u32	fa_extsize;
>   	__u32	fa_nextents;
>   	__u32	fa_projid;
> diff --git a/libfrog/file_attr.c b/libfrog/file_attr.c
> index c2cbcb4e14..6801c54588 100644
> --- a/libfrog/file_attr.c
> +++ b/libfrog/file_attr.c
> @@ -114,7 +114,7 @@
>   
>   	file_attr_to_fsxattr(fa, &fsxa);
>   
> -	error = ioctl(fd, FS_IOC_FSSETXATTR, fa);
> +	error = ioctl(fd, FS_IOC_FSSETXATTR, &fsxa);
>   	close(fd);
>   
>   	return error;
> 
> 


-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
