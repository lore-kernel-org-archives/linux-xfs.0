Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 06 Sep 2007 17:18:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l870I04p005569
	for <xfs@oss.sgi.com>; Thu, 6 Sep 2007 17:18:05 -0700
Date: Fri, 07 Sep 2007 10:23:37 +1000
Subject: Re: Bug Report
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <170b1bd40709061005t787494b6lca283320cace6c31@mail.gmail.com>
Message-ID: <op.tx9cpngf3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <170b1bd40709061005t787494b6lca283320cace6c31@mail.gmail.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodall <mark.goodall@gmail.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, 07 Sep 2007 03:05:29 +1000, Mark Goodall <mark.goodall@gmail.com>  
wrote:

> Not sure what caused this bug, how much more information do you need?

Version number of xfs_repair. Also, if possible, a zipped metadump image
(need xfsprogs 2.9.0 or later) to fix any xfs_repair bugs.

Regards,
Barry.

>         - 18:01:15: check for inodes claiming duplicate blocks - 198528  
> of
> 198528 inodes done
> No modify flag set, skipping phase 5
> Phase 6 - check inode connectivity...
>         - traversing filesystem starting at / ...
> corrupt dinode 25809974, extent total = 16, nblocks = 0.  This is a bug.
> Please report it to xfs@oss.sgi.com.
> cache_node_purge: refcount was 1, not zero (node=0x8d65fd0)
> couldn't map inode 25809974, err = 117
> entry "gobo_3.3-6_i386.deb" in shortform directory inode 1770978822  
> points
> to free inode 1770978825
> would junk entry "gobo_3.3-6_i386.deb"
>         - 18:01:48: traversing filesystem - 32 of 32 allocation groups  
> done
>         - traversal finished ...
>         - traversing all unattached subtrees ...
> Segmentation fault (core dumped)
>
> OS: Ubuntu Linux mserve 2.6.20-16-386 #2 Fri Aug 31 00:51:58 UTC 2007  
> i686
> GNU/Linux
> fully patched from official repositories
>
>
> [[HTML alternate version deleted]]
>
>
