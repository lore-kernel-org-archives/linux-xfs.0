Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 18:06:01 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAD25rmI006804
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 18:05:53 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 170DB1B21CE1
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 18:05:52 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id hDHTigD1JFQFlgkO for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 18:05:52 -0800 (PST)
Message-ID: <491B83E5.4030002@sandeen.net>
Date: Wed, 12 Nov 2008 19:33:25 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: last xfs_repair time?
References: <20081112224109.GC18990@pixar.com> <491B6F4C.6030506@sgi.com> <491B7EB9.1050207@sandeen.net> <20081113012045.GL18990@pixar.com>
In-Reply-To: <20081113012045.GL18990@pixar.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lars Damerow <lars@pixar.com>
Cc: Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

Lars Damerow wrote:
> From Eric Sandeen <sandeen@sandeen.net>, Wed, Nov 12, 2008 at 07:11:21PM -0600:
>> Timothy Shimmin wrote:
>>> Lars Damerow wrote:
>>>> Hi folks,
>>>>
>>>> Is it possible to query XFS for the last time xfs_repair fixed a
>>>> filesystem? I've been searching the man pages and haven't found anything
>>>> useful.
>>>>
>>> Not that I know of.
>>> Barry is the repair maintainer/expert though.
>>>
>>> --Tim
>>>
>>>
>> AFAIK it doesn't, but that'd be a neat feature - adding space for that,
>> and maybe date of mkfs (or mkfs version) etc might be nice too.
> 
> Thanks for the responses! It's handy to have that information
> available, especially when you're maintaining hundreds of workstations
> whose power cables occasionally get yanked out by their users. :/

So, for what it's worth, power loss should not necessarily require a
repair; as long as you have barriers enabled and/or you're not losing
log writes to a volatile write cache, power loss should never corrupt
the filesystem metadata; that is what the log is for, after all...

-Eric
