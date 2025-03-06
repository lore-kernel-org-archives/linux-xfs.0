Received: from mail-out01.uio.no (mail-out01.uio.no [129.240.10.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA7D2139A6
	for <linux-xfs@vger.kernel.org>; Thu,  6 Mar 2025 11:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.240.10.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741261028; cv=none; b=c6W0+49pwrnYe0DmrSh6hyNSDovUN0bsgOYBypjKu947FXjmoejQO0U+4TKoOmqEUMU67sSOEHjlCD9BKn+GIiEp6DekzLQUCQz+0CK4mPUVYxwXVVm3WjSqdZKE8s6RrsHSKBQ8VqTAzbZgjn6/uGckqjXpwpJMl16vDC0udb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741261028; c=relaxed/simple;
	bh=oTRv2GQh88isY6Tyqt10Pbv9YcwohVak2jyhWmhzJpA=;
	h=Message-ID:Subject:From:To:Cc:In-Reply-To:References:Content-Type:
	 Date:MIME-Version; b=PTkvkcyyxKIpzTUAXqsz2YSOfaV/Cf6ZXYlCcj8E5ltEwZ/zrj4zQFOlrjqAqETk7ERLWDGb3x1+jgDaaN6yvPcushkoDRMpfaqhviBErn8Ws1vm4roSrlDWY7D8GpRr0GGNuhHA24+lqMHOTO8le/XAEYAcxSDgS1I3tlDBKjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ifi.uio.no; spf=pass smtp.mailfrom=ifi.uio.no; dkim=pass (2048-bit key) header.d=ifi.uio.no header.i=@ifi.uio.no header.b=K+t0Jhky; arc=none smtp.client-ip=129.240.10.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ifi.uio.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ifi.uio.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ifi.uio.no header.i=@ifi.uio.no header.b="K+t0Jhky"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=ifi.uio.no;
	s=key2309; h=MIME-Version:Date:Content-Transfer-Encoding:Content-Type:
	References:In-Reply-To:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=D+tRAdofKXTPQVwv3OWg6rqxZLJxIRQwEaSKi6vgnak=; b=K+t0Jhkyk6/wItR7GaxwuCvZZ9
	oNKZV1HyxrEH4u098u55nSp0hoahSmhOC42JJYj3tlWH7YA2vCjhls4mABBmXhbf4qS0AMyu0Ga0F
	3MFubP0mOvHnpD9Y4WxYjebzSOjEtFPT+0TRbwwcLe+Bph4xn84cJwlnTOf32LTMeto8pxy9eXGLW
	2FPtBSgR2J0SylPgmgV3xIplEUbHVGIr7T+/tFhUhUE2gXV8UKDiUnh28IZpRkPdosag5Fh4e4wwr
	iQryj+59GMBTegMSOGZhY9WLwH3ddHpCXqpYk2amaYXDlYU549B1YpMdY9oIBQqdtnEOgaCQOB+u9
	777/KnUg==;
Received: from mail-mx11.uio.no ([129.240.10.83])
	by mail-out01.uio.no with esmtps  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98)
	(envelope-from <kjetilho@ifi.uio.no>)
	id 1tq9XC-00000008kIm-2e3b;
	Thu, 06 Mar 2025 12:37:02 +0100
Received: from vpn.i.bitbit.net ([87.238.42.13] helo=scribus.ms.redpill-linpro.com)
	by mail-mx11.uio.no with esmtpsa (TLS1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
	user kjetilho (Exim 4.98)
	(envelope-from <kjetilho@ifi.uio.no>)
	id 1tq9XC-00000000CJD-05jt;
	Thu, 06 Mar 2025 12:37:02 +0100
Message-ID: <521200e9de4a3b789af1e2890f8a50f9612ed9c9.camel@ifi.uio.no>
Subject: Re: nouuid hint in kernel message?
From: Kjetil Torgrim Homme <kjetilho@ifi.uio.no>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
In-Reply-To: <pgirewjvggop2v2s6qrovyqr72kxfajuk2sbqlqll3facikiuu@sriorffcy3x4>
References: 
	<Nro5gceoG1ar5vFFGSWGNwo-KlGPVYooeufy2thIqL3A5VKjZKQ0yp0kKyAxSVRiAvTm1CkpW4ITHawDjpez0A==@protonmail.internalid>
	 <cbf4f4c23efba09467ca7c08e516fe8561a1f130.camel@ifi.uio.no>
	 <pgirewjvggop2v2s6qrovyqr72kxfajuk2sbqlqll3facikiuu@sriorffcy3x4>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Mar 2025 12:36:34 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
X-UiO-SPF-Received: Received-SPF: neutral (mail-mx11.uio.no: 87.238.42.13 is neither permitted nor denied by domain of ifi.uio.no) client-ip=87.238.42.13; envelope-from=kjetilho@ifi.uio.no; helo=scribus.ms.redpill-linpro.com;
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5)
X-UiO-Scanned: 49C26F5C06643DCFEE33E67408026A814A668704

to. den 06. 03. 2025 klokka 11.00 (+0100) skreiv Carlos Maiolino:
> On Thu, Mar 06, 2025 at 12:46:23AM +0100, Kjetil Torgrim Homme wrote:
> > hey people, thank you for XFS!
> >=20
> > tl;dr: consider changing the kernel message "Filesystem has duplicate
> > UUID - can't mount" to include a hint about the existence of the nouuid
> > mount option.  perhaps append " (use -o nouuid?)" to message?
>=20
> This looks good at first, but adding a message like this has a big down
> side IMHO. This leads users to simply attempt to do that even in cases wh=
en they
> shouldn't.
>=20
> As an example, in a common multipath environment with dm-multipath, an us=
er
> might accidentally attempt to mount both individual paths to the same dev=
ice,
> and this uuid duplicate check protects against such cases, which might en=
d in
> disaster.

makes sense.


> On a mid term here, I think we could improve xfs(5) to include a bit more
> information about duplicated uuids.
>=20

current text:

   Each XFS filesystem is labeled with a Universal Unique Identifier
   (UUID).  The UUID is stored in every allocation group header and is used
   to help distinguish one XFS filesystem from another, therefore you
   should avoid using dd(1) or other block-by-block copying programs to
   copy  XFS  filesystems.   If two XFS filesystems on the same machine
   have the same UUID, xfsdump(8) may become confused when doing
   incremental and resumed dumps.  xfsdump(8) and xfsrestore(8) are
   recommended for making copies of XFS filesystems.

perhaps add a sentence at the end of that, "To mount a snapshot of an
already mounted filesystem, use mount option \fBnouuid\fR."

possibly also something about this in xfs_admin(8)?

current text:

       -U uuid
              Set  the  UUID  of the filesystem to uuid.  A sample UUID
              looks like this: "c1b9d5a2-f162-11cf-9ece-0020afc76f16".
              The uuid may also be nil, which will set the filesystem
              UUID to the null UUID.  The uuid may also be generate,
              which will generate a new UUID for the filesystem.  Note
              that on CRC-enabled  filesystems,  this will set an
              incompatible flag such that older kernels will not be
              able=C2=A0to mount the filesystem.  To remove this
              incompatible flag,  use restore, which will restore the
              original UUID and remove the incompatible feature flag
              as needed.

suggested addition: "A transient snapshot which conflicts with a mounted
filesystem can alternatively be mounted with the option \bBnouuid\fR."

what do you think?

--=20
venleg helsing,
Kjetil T.
