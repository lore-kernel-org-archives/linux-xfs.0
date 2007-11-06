Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 06 Nov 2007 08:46:16 -0800 (PST)
Received: from hogwarts.egr.duke.edu (hogwarts.egr.duke.edu [152.3.195.84])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA6GkAKd008127
	for <xfs@oss.sgi.com>; Tue, 6 Nov 2007 08:46:13 -0800
Date: Tue, 6 Nov 2007 11:46:09 -0500 (EST)
From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: 7Tb XFS partition lost on reboot
In-Reply-To: <473072FD.4070104@jamendo.com>
Message-ID: <alpine.LRH.0.9999.0711061144540.17301@hogwarts.egr.duke.edu>
References: <473072FD.4070104@jamendo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Amandine AUPETIT <amandine@jamendo.com>
Cc: xfs@oss.sgi.com

On Tue, 6 Nov 2007 at 2:58pm, Amandine AUPETIT wrote

> So I created the partition with parted, because fdisk can't do more that 2tb 
> partitions.
> It's ok, I can do what I want but...
>
> on reboot, there is a Superblock problem, something like that. When I check 
> with xfs_check :

First guess -- did you use a gpt disklabel on that device?  Standard 
(msdos) disklabels don't work on devices >2TB.  The usual symptom of a big 
device with an msdos disklabel is that the partition table goes away on 
reboot.

-- 
Joshua Baker-LePain
QB3 Shared Cluster Sysadmin
UCSF
