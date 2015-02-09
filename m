Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 01BB27FB4
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 15:24:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E4A578F80C5
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 13:24:24 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	iHQQVGTylk9SdN7Y for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 13:24:22 -0800 (PST)
Date: Tue, 10 Feb 2015 08:24:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS crashing system with general protection fault
Message-ID: <20150209212420.GU12722@dastard>
References: <20141224111403.54d7226b@neptune.home>
	<20141228115127.GN24183@dastard>
	<20141229084452.615e1900@pluto.restena.lu>
	<20150113081742.6c3a5823@pluto.restena.lu>
	<20150205151007.7c954c01@pluto.restena.lu>
	<20150205221516.GT4251@dastard>
	<20150209094701.6b1d480d@pluto.restena.lu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150209094701.6b1d480d@pluto.restena.lu>
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

On Mon, Feb 09, 2015 at 09:47:01AM +0100, Bruno Pr=E9mont wrote:
> Hi Dave,
> =

> On Fri, 6 Feb 2015 09:15:16 +1100 Dave Chinner wrote:
> > On Thu, Feb 05, 2015 at 03:10:07PM +0100, Bruno Pr=E9mont wrote:
> > > Hi Dave,
> > > =

> > > New crash, new trace, this time on 3.18.2.
> > > It looks like this time a NULL dereference happened prior to touched =
memory poison being detected.
> > > =

> > > Once again it's during normal system operation (no mount/umount activ=
ity)
> > =

> > Can you rebuild the kernel with CONFIG_XFS_WARN=3Dy and see if that
> > throws any interesting messages into logs?
> =

> Will try and see
> =

> > However:
> > =

> > > [1900390.261491] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > [1900390.272989] BUG task_struct (Tainted: G      D W     ): Poison o=
verwritten
> > > [1900390.283021] ----------------------------------------------------=
-------------------------
> > > [1900390.283021] =

> > > [1900390.297056] INFO: 0xffff880213d651b3-0xffff880213d651b3. First b=
yte 0x6d instead of 0x6b
> > > [1900390.309044] INFO: Slab 0xffffea00084f5800 objects=3D16 used=3D16=
 fp=3D0x          (null) flags=3D0x8000000000004080
> > > [1900390.323087] INFO: Object 0xffff880213d64ba0 @offset=3D19360 fp=
=3D0xffff880213d61e40
> > > [1900390.323087] =

> > > [1900390.336988] Bytes b4 ffff880213d64b90: 60 2d d6 13 02 88 ff ff 5=
a 5a 5a 5a 5a 5a 5a 5a  `-......ZZZZZZZZ
> > > [1900390.350988] Object ffff880213d64ba0: 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > > [1900390.364943] Object ffff880213d64bb0: 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> > ....
> > > [1900391.674636] Object ffff880213d651b0: 6b 6b 6b 6d 6b 6b 6b 6b 6b =
6b 6b 6b 6b 6b 6b 6b  kkkmkkkkkkkkkkkk
> >                                                      ^^
> > =

> > There's a single bit that has been flipped in the task_struct slab.
> > So more than just XFS is seeing memory corruption - this is in core
> > kernel structure slab caches. I'm not sure, either, how XFS could
> > cause corruption in this slab.
> > =

> > So, I'd be checking all the previous memory corruptions to see if
> > they are single bit errors, and if there is any pattern to the
> > addresses at which they occur. The above bit flip makes me think
> > "hardware issue" and everything else stems from that...
> =

> System has ECC RAM so faulty RAM looks less probable (no complaint seen
> by kernel nor recorded by firmware).

Sure, but that's not the only hardware in the memory path so single
bit errors can occur elsewhere as data moved across the bus of sits
in cpu caches. and if you're not using an IOMMU then it could even
be hardware writing to memory incorrectly...

> All previous crashes for which I have some logs were dereference after
> free but not attempt to allocate memory from a modified poison in free
> slabs.
> =

> Though what does that single bit represent in that area if it was
> used/modified after free?

It means that there's either a use after free, or you have a
hardware problem. being in the task struct slab, if it's a use after
free then it's unlikely to be an XFS problem.

FWIW, can you post the output of "grep PARAVIRT <kernel config
file>"?

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
