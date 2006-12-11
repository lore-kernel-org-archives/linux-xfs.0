Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 11 Dec 2006 12:12:12 -0800 (PST)
Received: from mail.lichtvoll.de (13.unused.teamix.net [194.150.191.13] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kBBKC2qw015802
	for <linux-xfs@oss.sgi.com>; Mon, 11 Dec 2006 12:12:03 -0800
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: invalid directory entry - bad magic number on inode
Date: Mon, 11 Dec 2006 21:11:07 +0100
References: <200612082100.00395.Martin@lichtvoll.de> <457D65A1.8030609@sgi.com>
In-Reply-To: <457D65A1.8030609@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200612112111.08209.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com, lachlan@sgi.com
Cc: xfs-dev@sgi.com

Am Montag 11 Dezember 2006 15:05 schrieb Lachlan McIlroy:

> > Any hints on what I could try if it ever happens again? Suppose I can
> > save out the bad inode contents before I let xfs_repair fix it...
>
> If you see it again could you run xfs_check in verbose mode (ie
> xfs_check -v /dev/hda5 and xfs_check -v -i <inode number> /dev/hda5)?

Hello Lachlan,

thanks for the hints. So far it didn't occur again (at least not that I am 
aware of) - well I don't expect it to happen often and am not really sure 
whether it will happen again at all.

> Thanks for reporting this problem.

You are welcome. Without further info reporting it to the bugtracker 
doesn't make much sense to me. I will keep an eye on it. If it happens 
again, I  will try the hints you gave me. I run xfs_check anyway and thus 
can easily give it a "-v >xfs_check.txt". I thought I would have to use 
xfs_db stuff to get further info.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
