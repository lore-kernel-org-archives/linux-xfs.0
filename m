Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 19:16:40 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9K2GbaV024295
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 19:16:37 -0700
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by netops-testserver-3.corp.sgi.com (Postfix) with SMTP id 344B19088D
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 19:18:18 -0700 (PDT)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id NAA07390 for <xfs@oss.sgi.com>; Mon, 20 Oct 2008 13:18:17 +1100
Message-ID: <48FBF841.1060603@sgi.com>
Date: Mon, 20 Oct 2008 13:17:21 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: git tree updates....
References: <20081017054742.GH31761@disturbed>
In-Reply-To: <20081017054742.GH31761@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Dave Chinner wrote:
> Lachlan,
> 
> I just noticed you've been updating the git tree. You might want to
> change the order that certain patches have been committed - the
> changes to the fs/inode.c needed to be committed before the changes
> to fs/xfs/xfs_inode.c that use them. They've been committed the
> wrong way around and about 20 commits apart, so there's significant
> region in the commit history where the kernel will fail to build.
> Given the distance between the commits, there's a fair chance that
> a git bisect could land in this range of compiliation failures.
> 
> Any chance of redoing these commits before you push to Linus so
> that they are ordered correctly in the git tree?

Yeah I'll try to get them back in the right order.  Our merge tools
conveniently missed anything outside fs/xfs so I didn't realise I had
missed them until after I merge all the XFS mods.  I just wanted to
get something out for linux-next and also since the cvs tree was busted.

Out of curiosity Dave, why didn't you send those changes directly to
Linus?
