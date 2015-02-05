Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF6767F7E
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 16:15:36 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E1F8304032
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 14:15:33 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	sguGKaG57bKXA78f for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 14:15:30 -0800 (PST)
Date: Fri, 6 Feb 2015 09:15:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS crashing system with general protection fault
Message-ID: <20150205221516.GT4251@dastard>
References: <20141224111403.54d7226b@neptune.home>
	<20141228115127.GN24183@dastard>
	<20141229084452.615e1900@pluto.restena.lu>
	<20150113081742.6c3a5823@pluto.restena.lu>
	<20150205151007.7c954c01@pluto.restena.lu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150205151007.7c954c01@pluto.restena.lu>
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
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: xfs@oss.sgi.com

On Thu, Feb 05, 2015 at 03:10:07PM +0100, Bruno Pr=E9mont wrote:
> Hi Dave,
> =

> New crash, new trace, this time on 3.18.2.
> It looks like this time a NULL dereference happened prior to touched memo=
ry poison being detected.
> =

> Once again it's during normal system operation (no mount/umount activity)

Can you rebuild the kernel with CONFIG_XFS_WARN=3Dy and see if that
throws any interesting messages into logs?

However:

> [1900390.261491] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [1900390.272989] BUG task_struct (Tainted: G      D W     ): Poison overw=
ritten
> [1900390.283021] --------------------------------------------------------=
---------------------
> [1900390.283021] =

> [1900390.297056] INFO: 0xffff880213d651b3-0xffff880213d651b3. First byte =
0x6d instead of 0x6b
> [1900390.309044] INFO: Slab 0xffffea00084f5800 objects=3D16 used=3D16 fp=
=3D0x          (null) flags=3D0x8000000000004080
> [1900390.323087] INFO: Object 0xffff880213d64ba0 @offset=3D19360 fp=3D0xf=
fff880213d61e40
> [1900390.323087] =

> [1900390.336988] Bytes b4 ffff880213d64b90: 60 2d d6 13 02 88 ff ff 5a 5a=
 5a 5a 5a 5a 5a 5a  `-......ZZZZZZZZ
> [1900390.350988] Object ffff880213d64ba0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [1900390.364943] Object ffff880213d64bb0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
....
> [1900391.674636] Object ffff880213d651b0: 6b 6b 6b 6d 6b 6b 6b 6b 6b 6b 6=
b 6b 6b 6b 6b 6b  kkkmkkkkkkkkkkkk
                                                     ^^

There's a single bit that has been flipped in the task_struct slab.
So more than just XFS is seeing memory corruption - this is in core
kernel structure slab caches. I'm not sure, either, how XFS could
cause corruption in this slab.

So, I'd be checking all the previous memory corruptions to see if
they are single bit errors, and if there is any pattern to the
addresses at which they occur. The above bit flip makes me think
"hardware issue" and everything else stems from that...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
