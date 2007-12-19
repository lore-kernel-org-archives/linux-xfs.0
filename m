Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 18 Dec 2007 17:12:17 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id lBJ1C9nG008938
	for <xfs@oss.sgi.com>; Tue, 18 Dec 2007 17:12:11 -0800
Message-ID: <4768703A.2000603@sgi.com>
Date: Wed, 19 Dec 2007 12:13:30 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: xfs mknod regression
References: <dda83e780712172048n4d40cfcbw4a4d3106fc99f02e@mail.gmail.com> <20071218173642.GA7338@infradead.org> <20071219003745.GR4396912@sgi.com> <20071219010607.GT4396912@sgi.com>
In-Reply-To: <20071219010607.GT4396912@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Bret Towe <magnade@gmail.com>, xfs@oss.sgi.com

David Chinner wrote:
> On Wed, Dec 19, 2007 at 11:37:45AM +1100, David Chinner wrote:
>> On Tue, Dec 18, 2007 at 05:36:42PM +0000, Christoph Hellwig wrote:
>>> This was broken by my '[XFS] simplify xfs_create/mknod/symlink prototype',
>>> which assigned the re-shuffled ondisk dev_t back to the rdev variable in
>>> xfs_vn_mknod.  Because of that i_rdev is set to the ondisk dev_t instead
>>> of the linux dev_t later down the function.
>>>
>>> Fortunately the fix for it is trivial:  we can just remove the
>>> assignment because xfs_revalidate_inode has done the proper job before
>>> unlocking the inode.
>>>
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>
>>> Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
>>> ===================================================================
>>> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-12-18 18:23:32.000000000 +0100
>>> +++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-12-18 18:23:43.000000000 +0100
>>> @@ -345,9 +345,7 @@ xfs_vn_mknod(
>>>  		ASSERT(vp);
>>>  		ip = vn_to_inode(vp);
>>>  
>>> -		if (S_ISCHR(mode) || S_ISBLK(mode))
>>> -			ip->i_rdev = rdev;
>>> -		else if (S_ISDIR(mode))
>>> +		if (S_ISDIR(mode))
>>>  			xfs_validate_fields(ip);
>>>  		d_instantiate(dentry, ip);
>>>  		xfs_validate_fields(dir);
>> Thanks for this, Christoph - I'll run some tests on it and check it in.
> 
> Can I get an eyeball or two on the qa test below so i can check it in at the
> same time?
> 

QA test looks fine Dave.
