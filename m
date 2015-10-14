Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 35FAB7F37
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 16:35:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1706A8F8064
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 14:35:33 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Bp08B0RB7OtnSKKX for <xfs@oss.sgi.com>;
	Wed, 14 Oct 2015 14:35:31 -0700 (PDT)
Date: Thu, 15 Oct 2015 08:34:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Any way to slow down fragmentation ?
Message-ID: <20151014213453.GP31326@dastard>
References: <561D7D9D.4030409@ixblue.com> <561D800B.90307@sandeen.net>
	<A51D31C2-A5F0-45A9-A258-3F6AB692DBD5@ixblue.com>
	<561EA0C0.8040305@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <561EA0C0.8040305@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: =?iso-8859-1?Q?C=E9dric?= Lemarchand <cedric.lemarchand@ixblue.com>, xfs@oss.sgi.com

On Wed, Oct 14, 2015 at 01:36:48PM -0500, Eric Sandeen wrote:
> =

> =

> On 10/14/15 1:29 PM, C=E9dric Lemarchand wrote:
> > Well .. it seems I missed the most important part of the FAQ, thank
> > for pointing it. As you stated, playing with xfs_bmap shows that the
> > 13TB file is fragmented a lot, xfs_fsr is now working on it.
> =

> how much was "a lot?"
> =

> a 13TB file can have "a lot" of *very* large extents.

With the maximum extent size being 8GB, a file that large going to
see "a lot" of extents even if it isn't fragmented. It will be
spread out over multiple AGs (being 1TB max in size), and that makes
it *appear* worse than it really is. Indeed, the best case is that
the BMBT will have ~1700 extent records in it for a file that
size, so it may appear to be fragmented when it really isn't.

Fragmentation is not measured by "having lots of extents in a file".
The extent layout of a file needs to be measured against the pattern
and size of the IOs the application does to that file - the file is
not fragmented if the size and/or packing of extents is optimal for
the access patterns of the application, regardless of the number of
extents in the file...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
