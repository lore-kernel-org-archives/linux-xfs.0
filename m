Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 21:49:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q4nEv4013283
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 21:49:16 -0700
Received: from web65603.mail.ac4.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id F13BC1288F1C
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 21:50:49 -0700 (PDT)
Received: from web65603.mail.ac4.yahoo.com (web65603.mail.ac4.yahoo.com [76.13.9.71]) by cuda.sgi.com with SMTP id pgnGZsmjVHofGWiH for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 21:50:49 -0700 (PDT)
Date: Thu, 25 Sep 2008 21:50:48 -0700 (PDT)
From: p v <pvlogin@yahoo.com>
Reply-To: pvlogin@yahoo.com
Subject: Clarification about NULLs in the file after a crash
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <607544.16970.qm@web65603.mail.ac4.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

so I've read the FAQ regarding the NULLs in the xfs
file after a crash (attached at the end of this email). I am
running an older version of the kernel which doesn't
have the fix for this problem and my question is this - is it
possible to get NULLs in the middle of the file or is it
guaranteed that I can get NULLs only at the tail of the file
if my io pattern is as following -

my io pattern is simple -

open() - open file with no special flags - defaults to
async

in a loop continuously perform extending writes
 lseek() - lseek to the end of the file
 writev()

Let's say that I did lseek/writev 10x - if I crash
after that according to the FAQ I can get NULLs in the file
- but - can I get it only at the end of the file or is it
possible to get NULLs in the middle as well? I could modify
my application to recover if it was only at the end
(ftruncate up to the last initialized data in the file) but
I cannot traverse the whole file and I don't want to
create checkpoints by doing fdatasync from time to time (at
that point I would consider to go up to the fixed version of
xfs).
 
Also - with the fix I assume that it's not possible to
end up with NULLs at all after the crash anywhere in the
file - in the middle or at the end. All the data under isize
is guaranteed to be initialized (even though I might loose
some of the last writes) Is my assumption correct?

thank you

Peter Vajgel


Q: Why do I see binary NULLS in some files after recovery
when I unplugged the power?

Update: This issue has been addressed with a CVS fix on the
29th March 2007 and merged into mainline on 8th May 2007 for
2.6.22-rc1.

XFS journals metadata updates, not data updates. After a
crash you are supposed to get a consistent filesystem which
looks like the state sometime shortly before the crash, NOT
what the in memory image looked like the instant before the
crash.

Since XFS does not write data out immediately unless you
tell it to with fsync, an O_SYNC or O_DIRECT open (the same
is true of other filesystems), you are looking at an inode
which was flushed out, but whose data was not. Typically
you'll find that the inode is not taking any space since
all it has is a size but no extents allocated (try examining
the file with the xfs_bmap(8) command).


      
