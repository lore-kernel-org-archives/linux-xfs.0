Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6DBB47F3F
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 18:46:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4170F304032
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2014 16:46:34 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	Omu147G3ENjE88p5 for <xfs@oss.sgi.com>;
	Tue, 22 Apr 2014 16:46:32 -0700 (PDT)
Date: Wed, 23 Apr 2014 09:46:28 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remote attribute overwrite causes transaction overrun
Message-ID: <20140422234628.GN18672@dastard>
References: <1398149949-11324-1-git-send-email-david@fromorbit.com>
	<535659F7.4060702@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <535659F7.4060702@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jeff Liu <jeff.liu@oracle.com>
Cc: xfs@oss.sgi.com

On Tue, Apr 22, 2014 at 08:00:55PM +0800, Jeff Liu wrote:
> =

> On 04/22 2014 14:59 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > =

> > Commit e461fcb ("xfs: remote attribute lookups require the value
> > length") passes the remote attribute length in the xfs_da_args
> > structure on lookup so that CRC calculations and validity checking
> > can be performed correctly by related code. This, unfortunately has
> > the side effect of changing the args->valuelen parameter in cases
> > where it shouldn't.
> > =

> > That is, when we replace a remote attribute, the incoming
> > replacement stores the value and length in args->value and
> > args->valuelen, but then the lookup which finds the existing remote
> > attribute overwrites args->valuelen with the length of the remote
> > attribute being replaced. Hence when we go to create the new
> > attribute, we create it of the size of the existing remote
> > attribute, not the size it is supposed to be. When the new attribute
> > is much smaller than the old attribute, this results in a
> > transaction overrun and an ASSERT() failure on a debug kernel:
> > =

> > XFS: Assertion failed: tp->t_blk_res_used <=3D tp->t_blk_res, file: fs/=
xfs/xfs_trans.c, line: 331
> > =

> > Fix this by keeping the remote attribute value length separate to
> > the attribute value length in the xfs_da_args structure. The enables
> > us to pass the length of the remote attribute to be removed without
> > overwriting the new attribute's length.
> > =

> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
....
> > @@ -348,6 +348,11 @@ xfs_attr_rmtval_get(
> >  =

> >  	ASSERT(!(args->flags & ATTR_KERNOVAL));
> >  =

> > +	/* remote value might be different size to the buffer supplied. */
> > +	if (args->rmtvaluelen =3D args->valuelen)
> 			     ^^^
> Here is a typo...

Oh, well spotted.

But, hold on a minute, shouldn't gcc be catching those sorts of
typos?

/me groans

$ gcc t.c
$ gcc -Wall t.c
t.c: In function =BFmain=BF:
t.c:10:2: warning: suggest parentheses around assignment used as truth valu=
e [-Wparentheses]
  if (foo =3D bar)
  ^
$

Only if -Wparentheses is specified.

Why the hell are we suppressing useful warnings on the kernel build?

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
