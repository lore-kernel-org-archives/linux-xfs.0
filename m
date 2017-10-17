Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:55921 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753349AbdJQIib (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2017 04:38:31 -0400
MIME-Version: 1.0
In-Reply-To: <59e01fb1.9b88df0a.6e93f.3781@mx.google.com>
References: <59e01fb1.9b88df0a.6e93f.3781@mx.google.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 17 Oct 2017 10:38:30 +0200
Message-ID: <CAK8P3a1OcUGEDqA0MQk+037jMXQnZgYgMtYvKeJTXgNsy+4Bzw@mail.gmail.com>
Subject: Re: mainline/master build: 212 builds: 0 failed, 212 passed, 48
 warnings (v4.14-rc4-126-g3d7882769b5d)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "kernelci.org bot" <bot@kernelci.org>
Cc: Kernel Build Reports Mailman List <kernel-build-reports@lists.linaro.org>, linux-xfs <linux-xfs@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, Oct 13, 2017 at 4:06 AM, kernelci.org bot <bot@kernelci.org> wrote:
>
> mainline/master build: 212 builds: 0 failed, 212 passed, 48 warnings (v4.14-rc4-126-g3d7882769b5d)
> Full Build Summary: https://kernelci.org/build/mainline/branch/master/kernel/v4.14-rc4-126-g3d7882769b5d/
> Tree: mainline
> Branch: master
> Git Describe: v4.14-rc4-126-g3d7882769b5d
> Git Commit: 3d7882769b5dc929690f96e0c318c29b97f51018
> Git URL: http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> Built: 4 unique architectures
>
> Warnings Detected:
>
> arm64: gcc version 5.3.1 20160412 (Linaro GCC 5.3-2016.05)
> defconfig+kselftest 2 warnings
> arm: gcc version 5.3.1 20160412 (Linaro GCC 5.3-2016.05)
> davinci_all_defconfig 2 warnings
> multi_v7_defconfig+kselftest 2 warnings
> pxa_defconfig 2 warnings
> mips: gcc version 6.3.0 (GCC)
> db1xxx_defconfig 2 warnings
> defconfig+CONFIG_LKDTM=y 2 warnings
> defconfig+kselftest 2 warnings
> ip22_defconfig 2 warnings
> ip27_defconfig 2 warnings
> jazz_defconfig 2 warnings
> lemote2f_defconfig 2 warnings
> malta_defconfig 2 warnings
> malta_kvm_defconfig 2 warnings
> malta_kvm_guest_defconfig 2 warnings
> malta_qemu_32r6_defconfig 2 warnings
> maltaaprp_defconfig 2 warnings
> maltasmvp_defconfig 2 warnings
> maltasmvp_eva_defconfig 2 warnings
> maltaup_defconfig 2 warnings
> maltaup_xpa_defconfig 2 warnings
> markeins_defconfig 2 warnings
> rm200_defconfig 2 warnings
> tb0287_defconfig 2 warnings
> x86: gcc version 5.4.0 20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.4)
> defconfig+kselftest 2 warnings
> Warnings summary:
> 24 fs/xfs/xfs_fsmap.c:480:1: warning: '__xfs_getfsmap_rtdev' defined but not used [-Wunused-function]
> 24 fs/xfs/xfs_fsmap.c:372:1: warning: 'xfs_getfsmap_rtdev_rtbitmap_helper' defined but not used [-Wunused-function]

I found the problem independently while testing linux-next. My patch
has been Acked already and I assume it will soon make it into mainline.

      Arnd
