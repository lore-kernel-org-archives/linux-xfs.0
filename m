Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34452 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbdEPLRa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2017 07:17:30 -0400
MIME-Version: 1.0
In-Reply-To: <1494932559.3971.18.camel@abdul.in.ibm.com>
References: <1494932559.3971.18.camel@abdul.in.ibm.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 16 May 2017 13:17:29 +0200
Message-ID: <CAK8P3a1e+Rgv2emmTgewm-YJ6j2H7xJzM_+Mz8J3OKWCpbsD6g@mail.gmail.com>
Subject: Re: Mainline build brakes on powerpc with error : fs/xfs/xfs_iomap.c:1152:
 undefined reference to `.put_dax
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-xfs <linux-xfs@vger.kernel.org>, sachinp <sachinp@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dan Williams <dan.j.williams@intel.com>

On Tue, May 16, 2017 at 1:02 PM, Abdul Haleem
<abdhalee@linux.vnet.ibm.com> wrote:
> Hi,
>
> Today's mainline 4.12-rc1 fails to build for the attached configuration
> file on Power7 box with below errors.
>
> $ make
> fs/built-in.o: In function `xfs_file_iomap_end':
> fs/xfs/xfs_iomap.c:1152: undefined reference to `.put_dax'
> fs/built-in.o: In function `xfs_file_iomap_begin':
> fs/xfs/xfs_iomap.c:1071: undefined reference to `.dax_get_by_host'
>
> Also reproducible on latest linux-next, and the last successful build
> was at next-20170510.

This should be fixed by https://patchwork.kernel.org/patch/9725515/

  Arnd
