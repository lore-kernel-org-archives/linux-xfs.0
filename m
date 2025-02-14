Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EFC263F24
	for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 12:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739536195; cv=none; b=eAm6/coI7p7iYMlpA3W4XI52U0/GO1QIFYakAovwL3W0YXxdvbvJAqa8YGnFNw4fTwfuzhgpyrzByum7x7h1WSAn0X2GTp8fzkir00cC2BnHkmyNCohL3HNeDovOhoB/0zYSle54Rs9UMS4ieLbBDIYDovbc99vpwUeUw+VWMts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739536195; c=relaxed/simple;
	bh=o+9eJVl8CwL4mxIer/X2JlMnYjvZGgitWo5E6XsIP00=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mEiMhumquzEZ6X/gLqb5UwmORkw9DqorRTVe1Z7AEj17aGjJtofpCjbHR/6XTaDnVVHUfC4Kmkvl8Hc3zlUcyNJFq1lBZKfuvxmACOhVvcU+UO3UJMn7swt/ZIZCCRC8LxOOcNNkwIBtzm9+d14rq5vCmfRMk+wHKHPyjBYrOCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jIznVETw; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jIznVETw"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-4bbe0d2189aso594081137.2
        for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 04:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739536192; x=1740140992; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lTFbAU7wJoF4fOBfb8cWjl4tFAB0huVpYXczHim4Y1o=;
        b=jIznVETwq8/92diQRkc6ubURVuUbxWxObGWy0fYTTNYnFS2bA0Is0SP1zksOKVKmEH
         gzC2IIQLArsP7NWH67thl2+I7QOwC27AHoOy0onLqMJ6Iymapkue2Mk3gC7WCvLCrbhj
         uqtCKuesU6S8iwHfAnuoP3eqbPseN1vwhze1u5TmXPDyEAnRM6swd2KTLIGO0SsnSVUZ
         f2PVAkDzYt6WdHaePrc6gydE7YTCzMp2Iq4JsEj6oSeVtEfGukB+zavGyb2xC/eaG1tU
         yZi+fQ6j6ugoz6rhVk8YTpmJIjuqRUJx3EAFExjDnw7ACcwudWxAIrxkGT76Q9q8kmDm
         mzRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739536192; x=1740140992;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lTFbAU7wJoF4fOBfb8cWjl4tFAB0huVpYXczHim4Y1o=;
        b=kqlWcquNx8ijL7gW01WWh3wYQyfqRzKk2LBC7Y7QhScxA5LGyk4wqS79AbT9DUAzYp
         IqSrw5wrupto/6RxHox3+viKwamw/1TAl7V1kZStU7Tg+jwXW69z+XMzsQ8v6iDeqbnX
         alr3JKNp+9t2SyWk5mb45QlD5C41Mf5rOhFKASXe/SbNKLxMWxsG/x0wc8rgEIJ/US3d
         XV3dtjak97ZoSQrqbJ4FJtSh72M9CfMWEAl8k/33xzJQXkk/VDe9hNvtBuWcwMtMbzvQ
         e9JXnoljAThFf/+6LsbfYA/po25K7MOzoZTiKFSzd3ZolDi2XCGQ88k4ye2m7hw9clTp
         EzQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPsNgS43hav3GDcjNba1PcVQqaF27P6sYiRANgj7tr+/TBJWQ7LFo7R3PVFVZ7Sf/wazbGn/P3kdY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz33+ysI9m6z5OjlHTzDRc2CdgQZsQ1xWu1iRNeGLROqkm0fDYw
	Ya65NHxpSZse96JiZNttEhSL+I9Z70PLO6i5YmZ2fw4Yd39IAlD2KqsosKjsdfCI8wg7UjTLjON
	Lb2nglstJBZpFUH3IeV6sM1e3tbND+HfZoxXf/g==
X-Gm-Gg: ASbGncszxRtDgDXh6LMRJq2b3TpL9LoPyrkIS5NjefIbg7DYOPXgYWWUG5z6tAKVaH5
	dUP0nt/FYaiUv6alGE2DNT7GIef2dZb+fCDtKKjeQRVPfbdH4raeBqT+iXHS1ElNrVoECZ8pRQv
	LQC1sC9bQ1wgSvls6fsUPg89Ju+M9weZs=
X-Google-Smtp-Source: AGHT+IFayjXgqLnPIi5Gj/6+Fnamdf+uE2pl1g6krTGZMHKX9RJajOKZ81JoDlIpuTxR8LgZtuj0I33nc9DhR+zNH3w=
X-Received: by 2002:a05:6102:3a0e:b0:4bb:e14a:944b with SMTP id
 ada2fe7eead31-4bc03781b64mr5853377137.20.1739536192461; Fri, 14 Feb 2025
 04:29:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250213142436.408121546@linuxfoundation.org> <CA+G9fYuVj+rhFPLshE_RKfBMyMvKiHaDzPttZ1FeqqeJHOnSbQ@mail.gmail.com>
In-Reply-To: <CA+G9fYuVj+rhFPLshE_RKfBMyMvKiHaDzPttZ1FeqqeJHOnSbQ@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 14 Feb 2025 17:59:40 +0530
X-Gm-Features: AWEUYZk1PwH1MSNr9Lf4hA8ve4s44k0qj-QHXi0NZuppFfQe21jEYySxIYPOqJU
Message-ID: <CA+G9fYsVFoLTXYBqpeUN1VUTwy5kXTB82fztK62fMPR6tYxChA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/422] 6.12.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	linux-xfs@vger.kernel.org, chandan.babu@oracle.com, 
	"Darrick J. Wong" <djwong@kernel.org>, Long Li <leo.lilong@huawei.com>, 
	Wentao Liang <vulab@iscas.ac.cn>
Content-Type: text/plain; charset="UTF-8"

On Fri, 14 Feb 2025 at 14:16, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Thu, 13 Feb 2025 at 20:02, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.12.14 release.
> > There are 422 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Regressions on the arm64, powerpc builds failed with gcc-8/13 and clang
> on the Linux stable-rc 6.12.14-rc1.
>
> Build regression: arm, powerpc, fs/xfs/xfs_trans.c too few arguments
>
> Good: v6.12.13
> Bad:  6.12.14-rc1 (v6.12.13-423-gfb9a4bb2450b)

Anders bisected this to,
# first bad commit:
   [91717e464c5939f7d01ca64742f773a75b319981]
   xfs: don't lose solo dquot update transactions

--
Linaro LKFT
https://lkft.linaro.org
