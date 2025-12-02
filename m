Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D772B263F4E
	for <linux-xfs@vger.kernel.org>; Tue,  2 Dec 2025 15:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764689871; cv=none; b=Zry2MMPLCSWsFYQCXIo6+KlZWtKxNsQv5PAALZ+Ifq6DEtw91+iqKIMhmP8921QuDcsF6WWQpGuWg/xy+LOq2yS2dBBkCHBXV1MDzt7UGH+Hi/Z6ZrvevLDiEx5IRu/OoTSNUWbCuQzfQc/HbVLF+CKCcCIgO8IARJLJKNKFsaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764689871; c=relaxed/simple;
	bh=vpE5EoPl81OXEBoVcuuXCPpqAzZxp4nL17xE1XR1pcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OCSQdoaNqttst0EYe4y1Vi1DmZMpAauydp5dI1I8X+OMzqwG+sLZgfFM8eahlFT8UXIdCOsNkHsCNf4mqr4VsPS2lxdnkjXKjz9MVpKC+6UAMGTSSNd7E5EWQ/urDSyqIC5oBd6USxktcSqkNTS/vommh0TZognWa8tsrNSmxUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=maven.pl; spf=pass smtp.mailfrom=maven.pl; dkim=pass (1024-bit key) header.d=maven.pl header.i=@maven.pl header.b=J3HPtnLh; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=maven.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=maven.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=maven.pl header.i=@maven.pl header.b="J3HPtnLh"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6419b7b4b80so8420817a12.2
        for <linux-xfs@vger.kernel.org>; Tue, 02 Dec 2025 07:37:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maven.pl; s=maven; t=1764689867; x=1765294667; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ConuvD8daUO5TViY4uGMmoV/CoG7J3iCApA22ZT8ug4=;
        b=J3HPtnLhD8dZ1NxPGy1zcba2ZrsPjGuIJJKgafRKoQG+qxKemdC8lFY0th8L59ntdb
         V5KZiqL2h1qLej8hT9Y+em7byAnTKDt6c09WMJjdnQP61mCVX+YTn6zkZkuYJKloRZCp
         fr2+JKS06wKPYXiu5dPlzUX9tWAnmO98pYkn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764689867; x=1765294667;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ConuvD8daUO5TViY4uGMmoV/CoG7J3iCApA22ZT8ug4=;
        b=S4xihUSwlnbSUy3rWce1qFr5hbql9QtMivIHyDxlXXkjY8IwbilmWk80GQnFHVlCnD
         QVglcCiNPgg6tB/0vVlOja2dkM7w/l0XmaNAAnXcjpxu88ZUC+0Oc1DevokRdkcYaPn6
         Ts1U4lj6jenKOQbYo9o16l9whDjcHZ7tu7h1FsMooeDM4kErg5i78K/xzBbcQg11qvLk
         mPQfcryvDoVnWQ4Cd5plwYWBoruY/OaSd9f3FIGGNrpdnhUrS6eAxdXLouVZBBMloJOc
         tEgoqJDUZP5zkWbMbvOMJmNWf43k/U8K2FH0G2ONE9QAy0medR0yK2tKeKjh99i5TBc9
         /Ruw==
X-Forwarded-Encrypted: i=1; AJvYcCVJJVHfRC6gqWI7RFDIgyJAS+CrU/Y7BfOJf4iGu2bWRNQYKZVf7fkza1cXExOeH8dyvurBACyCHI4=@vger.kernel.org
X-Gm-Message-State: AOJu0YykED5db3wriNwWAgEbNWpJrYJmVxu5ux5MQ+E7joWFXRWx1W/t
	gVLqSar7V2SRFdx3GaDc0xLC7IVMdTsAZApUaJ9XimzY3xQ76F06sLt0nHE8z0+mnWo=
X-Gm-Gg: ASbGncuVpF96gYyhuMhES+hsmxGgH84EcoNfY+mYCkHDec/83DrCy6jne40l23lv/ok
	Dsz3nN7QWHyL+6fayM3GMTqPtCS+qQOXwgoCC67Ih2WJQ+dWfCriqcg1THf3+8Fgruja6YtiJmr
	ZmK/jvlvkM+uRgzNXOlW413vkl3A8RSW6MP1bNBwem+GlPQyqgOeAnfjJ7Z8fH93ojW515EaXcO
	GaKt5S7c4JwQg/9x1vYng17UhueFbJNynmBAl0v9LG4yTA1yu+tJvxmW9388RCHifjy0N9Yqe4+
	TTDEC/UGODKhleVgB4DML/4E7zRHYaHUu8Nb8flRECaFhRGXGzMHVi0Rr6HGzfua3c33tzoz5Vt
	dR7E/qu4NgPPxVQIfFENghfvN+uOgtS762DJACIT4ahb4um1dTb3rVNEyQ/diyhj1n2Aq3cpx+K
	/9ykMk5lKjSiIP0NRvO9UNCi7TWJPUt8YL3de7PHYKhRqkep73NzJo4SkFi9chht+YfLkW/KIs
X-Google-Smtp-Source: AGHT+IG9aOwXWKF1qA+hOvaDs1nJOECV5tbhMVAg0A7LAbBljmK4RosPZQYagf6VaHBxq+UnR/4QJw==
X-Received: by 2002:a05:6402:42ca:b0:640:b373:205e with SMTP id 4fb4d7f45d1cf-64554469ef2mr44474663a12.15.1764689867185;
        Tue, 02 Dec 2025 07:37:47 -0800 (PST)
Received: from [192.168.68.100] (user-188-33-10-15.play-internet.pl. [188.33.10.15])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-647510508e1sm15924208a12.27.2025.12.02.07.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Dec 2025 07:37:46 -0800 (PST)
Message-ID: <905377ba-b2cb-4ca7-bf41-3d3382b48e1d@maven.pl>
Date: Tue, 2 Dec 2025 16:37:45 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] libfrog: add wrappers for
 file_getattr/file_setattr syscalls
To: Andrey Albershteyn <aalbersh@redhat.com>, aalbersh@kernel.org,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
References: <20250827-xattrat-syscall-v2-0-82a2d2d5865b@kernel.org>
 <20250827-xattrat-syscall-v2-1-82a2d2d5865b@kernel.org>
Content-Language: en-US, pl
From: =?UTF-8?Q?Arkadiusz_Mi=C5=9Bkiewicz?= <arekm@maven.pl>
In-Reply-To: <20250827-xattrat-syscall-v2-1-82a2d2d5865b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 27/08/2025 17:15, Andrey Albershteyn wrote:

Hello.

> +int
> +xfrog_file_setattr(
> +	const int		dfd,
> +	const char		*path,
> +	const struct stat	*stat,
> +	struct file_attr	*fa,
> +	const unsigned int	at_flags)
> +{
> +	int			error;
> +	int			fd;
> +	struct fsxattr		fsxa;
> +
> +#ifdef HAVE_FILE_ATTR
> +	error = syscall(__NR_file_setattr, dfd, path, fa,
> +			sizeof(struct file_attr), at_flags);
> +	if (error && errno != ENOSYS)
> +		return error;
> +
> +	if (!error)
> +		return error;
> +#endif
> +
> +	if (SPECIAL_FILE(stat->st_mode)) {
> +		errno = EOPNOTSUPP;
> +		return -1;
> +	}
> +
> +	fd = open(path, O_RDONLY|O_NOCTTY);
> +	if (fd == -1)
> +		return fd;
> +
> +	file_attr_to_fsxattr(fa, &fsxa);
> +
> +	error = ioctl(fd, FS_IOC_FSSETXATTR, fa);

&fsxa should be passed here.

xfsprogs 6.17.0 has broken project quota due to that

# LC_ALL=C /usr/sbin/xfs_quota -x -c "project -s -p /home/xxx 389701" /home
Setting up project 389701 (path /home/xxx)...
xfs_quota: cannot set project on /home/xxx: Invalid argument
Processed 1 (/etc/projects and cmdline) paths for project 389701 with 
recursion depth infinite (-1).


ioctl(5, FS_IOC_FSSETXATTR, 
{fsx_xflags=FS_XFLAG_PROJINHERIT|FS_XFLAG_HASATTR, fsx_extsize=0, 
fsx_projid=0, fsx_cowextsize=389701}) = -1 EINVAL (Invalid argument)


diff --git a/libfrog/file_attr.c b/libfrog/file_attr.c
index c2cbcb4e..6801c545 100644
--- a/libfrog/file_attr.c
+++ b/libfrog/file_attr.c
@@ -114,7 +114,7 @@ xfrog_file_setattr(

         file_attr_to_fsxattr(fa, &fsxa);

-       error = ioctl(fd, FS_IOC_FSSETXATTR, fa);
+       error = ioctl(fd, FS_IOC_FSSETXATTR, &fsxa);
         close(fd);

         return error;

fixes it (confirmed here)

> +	close(fd);
> +
> +	return error;
> +}
-- 
Arkadiusz Miśkiewicz, arekm / ( maven.pl | pld-linux.org )
