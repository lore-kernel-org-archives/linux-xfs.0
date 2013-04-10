Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BB77D7FD6
	for <xfs@oss.sgi.com>; Wed, 10 Apr 2013 15:31:57 -0500 (CDT)
Message-ID: <5165CC39.2090108@sgi.com>
Date: Wed, 10 Apr 2013 15:31:53 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: reserve fields in inode for parent ptr and alloc
	policy
References: <20130410182438.268267840@sgi.com> <5165B5CB.2070203@sandeen.net>
	<5165BFF4.8020601@sgi.com>
In-Reply-To: <5165BFF4.8020601@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rich Johnston <rjohnston@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 04/10/13 14:39, Rich Johnston wrote:
> On 04/10/2013 01:56 PM, Eric Sandeen wrote:
>> On 4/10/13 1:24 PM, Mark Tinguely wrote:
>>> Reserve fields in new inode layout for parent pointer and
>>> allocation policy.
>>> ----
>>> The inode will hold the parent information for the first
>>> link to a file. Information for the other links will be
>>> held in extended attribute entries.
>>>
>>> The "di_parino" is the inode of the parent directory. The
>>> directory information for this entry is located the parent
>>> directory with "di_paroff" offset.
>>>
>>> The di_parino/di_paroff concept code is running.
>>> ----
>>> The "di_allocpolicy" will be used to remember the allocation
>>> policy associated with this inode.
>>
>> can you say more about this allocation policy?
>>
>> -Eric
>
> No its super secret information. ;)
>
> Its on my plate Eric, because Mark was making a change for parent ptrs,
> I asked him to request space for allocation policies also.
>
> I don't have all the details yet but here is a very high level concept.
>
> Identify allocation groups by names (or numbers -- preferably using names
> in user-visible areas), allowing many different areas. Placing the
> allocation
> policy outside of user programs is necessary for this to be successful.
>
> Current thoughts on proposed a layered allocation policies:
>
> Policy for the entire filesystem
> Policy attached to a directory (whose policy would be inherited by
> subdirectories when subdirectories are created)
> Policy for a single file
>
> The policy would define:
>
> where to place file data
> where to place metadata for the files.
> a prefered allocation group for placing file data (for directories).
>
> --Rich
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

The allocation policies is based on work by Dave:

	http://oss.sgi.com/archives/xfs/2009-02/msg00250.html

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
