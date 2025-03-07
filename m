Received: from mail-out01.uio.no (mail-out01.uio.no [129.240.10.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4A912F5A5
	for <linux-xfs@vger.kernel.org>; Fri,  7 Mar 2025 07:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.240.10.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741333696; cv=none; b=pr/ud8DZs0TocWAw6XPD7lAH8ckTTBLXbnoZPIM5YbdGXBOuM6wOYjJ2tKs5GRriuJxhKnaWs2hYfK4NuSi3wBjBrgw0NANDkwCQGk1p76E7t5T7o9op9Em8AUIg/YwST4q1P/ynNigKdP7afRx2CwF/FcfEomPw9+Oimesvv+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741333696; c=relaxed/simple;
	bh=9BN8yN+OEHO6oFrW26wq1aFCcRaHB3RrDse43fciFp4=;
	h=Message-ID:Subject:From:To:Cc:In-Reply-To:References:Content-Type:
	 Date:MIME-Version; b=c7vN/Ag2MS72D78O4PHaBOKKNmNvmdN7oLOftS1gEmm05/QCAch5AFNv14ktkmQTlquBYdMe3mrygLenewFcxPmJWkLtp9a7C2cVPihY9TQwSNL7j4UhU6vR7ZkDTQ/CyBtM0QKk+v/cihjJWhnEFyYWpSPZqOk6n4y4TE/F6vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ifi.uio.no; spf=pass smtp.mailfrom=ifi.uio.no; dkim=pass (2048-bit key) header.d=ifi.uio.no header.i=@ifi.uio.no header.b=IqCilCrL; arc=none smtp.client-ip=129.240.10.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ifi.uio.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ifi.uio.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ifi.uio.no header.i=@ifi.uio.no header.b="IqCilCrL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=ifi.uio.no;
	s=key2309; h=MIME-Version:Date:Content-Transfer-Encoding:Content-Type:
	References:In-Reply-To:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fqsFuSRp6MgwIkrvs1OUv6KAcs+grxdc8862AuBWCmA=; b=IqCilCrLLWesffHl1NE/sulBPQ
	oAPNrFjWeexFU7bT/hbWTIHADUw5KpWcS/tPouQs1U7cQ+h0sUvcpm2eZ0ZJ4pgc+Sl47052s7yVe
	IHpbmumMoHd33PKUoCdGwslTUdAameWFFN5GQd6JsuT+tHuNpmGuNrescr2ej8s7sRoaq4ale1uUo
	u9Kz1NkBGjKGdEv4l7CnL9kjSIopsNwlljopZV1KkDYKbXwv3ynIFnd0vKXEOZH0c8nQ+k19zD1+x
	2n9NdbIC9oU6KPFsTEyeBUiEsqkSBcXpAmK+wNoM+z+M3CkiL1aT5TOSVxdLihDADradnK66M0K03
	8OVUUZmg==;
Received: from mail-mx10.uio.no ([129.240.10.27])
	by mail-out01.uio.no with esmtps  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98)
	(envelope-from <kjetilho@ifi.uio.no>)
	id 1tqSRG-0000000A1A4-0WWM;
	Fri, 07 Mar 2025 08:48:10 +0100
Received: from vpn.i.bitbit.net ([87.238.42.13] helo=scribus.ms.redpill-linpro.com)
	by mail-mx10.uio.no with esmtpsa (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
	user kjetilho (Exim 4.98)
	(envelope-from <kjetilho@ifi.uio.no>)
	id 1tqSRF-000000006U3-1bQx;
	Fri, 07 Mar 2025 08:48:10 +0100
Message-ID: <359a0fe9a2aaa308016ca236b145feb038f07687.camel@ifi.uio.no>
Subject: Re: nouuid hint in kernel message?
From: Kjetil Torgrim Homme <kjetilho@ifi.uio.no>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20250306183948.GQ2803749@frogsfrogsfrogs>
References: 
	<Nro5gceoG1ar5vFFGSWGNwo-KlGPVYooeufy2thIqL3A5VKjZKQ0yp0kKyAxSVRiAvTm1CkpW4ITHawDjpez0A==@protonmail.internalid>
	 <cbf4f4c23efba09467ca7c08e516fe8561a1f130.camel@ifi.uio.no>
	 <pgirewjvggop2v2s6qrovyqr72kxfajuk2sbqlqll3facikiuu@sriorffcy3x4>
	 <521200e9de4a3b789af1e2890f8a50f9612ed9c9.camel@ifi.uio.no>
	 <20250306183948.GQ2803749@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Fri, 07 Mar 2025 08:47:08 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
X-UiO-SPF-Received: Received-SPF: neutral (mail-mx10.uio.no: 87.238.42.13 is neither permitted nor denied by domain of ifi.uio.no) client-ip=87.238.42.13; envelope-from=kjetilho@ifi.uio.no; helo=scribus.ms.redpill-linpro.com;
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5)
X-UiO-Scanned: D72EB859647CA09123A12983B3ADB5FD895D1640

to. den 06. 03. 2025 klokka 10.39 (-0800) skreiv Darrick J. Wong:
> On Thu, Mar 06, 2025 at 12:36:34PM +0100, Kjetil Torgrim Homme wrote:
> > to. den 06. 03. 2025 klokka 11.00 (+0100) skreiv Carlos Maiolino:
> >=20
> > > On a mid term here, I think we could improve xfs(5) to include a bit =
more
> > > information about duplicated uuids.
> > >=20
> >=20
> > current text:
> >=20
> >    Each XFS filesystem is labeled with a Universal Unique Identifier
> >    (UUID).  The UUID is stored in every allocation group header and is =
used
> >    to help distinguish one XFS filesystem from another, therefore you
> >    should avoid using dd(1) or other block-by-block copying programs to
> >    copy  XFS  filesystems.   If two XFS filesystems on the same machine
> >    have the same UUID, xfsdump(8) may become confused when doing
> >    incremental and resumed dumps.  xfsdump(8) and xfsrestore(8) are
> >    recommended for making copies of XFS filesystems.
> >=20
> > perhaps add a sentence at the end of that, "To mount a snapshot of an
> > already mounted filesystem, use mount option \fBnouuid\fR."
> >=20
> > possibly also something about this in xfs_admin(8)?
> >=20
> > current text:
> >=20
> >        -U uuid
> >               Set  the  UUID  of the filesystem to uuid.  A sample UUID
> >               looks like this: "c1b9d5a2-f162-11cf-9ece-0020afc76f16".
> >               The uuid may also be nil, which will set the filesystem
> >               UUID to the null UUID.  The uuid may also be generate,
> >               which will generate a new UUID for the filesystem.  Note
> >               that on CRC-enabled  filesystems,  this will set an
> >               incompatible flag such that older kernels will not be
> >               able=C2=A0to mount the filesystem.  To remove this
> >               incompatible flag,  use restore, which will restore the
> >               original UUID and remove the incompatible feature flag
> >               as needed.
> >=20
> > suggested addition: "A transient snapshot which conflicts with a mounte=
d
> > filesystem can alternatively be mounted with the option \bBnouuid\fR."
> >=20
> > what do you think?
>=20
> I think we ought to fix the informational messages in xfs_db:
>=20
> "ERROR: The filesystem has valuable metadata changes in a log which
> needs to be replayed.  Mount the filesystem to replay the log, and
> unmount it before re-running xfs_admin.  If the filesystem is a snapshot
> of a mounted filesystem, you may need to give mount the nouuid option.
> If you are unable to mount the filesystem, then use the xfs_repair -L
> option to destroy the log and attempt a repair.  Note that destroying
> the log may cause corruption -- please attempt a mount of the filesystem
> before doing this.
>=20
> and xfs_repair:
>=20
> "ERROR: The filesystem has valuable metadata changes in a log which
> needs to be replayed.  Mount the filesystem to replay the log, and
> unmount it before re-running xfs_repair.  If the filesystem is a
> snapshot of a mounted filesystem, you may need to give mount the nouuid
> option.  If you are unable to mount the filesystem, then use the -L
> option to destroy the log and attempt a repair.  Note that destroying
> the log may cause corruption -- please attempt a mount of the filesystem
> before doing this."

I like these texts, simple and plain spoken.  I think my extra text for
xfs(5) is appropriate in addition to your change, the xfs_admin(8)
addition is less obvious.

--=20
venleg helsing,
Kjetil T.
