Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 28 May 2008 15:21:10 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4SML6cQ024930
	for <linux-xfs@oss.sgi.com>; Wed, 28 May 2008 15:21:06 -0700
Received: from mail.lichtvoll.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 871C61C7E15
	for <linux-xfs@oss.sgi.com>; Wed, 28 May 2008 15:21:56 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by cuda.sgi.com with ESMTP id 7ozsPjGnsIPX9wZi for <linux-xfs@oss.sgi.com>; Wed, 28 May 2008 15:21:56 -0700 (PDT)
Received: from [10.0.0.21] (g226140169.adsl.alicedsl.de [92.226.140.169])
	by mail.lichtvoll.de (Postfix) with ESMTP id BF7D85AE0E
	for <linux-xfs@oss.sgi.com>; Thu, 29 May 2008 00:22:13 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Question for XFS (mounting and clean bit)
Date: Thu, 29 May 2008 00:21:52 +0200
References: <20080527181336.22qjfcgcfdlwsg40@webmail.versatel.de> (sfid-20080527_213946_881555_0B129DA7)
In-Reply-To: <20080527181336.22qjfcgcfdlwsg40@webmail.versatel.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805290021.53240.Martin@lichtvoll.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com


Hi Andre,

Am Dienstag 27 Mai 2008 schrieb Andre Nitschke:
> Hello,
> i am a Linux User from Germany and chanched to xfs. I use Debian 4 and
> the installer creates lilo. Because of a wrong configuration i
> destroyed the lilo.conf and rebootet with a systemrescuecd. from here i
> mount the xfs partition and try to run lilo, but it fails.
> then i had a realy bad idea. i unmount the xfs partition and then mount
> it as root, but there exit a root file system.

[...]

> i have two questions. first, is the xfs on my working-machine damaged
> by my bad idea mounting two devices as root
> and secound, is the clean bit removed when mounting a xfs or when i
> first write data on it?

Mounting two devices on / should not harm the XFS filesystem in itself. I 
even think that also new files created from within the already running 
part of the live distribution should go to the initially mounted root 
filesystem (if the live distro creates new files in there at all). But I 
am not completely sure on that.

Anyway, there are two ways to check: xfs_check or xfs_repair -n

I do not know an answer to you second question. But when atime updates are 
enabled you usually have your first write pretty soon.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
