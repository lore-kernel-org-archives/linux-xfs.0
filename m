Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EF6221D9A
	for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 08:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739522789; cv=none; b=uzYmCrLDmK5/si8ImqpH2s/1KJUkmrtQ8QDn5oG50Ct510QZjMCm0IVoTrjAlpsk24Rt/sQWF7X+4Dmm8rvj3c/LAlmolnqn21D941N532Dcmj0IpacsaOoXWnqCWuJvmDg0Gyn8Tk3EJNB3l4cH4L56jfE3T3OrAoQhsqFrm+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739522789; c=relaxed/simple;
	bh=DaapRn/iW7Nn3mWXq/1zNU2x1WmgQpD91mDAIchYOno=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e0pyGfx7i63mravadnfOp2jVPv0Qw642MuPOAVYndoiBSAQSFQwgxtFHbmfAiSsA6/IhvMEb7klB5aEgSkjXPZwiKYLzFD5EU20gXM6NSYIdxJak7akUvM52JCU39Dg/O8ntJEkz6XOiTrbkoXvKYqbtUvNeNLXyAHMamAanDZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mRR1CKAB; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mRR1CKAB"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-52067a2ca31so975784e0c.0
        for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 00:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739522785; x=1740127585; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s/SpVrueRYoLO67L8eIIkV6jzrQYHfIk1nopkq7+ltQ=;
        b=mRR1CKABP2MCEa4qcB5AWjHEhB9x81OVQR2pLhPKP/4IT5sSa1fRSUaF3TrFwDvWCM
         BPrJAg+JyC6A5MsDVLE3g0UXr1TtuQlnJK/ODRZhsLGDLjY6eScloqDPGz8UCfT0X1WE
         TeFu9cmZxikMC/k1tkUPUAkmtlbG1RzWKBpNILF28etIsTtx/X/M5e54Ea5MQB1lgm96
         nT/jLcScWOKPnLgld/iXBiZhSFnF4AGDhfiOsdXQTQiUTxp6Z3ucp8cdEmmN/hwptzQl
         KdEiTllQOsCI3wYLod0ks3+OPLzK0BrUhAYAAABvce91wzJUhE3AN1krpSXsld6vQGRj
         XDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739522785; x=1740127585;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s/SpVrueRYoLO67L8eIIkV6jzrQYHfIk1nopkq7+ltQ=;
        b=Ye+YOLwINsOLfjqs4DWsJTe1tJJHGrIG15VE+9kZRP6wK/JyOhOTi0jCvbNI2k3nQd
         /Jp5iPdykFSZ/1z4xITIBr5est9BZzkGpWTu0WspNnXyj/ndHBYYPU0WYekuTwnm5QnM
         J+UxhAOv0w0cuT0eLLG+lOkLFj3M/39vQisV0zrwyI8/OFvwAfg1OHT+yzxQL5tqq5yI
         QOKgM8E2JP9iowbckphiZt88fX/XzamOjWmItwwzJghw7mGI4EO4mclOm5XvylPP27Tg
         Akp2BWLyxcEQnCvOWqwzKJDY3ybCzV8YTK0x7uJixc4N2EU/p0LyYEb21I04zmh8OjBL
         4mNA==
X-Forwarded-Encrypted: i=1; AJvYcCWUZzuL86vkf+YoAgMBveWyP/vquc3YiHRaNW8hxDCoyY5nCzsTVVdmCidE/v/mVv0+m3JLbj+I97k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFD1yb5N3EN6bB/BMzxJVfCWEbKz4OrLtdHwfOO/RAFK/6MzBW
	bMt1yotNESFXe5q3XNj35AQ8U3amFO7P458mEPAcmcYCcACHq92pR42u2Rykok5L01M8XcohRU3
	76O+zFVuHPtadB2tpVdoJToOJCm0crkWJNToxQA==
X-Gm-Gg: ASbGnctAEIbZY/FV+fMS/V9dsSiOGBZOK2vuhErikSeGgv1yU06bbeVdQPUD2rsrOwN
	lPmD/+c/+i06DGCopmTBUBJKEkgMXnL3ENqug6m0hqEUxAGbf27V8uZcpQ9KEcNFgMcRvoylUOz
	I4o6PZIBSHW/ZriM3/VpuBlbWqKBRRgJg=
X-Google-Smtp-Source: AGHT+IEmsJZT+jXKj4JBRFBmsWO8P+p3scpYQLSYSd7oc2CaHyRP52nyDmef7v9VG3cRCZJx74tDbUVT3Hl5ru2KBmM=
X-Received: by 2002:a05:6122:2028:b0:520:3d87:5cdb with SMTP id
 71dfb90a1353d-52067c9792amr8941602e0c.9.1739522785112; Fri, 14 Feb 2025
 00:46:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250213142436.408121546@linuxfoundation.org>
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 14 Feb 2025 14:16:13 +0530
X-Gm-Features: AWEUYZmYXnFVTFbZ3xpIYpccIn9qqsxnpqLJJ2bHanM_Ra-e0XbxIu6KOWpiedk
Message-ID: <CA+G9fYuVj+rhFPLshE_RKfBMyMvKiHaDzPttZ1FeqqeJHOnSbQ@mail.gmail.com>
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

On Thu, 13 Feb 2025 at 20:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.14 release.
> There are 422 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Feb 2025 14:23:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on the arm64, powerpc builds failed with gcc-8/13 and clang
on the Linux stable-rc 6.12.14-rc1.

Build regression: arm, powerpc, fs/xfs/xfs_trans.c too few arguments

Good: v6.12.13
Bad:  6.12.14-rc1 (v6.12.13-423-gfb9a4bb2450b)

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

* arm, build
  - clang-19-davinci_all_defconfig
  - clang-nightly-davinci_all_defconfig
  - gcc-13-davinci_all_defconfig
  - gcc-8-davinci_all_defconfig

* powerpc, build
  - clang-19-defconfig
  - clang-19-ppc64e_defconfig
  - clang-nightly-allyesconfig
  - clang-nightly-defconfig
  - clang-nightly-lkftconfig-hardening
  - clang-nightly-lkftconfig-lto-full
  - clang-nightly-lkftconfig-lto-thing
  - clang-nightly-ppc64e_defconfig
  - gcc-13-defconfig
  - gcc-13-lkftconfig-hardening
  - gcc-13-ppc64e_defconfig
  - gcc-8-defconfig
  - gcc-8-lkftconfig-hardening
  - gcc-8-ppc64e_defconfig
  - korg-clang-19-lkftconfig-hardening
  - korg-clang-19-lkftconfig-lto-full
  - korg-clang-19-lkftconfig-lto-thing


## Build log arm and powerpc
fs/xfs/xfs_trans.c:843:33: error: too few arguments provided to
function-like macro invocation
  843 |         xfs_trans_apply_dquot_deltas(tp);
      |                                        ^
fs/xfs/xfs_quota.h:169:9: note: macro 'xfs_trans_apply_dquot_deltas'
defined here
  169 | #define xfs_trans_apply_dquot_deltas(tp, a)
      |         ^
fs/xfs/xfs_trans.c:843:2: error: use of undeclared identifier
'xfs_trans_apply_dquot_deltas'; did you mean
'xfs_trans_apply_sb_deltas'?
  843 |         xfs_trans_apply_dquot_deltas(tp);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |         xfs_trans_apply_sb_deltas
fs/xfs/xfs_trans.c:475:1: note: 'xfs_trans_apply_sb_deltas' declared here
  475 | xfs_trans_apply_sb_deltas(
      | ^
fs/xfs/xfs_trans.c:843:2: warning: expression result unused [-Wunused-value]
  843 |         xfs_trans_apply_dquot_deltas(tp);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
1 warning and 2 errors generated.


## Source
* kernel version: 6.12.14-rc1
* git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git sha: fb9a4bb2450b6b0f073a493bd6a1f54f231413e9
* git describe: v6.12.13-423-gfb9a4bb2450b
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.13-423-gfb9a4bb2450b

## Build
* build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2szXNYzJaqUDby0ajsj9cBcVrPY/
* build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.13-423-gfb9a4bb2450b/testrun/27280977/suite/build/test/clang-19-davinci_all_defconfig/log
* build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.13-423-gfb9a4bb2450b/testrun/27280977/suite/build/test/clang-19-davinci_all_defconfig/history/
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.13-423-gfb9a4bb2450b/testrun/27280977/suite/build/test/clang-19-davinci_all_defconfig/
* kernel config: arm-clang-19-davinci_all_defconfig and gcc-8-ppc64e_defconfig
* architectures: arm, powerpc
* toolchain version: clang and gcc

## Steps to reproduce
# tuxmake --runtime podman --target-arch arm --toolchain clang-19
--kconfig davinci_all_defconfig LLVM=1 LLVM_IAS=1

--
Linaro LKFT
https://lkft.linaro.org
