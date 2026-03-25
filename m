Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521043DB649
	for <linux-xfs@vger.kernel.org>; Wed, 25 Mar 2026 13:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774443616; cv=none; b=YCJQ0rUUZswmez9LEGMnebKtqQMrr2iQmN63jPLeuVUQyT7jwaMpVZ1GT6rtlI+1Gz3PZzDjnq0K/nKkUpTFBmhFsnfP/Hq2fICQv12WwxMZXGHLxUDZOHndP0/NIePQpdi8RTygGKaD2C4T139RN8FCXdqWaFzhKj/jf0L8Yvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774443616; c=relaxed/simple;
	bh=jx3tH0w/EHcIpPZwFmsD4DMLy1VEyrcVixfC8WdtKjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MnGvTRPKGti0KxYMyEd6nm9sdOXFaGPu0I24z6rDFS2jUGV10LplshficwFf669fnkk6sLnhOMCTJZm1Gxvmr1E9Yud3ereZWszgpVMCMPsfTLhjQKt9GtYrXjm5Eo5qlFPtSc7KxAH7vKnlnO3wK45fMCy/QPMrMZRwWOCEtQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=KTzVm2Qg; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="KTzVm2Qg"
Received: from macsyma.thunk.org (172-245-102-52-host.colocrossing.com [172.245.102.52] (may be forged))
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62PCxqRQ020980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 08:59:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774443596; bh=GBOh37T6P2yWOHsFP/yTX6BJRBVtLnsV5e9wrBTEaKE=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=KTzVm2QgtxRy0flXMeu3HagHdaJuX86XgoqHhwisUFBXuHQj9ccH0NB4ikuZnJ9g2
	 gjDQirw4h4bf5K+D9D6pHBkvcaOV77HlhhKD0BOqX6C+79Yz0T/Lx50/sjHF0rzHwa
	 mcYjcTpn7Fmq3cZazsHSULuRvFNuKGDqxhCikiEde5Yoh71ySn8pcYcbTMHQhdnU4z
	 YrwgVbXMktTDPMjnwGEv7TrGOaAmYmLE1a1KrBOoixI2OdapGnoVjR8oH7a2iAeMj2
	 hQyHLV/U1xE+vX+g/Pb4iENipwRr4h/JtUCzDGMG9lehQV1hsHfczy6QTR1c5yZ0pa
	 PDd4xWsHtZgFQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 28D9F5F3CC6D; Wed, 25 Mar 2026 07:59:52 -0500 (CDT)
Date: Wed, 25 Mar 2026 07:59:52 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Anand Jain <anajain.sg@gmail.com>
Cc: Andreas Dilger <adilger@dilger.ca>, "Darrick J. Wong" <djwong@kernel.org>,
        Anand Jain <asj@kernel.org>, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        hch@infradead.org
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
Message-ID: <20260325125952.GB2107@macsyma.local>
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
 <20260323152943.GH6223@frogsfrogsfrogs>
 <5DB914D4-594D-49EE-B69E-6F68E9C103A1@dilger.ca>
 <91d1e10b-b24d-477a-8724-2a75a710dd8d@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <91d1e10b-b24d-477a-8724-2a75a710dd8d@gmail.com>

On Wed, Mar 25, 2026 at 06:59:32PM +0800, Anand Jain wrote:
> 
> IMO, sb->s_uuid (as used by overlayfs)
> Represents a filesystem UUID that is persistent.
> It is derived from on-disk metadata.
> 
> statfs()->f_fsid is..
> A kind of runtime filesystem identifier used to distinguish mounted
> filesystems within a running system.
> It may be stable across reboots or device removal and reinsertion,
> but this is not guaranteed. It may change if the device dev_t changes.

I always worry about "it might be stable, but it might not; ¯\_(ツ)_/¯"

The problem with that is that people might starting using this
kinda-of-guarantee-but-maybe-not in scripts or in programs, and then
when people try to run that script or program on a different system,
or on a different file system, things goes *boom*.

So if we want to say that it is stable so long as dev_t and the file
system the same, that's a well defined semantic.

If it's that it has no guarantees whatsoever; cloud change across
reboots; could change across remounts, then maybe it should just be a
global mount sequence number that starts with a random number at boot.
So you can use it to distinguish between different mounted file
systems, but that's *all* you can do with the thing.  That would also
be a well defined semantic.

Cheers,

					- Ted
