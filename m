Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Feb 2008 23:12:43 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1Q7CbEk017685
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 23:12:39 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A9A1A61892B
	for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 23:13:05 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id HuVzVBzjlXLGUhO4 for <xfs@oss.sgi.com>; Mon, 25 Feb 2008 23:13:05 -0800 (PST)
Message-ID: <47C3BBF9.8090403@sandeen.net>
Date: Mon, 25 Feb 2008 23:12:57 -0800
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [GIT PULL] XFS update for 2.6.25-rc4
References: <20080226064909.5457F58C4C0F@chook.melbourne.sgi.com>
In-Reply-To: <20080226064909.5457F58C4C0F@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

Lachlan McIlroy wrote:
> Please pull from the for-linus branch:
>     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
> 
> This will update the following files:
> 
>  fs/xfs/xfs_bit.c     |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_bit.h     |   27 ++-----------
>  fs/xfs/xfs_rtalloc.c |   19 ++++++---
>  3 files changed, 120 insertions(+), 29 deletions(-)

what's the thought on fixing the ikeep regression for 2.6.25?

-Eric

> through these commits:
> 
> commit ef8ece55d9b6825c28a5c1a4bd89b94040cb7b32
> Author: Lachlan McIlroy <lachlan@sgi.com>
> Date:   Tue Feb 26 17:00:22 2008 +1100
> 
>     [XFS] Undo bit ops cleanup mod due to regression on 32-bit powermac
>     platform.
>     
>     SGI-PV: 971186
>     SGI-Modid: xfs-linux-melb:xfs-kern:30559a
>     
>     Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
> 
> commit db69c915e67705daac25cad06d816c09be634de0
> Author: Lachlan McIlroy <lachlan@sgi.com>
> Date:   Tue Feb 26 17:00:14 2008 +1100
> 
>     [XFS] Undo bit ops cleanup mod due to regression on 32-bit powermac
>     platform.
>     
>     SGI-PV: 974005
>     SGI-Modid: xfs-linux-melb:xfs-kern:30558a
>     
>     Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
> 
> 
