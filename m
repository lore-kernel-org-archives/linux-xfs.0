Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 00:38:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4L7cFep027032
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 00:38:18 -0700
Subject: Re: TAKE 981521 - Return actual name for CI match for dentry cache
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080521034449.67F4758C4C29@chook.melbourne.sgi.com> <20080521073625.GA26580@infradead.org>
Content-Transfer-Encoding: 7bit
Date: Wed, 21 May 2008 17:40:56 +1000
Message-ID: <op.ubhuaik63jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080521073625.GA26580@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Wed, 21 May 2008 17:36:25 +1000, Christoph Hellwig <hch@infradead.org>  
wrote:

> On Wed, May 21, 2008 at 01:44:49PM +1000, Barry Naujok wrote:
>> Return case-insensitive match for dentry cache
>>
>> This implements the code to store the actual filename found
>> during a lookup in the dentry cache and to avoid multiple entries
>> in the dcache pointing to the same inode.
>>
>> To avoid polluting the dcache, we implement a new directory inode
>> operations for lookup. xfs_vn_ci_lookup() stores the correct case
>> name in the dcache.
>>
>> The "actual name" is only allocated and returned for a case-
>> insensitive match and not an actual match.
>>
>> Another unusual interaction with the dcache is not storing
>> negative dentries like other filesystems doing a d_add(dentry, NULL)
>> when an ENOENT is returned. During the VFS lookup, if a dentry
>> returned has no inode, dput is called and ENOENT is returned.
>> By not doing a d_add, this actually removes it completely from
>> the dcache to be reused. create/rename have to be modified to
>> support unhashed dentries being passed in.
>
> This requires the d_add_ci helper which doesn't exist in the CVS on oss.

I have pushed all patches to oss master git tree now.

I'm not sure how CVS can get updated.

Barry.
