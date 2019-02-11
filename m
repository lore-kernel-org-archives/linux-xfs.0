Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:58566 "EHLO
        email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387599AbfBKPla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 10:41:30 -0500
From: Wolfgang Walter <linux@stwm.de>
Subject: Re: [PATCH 1/2] Revert "mm: don't reclaim inodes with many attached pages"
Date: Mon, 11 Feb 2019 16:34:34 +0100
Message-ID: <2582452.8YSf1DXvRS@stwm.de>
In-Reply-To: <20190207102750.GA4570@quack2.suse.cz>
References: <20190130041707.27750-1-david@fromorbit.com> <20190131221904.GL4205@dastard> <20190207102750.GA4570@quack2.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Chris Mason <clm@fb.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, akpm@linux-foundation.org, vdavydov.dev@gmail.com

Am Donnerstag, 7. Februar 2019, 11:27:50 schrieb Jan Kara:
> On Fri 01-02-19 09:19:04, Dave Chinner wrote:
> > Maybe for memcgs, but that's exactly the oppose of what we want to
> > do for global caches (e.g. filesystem metadata caches). We need to
> > make sure that a single, heavily pressured cache doesn't evict smal=
l
> > caches that lower pressure but are equally important for
> > performance.
> >=20
> > e.g. I've noticed recently a significant increase in RMW cycles in
> > XFS inode cache writeback during various benchmarks. It hasn't
> > affected performance because the machine has IO and CPU to burn, bu=
t
> > on slower machines and storage, it will have a major impact.
>=20
> Just as a data point, our performance testing infrastructure has bise=
cted
> down to the commits discussed in this thread as the cause of about 40=
%
> regression in XFS file delete performance in bonnie++ benchmark.

We also bisected our big IO-performance problem of an imap-server (star=
ting=20
with 4.19.3) down to

=09mm: don't reclaim inodes with many attached pages
=09commit a76cf1a474d7dbcd9336b5f5afb0162baa142cf0 upstream.

On other servers the filesystems sometimes seems to hang for 10 seconds=
 and=20
more.

We also see a performance regression compared to 4.14 even with this pa=
tch=20
reverted, but much less dramatic.

Now I saw this thread and I'll try to revert

172b06c32b949759fe6313abec514bc4f15014f4

and see if this helps.

Regards,
--=20
Wolfgang Walter
Studentenwerk M=FCnchen
Anstalt des =F6ffentlichen Rechts
