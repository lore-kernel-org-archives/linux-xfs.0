Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Mar 2007 10:36:23 -0700 (PDT)
Received: from tmailer.gwdg.de (tmailer.gwdg.de [134.76.10.23])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2THaD6p026706
	for <xfs@oss.sgi.com>; Thu, 29 Mar 2007 10:36:14 -0700
Date: Thu, 29 Mar 2007 19:01:54 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Interface for the new fallocate() system call
In-Reply-To: <20070329115126.GB7374@amitarora.in.ibm.com>
Message-ID: <Pine.LNX.4.61.0703291854000.31834@yvahk01.tjqt.qr>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
 <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com>
 <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
 <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com>
 <20070329115126.GB7374@amitarora.in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

Hi,

On Mar 29 2007 17:21, Amit K. Arora wrote:
>
>We need to come up with the best possible layout of arguments for the
>fallocate() system call. Various architectures have different
>requirements for how the arguments should look like. Since the mail
>chain has become huge, here is the summary of various inputs received
>so far.

>s390 prefers following layout:
>   int fallocate(int fd, loff_t offset, loff_t len, int mode)
>For details on why and how "int, int, loff_t, loff_t" is a problem on
>s390, please see Heiko's mail on 16th March. Here is the link:
>http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg133595.html

Quoting that...
	|len -> r6 + second halve on stack

Then, is not this a gcc glitch? (IMO, it should put all of "len" on the 
stack)

>Platform: ppc, arm
>------------------
>6 arguments. Thus the desired layout by ppc32 is:
>   int fallocate(int fd, int mode, loff_t offset, loff_t len)
>
>Option of loff_t => high u32 + low u32
>--------------------------------------
>Matthew and Russell have suggested another option of breaking each
>"loff_t" into two "u32"s. This will result in 6 arguments in total.
>
>What are your thoughts on this ? What layout should we finalize on ?
>Perhaps, since sync_file_range() system call has similar arguments, we
>can take hint from the challenges faced on implementing it on various
>architectures, and decide.
>
>Please suggest. Thanks!

Does it actually matter? Glibc can have its own argument ordering
different from the syscalls, so at least it would be possible to lay out
the syscall arguments in the most portable way while retaining nice
userspace C code. Hey, glibc might even wrap it up in a struct! (Using a 
pointer, as suggested in one of the proposals.)

int fallocate(int fd, loff_t offset, loff_t len, int mode)
{
	struct fallocate_foobar d = {fd, offset, len, mode};
	return _syscall(..., &d);
}




Jan
-- 
