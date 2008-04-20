Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 19 Apr 2008 21:38:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3K4bivj015154
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 21:37:46 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 03B021596001
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 21:38:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id Qk51FAG3F9pB3Acd for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 21:38:25 -0700 (PDT)
Message-ID: <480AC8C1.1050102@sandeen.net>
Date: Sat, 19 Apr 2008 23:38:25 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Is my partition repairable?
References: <18b102300804090813u24423515k4c478635494534dc@mail.gmail.com>
In-Reply-To: <18b102300804090813u24423515k4c478635494534dc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: James Klaas <jklaas@appalachian.dyndns.org>
Cc: xfs@oss.sgi.com

James Klaas wrote:
> I've been struggling to recover/repair an XFS partition that is on a
> Linux software raid.  This is on Ubuntu Feisty (7.04) with xfsprogs
> v2.8.18.
> 
> When I try to mount the system, it attempts a recovery:
> 
> [127094.470809] Filesystem "md0": Disabling barriers, not supported by
> the underlying device
> [127094.471954] XFS mounting filesystem md0
> [127094.613551] Starting XFS recovery on filesystem: md0 (logdev: internal)
> [127094.858897] Filesystem "md0": XFS internal error
> xfs_btree_check_sblock at line 334 of file fs/xfs/xfs_btree.c.  Caller
> 0xf8eda9fb

The simplest approach, though perhaps not the least prone to data loss,
is to run xfs_repair with the -L option to zero out the log before
proceeding.

You could also mount -o ro,norecovery first to back up as much critical
data as possible, beforehand.

-Eric
