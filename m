Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 20 Apr 2007 08:00:40 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3KF0VfB019084
	for <xfs@oss.sgi.com>; Fri, 20 Apr 2007 08:00:33 -0700
Date: Fri, 20 Apr 2007 10:59:18 -0400
From: Jakub Jelinek <jakub@redhat.com>
Subject: Re: Interface for the new fallocate() system call
Message-ID: <20070420145918.GY355@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420135146.GA21352@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, cmm@us.ibm.com, suparna@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org

On Fri, Apr 20, 2007 at 07:21:46PM +0530, Amit K. Arora wrote:
> Ok.
> In this case we may have to consider following things:
> 
> 1) Obviously, for this glibc will have to call fallocate() syscall with
> different arguments on s390, than other archs. I think this should be
> doable and should not be an issue with glibc folks (right?).

glibc can cope with this easily, will just add
sysdeps/unix/sysv/linux/s390/fallocate.c or something similar to override
the generic Linux implementation.

> 2) we also need to see how strace behaves in this case. With little
> knowledge that I have of strace, I don't think it should depend on
> argument ordering of a system call on different archs (since it uses
> ptrace internally and that should take care of it). But, it will be
> nice if someone can confirm this.

strace would solve this with #ifdef mess, it already does that in many
places so guess another few lines don't make it significantly worse.

	Jakub
