Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q626fVwZ175597 for <xfs@oss.sgi.com>; Mon, 2 Jul 2012 01:41:31 -0500
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 0RMdEZBWd5QBbHGG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 01 Jul 2012 23:41:30 -0700 (PDT)
Date: Mon, 2 Jul 2012 16:41:13 +1000
From: NeilBrown <neilb@suse.de>
Subject: Re: mkfs.xfs states log stripe unit is too large
Message-ID: <20120702164113.109162be@notabene.brown>
In-Reply-To: <20120702061827.GB16671@infradead.org>
References: <D3F781FA-CEB0-4896-9441-772A9E533354@2012.bluespice.org>
	<20120623234445.GZ19223@dastard> <4FE67970.2030008@sandeen.net>
	<4FE710B7.5010704@hardwarefreak.com>
	<d71834a062ffd666ab53a4695eb643e9@muaddib.hro.localnet>
	<20120626023059.GC19223@dastard>
	<20120626080217.GA30767@infradead.org>
	<20120702061827.GB16671@infradead.org>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6493198522060784266=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid@vger.kernel.org, Ingo J?rgensmann <ij@2012.bluespice.org>, xfs@oss.sgi.com

--===============6493198522060784266==
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1.FH_uAeKVUqRVkMkg080sS"; protocol="application/pgp-signature"

--Sig_/1.FH_uAeKVUqRVkMkg080sS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Jul 2012 02:18:27 -0400 Christoph Hellwig <hch@infradead.org> wro=
te:

> Ping to Neil / the raid list.

Thanks for the reminder.

>=20
> On Tue, Jun 26, 2012 at 04:02:17AM -0400, Christoph Hellwig wrote:
> > On Tue, Jun 26, 2012 at 12:30:59PM +1000, Dave Chinner wrote:
> > > You can't, simple as that. The maximum supported is 256k. As it is,
> > > a default chunk size of 512k is probably harmful to most workloads -
> > > large chunk sizes mean that just about every write will trigger a
> > > RMW cycle in the RAID because it is pretty much impossible to issue
> > > full stripe writes. Writeback doesn't do any alignment of IO (the
> > > generic page cache writeback path is the problem here), so we will
> > > lamost always be doing unaligned IO to the RAID, and there will be
> > > little opportunity for sequential IOs to merge and form full stripe
> > > writes (24 disks @ 512k each on RAID6 is a 11MB full stripe write).
> > >=20
> > > IOWs, every time you do a small isolated write, the MD RAID volume
> > > will do a RMW cycle, reading 11MB and writing 12MB of data to disk.
> > > Given that most workloads are not doing lots and lots of large
> > > sequential writes this is, IMO, a pretty bad default given typical
> > > RAID5/6 volume configurations we see....
> >=20
> > Not too long ago I benchmarked out mdraid stripe sizes, and at least
> > for XFS 32kb was a clear winner, anything larger decreased performance.
> >=20
> > ext4 didn't get hit that badly with larger stripe sizes, probably
> > because they still internally bump the writeback size like crazy, but
> > they did not actually get faster with larger stripes either.
> >=20
> > This was streaming data heavy workloads, anything more metadata heavy
> > probably will suffer from larger stripes even more.
> >=20
> > Ccing the linux-raid list if there actually is any reason for these
> > defaults, something I wanted to ask for a long time but never really got
> > back to.
> >=20
> > Also I'm pretty sure back then the md default was 256kb writes, not 512
> > so it seems the defaults further increased.

"originally" the default chunksize was 64K.
It was changed in late 2009 to 512K - this first appeared in mdadm 3.1.1

I don't recall the details of why it was changed but I'm fairly sure that
it was based on measurements that I had made and measurements that others h=
ad
made.  I suspect the tests were largely run on ext3.

I don't think there is anything close to a truly optimal chunk size.  What
works best really depends on your hardware, your filesystem, and your work
load.=20

If 512K is always suboptimal for XFS then that is unfortunate but I don't
think it is really possible to choose a default that everyone will be happy
with.  Maybe we just need more documentation and warning emitted by various
tools.  Maybe mkfs.xfs could augment the "stripe unit too large" message wi=
th
some text about choosing a smaller chunk size?

NeilBrown



> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> ---end quoted text---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/1.FH_uAeKVUqRVkMkg080sS
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/FCiTnsnt1WYoG5AQI5CBAAqXcfHN5XP+qDTD87cqLwNOtJiH9ABmQM
7qurfkRmWhNeVSK23sERBOOOAtIFF98QMwXS5AkCDeLBYnzHRO5bCcRYBr8x1Hi6
2XHHJeAtBPvxhyy6ALtvx1mdFg6MxuOoisd6cerxLvJz5kA1DO8XfXmcXXcCAtxX
DTeCLAXy+qwzisEFwSotYcY+qtRVqQDQF4mHEkVx2TS89+p93LTXRWBFFXSHe/jc
QUiXt4suGADktABJ4Xz6TnYP0F9ljcHjOyXuhV3qAX4ytlkFXbwMdTB1vUagQYM0
qAM2StLmXRdwb4+0mlC5iqulJE0qyUO7Q7Ua7+LngU8He/5skeVsAJhM32RfVUiM
306af3ScMFJmHXPDcLyu1t8LuBRO56brkLjUAMPKwckBZ2aehjwI9cq4WhV1S2s5
GHLOA7cpdls+Vlv4MB0IZBEz0CR0zVbY8G4LkR0Uqz8kBpm9e2gV2s01iAdogNEL
8BneIu0SHzTBP2CG/yG/WkDY/NIo5Jdu9zkljTyrcJiHcW6lYB4/eVVlAildmCDR
f0u1DtR28vGvuQxJxxOGU+Q+U601VGOOO/cty8AL7b1CeWzESdoponJVE9RXC/An
7gI4HUKXJaS9gPdzFOrVBUfQfD3Sb2Y++nu/V1dYzMLR4F/x5jdkZQsW2mu47nDT
oDnRk9ivoFI=
=3UvL
-----END PGP SIGNATURE-----

--Sig_/1.FH_uAeKVUqRVkMkg080sS--


--===============6493198522060784266==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6493198522060784266==--
