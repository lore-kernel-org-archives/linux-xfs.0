Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Dec 2006 20:06:28 -0800 (PST)
Received: from s-utl01-dcpop.stsn.net (s-utl01-dcpop.stsn.net [72.255.0.201])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBO46Lqx030511
	for <linux-xfs@oss.sgi.com>; Sat, 23 Dec 2006 20:06:23 -0800
Message-ID: <458DF8F7.5030104@sandeen.net>
Date: Sat, 23 Dec 2006 21:50:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: unexpected XFS SB magic number
References: <Pine.SOL.4.58.0612221219570.2514@titan.cfa.harvard.edu> <458C6719.6080106@sandeen.net> <Pine.SOL.4.58.0612221824500.2856@titan.cfa.harvard.edu> <458C6C5A.6090504@sandeen.net> <Pine.SOL.4.58.0612231748450.3446@titan.cfa.harvard.edu>
In-Reply-To: <Pine.SOL.4.58.0612231748450.3446@titan.cfa.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: gbakos@cfa.harvard.edu
Cc: linux-xfs@oss.sgi.com

Gaspar Bakos wrote:
> Hi, Eric,

> One of the users was running quite memory and disk IO intensive tasks
> past week. This lead to a crash. (I was not around to keep an eye on
> it). The computer rebooted, and few days later another crash, etc.
> Finally, when I returned this week, I found it powered off.
> 
> And then I realized that the sdc1 partition can not be mounted any more.

Well, something put a gpt label on top of your xfs partition... and it 
wasn't xfs :)

>> i also remember something about parted (maybe...) finding a backup gpt
>> signature at the end of a disk, and "helpfully" copying it over the
>> front end if so.  This was a bug.  sgi guys do you remember?
> 
> But for this one has to invoke parted, and commit the operations done,
> am I right?

if I recall, even invoking parted could do this.

> Maybe there is a nasty daemon doing something. The fs was also exported
> as NFS and mounted by two other hosts.
> 
> ---------
> So the questions are:
> - what partition type to choose next time?
> - is there a simpler way of recovery (than xfs_recovery), i.e. the
>   first few bytes of the partition need to be changed back to something
>   XFS magic, and the rest is probably untouched?

i'd google around and find out how big the gpt header is; try to find 
out how much of the front of your partition got clobbered.  that'll give 
a clue as to how much you may have lost.

-Eric
