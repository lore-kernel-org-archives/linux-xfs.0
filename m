Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEC514F9F4
	for <linux-xfs@vger.kernel.org>; Thu, 27 Mar 2025 12:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743079825; cv=none; b=QmeaI556mFUNGL5rMAQc+UMhcIKV0pzW2YLtC57j0gxefW6VSadxZQkJoPTVfLtlYQSBYz1SxARBADDecvt0V6oCceZCcdjQOzPMs/hsVbHQz2NCBoOHijctrnKajHX/atEuFgBP0pi20eESNYZBNXQcrVsoE1Ic+Q6QSZXkvTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743079825; c=relaxed/simple;
	bh=x0/E2M0F+EgLHnBAChfuUY4dPirGmTNiotD1PkORt9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZBEtD7HHj5H6Jv/m95SWQC3U4wdOV3vtNEGbYT+HOvmg5laeYTS8jmy6246BL+gNZv4o4+/rjdFUkV3Uu0FhQ7ASzUiZ/ppmF8RTFyJZsVWF6mhfgBRkQ0AVykJtlwACnwcfpGJGKDCiZU4V4KuTZJWqu7amK44fv9FW7/wqC9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F7QQm62O; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F7QQm62O"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-86f9c719d63so440677241.1
        for <linux-xfs@vger.kernel.org>; Thu, 27 Mar 2025 05:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743079822; x=1743684622; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YxPf82X3yEknJZahIFwtaw08CtPbnq39I71FWEqVAf8=;
        b=F7QQm62OZHOUaeLPsRQHgemR1rBdyRwYLC/mzeib+x13U1Tb2asL6cwOBqmRZP3fD7
         tvQhPrhkzUSxf9Eij4gUGWkVEqKdqlZ9XWeu73FnEa9MAEu6PvBI2IPj8Ljc8kgQjl+K
         vVwjxC/ZBhVRayWt3slHX7er26mgZ8ilIWL3KnYAtt3g1HjZ3VQYSfYIyu3LhcJGSYQT
         IAftgDXu8sKVgCpBpQvatSFKcWCKgbzEcxuueE/KZtCV4dwdR0HSjwRVUxZglpUYYg6j
         mcAwmap5ttkX+T5POPhlgcHwzKHNnQO7RTW1BjUnPNr/TFFkMlqRd0sX0h9vbX2vt2WL
         8X4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743079822; x=1743684622;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YxPf82X3yEknJZahIFwtaw08CtPbnq39I71FWEqVAf8=;
        b=ofCTM94KVGB+9vXuVUrgBbUGQpnN9aDc9Z1ZyoDTSTxDMUpOe3/s2naxHwIxgif4Mp
         zS92kTH94Pji5r8sYXXx7iIVEYddxU55INGh6Zskwu0W+wUYdNh3V99eEQcq3PXruYOU
         52hFKIH7J7C5BdlEmvtwxfzIKn68eXTnHsqdTWR71pUdmQsicRb1b6UgGJ/lSidYWn+6
         dGWI+qf9SrmhIsH7lgl0CpqE0Coikjy+bbx7X0D3/A8l+x1BDV1/s2AI5UBh2vNysZkY
         Qp3IdNblEkasQOv9A8c3ZT5V2kABWBYcFyBFJFIksC7ywEGgOxRaka3jeronboCaVpPI
         H2fg==
X-Forwarded-Encrypted: i=1; AJvYcCWSuPbBJ1X7yzZ2KUrriR9IlzXt9isVrn1js38ZS4JF2Ez/94V88tS+yyvlkLqzAZ3SW3CacCfteo0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz83kesB075FcqSJy+UFxBZ9FPA4mcuLIN+Nxu5od5y8gaHD/IS
	nIg3C0x4/A8HrYZjZuKKk+CuXCgulnb1MKdJLJ5JEswVkHfxK0Z/RXd03DiDg5/G0LFEz7kVajr
	EWfSO7DGa/6nkDWXHtbwLemRIJ6uLmfmtgOtISQ==
X-Gm-Gg: ASbGncuRSfY18jyRzkJCray3+Ri0sFoNFGMRzrfYCZq+oZ6Z2GipUlx6Yv3I1En4hLA
	wSYw/m0MbP3e1jxPQDcp2WRuvfWJbzZ31+wOzwJ16LEcm8dUepk1i5JypqEfotFeG95E72d4DkF
	04zIyiNjc+doUljKj2SG4RDIdttdwVdgvio/XZXlKAhJFYfLeDyG6spJ3lkwM=
X-Google-Smtp-Source: AGHT+IHJT4hKKSEUXlpmrmhxoV+NJpCfU27nTmRX+PSKGFNIOYp+YtuJN7H/mSdObFWYsi6xV1D2Xzz8lFMeeJw8D60=
X-Received: by 2002:a05:6102:1529:b0:4bb:b589:9d95 with SMTP id
 ada2fe7eead31-4c586ef2197mr3532762137.4.1743079821716; Thu, 27 Mar 2025
 05:50:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250326154349.272647840@linuxfoundation.org>
In-Reply-To: <20250326154349.272647840@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 27 Mar 2025 18:20:10 +0530
X-Gm-Features: AQ5f1JqzxAAFsa6xfl6ahL538LTvEz_6T0WQuL-UCtRCOoqdpwdAR2e1PKOJHcs
Message-ID: <CA+G9fYsRQub2qq0ePDs6aBAc+0qHRGwH_WPsTfhcwkviD1eH1w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/197] 6.1.132-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>, 
	Leah Rumancik <leah.rumancik@gmail.com>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Wed, 26 Mar 2025 at 21:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.132 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 28 Mar 2025 15:43:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.132-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on arm, arm64, mips, powerpc builds failed with gcc-13 and
clang the stable-rc 6.1.132-rc1 and 6.1.132-rc2.

First seen on the 6.1.132-rc1
 Good: v6.1.131
 Bad: Linux 6.1.132-rc1 and Linux 6.1.132-rc2

* arm, build
  - clang-20-davinci_all_defconfig
  - clang-nightly-davinci_all_defconfig
  - gcc-13-davinci_all_defconfig
  - gcc-8-davinci_all_defconfig

* arm64, build
  - gcc-12-lkftconfig-graviton4
  - gcc-12-lkftconfig-graviton4-kselftest-frag
  - gcc-12-lkftconfig-graviton4-no-kselftest-frag

* mips, build
  - gcc-12-malta_defconfig
  - gcc-8-malta_defconfig

* powerpc, build
  - clang-20-defconfig
  - clang-20-ppc64e_defconfig
  - clang-nightly-defconfig
  - clang-nightly-ppc64e_defconfig
  - gcc-13-defconfig
  - gcc-13-ppc64e_defconfig
  - gcc-13-ppc6xx_defconfig
  - gcc-8-defconfig
  - gcc-8-ppc64e_defconfig
  - gcc-8-ppc6xx_defconfig

Regression Analysis:
 - New regression? yes
 - Reproducibility? Yes

Build regression: arm arm64 mips powerpc xfs_alloc.c 'mp' undeclared
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log
fs/xfs/libxfs/xfs_alloc.c: In function '__xfs_free_extent_later':
fs/xfs/libxfs/xfs_alloc.c:2551:51: error: 'mp' undeclared (first use
in this function); did you mean 'tp'?
 2551 |         if (XFS_IS_CORRUPT(mp, !xfs_verify_fsbext(mp, bno, len)))
      |                                                   ^~


## Source
* Kernel version: 6.1.132-rc2
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: f5ad54ef021f6fb63ac97b3dec5efa9cc1a2eb51
* Git describe: v6.1.131-198-gf5ad54ef021f
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-198-gf5ad54ef021f/

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-198-gf5ad54ef021f/testrun/27785617/suite/build/test/gcc-12-lkftconfig-graviton4-kselftest-frag/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-198-gf5ad54ef021f/testrun/27785617/suite/build/test/gcc-12-lkftconfig-graviton4-kselftest-frag/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.131-198-gf5ad54ef021f/testrun/27785617/suite/build/test/gcc-12-lkftconfig-graviton4-kselftest-frag/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2urSwNctsyhQzf1j7dvt6nHemP5/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2urSwNctsyhQzf1j7dvt6nHemP5/config

## Steps to reproduce
 - tuxmake --runtime podman --target-arch arm64 --toolchain gcc-12 \
    --kconfig https://storage.tuxsuite.com/public/linaro/lkft/builds/2urSwNctsyhQzf1j7dvt6nHemP5/config
debugkernel dtbs dtbs-legacy headers kernel kselftest modules
 - tuxmake --runtime podman --target-arch arm --toolchain clang-20
--kconfig davinci_all_defconfig LLVM=1 LLVM_IAS=1


--
Linaro LKFT
https://lkft.linaro.org
