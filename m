Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F03B7F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 21:13:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7106C8F8054
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 19:13:50 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id bf4cwmhB26IsKmmg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 19:13:48 -0700 (PDT)
Message-ID: <535721C4.3040902@oracle.com>
Date: Wed, 23 Apr 2014 10:13:24 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: remote attribute overwrite causes transaction overrun
References: <1398149949-11324-1-git-send-email-david@fromorbit.com>	<535659F7.4060702@oracle.com>
	<20140422234628.GN18672@dastard>
In-Reply-To: <20140422234628.GN18672@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


On 04/23 2014 07:46 AM, Dave Chinner wrote:
> On Tue, Apr 22, 2014 at 08:00:55PM +0800, Jeff Liu wrote:
>>
>> On 04/22 2014 14:59 PM, Dave Chinner wrote:
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> Commit e461fcb ("xfs: remote attribute lookups require the value
>>> length") passes the remote attribute length in the xfs_da_args
>>> structure on lookup so that CRC calculations and validity checking
>>> can be performed correctly by related code. This, unfortunately has
>>> the side effect of changing the args->valuelen parameter in cases
>>> where it shouldn't.
>>>
>>> That is, when we replace a remote attribute, the incoming
>>> replacement stores the value and length in args->value and
>>> args->valuelen, but then the lookup which finds the existing remote
>>> attribute overwrites args->valuelen with the length of the remote
>>> attribute being replaced. Hence when we go to create the new
>>> attribute, we create it of the size of the existing remote
>>> attribute, not the size it is supposed to be. When the new attribute
>>> is much smaller than the old attribute, this results in a
>>> transaction overrun and an ASSERT() failure on a debug kernel:
>>>
>>> XFS: Assertion failed: tp->t_blk_res_used <=3D tp->t_blk_res, file: fs/=
xfs/xfs_trans.c, line: 331
>>>
>>> Fix this by keeping the remote attribute value length separate to
>>> the attribute value length in the xfs_da_args structure. The enables
>>> us to pass the length of the remote attribute to be removed without
>>> overwriting the new attribute's length.
>>>
>>> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ....
>>> @@ -348,6 +348,11 @@ xfs_attr_rmtval_get(
>>>  =

>>>  	ASSERT(!(args->flags & ATTR_KERNOVAL));
>>>  =

>>> +	/* remote value might be different size to the buffer supplied. */
>>> +	if (args->rmtvaluelen =3D args->valuelen)
>> 			     ^^^
>> Here is a typo...
> =

> Oh, well spotted.
> =

> But, hold on a minute, shouldn't gcc be catching those sorts of
> typos?
> =

> /me groans
> =

> $ gcc t.c
> $ gcc -Wall t.c
> t.c: In function =BFmain=BF:
> t.c:10:2: warning: suggest parentheses around assignment used as truth va=
lue [-Wparentheses]
>   if (foo =3D bar)
>   ^
> $
> =

> Only if -Wparentheses is specified.
> =

> Why the hell are we suppressing useful warnings on the kernel build?
> =


Well, maybe it's due to the different gcc release? I can hit this warning v=
ia
gcc-4.8.1 which is the default version on Ubuntu 13.10 as below:

# make SUBDIRS=3Dfs/xfs -j4
...
fs/xfs/xfs_attr_remote.c: In function =91xfs_attr_rmtval_get=92:
fs/xfs/xfs_attr_remote.c:352:2: warning: suggest parentheses around assignm=
ent used as truth value [-Wparentheses]
  if (args->rmtvaluelen =3D args->valuelen)
  ^
  CC [M]  fs/xfs/xfs_bmap_btree.o
  CC [M]  fs/xfs/xfs_btree.o
...


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
