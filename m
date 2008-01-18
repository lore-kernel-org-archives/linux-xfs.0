Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 18 Jan 2008 10:05:29 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0II5PiB006683
	for <linux-xfs@oss.sgi.com>; Fri, 18 Jan 2008 10:05:26 -0800
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D7A3536429
	for <linux-xfs@oss.sgi.com>; Fri, 18 Jan 2008 10:05:40 -0800 (PST)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id ArwJl6PTOd3g4UH7 for <linux-xfs@oss.sgi.com>; Fri, 18 Jan 2008 10:05:40 -0800 (PST)
Received: from [192.168.1.21] (dslb-084-056-113-002.pools.arcor-ip.net [84.56.113.2])
	by mail.lichtvoll.de (Postfix) with ESMTP id 00D275AD29
	for <linux-xfs@oss.sgi.com>; Fri, 18 Jan 2008 19:04:16 +0100 (CET)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: [REVIEW 0/2] Case insensitive support for XFS
Date: Fri, 18 Jan 2008 19:05:04 +0100
References: <op.t43ze9ot3jf8g2@pc-bnaujok.melbourne.sgi.com> (sfid-20080118_105816_866313_50CC6B33)
In-Reply-To: <op.t43ze9ot3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181905.05263.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hi Barry!

Am Freitag 18 Januar 2008 schrieb Barry Naujok:

> There are two mount options for enabling case-insensitivity
> on a Unicode XFS filesystem:
>    - "ci" - enables case-insensitivity for file names
>    - "ciattr" - enables case-insensitivity for extended
>                 attributes.

How do I know that I am on an Unicode XFS filesystem. Could I see this 
with xfs_db -r -c 'sb 0' -c p <device>? Hmm, nothing unicode related in 
there as far as I can see. The fs was created with 2.6.23, mkfs.xfs 2.9.4 
and the mkfs options that David suggested.

Do I need to backup / mkfs / restore to switch to one? I understand that I 
can switch between enable / disable case-insensitivity via a mount 
option. Would I be able to enable unicode via xfs_db version command or 
something like it?

Just curious.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
