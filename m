Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506E22D2496
	for <linux-xfs@vger.kernel.org>; Thu,  9 Apr 2026 13:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775740606; cv=none; b=t9SciE8uJMTwJZHvypydsuEXtglAcCKPYN8eFk8/4mAYDk6A4oOLZv8BgeTff7lwYkAYO+Z42KwkC/aXYPW67o5dFkIzcylBpBT3cENsq8hUbQ7P7QhB93nUJDpssWllYndqsKFHyqZRzhzM3EtLXhD2Ez79GR9jN+uzxvEwmE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775740606; c=relaxed/simple;
	bh=+8HNfJO6lKTadPMqN2KZn/OiSKoWTTnUtegSrnHPbP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JWGBp3TBJOqpTOtoi1whrlqSAluCkCFYDZgsDlJIKU2lcUbPScz9PbzpA53W3srBdg4novKkS2tt/YGJmndL+kh67S/dNfFJA6H8QXuB6510yUl15f6JJlgcwQxk4Jn/LQLqM21NKBTNf3Kn/vTJiXqbS/alNppLydWt8dHXuso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=aB1/hUZC; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="aB1/hUZC"
Received: from macsyma.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 639DDdk6013555
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 9 Apr 2026 09:13:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775740421; bh=D4w40sIfh1Zntye5XlBYIgg6R4pyKLV6UQBgcYVuBLQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=aB1/hUZCUwChjF0Cy6Ac/lyMdZ8fknqSwjOEr/Slwnu1/7zrijKrl0yu//YjNR/2W
	 nA8X/mUUUsph1zzX7DAOsvs0F6GxQRkrDyWbRfgfUKN8HxEYIGSSrsCsB9+2ITfvP4
	 HqWbWnmxodRp1VeTC/zHA5pc5lQXE0B2Kva5Bo7VbF3ut4wxHIKywXVFjrOYN+qkn5
	 aw9QANPp9kcWzm+n5dbl6xoSNcg6rqEEEyrfjDBumi4ClQ90rnvXirgbWK9aGInzkX
	 Ar6ZyCpvrarriDc07RTgj3MsXSDq6znimTN5YHwozS7y/4kksPc30jGl2iM3yF9h1Y
	 F6+VnFPS2B+2Q==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id CFBE76261ECD; Thu,  9 Apr 2026 09:12:38 -0400 (EDT)
Date: Thu, 9 Apr 2026 09:12:38 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Anand Jain <anajain.sg@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        Anand Jain <asj@kernel.org>, dsterba@suse.com
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
Message-ID: <20260409131238.GC18443@macsyma-wired.lan>
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
 <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
 <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
 <adSUiB9L0sFAd04U@infradead.org>
 <20260407144709.GA81690@macsyma-wired.lan>
 <3c9e478a-42ef-446f-a8cc-1b4ac970d2ef@gmail.com>
 <20260409041035.GC99725@macsyma-wired.lan>
 <22cfbf8d-af9b-462e-b240-67a1de24764f@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22cfbf8d-af9b-462e-b240-67a1de24764f@gmail.com>

On Thu, Apr 09, 2026 at 05:45:24PM +0800, Anand Jain wrote:
> 
> Got it. Do you mean that since both filesystems are identical,
> statfs(A) and statfs(B) can legitimately return the same values?

Yes.  f_Fsid can legitimately always be zero (which I believe is the
case for FreeBSD, but I understand that there are some programs, like
systemd, which subscribe to the heresy, "All the World's Linux", which
is a variant of the "All the World's a Vax" or "All the World's SunOS"
at the beginning of my career :-).

> I'm not entirely sure what the correct expectation for f_fsid
> should be.

That's my point, there *is* no correct expectation, and I don't
believe there can or should be.  What we should be doing instead is
actively discouraging people from using f_fsid.  I suspect that's one
of the reasons why FreeBSD may have chosen to just return zero.

Which is why I don't think we should be testing this in xfstests's
generic/791, either.  (Unless we get consensus across file system
developers abnd willing to make it be a documented behavior as of a
particular kernel version, and we then adjust the test to skip it if
it's older than that kernel version, so it doesn't break LTS kernel
tests.  See below....)

> My initial idea was to make f_fsid behavior consistent across
> major filesystems so that user space benefits from predictable
> semantics.

I'm OK with that, so long as it's unconditional across all file system
types (ideally) or unconditionally across all major file systems (xfs,
btrfs, ext4, f2fs) as of a particular kernel version (which is
probably much more realistic), *and* it is documented in the Linux man
pages as this is the standard behavior starting with 7.1 (or
whatever), and that the man page further cautions that programs that
expect to be portable to other OS's (MacOS, FreeBSD, Solaris, etc.)
should not count on this behavior.

But given that you originally stumbled across this with Overlayfs,
because it was originally using s_uuid, and that didn't work well for
btrfs, why not change overlayfs to just use s_uuid plus kdev_t in its
xattr, and just fix the problem for overlayfs?  That has the benefit
that it will work for all file system types in Linux, not just for
those where we have changed what f_fsid does.

Cheers,

					- Ted
