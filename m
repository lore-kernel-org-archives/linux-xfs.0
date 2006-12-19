Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Dec 2006 23:39:19 -0800 (PST)
Received: from ciao.gmane.org (main.gmane.org [80.91.229.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBJ7dCqw005720
	for <linux-xfs@oss.sgi.com>; Mon, 18 Dec 2006 23:39:13 -0800
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1GwZYK-0003SO-FY
	for linux-xfs@oss.sgi.com; Tue, 19 Dec 2006 08:38:20 +0100
Received: from finn.gmane.org ([80.91.229.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Tue, 19 Dec 2006 08:38:20 +0100
Received: from mszpak by finn.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-xfs@oss.sgi.com>; Tue, 19 Dec 2006 08:38:20 +0100
From: =?ISO-8859-2?Q?Marcin_Zaj=B1czkowski?= <mszpak@wp.pl>
Subject: Re: xfs_ncheck (actually xfs_db) eats a lot of memory and is killed
Date: Tue, 19 Dec 2006 08:38:59 +0100
Message-ID: <em84t3$b27$1@sea.gmane.org>
References: <em1c1v$ig8$1@sea.gmane.org> <200612180118.MAA21311@larry.melbourne.sgi.com> <em5il9$tge$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
In-Reply-To: <em5il9$tge$1@sea.gmane.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

Marcin Zaj±czkowski wrote:
> Barry Naujok wrote:
>>> Subject: xfs_ncheck (actually xfs_db) eats a lot of memory and is killed
> (...)
>>> Recently I've got rescue CD with xfs_progs in version 2.8.11 and 
>>> tried to repair it. xfs_repair gave me about 150 files with names 
>>> like inode numbers in /lost+found and 1500 "normal" named files in 
>>> its subdirectory.
>>> I've tried to use "xfs_ncheck -i inode /dev/hdX" to got names 
>>> corresponding with specified inode(s), but program had been runing 
>>> several minutes, xfs_db had eaten all available memory (768MB) and 
>>> was killed by system (whole system hung too). The second time I 
>>> killed it (kill -15) when it ate whole available memory.
>>> My file system has about 6GB and is filled with 95%.
>>
>> This is the second report of a smallish filesystem using all of the
>> system's memory (the other being xfs_repair). Hopefully when I diagnose
>> the problem with the previous report, I can fix the same issue with
>> xfs_db and your filesystem.
>>
>> If it at all possible, can you xfs_copy the offending filesystem to a
>> file and compress it and make it available to me to find/fix the
>> problem.
> 
> Hmm, it won't be so easy. Compressed dump of a fielsystem before repair 
> (I had to use dd, because xfsdump refused to cooperate) has 2,5GB.
> Damaged files were (probably) only in one directory /usr/bin. Maybe I 
> could reduce size of the image excluding few other directories (in 
> xfsdump)?
> Do you think that error would still occur?

What do you think about that?


Btw, is it possible to mount XFS filesystem from the file created by 
xfs_copy?
If not, is it possible to restore file system "backuped" to file (by 
xfs_copy)? I read in the manual that the first parameter xfs_copy has to 
be device (not file). xfs_restore will work with that "dump"?


>>> Am I doing something wrong with xfs_db?
>>> Is there any easier way to restore my files?
>>
>> Your files have been restored as much as possible. You'll have to work
>> out what is in lost+found and move them back to their appropriate
>> locations.
> 
> With files with "normal" names there is no problem. There are all from 
> one directory (/usr/bin), but I'm unable (without xfs_ncheck) to map 
> files with inode-like names with their normal names (150+ files). I 
> tried with xfs_db and the way described in your FAQ, but I had some 
> problems too.

Currently I have to use LiveCD (/usr/bin is a quite important directory 
;) ). Do you suggest to try to repair it manually (copy files with 
names, try to boot and try to use RPM to repair broken packages 
(restore missing files) or there could be an easiest way (at the xfs 
layer to match numbers with proper names)?


Regards
Marcin
