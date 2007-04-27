Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Apr 2007 05:10:52 -0700 (PDT)
Received: from mtagate8.uk.ibm.com (mtagate8.uk.ibm.com [195.212.29.141])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3RCAhfB012803
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 05:10:44 -0700
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate8.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l3RCAf3w135080
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 12:10:41 GMT
Received: from d06av04.portsmouth.uk.ibm.com (d06av04.portsmouth.uk.ibm.com [9.149.37.216])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3RCAfVW2519164
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 13:10:41 +0100
Received: from d06av04.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av04.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3RCAeHQ009263
	for <xfs@oss.sgi.com>; Fri, 27 Apr 2007 13:10:41 +0100
Date: Fri, 27 Apr 2007 14:10:03 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 0/5] fallocate system call
Message-ID: <20070427121003.GA7808@osiris.boeblingen.de.ibm.com>
References: <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426175056.GA25321@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, Apr 26, 2007 at 11:20:56PM +0530, Amit K. Arora wrote:
> Based on the discussion, this new patchset uses following as the
> interface for fallocate() system call:
> 
>  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> 
> It seems that only s390 architecture has a problem with such a layout of
> arguments in fallocate(). Thus for s390, we plan to have a wrapper
> (say, sys_s390_fallocate()) for the sys_fallocate(), which will get
> called by glibc when an application issues a fallocate() system call
> on s390. The s390 arch specific changes will be part of a separate
> patch (PATCH 2/5). It will be great if some s390 expert can verify the
> patch, since I have not been able to test it on s390 so far.

After long discussions where at least two possible implementations
were suggested that would work on _all_ architectures you chose one
which doesn't and causes extra effort.

> It was also noted that minor changes might be required to strace code
> to take care of "different arguments on s390" issue.

This is not limited to strace...

Besides that the s390 backend looks ok.
