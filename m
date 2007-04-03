Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 03 Apr 2007 05:01:56 -0700 (PDT)
Received: from an-out-0708.google.com (an-out-0708.google.com [209.85.132.245])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l33C1lfB004228
	for <xfs@oss.sgi.com>; Tue, 3 Apr 2007 05:01:48 -0700
Received: by an-out-0708.google.com with SMTP id c5so1529305anc
        for <xfs@oss.sgi.com>; Tue, 03 Apr 2007 05:01:47 -0700 (PDT)
Message-ID: <12fac1030704030403t3ffc3599w5a0191476eb8b865@mail.gmail.com>
Date: Tue, 3 Apr 2007 13:03:39 +0200
From: Sencer <alisencer@gmail.com>
Subject: md/dm devices, barrier support, commodity hardware and data integrity
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,

After reading up on XFS, there are a couple of issues that still seem
kind of cloudy to me. I am merely a user of filesystems, so forgive me
if some issues seem obvious. If you could confirm/clarify/answer the
following issues, it would be very helpful to me.

Situation 1)
We are currently using XFS on a commodity x86 server with SATA drives
(with NCQ) on Debian Etch (Kernel: 2.6.18-3-k7). We are also using
Software-Raid1 (mdadm). All partitions except /boot are XFS. If I
understand the FAQ and recent ml-discussions right, then

1a) without software-raid, we would enjoy write barrier support,
however given that we are using md-devices this is not the case
(kern.log confirms this by explicitly stating barrier support is
disabled for mdX ...). Did this (barrier support with XFS on md)
change in later kernels or is it likely to change in the near (or far)
future? (I think I read mentions of md, and some kind of
barrier-awareness on the ml, but didn't quite understand what
effectively  follows from it from a users POV).

1b) Given the current circumstances above, we should disable write
cache as suggested in the faq (there are actually UPS's but they've
failed before) to reduce the possibility of loosing data. Correct? We
did need to do some hard-resets, and had power failure, though as of
yet we never had problems with lost data on any xfs partitions, and
I'd like to make sure it stays that way.

1c) We have backup strategies in place, so I can live with having a
few partly damaged files and restoring them from backups. However I am
not sure how we would make sure that we can find out about all such
damaged files or if any such files exist ( referring to
http://oss.sgi.com/projects/xfs/faq.html#nulls ). Are there tools for
finding potential candidates for corruption? I am assuming that there
would be a way to find out which files were the most recently touched
with the help of the journal. Or do I just use shell-magic and  find
files by mtime and check if there are Nulls at the end of those file
modified within the last minute or two before the crash?

Situation 2)
I hear many people saying that using XFS on machines that have no UPS
(as in Notebooks [battery removed], Desktops etc.) is something that
is not recommended. But after reading up on the issues, the
recommendation should really go for every FS that only does meta-data
journaling, as alluded to in the FAQ.

2a) And with the recent changes (barrier support and sync on
truncated+modified+closed files) I assume there is really no reason to
choose another meta-data journaling FS over XFS for such machines in
terms of likelihood of damaged files after hard-resets and power
failures - would you agree?

2b) When dm-crypt+luks is being used, there is no barrier support
available (for XFS) even if the underlying hdd supports it, correct?
Should this be expected to change, or is it more likely to stay that
way? (due to limited dev. resources and priorities? or due to
principal issues with it?)


Thanks in advance

Sencer
