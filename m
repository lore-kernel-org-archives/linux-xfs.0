Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 09 Feb 2008 12:45:33 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m19KjNlJ011414
	for <xfs@oss.sgi.com>; Sat, 9 Feb 2008 12:45:26 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0DDD75BBB96
	for <xfs@oss.sgi.com>; Sat,  9 Feb 2008 12:45:47 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id o5yDvqtXkKw0dsVn for <xfs@oss.sgi.com>; Sat, 09 Feb 2008 12:45:47 -0800 (PST)
Message-ID: <47AE10FA.6020708@sandeen.net>
Date: Sat, 09 Feb 2008 14:45:46 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] recover from iclog allocation failures
References: <47AD3E11.7020608@redhat.com> <20080209063329.GA6840@infradead.org> <47AD4BD9.5030605@sandeen.net>
In-Reply-To: <47AD4BD9.5030605@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Eric Sandeen wrote:
> Christoph Hellwig wrote:

>>> Index: linux-2.6.24.noarch/fs/xfs/xfs_mount.c
>>> ===================================================================
>>> --- linux-2.6.24.noarch.orig/fs/xfs/xfs_mount.c
>>> +++ linux-2.6.24.noarch/fs/xfs/xfs_mount.c
>>> @@ -1007,6 +1007,7 @@ xfs_mountfs(
>>>  			error = XFS_ERROR(EINVAL);
>>>  			goto error1;
>>>  		}
>>> +		uuid_mounted = 1;
>> How is this related to the rest of the patch?
> 
> if we errored out, we returned from mount w/o taking the uuid back out
> of the table.

er, I must have messed up the tree, that's already there isn't it...

Let me respin this one... :)

-Eric
