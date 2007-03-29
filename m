Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Mar 2007 04:51:31 -0700 (PDT)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2TBpP6p011068
	for <xfs@oss.sgi.com>; Thu, 29 Mar 2007 04:51:27 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l2TBq9Ub012186
	for <xfs@oss.sgi.com>; Thu, 29 Mar 2007 07:52:09 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2TBpMb9293154
	for <xfs@oss.sgi.com>; Thu, 29 Mar 2007 07:51:22 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2TBpMb0030817
	for <xfs@oss.sgi.com>; Thu, 29 Mar 2007 07:51:22 -0400
Date: Thu, 29 Mar 2007 17:21:26 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Interface for the new fallocate() system call
Message-ID: <20070329115126.GB7374@amitarora.in.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321120425.GA27273@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

Hello,

We need to come up with the best possible layout of arguments for the
fallocate() system call. Various architectures have different
requirements for how the arguments should look like. Since the mail
chain has become huge, here is the summary of various inputs received
so far.

Platform: s390
--------------
s390 prefers following layout:

   int fallocate(int fd, loff_t offset, loff_t len, int mode)

For details on why and how "int, int, loff_t, loff_t" is a problem on
s390, please see Heiko's mail on 16th March. Here is the link:
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg133595.html

Platform: ppc, arm
------------------
ppc (32 bit) has a problem with "int, loff_t, loff_t, int" layout,
since this will result in a pad between fd and offset, making seven
arguments total - which is not supported by ppc32. It supports only
6 arguments. Thus the desired layout by ppc32 is:

   int fallocate(int fd, int mode, loff_t offset, loff_t len)

Even ARM prefers above kind of layout. For details please see the
definition of sys_arm_sync_file_range().

Option of loff_t => high u32 + low u32
--------------------------------------
Matthew and Russell have suggested another option of breaking each
"loff_t" into two "u32"s. This will result in 6 arguments in total.

Following think that this is a good alternative:
Matthew Wilcox, Russell King, Heiko Carstens

Following do not like this idea:
Chris Wedgwood


What are your thoughts on this ? What layout should we finalize on ?
Perhaps, since sync_file_range() system call has similar arguments, we
can take hint from the challenges faced on implementing it on various
architectures, and decide.

Please suggest. Thanks!

--
Regards,
Amit Arora
