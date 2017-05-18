Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33728 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754951AbdERJdX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 May 2017 05:33:23 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4I98Z3J162677
        for <linux-xfs@vger.kernel.org>; Thu, 18 May 2017 05:33:22 -0400
Received: from e23smtp09.au.ibm.com (e23smtp09.au.ibm.com [202.81.31.142])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2agyfkwxtf-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 18 May 2017 05:33:22 -0400
Received: from localhost
        by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <abdhalee@linux.vnet.ibm.com>;
        Thu, 18 May 2017 19:33:19 +1000
Subject: Re: Mainline build brakes on powerpc with error :
 fs/xfs/xfs_iomap.c:1152: undefined reference to `.put_dax
From: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Date: Thu, 18 May 2017 15:02:24 +0530
In-Reply-To: <CAK8P3a1e+Rgv2emmTgewm-YJ6j2H7xJzM_+Mz8J3OKWCpbsD6g@mail.gmail.com>
References: <1494932559.3971.18.camel@abdul.in.ibm.com>
         <CAK8P3a1e+Rgv2emmTgewm-YJ6j2H7xJzM_+Mz8J3OKWCpbsD6g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1495099944.22101.6.camel@abdul>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>, dan.j.williams@intel.com
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-xfs <linux-xfs@vger.kernel.org>, sachinp <sachinp@linux.vnet.ibm.com>, linux-kernel <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>

On Tue, 2017-05-16 at 13:17 +0200, Arnd Bergmann wrote:
> On Tue, May 16, 2017 at 1:02 PM, Abdul Haleem
> <abdhalee@linux.vnet.ibm.com> wrote:
> > Hi,
> >
> > Today's mainline 4.12-rc1 fails to build for the attached configuration
> > file on Power7 box with below errors.
> >
> > $ make
> > fs/built-in.o: In function `xfs_file_iomap_end':
> > fs/xfs/xfs_iomap.c:1152: undefined reference to `.put_dax'
> > fs/built-in.o: In function `xfs_file_iomap_begin':
> > fs/xfs/xfs_iomap.c:1071: undefined reference to `.dax_get_by_host'
> >
> > Also reproducible on latest linux-next, and the last successful build
> > was at next-20170510.
> 
> This should be fixed by https://patchwork.kernel.org/patch/9725515/
> 
>   Arnd
> 

Arnd,

With the given patch, kernel build and boot is fine on ppc.

Thanks Dan, for the patch!

Tested-by : Abdul Haleem <abdhalee@linux.vnet.ibm.com>

-- 
Regard's

Abdul Haleem
IBM Linux Technology Centre



