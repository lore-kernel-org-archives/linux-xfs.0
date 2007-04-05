Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Apr 2007 04:44:19 -0700 (PDT)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l35BiDfB031345
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 04:44:15 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l35Biv3S002799
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 07:44:57 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l35BiC7l280220
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 07:44:12 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l35BiCDL001445
	for <xfs@oss.sgi.com>; Thu, 5 Apr 2007 07:44:12 -0400
Date: Thu, 5 Apr 2007 17:14:16 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: Interface for the new fallocate() system call
Message-ID: <20070405114416.GB19982@amitarora.in.ibm.com>
References: <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070405112619.GA19982@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070405112619.GA19982@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jakub Jelinek <jakub@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, Apr 05, 2007 at 04:56:19PM +0530, Amit K. Arora wrote:

Correction below:

> asmlinkage long sys_s390_fallocate(int fd, loff_t offset, loff_t len, int mode)
> {
>         return sys_fallocate(fd, offset, len, mode);
          return sys_fallocate(fd, mode, offset, len);
> }

--
Regards,
Amit Arora
