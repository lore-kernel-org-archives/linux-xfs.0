Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56996 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752213AbeFFRpf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Jun 2018 13:45:35 -0400
Subject: Re: [PATCH V2] xfs: fix string handling in get/set functions
References: <20180525151421.2317292-1-arnd@arndb.de>
 <7aad9fc3-ed65-a016-d477-5d830e31cb43@sandeen.net>
 <20180606105817.GA6575@infradead.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <75d75204-60e7-e5fd-febb-b82c70e26378@sandeen.net>
Date: Wed, 6 Jun 2018 12:45:33 -0500
MIME-Version: 1.0
In-Reply-To: <20180606105817.GA6575@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, Martin Sebor <msebor@gmail.com>, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org



On 6/6/18 5:58 AM, Christoph Hellwig wrote:
>> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
>> index 82f7c83c1dad..596e176c19a6 100644
>> --- a/fs/xfs/xfs_ioctl.c
>> +++ b/fs/xfs/xfs_ioctl.c
>> @@ -1828,13 +1828,13 @@ xfs_ioc_getlabel(
>>  	/* Paranoia */
>>  	BUILD_BUG_ON(sizeof(sbp->sb_fname) > FSLABEL_MAX);
>>  
>> +	/* 1 larger than sb_fname, so this ensures a trailing NUL char */
>> +	memset(label, 0, sizeof(label));
> 
> I don't get the comment.  In fact I don't even get why we need any
> comment here.  This is a structure that gets copied to userspace,
> and we zero the whole structure, as we should do by default for
> anything that goes to userspace.

Sure, I guess we didn't really need the comment, my main point was that
we were guaranteed to have a \0 remaining at the end because we'd never copy
over it due to sb_fname's smaller size.

> Otherwise this looks fine to me.

Thanks.  In retrospect we could have gone back to Arnd's original patch
but I guess the explicit memset is ... well, nice and explicit.

-Eric
