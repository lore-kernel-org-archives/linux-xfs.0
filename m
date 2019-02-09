Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37608 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726522AbfBIDmp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 22:42:45 -0500
From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 1/2] Revert "mm: don't reclaim inodes with many attached
 pages"
Date: Sat, 9 Feb 2019 03:42:30 +0000
Message-ID: <20190209034223.GA2591@castle.DHCP.thefacebook.com>
References: <25EAF93D-BC63-4409-AF21-F45B2DDF5D66@fb.com>
 <20190131013403.GI4205@dastard> <20190131091011.GP18811@dhcp22.suse.cz>
 <20190131185704.GA8755@castle.DHCP.thefacebook.com>
 <20190131221904.GL4205@dastard> <20190207102750.GA4570@quack2.suse.cz>
 <20190207213727.a791db810341cec2c013ba93@linux-foundation.org>
 <20190208095507.GB6353@quack2.suse.cz>
 <20190208125049.GA11587@quack2.suse.cz>
 <20190208144944.082a771e84f02a77bad3e292@linux-foundation.org>
In-Reply-To: <20190208144944.082a771e84f02a77bad3e292@linux-foundation.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <732A74A8901BE749BECB4649E223D905@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Michal Hocko <mhocko@kernel.org>, Chris Mason <clm@fb.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>

On Fri, Feb 08, 2019 at 02:49:44PM -0800, Andrew Morton wrote:
> On Fri, 8 Feb 2019 13:50:49 +0100 Jan Kara <jack@suse.cz> wrote:
>=20
> > > > Has anyone done significant testing with Rik's maybe-fix?
> > >=20
> > > I will give it a spin with bonnie++ today. We'll see what comes out.
> >=20
> > OK, I did a bonnie++ run with Rik's patch (on top of 4.20 to rule out o=
ther
> > differences). This machine does not show so big differences in bonnie++
> > numbers but the difference is still clearly visible. The results are
> > (averages of 5 runs):
> >=20
> > 		 Revert			Base			Rik
> > SeqCreate del    78.04 (   0.00%)	98.18 ( -25.81%)	90.90 ( -16.48%)
> > RandCreate del   87.68 (   0.00%)	95.01 (  -8.36%)	87.66 (   0.03%)
> >=20
> > 'Revert' is 4.20 with "mm: don't reclaim inodes with many attached page=
s"
> > and "mm: slowly shrink slabs with a relatively small number of objects"
> > reverted. 'Base' is the kernel without any reverts. 'Rik' is a 4.20 wit=
h
> > Rik's patch applied.
> >=20
> > The numbers are time to do a batch of deletes so lower is better. You c=
an see
> > that the patch did help somewhat but it was not enough to close the gap
> > when files are deleted in 'readdir' order.
>=20
> OK, thanks.
>=20
> I guess we need a rethink on Roman's fixes.   I'll queued the reverts.

Agree.

I still believe that we should cause the machine-wide memory pressure
to clean up any remains of dead cgroups, and Rik's patch is a step into
the right direction. But we need to make some experiments and probably
some code changes here to guarantee that we don't regress on performance.

>=20
>=20
> BTW, one thing I don't think has been discussed (or noticed) is the
> effect of "mm: don't reclaim inodes with many attached pages" on 32-bit
> highmem machines.  Look why someone added that code in the first place:
>=20
> : commit f9a316fa9099053a299851762aedbf12881cff42
> : Author: Andrew Morton <akpm@digeo.com>
> : Date:   Thu Oct 31 04:09:37 2002 -0800
> :=20
> :     [PATCH] strip pagecache from to-be-reaped inodes
> :    =20
> :     With large highmem machines and many small cached files it is possi=
ble
> :     to encounter ZONE_NORMAL allocation failures.  This can be demonstr=
ated
> :     with a large number of one-byte files on a 7G machine.
> :    =20
> :     All lowmem is filled with icache and all those inodes have a small
> :     amount of highmem pagecache which makes them unfreeable.
> :    =20
> :     The patch strips the pagecache from inodes as they come off the tai=
l of
> :     the inode_unused list.
> :    =20
> :     I play tricks in there peeking at the head of the inode_unused list=
 to
> :     pick up the inode again after running iput().  The alternatives see=
med
> :     to involve more widespread changes.
> :    =20
> :     Or running invalidate_inode_pages() under inode_lock which would be=
 a
> :     bad thing from a scheduling latency and lock contention point of vi=
ew.
>=20
> I guess I shold have added a comment.  Doh.
>=20

It's a very useful link.

Thanks!
