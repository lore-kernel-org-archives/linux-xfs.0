Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 20:58:01 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9N3vr1t030746
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 20:57:53 -0700
Message-ID: <4900048B.3080706@sgi.com>
Date: Thu, 23 Oct 2008 14:58:51 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] free partially initialized inodes using	destroy_inode
References: <20081022163129.GC25556@infradead.org> <20081022213049.GS18495@disturbed>
In-Reply-To: <20081022213049.GS18495@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Dave Chinner wrote:
> On Wed, Oct 22, 2008 at 12:31:29PM -0400, Christoph Hellwig wrote:
>> To make sure we free the security data inodes need to be freed using
>> the proper VFS helper (which we also need to export for this). We mark
>> these inodes bad so we can skip the flush path for them.
> 
> Looks good, except for one minor mistake in a comment:
> 
>> Index: xfs-2.6/fs/xfs/xfs_inode.h
>> ===================================================================
>> --- xfs-2.6.orig/fs/xfs/xfs_inode.h	2008-10-22 17:57:30.000000000 +0200
>> +++ xfs-2.6/fs/xfs/xfs_inode.h	2008-10-22 18:00:15.000000000 +0200
>> @@ -310,6 +310,23 @@ static inline struct inode *VFS_I(struct
>>  }
>>  
>>  /*
>> + * Get rid of a partially initialized inode.
>> + *
>> + * We have to go through destroy_inode to make sure allocations
>> + * from init_inode_always like the security data are undone.
>> + *
>> + * We mark the inode dirty so that it takes the short cut in
>                         ^^^^^
> 			"bad"
> 
>> + * the reclaim path instead of going through the flush path
>> + * which doesn't make sense for an inode that has never seen the
>> + * light of day.
>> + */
>> +static inline void xfs_destroy_inode(struct xfs_inode *ip)
>> +{
>> +	make_bad_inode(VFS_I(ip));
>> +	return destroy_inode(VFS_I(ip));
>> +}
>> +
>> +/*
>>   * i_flags helper functions
>>   */
>>  static inline void
> 
> I don't think this needs another round of review just to fix the
> comment, so it can probably go straight in if the committer can
> touch up that comment.

Will do.  Thanks guys.
