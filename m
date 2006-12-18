Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Dec 2006 17:32:04 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBI1Vrqw021575
	for <linux-xfs@oss.sgi.com>; Sun, 17 Dec 2006 17:31:55 -0800
Message-Id: <200612180118.MAA21311@larry.melbourne.sgi.com>
From: "Barry Naujok" <bnaujok@melbourne.sgi.com>
Subject: RE: xfs_ncheck (actually xfs_db) eats a lot of memory and is killed
Date: Mon, 18 Dec 2006 12:24:21 +1100
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
In-Reply-To: <em1c1v$ig8$1@sea.gmane.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?iso-8859-2?Q?'Marcin_Zaj=B1czkowski'?= <mszpak@wp.pl>, linux-xfs@oss.sgi.com

 

> -----Original Message-----
> From: xfs-bounce@oss.sgi.com [mailto:xfs-bounce@oss.sgi.com] 
> On Behalf Of Marcin Zajaczkowski
> Sent: Sunday, 17 December 2006 4:58 AM
> To: linux-xfs@oss.sgi.com
> Subject: xfs_ncheck (actually xfs_db) eats a lot of memory 
> and is killed
> 
> Hi,
> 
> 
> A few weeks ago I described problem with my file system 
> (caused by a bug 
> in kernel 2.6.17) - 
> http://oss.sgi.com/archives/xfs/2006-11/msg00271.html
> 
> Recently I've got rescue CD with xfs_progs in version 2.8.11 
> and tried 
> to repair it. xfs_repair gave me about 150 files with names 
> like inode 
> numbers in /lost+found and 1500 "normal" named files in its 
> subdirectory.
> I've tried to use "xfs_ncheck -i inode /dev/hdX" to got names 
> corresponding with specified inode(s), but program had been runing 
> several minutes, xfs_db had eaten all available memory 
> (768MB) and was 
> killed by system (whole system hung too). The second time I killed it 
> (kill -15) when it ate whole available memory.
> My file system has about 6GB and is filled with 95%.

This is the second report of a smallish filesystem using all of the
system's memory (the other being xfs_repair). Hopefully when I diagnose
the problem with the previous report, I can fix the same issue with
xfs_db and your filesystem.

If it at all possible, can you xfs_copy the offending filesystem to a
file and compress it and make it available to me to find/fix the
problem.
 
> Am I doing something wrong with xfs_db?
> Is there any easier way to restore my files?

Your files have been restored as much as possible. You'll have to work
out what is in lost+found and move them back to their appropriate
locations.

> Btw, xfs_check shows two lines:
> link count mismatch for inode 1572882 (name ?), nlink 16, counted 15
> link count mismatch for inode 2102297 (name ?), nlink 2, counted 3
> Can it be reason for strange xfs_db behavior?

No, this shouldn't be causing the xfs_db strange behaviour, but the
nlink count mismatch is a problem with xfs_repair 2.8.11. Try and use
xfs_repair 2.8.16 and later to fix this issue. Older versions before
2.8.11 will also fix the nlink issue.
