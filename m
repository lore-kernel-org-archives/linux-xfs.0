Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9EE287F37
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 17:44:47 -0500 (CDT)
Message-ID: <5230F25B.2030806@sgi.com>
Date: Wed, 11 Sep 2013 17:44:43 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs: recovery of swap extents operations for CRC filesystems
References: <20130911211819.GB10527@elgon.mountain>
	<20130911021929.GF2445@devil.localdomain>
In-Reply-To: <20130911021929.GF2445@devil.localdomain>
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
To: Dave Chinner <dchinner@redhat.com>
Cc: tinguely@sgi.com, Dan Carpenter <dan.carpenter@oracle.com>, xfs@oss.sgi.com

On 09/10/13 21:19, Dave Chinner wrote:
> On Thu, Sep 12, 2013 at 12:18:19AM +0300, Dan Carpenter wrote:
>> Hello Dave Chinner,
>>
>> The patch 638f44163d57: "xfs: recovery of swap extents operations for
>> CRC filesystems" from Aug 30, 2013, leads to the following
>> static checker warning: "fs/xfs/xfs_log_recover.c:2999
>> xlog_recover_inode_pass2()
>> 	 info: ignoring unreachable code."
>>
>> fs/xfs/xfs_log_recover.c
>>    2992  out_release:
>>    2993          xfs_buf_relse(bp);
>>    2994  error:
>>    2995          if (need_free)
>>    2996                  kmem_free(in_f);
>>    2997          return XFS_ERROR(error);
>>                  ^^^^^^^^^^^^^^^^^^^^^^^
>>    2998
>>    2999          xfs_buf_relse(bp);
>>    3000          goto error;
>>
>> These two added lines are unreachable.  Sometimes people add dead code
>> for later, so this might be intentional.  It's not clear.
>
> It's dead code. I reworked the error handling of the function and
> didn't clean up all the mess.
>
> Mark, I'm away from my upstream dev environment until next week -
> can you send a followup patch to fix this?
>
> Cheers,
>
> Dave.

sure. I should have caught it in review.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
