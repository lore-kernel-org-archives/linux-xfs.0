Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 02:46:00 -0800 (PST)
Received: from gw02.mail.saunalahti.fi (gw02.mail.saunalahti.fi [195.197.172.116])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l08Ajsqw006620
	for <xfs@oss.sgi.com>; Mon, 8 Jan 2007 02:45:56 -0800
Received: from mrp2.mail.saunalahti.fi (mrp2.mail.saunalahti.fi [62.142.5.31])
	by gw02.mail.saunalahti.fi (Postfix) with ESMTP id 0EDFE13978A
	for <xfs@oss.sgi.com>; Mon,  8 Jan 2007 12:23:34 +0200 (EET)
Received: from [192.168.0.151] (unknown [62.142.247.178])
	(using SSLv3 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by mrp2.mail.saunalahti.fi (Postfix) with ESMTP id E1752598004
	for <xfs@oss.sgi.com>; Mon,  8 Jan 2007 12:23:32 +0200 (EET)
Subject: xfs_repair: corrupt inode error
From: Jyrki Muukkonen <jyrki.muukkonen@futurice.fi>
Content-Type: text/plain
Date: Mon, 08 Jan 2007 12:23:32 +0200
Message-Id: <1168251812.20568.8.camel@mustis>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Got this error in phase 6 when running xfs_repair 2.8.18 on ~1.2TB
partition over the weekend (it took around 60 hours to get to this
point :). On earlier versions xfs_repair aborted after ~15-20 hours with
"invalid inode type" error.

...
disconnected inode 4151889519, moving to lost+found
disconnected inode 4151889543, moving to lost+found
corrupt inode 4151889543 (btree).  This is a bug.
Please report it to xfs@oss.sgi.com.
cache_node_purge: refcount was 1, not zero (node=0x132650d0)

fatal error -- 117 - couldn't iget disconnected inode

I've got the full log (both stderr and stdout) and can put that
somewhere if needed. It's about 80MB uncompressed and around 7MB
gzipped. Running the xfs_repair without multithreading and with -v might
also be possible if that's going to help.

-- 
Jyrki Muukkonen
Futurice Oy
jyrki.muukkonen@futurice.fi
+358 41 501 7322
