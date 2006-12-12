Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 12 Dec 2006 01:26:53 -0800 (PST)
Received: from mail.lichtvoll.de (13.unused.teamix.net [194.150.191.13] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBC9Qaqw019255
	for <linux-xfs@oss.sgi.com>; Tue, 12 Dec 2006 01:26:38 -0800
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: hints on how to help debugging as FAQ entry (Re: invalid directory entry - bad magic number on inode)
Date: Tue, 12 Dec 2006 10:25:41 +0100
References: <200612082100.00395.Martin@lichtvoll.de> <200612112111.08209.Martin@lichtvoll.de> <457DFA6A.9050200@sgi.com>
In-Reply-To: <457DFA6A.9050200@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200612121025.42895.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, lachlan@sgi.com
Cc: xfs-dev@sgi.com

Am Dienstag 12 Dezember 2006 01:40 schrieb Lachlan McIlroy:

> > You are welcome. Without further info reporting it to the bugtracker
> > doesn't make much sense to me. I will keep an eye on it. If it
> > happens again, I  will try the hints you gave me. I run xfs_check
> > anyway and thus can easily give it a "-v >xfs_check.txt". I thought I
> > would have to use xfs_db stuff to get further info.
>
> Now that you mention it, printing out the inode in xfs_db might be
> useful.

Hello Lachlan,

well I can do that too... my problem is just: As I use the notebook for 
daily work I have to fix it up quickly when problems arise. So usually I 
can not afford to report first and await instructions on what to do. I 
also currently often have no storage space left to store the complete 
partition onto. 

So ideally I have some hints on how to help debugging before an incident 
happens. I think this would make a nice FAQ entry, too. 

It could contain:

1) xfs_check -v <device>
2) xfs_check -v -i <inode> <device>
3) xfs_db stuff
4) probably some hints to determine a useful range for dd / ddrescue from 
xfs_check output so that people with either very large partitions or low 
storage space can just copy a part of the defect partition for 
inspection. Well if thats useful. A complete partition would still be 
better cause it is possible to use the XFS tools on it
5) probably some hints on how to store a partition in a file with 
compression... somewhere along the lines of piping dd into bzip2 and 
bzip2 into a file. maybe "cat /dev/hda1 | bzip2 >mypartition"

What do you think?

Those hints could help XFS developers to get useful bug reports...

I am willing to collect the hints and writing a FAQ entry about it that 
you can include in your FAQ.

Well that would probably basically be an extension to:

" Q: What information should I include when reporting a problem?"

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
