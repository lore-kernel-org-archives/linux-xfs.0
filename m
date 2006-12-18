Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Dec 2006 00:16:57 -0800 (PST)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBI8Gkqw001765
	for <linux-xfs@oss.sgi.com>; Mon, 18 Dec 2006 00:16:49 -0800
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1GwDeG-0001GH-PM
	for linux-xfs@oss.sgi.com; Mon, 18 Dec 2006 09:15:01 +0100
Received: from finn.gmane.org ([80.91.229.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 18 Dec 2006 09:15:00 +0100
Received: from mszpak by finn.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Mon, 18 Dec 2006 09:15:00 +0100
From: =?ISO-8859-2?Q?Marcin_Zaj=B1czkowski?= <mszpak@wp.pl>
Subject: Re: xfs_ncheck (actually xfs_db) eats a lot of memory and is killed
Date: Mon, 18 Dec 2006 09:15:19 +0100
Message-ID: <em5il9$tge$1@sea.gmane.org>
References: <em1c1v$ig8$1@sea.gmane.org> <200612180118.MAA21311@larry.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <200612180118.MAA21311@larry.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Barry Naujok wrote:
>> Subject: xfs_ncheck (actually xfs_db) eats a lot of memory 
>> and is killed
(...)
>> Recently I've got rescue CD with xfs_progs in version 2.8.11 
>> and tried 
>> to repair it. xfs_repair gave me about 150 files with names 
>> like inode 
>> numbers in /lost+found and 1500 "normal" named files in its 
>> subdirectory.
>> I've tried to use "xfs_ncheck -i inode /dev/hdX" to got names 
>> corresponding with specified inode(s), but program had been runing 
>> several minutes, xfs_db had eaten all available memory 
>> (768MB) and was 
>> killed by system (whole system hung too). The second time I killed it 
>> (kill -15) when it ate whole available memory.
>> My file system has about 6GB and is filled with 95%.
> 
> This is the second report of a smallish filesystem using all of the
> system's memory (the other being xfs_repair). Hopefully when I diagnose
> the problem with the previous report, I can fix the same issue with
> xfs_db and your filesystem.
> 
> If it at all possible, can you xfs_copy the offending filesystem to a
> file and compress it and make it available to me to find/fix the
> problem.

Hmm, it won't be so easy. Compressed dump of a fielsystem before repair 
(I had to use dd, because xfsdump refused to cooperate) has 2,5GB.
Damaged files were (probably) only in one directory /usr/bin. Maybe I 
could reduce size of the image excluding few other directories (in xfsdump)?
Do you think that error would still occur?


>> Am I doing something wrong with xfs_db?
>> Is there any easier way to restore my files?
> 
> Your files have been restored as much as possible. You'll have to work
> out what is in lost+found and move them back to their appropriate
> locations.

With files with "normal" names there is no problem. There are all from 
one directory (/usr/bin), but I'm unable (without xfs_ncheck) to map 
files with inode-like names with their normal names (150+ files). I 
tried with xfs_db and the way described in your FAQ, but I had some 
problems too.


>> Btw, xfs_check shows two lines:
>> link count mismatch for inode 1572882 (name ?), nlink 16, counted 15
>> link count mismatch for inode 2102297 (name ?), nlink 2, counted 3
>> Can it be reason for strange xfs_db behavior?
> 
> No, this shouldn't be causing the xfs_db strange behaviour, but the
> nlink count mismatch is a problem with xfs_repair 2.8.11. Try and use
> xfs_repair 2.8.16 and later to fix this issue. Older versions before
> 2.8.11 will also fix the nlink issue.

I have some old system rescue CD with xfs_progs from line 2.7.x. Would 
it be ok?


Regards
Marcin
