Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Dec 2006 09:17:47 -0800 (PST)
Received: from imr2.americas.sgi.com (imr2.americas.sgi.com [198.149.16.18])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBJHHgqw029737
	for <linux-xfs@oss.sgi.com>; Tue, 19 Dec 2006 09:17:43 -0800
Message-ID: <45881E7F.1070604@sgi.com>
Date: Tue, 19 Dec 2006 17:16:47 +0000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: hints on how to help debugging as FAQ entry (Re: invalid directory
 entry - bad magic number on inode)
References: <200612082100.00395.Martin@lichtvoll.de> <200612112111.08209.Martin@lichtvoll.de> <457DFA6A.9050200@sgi.com> <200612121025.42895.Martin@lichtvoll.de>
In-Reply-To: <200612121025.42895.Martin@lichtvoll.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-xfs@oss.sgi.com, xfs-dev@sgi.com

Martin Steigerwald wrote:
> Am Dienstag 12 Dezember 2006 01:40 schrieb Lachlan McIlroy:
> 
> 
>>>You are welcome. Without further info reporting it to the bugtracker
>>>doesn't make much sense to me. I will keep an eye on it. If it
>>>happens again, I  will try the hints you gave me. I run xfs_check
>>>anyway and thus can easily give it a "-v >xfs_check.txt". I thought I
>>>would have to use xfs_db stuff to get further info.
>>
>>Now that you mention it, printing out the inode in xfs_db might be
>>useful.
> 
> 
> Hello Lachlan,
> 
> well I can do that too... my problem is just: As I use the notebook for 
> daily work I have to fix it up quickly when problems arise. So usually I 
> can not afford to report first and await instructions on what to do. I 
> also currently often have no storage space left to store the complete 
> partition onto. 
> 
> So ideally I have some hints on how to help debugging before an incident 
> happens. I think this would make a nice FAQ entry, too. 
> 
> It could contain:
> 
> 1) xfs_check -v <device>
> 2) xfs_check -v -i <inode> <device>
> 3) xfs_db stuff
> 4) probably some hints to determine a useful range for dd / ddrescue from 
> xfs_check output so that people with either very large partitions or low 
> storage space can just copy a part of the defect partition for 
> inspection. Well if thats useful. A complete partition would still be 
> better cause it is possible to use the XFS tools on it

Since the tools wont operate on a fragment of a partition I don't think
this would be feasible.  It might be possible to debug a single allocation
group on it's own but not right now as far as I'm aware.

> 5) probably some hints on how to store a partition in a file with 
> compression... somewhere along the lines of piping dd into bzip2 and 
> bzip2 into a file. maybe "cat /dev/hda1 | bzip2 >mypartition"

Is this so that the problem can be debugged while the filesystem is still
in use or is repaired?  If the file system can be repaired then the output
from repair should be enough to tell us what the problem is (the cause is 
another matter but we're unlikely to get more information from a dump of
the partition).  If the partition cannot be repaired then I don't see a
point in dumping the partition to a file since the filesystem needs to be
fixed before it should be used again.

> 
> What do you think?

Sounds good.  Our FAQ is lacking in bug triage processes so any hints to
gather additional information would be a welcome addition.

> 
> Those hints could help XFS developers to get useful bug reports...
> 
> I am willing to collect the hints and writing a FAQ entry about it that 
> you can include in your FAQ.
> 
> Well that would probably basically be an extension to:
> 
> " Q: What information should I include when reporting a problem?"
> 
> Regards,
