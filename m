Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 21:01:40 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M51YKC013804
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 21:01:37 -0800
Received: from mail.dvmed.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D138DE8F1DE
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 21:02:00 -0800 (PST)
Received: from mail.dvmed.net (srv5.dvmed.net [207.36.208.214]) by cuda.sgi.com with ESMTP id xF37oUkV6J62PTcf for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 21:02:00 -0800 (PST)
Message-ID: <47BE571E.4000802@garzik.org>
Date: Fri, 22 Feb 2008 00:01:18 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.25-rc3
References: <20080222044209.AD5C558C4C0F@chook.melbourne.sgi.com>
In-Reply-To: <20080222044209.AD5C558C4C0F@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org

Lachlan McIlroy wrote:
>     Remove empty file fs/xfs/Makefile-linux-2.6.

Already in the upstream kernel...


> commit 1803f3389b7ac9ed33ea561b3b94e22e2864a95d
> Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
> Date:   Wed Feb 20 19:55:09 2008 -0800
> 
>     Remove empty file remnants that were left in the tree by mistake
>     
>     Noted by various people (Sam, Jeff, Roland..)
>     
>     Commit 58b7983d15a422d9616bdc4e245d5c31dfaefbe2 intended to remove the
>     xfs "Makefile-linux-2.6" file, but it was mistakenly still left in the
>     tree as a empty file, and would cause git to correctly complain about a
>     tracked file being removed after a "make distclean" (which removes empty
>     files as garbage).
>     
>     And the asm-x86/desc_64.h file was supposed to be removed by commit
>     c81c6ca45a69478c7877b729af1942d2b80ef582, but instead stayed around
>     containing just a single newline.
>     
>     Get rid of them both properly.
>     
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
