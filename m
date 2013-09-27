Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BA0F77F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 14:52:58 -0500 (CDT)
Message-ID: <5245E216.8000609@sgi.com>
Date: Fri, 27 Sep 2013 14:52:54 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: fix memory leak in xfs_dir2_node_removename
References: <20130927130140.640252809@sgi.com>
	<1380310573.22649.1082.camel@montana.filmlight.ltd.uk>
In-Reply-To: <1380310573.22649.1082.camel@montana.filmlight.ltd.uk>
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs@oss.sgi.com

On 09/27/13 14:36, Roger Willcocks wrote:
>
> On Fri, 2013-09-27 at 08:01 -0500, Mark Tinguely wrote:
>> plain text document attachment
>> (xfs-fix-leak-in-xfs_dir2_node_removename.patch)
>> Free the memory pointed to by state before returning on error from
>> xfs_dir2_node_removename.c
>>
>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>> ---
>> Found by Coverity (134681) in userspace, same patch applies there
>> also.
>>
>
> Is the first hunk right ?
>
> xfs_da_node_lookup_int called as
>
>          error = xfs_da_node_lookup_int(state,&rval);
>
> and returns with
>
>          *result = retval;
>          return(0);
>
> so, on return, error == 0 and rval == an error code. The next lines:
>
>          if (error)
>                  rval = error;
>
> won't change that. But previously if rval != EEXIST you returned rval.
> With the change below, you return error, which is zero.
>
> --
> Roger


Thanks, guilty as charged. need to add the error = EEXIST.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
