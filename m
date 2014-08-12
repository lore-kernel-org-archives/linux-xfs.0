Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E2D307F3F
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 11:51:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 91AC6304043
	for <xfs@oss.sgi.com>; Tue, 12 Aug 2014 09:51:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0g0aJX7M2Gle8T4D (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 12 Aug 2014 09:51:50 -0700 (PDT)
Date: Tue, 12 Aug 2014 12:51:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: Subject : Happened again, 20140811 -- Got "Internal error
	XFS_WANT_CORRUPTED_GOTO". Filesystem needs reformatting to correct
	issue.
Message-ID: <20140812165143.GB46654@bfoster.bfoster>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>
	<53E8D9F6.7080704@sgi.com>
	<alpine.LSU.2.11.1408111720170.7326@minas-tirith.valinor>
	<53E93530.4070902@sgi.com>
	<alpine.LSU.2.11.1408112347480.17839@minas-tirith.valinor>
	<53E93C29.1020103@sgi.com>
	<alpine.LSU.2.11.1408120013500.17839@minas-tirith.valinor>
	<alpine.LSU.2.11.1408120139060.21410@minas-tirith.valinor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1408120139060.21410@minas-tirith.valinor>
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
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Tue, Aug 12, 2014 at 02:17:00AM +0200, Carlos E. R. wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
> =

> Content-ID: <alpine.LSU.2.11.1408120142170.21410@minas-tirith.valinor>
> =

> =

> El 2014-08-12 a las 00:36 +0200, Carlos E. R. escribi=F3:
> >El 2014-08-11 a las 16:56 -0500, Mark Tinguely escribi=F3:
> =

> >but all of them are about 401M before compression. The upload will take
> >long, my ADSL upload is 0.3M/s at most.
> =

> =

> I have shared (view) on google drive a folder with the three files. Both
> Brian Foster and Mark Tinguely should have got a link on the mail from me.
> If somebody else wants access, just tell me.
> =


I see the same thing from repair that was in your repair output:

block (1,12608397-12608397) multiply claimed by cnt space tree, state - 2

If I take a look at the btrees as is, I see "235:[12608397,10]" included
in the bnobt (fsb 0x200aa55) and "270:[12608397,10]" in the cntbt (fsb
0x2000781). If I skip the mount, zero the log and repair, everything
seems Ok. I can allocate the remainder of available space and rm -rf
everything in the fs without an error.

Once I replay the log, I see "272:[12608397,10] 273:[12608397,10]" in
the cntbt, which is clearly a duplicate entry. This is what repair
detects and cleans up and seems to lead to the shutdown. E.g., if I
mount and use the fs, I can hit an assert or failure just by attempting
to allocate the rest of the space in the fs. If that is the state of the
fs on disk, it's only a matter of time we explode due to allocating and
freeing that range of space or possibly attempting to allocate that
space twice.

Mark mentioned that he didn't see the superblock item in the log with
regard to the freeze. I don't see that either... which perhaps suggests
that this all happens during the wake-from-hibernate sequence..? My
understanding is that we should freeze on hibernate, thus force
everything out to the log, write an unmount record and then dirty the
log with a superblock transaction. Therefore, that should be the only
item in the log post-freeze. Here, we have various items in the log
including several logged buffers that correspond to the cntbt block that
ends up corrupted (daddr 0xf427c08).

Given the failure occurs on freeing an extent via the xfs_eofblocks
scanner, perhaps this extent was initially allocated as speculative
preallocation and the eofblocks scanner is where we happen to first
identify the corrupted cntbt. What is strange is that, as mentioned
previously, the space appears to be free if I zero the log, so that
means it was probably free before the freeze. It seems highly unlikely
for a file to gain preallocation, be written out and then get trimmed by
the scanner all on wake-from-hibernate.

Carlos,

How long after hibernate does the shutdown/crash typically occur? Do you
basically wake-up and within a few seconds the filesystem crashes, or is
it some time (minutes) later?

If the former, I wonder if it's possible that the scanner returns to
life pointing to a stale or freed incore inode and does something bogus
based on that.

Brian

> - -- Cheers
>        Carlos E. R.
> =

>        (from 13.1 x86_64 "Bottle" (Minas Tirith))
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.22 (GNU/Linux)
> =

> iF4EAREIAAYFAlPpXQYACgkQja8UbcUWM1wQ9gEAl1WI24UDArdlWHh3J2ih3AV3
> nMTwDRqTrT0Rk2BJOB8A/1BOzzn3/IX16sPCsYoqGEyXNHcNXWBHENShlyWzJGUr
> =3DW+BG
> -----END PGP SIGNATURE-----

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
