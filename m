Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 22:34:20 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9K5YHsv014955
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 22:34:18 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2B3551A04B
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 22:36:01 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id hFa4EJTZxtxROZPT for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 22:36:01 -0700 (PDT)
Date: Mon, 20 Oct 2008 16:35:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: git tree updates....
Message-ID: <20081020053553.GO31761@disturbed>
References: <20081017054742.GH31761@disturbed> <48FBF841.1060603@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FBF841.1060603@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 20, 2008 at 01:17:21PM +1000, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> Lachlan,
>>
>> I just noticed you've been updating the git tree. You might want to
>> change the order that certain patches have been committed - the
>> changes to the fs/inode.c needed to be committed before the changes
>> to fs/xfs/xfs_inode.c that use them. They've been committed the
>> wrong way around and about 20 commits apart, so there's significant
>> region in the commit history where the kernel will fail to build.
>> Given the distance between the commits, there's a fair chance that
>> a git bisect could land in this range of compiliation failures.
>>
>> Any chance of redoing these commits before you push to Linus so
>> that they are ordered correctly in the git tree?
>
> Yeah I'll try to get them back in the right order.  Our merge tools
> conveniently missed anything outside fs/xfs so I didn't realise I had
> missed them until after I merge all the XFS mods.  I just wanted to
> get something out for linux-next and also since the cvs tree was busted.

Fair enough - I wasn't sure that you noticed it.

> Out of curiosity Dave, why didn't you send those changes directly to
> Linus?

Because trying to co-ordinate an dependent updates in different
trees is extremely painful. We'd have to delay the XFS update 
till the inode patches were in mainline anyway, so it makes little
sense to separate them....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
