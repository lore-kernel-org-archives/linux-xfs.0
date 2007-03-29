Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 Mar 2007 10:49:37 -0700 (PDT)
Received: from odyssey.analogic.com (odyssey.analogic.com [204.178.40.5])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2THnR6p030520
	for <xfs@oss.sgi.com>; Thu, 29 Mar 2007 10:49:29 -0700
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-class: urn:content-classes:message
Subject: Re: Interface for the new fallocate() system call
Date: Thu, 29 Mar 2007 13:18:53 -0400
Message-ID: <Pine.LNX.4.61.0703291314330.4366@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0703291854000.31834@yvahk01.tjqt.qr>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <Pine.LNX.4.61.0703291854000.31834@yvahk01.tjqt.qr>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com


On Thu, 29 Mar 2007, Jan Engelhardt wrote:

> Hi,
>
> On Mar 29 2007 17:21, Amit K. Arora wrote:
>>
>> We need to come up with the best possible layout of arguments for the
>> fallocate() system call. Various architectures have different
>> requirements for how the arguments should look like. Since the mail
>> chain has become huge, here is the summary of various inputs received
>> so far.
>
>> s390 prefers following layout:
>>   int fallocate(int fd, loff_t offset, loff_t len, int mode)
>> For details on why and how "int, int, loff_t, loff_t" is a problem on
>> s390, please see Heiko's mail on 16th March. Here is the link:
>> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg133595.html
>
> Quoting that...
> 	|len -> r6 + second halve on stack
>
> Then, is not this a gcc glitch? (IMO, it should put all of "len" on the
> stack)
>
>> Platform: ppc, arm
>> ------------------
>> 6 arguments. Thus the desired layout by ppc32 is:
>>   int fallocate(int fd, int mode, loff_t offset, loff_t len)
>>
>> Option of loff_t => high u32 + low u32
>> --------------------------------------
>> Matthew and Russell have suggested another option of breaking each
>> "loff_t" into two "u32"s. This will result in 6 arguments in total.
>>
>> What are your thoughts on this ? What layout should we finalize on ?
>> Perhaps, since sync_file_range() system call has similar arguments, we
>> can take hint from the challenges faced on implementing it on various
>> architectures, and decide.
>>
>> Please suggest. Thanks!
>
> Does it actually matter? Glibc can have its own argument ordering
> different from the syscalls, so at least it would be possible to lay out
> the syscall arguments in the most portable way while retaining nice
> userspace C code. Hey, glibc might even wrap it up in a struct! (Using a
> pointer, as suggested in one of the proposals.)
>
> int fallocate(int fd, loff_t offset, loff_t len, int mode)
> {
> 	struct fallocate_foobar d = {fd, offset, len, mode};
> 	return _syscall(..., &d);
> }
>
> Jan
> --

I think it's always better to put only a pointer on the stack as
above.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5592.62 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
