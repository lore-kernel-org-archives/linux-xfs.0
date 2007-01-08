Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 08:08:14 -0800 (PST)
Received: from gw03.mail.saunalahti.fi (gw03.mail.saunalahti.fi [195.197.172.111])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l08G86qw006890
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 08:08:07 -0800
Received: from mrp3.mail.saunalahti.fi (mrp3.mail.saunalahti.fi [62.142.5.32])
	by gw03.mail.saunalahti.fi (Postfix) with ESMTP id 129C521638F
	for <xfs@oss.sgi.com>; Mon,  8 Jan 2007 18:07:13 +0200 (EET)
Received: from [192.168.0.151] (unknown [62.142.247.178])
	(using SSLv3 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by mrp3.mail.saunalahti.fi (Postfix) with ESMTP id E647B708001
	for <xfs@oss.sgi.com>; Mon,  8 Jan 2007 18:07:11 +0200 (EET)
Subject: Re: xfs_repair: corrupt inode error
From: Jyrki Muukkonen <jyrki.muukkonen@futurice.fi>
In-Reply-To: <1168251812.20568.8.camel@mustis>
References: <1168251812.20568.8.camel@mustis>
Content-Type: text/plain
Date: Mon, 08 Jan 2007 18:07:11 +0200
Message-Id: <1168272431.21580.14.camel@mustis>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On ma, 2007-01-08 at 12:23 +0200, Jyrki Muukkonen wrote:
> Got this error in phase 6 when running xfs_repair 2.8.18 on ~1.2TB
> partition over the weekend (it took around 60 hours to get to this
> point :). On earlier versions xfs_repair aborted after ~15-20 hours with
> "invalid inode type" error.
> 
> ...
> disconnected inode 4151889519, moving to lost+found
> disconnected inode 4151889543, moving to lost+found
> corrupt inode 4151889543 (btree).  This is a bug.
> Please report it to xfs@oss.sgi.com.
> cache_node_purge: refcount was 1, not zero (node=0x132650d0)
> 
> fatal error -- 117 - couldn't iget disconnected inode
> 
> I've got the full log (both stderr and stdout) and can put that
> somewhere if needed. It's about 80MB uncompressed and around 7MB
> gzipped. Running the xfs_repair without multithreading and with -v might
> also be possible if that's going to help.
> 

Some more information:
- running 64bit Ubuntu Edgy 2.6.17-10-generic
- one processor so xfs_repair was run with two threads
- 1.5GB RAM, 3GB swap (at some point the xfs_repair process took a bit
over 2GB)
- filesystem is ~1.14TB with about ~1.4 million files
- most of the files are in subdirectories by date
(/something/YYYY/MM/DD/), ~2-10 thousand per day

So is there a way to skip / ignore this error? I could do some testing
with different command line options and small code patches if that's
going to help solve the bug.

Most of the files have been recovered from backups, raw disk images etc.
but unfortunately some are still missing.

-- 
Jyrki Muukkonen
Futurice Oy
jyrki.muukkonen@futurice.fi
+358 41 501 7322
