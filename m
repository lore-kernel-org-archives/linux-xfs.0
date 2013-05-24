Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1F3B07CBF
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 08:10:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F0BD0304067
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 06:10:29 -0700 (PDT)
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4]) by
	cuda.sgi.com with ESMTP id 5UBvIKVbUoyRm5XE for
	<xfs@oss.sgi.com>; Fri, 24 May 2013 06:10:26 -0700 (PDT)
Date: Fri, 24 May 2013 15:10:22 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Intermittent crashes - xfs_repair finds no errors
Message-ID: <20130524151022.160656e9@harpe.intellique.com>
In-Reply-To: <CANU9nTnbA8WLK68X4yLFODiBZZgT4xX9U6fEmCHp+0+BMb6XQQ@mail.gmail.com>
References: <CANU9nTnbA8WLK68X4yLFODiBZZgT4xX9U6fEmCHp+0+BMb6XQQ@mail.gmail.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Ole Tange <tange@binf.ku.dk>
Cc: xfs@oss.sgi.com

Le Fri, 24 May 2013 11:59:02 +0200
Ole Tange <tange@binf.ku.dk> =E9crivait:

> # uname -a
> Linux lemaitre 3.2.0-0.bpo.1-amd64 #1 SMP Sat Feb 11 08:41:32 UTC 2012
> x86_64 GNU/Linux
> =

> May 13 11:43:31 lemaitre kernel: [507964.074856] XFS (md3): metadata
> I/O error: block 0x18dcf8 ("xfs_trans_read_buf") error 5 buf count
> 4096

What are the few previous lines of /var/log/messages before these?
There could be some hardware related message, or some hint of corrupted
metadata.

-- =

------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
