Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8F6857F37
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 09:28:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7CE428F8040
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 07:28:46 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Ibjw8aa9EY8LHGLh for <xfs@oss.sgi.com>;
	Fri, 18 Sep 2015 07:28:43 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 903DA6035B3E
	for <xfs@oss.sgi.com>; Fri, 18 Sep 2015 09:28:43 -0500 (CDT)
Subject: Re: [RFC PATCH] xfs_io: Implement inodes64 command
References: <1442499846-10470-1-git-send-email-cmaiolino@redhat.com>
	<55FAF212.2010308@sandeen.net> <20150918142117.GA20717@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55FC1F9A.5020103@sandeen.net>
Date: Fri, 18 Sep 2015 09:28:42 -0500
MIME-Version: 1.0
In-Reply-To: <20150918142117.GA20717@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 9/18/15 9:21 AM, Carlos Maiolino wrote:
> On Thu, Sep 17, 2015 at 12:02:10PM -0500, Eric Sandeen wrote:

...

>>> Also, I was wondering if might be useful to, besides return the existence of
>>> 64bit inodes, also inform if there is any 64bit inodes allocated in the groups
>>> or not. Although, this will need the tool to walk through all the inode groups
>>> checking for allocated inodes or not, instead of just stop at the first 64bit
>>> inode found.
>>
>> I'm not sure what you mean here - list the groups which contain them?
>> Any group above the one where the first 64 bit inode is found will also
>> have 64-bit inodes, (unless they have no inodes at all) - so I don't see
>> the value, but maybe I'm missing something.
>>
> 
> Inodes are allocated in 'clusters', you might have a 64-bit inodes cluster
> allocated, but not in use at all, the  xfs_inogrp_t.xi_allocmask field will show
> which inodes from that cluster is allocated or not, so, I was wondering if the
> information that "64bit inodes were created" is enough, of if would be useful to
> say that '64bits inodes were created and are/aren't in use'.

Hm, unless the ikeep option is specified, aren't 100% unused clusters freed?
 
>>> Also, I'm still not sure if 'inodes64' is a good name for the command, I was
>>> also thinking about something like 'chk64inos' but 'inodes64' was the best and
>>> easy to be remembered I could find.
>>
>> Eh, seems reasonable to me.  Not super, but I can't think of anything much
>> better. 
>>
>>> Comments are appreciated 
>>
>> Below...

...

>>> +	xfs_inogrp_t		igroup[64];
>>
>> why 64?  wouldn't one suffice?
>>
> 
> well, 64 is the default size of the inode chunks (or clusters, whatever we call
> it), so we can get a whole inode cluster at a time.

Ok, but the stated purpose of the command is to tell us whether there are 0,
or more than 0, 64-bit inodes on the filesystem.  Why do you need the whole
cluster for that?

>>> +	xfs_fsop_bulkreq_t	bulkreq;
>>> +
>>> +	/* Setup bulkreq structure */
>>> +	bulkreq.lastip = &last;
>>> +	bulkreq.icount = 64;
>>> +	bulkreq.ubuffer = &igroup;
>>> +	bulkreq.ocount = &count;
>>> +
>>> +	while (xfsctl(file->name, file->fd, XFS_IOC_FSINUMBERS, &bulkreq) == 0) {
>>> +		if (count > 0) {
>>> +			printf("Filesystem does have 64bit inodes\n");
>>> +			return 0;
>>> +		} else {
>>> +			printf("Filesystem does not have 64bit inodes\n");
>>> +			return 0;
>>> +		}
>>> +	}
>>
>> I'm also not sure what the "while" is for, here.
>>
>> If you start at XFS_MAXINUMBER_32, won't a single call either
>> give you count = 1 or count = 0?
>>
> 
> Probably you are right. I used the while() keeping in mind the possibility to
> return the status of all 64bit inodes existing in the filesystem, also, I had
> this question:
> 
> "What if the inode XFS_MAXINUMBER_32 does not exist, but bigger inodes do? Like
> in different, bigger AGs?"

I thought that the interface returns the first inode(s) greater than lastip,
or returns none and ocount == 0 if none are found.

> I was considering that each call using XFS_IOC_FSINUMBERS, will return only the
> inodes in the same allocation group, and another xfsctl call was needed to
> continue in the following ones. But I really don't know from where I took it,
> probably misinterpreting the xfsctl manpage :)
> 
> I should have read the kernel implementation before writing it :)
> 
> So, yes, you're right, just a single xfsctl call here will return the next valid
> inode bigger than 0xffffffff.

ok.

> while{} needed only if we want to keep track of the status of the remaining
> ones, which, IMHO is not the goal of this command.

*nod*

...

>> needs xfs_io manpage updates too, and possibly an xfstest test case?
>>
>> -Eric
> 
> Will do, this was just an RFC to get comments about it. I wasn't willing to
> write a manpage entry without even know if people agreed with the command name,
> or even with the idea :)

I understand, it's just a reminder.  :)

> Thanks for the comments, much appreciated.

no problem!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
