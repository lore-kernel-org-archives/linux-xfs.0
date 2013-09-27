Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ECE607F52
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 15:04:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C8A7C304053
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 13:04:35 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id A2EYaJwmPrvOGlZl for <xfs@oss.sgi.com>;
	Fri, 27 Sep 2013 13:04:34 -0700 (PDT)
Message-ID: <5245E4D0.6090108@sandeen.net>
Date: Fri, 27 Sep 2013 15:04:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: Mark Tinguely <tinguely@sgi.com>, xfs@oss.sgi.com

On 9/27/13 2:36 PM, Roger Willcocks wrote:
> 
> On Fri, 2013-09-27 at 08:01 -0500, Mark Tinguely wrote:
>> plain text document attachment
>> (xfs-fix-leak-in-xfs_dir2_node_removename.patch)
>> Free the memory pointed to by state before returning on error from 
>> xfs_dir2_node_removename.c
>>
>> Signed-off-by: Mark Tinguely <tinguely@sgi.com>
>> ---
>> Found by Coverity (134681) in userspace, same patch applies there
>> also.
>>
> 
> Is the first hunk right ?
> 
> xfs_da_node_lookup_int called as
> 
>         error = xfs_da_node_lookup_int(state, &rval);
> 
> and returns with
> 
>         *result = retval;
>         return(0);
> 
> so, on return, error == 0 and rval == an error code. The next lines:
> 
>         if (error)
>                 rval = error;
> 
> won't change that. But previously if rval != EEXIST you returned rval.
> With the change below, you return error, which is zero.

Oh geez.  o_O . . . Thanks Roger.

3rd review's the charm? ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
