Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421DF3264EE
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775573312; cv=none; b=urxXLZ/YP2RnlMMBYo2XonFxMXDH2lE3Stjd2deh+v98eKk9SlR0/ksdXGJCQ4+5oyJ8B2+er1ZKzaastC9p9YUeGW7EIh61m//x9YPRWO56VOuZubEWZ9nC0OpRJhftiZ6UOKn7Z2JkxePj2ASM60ITEQXPRFLFyymK51T10FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775573312; c=relaxed/simple;
	bh=P3GvwR+j8UgQw/D50ZFDRswhdtkd7NU/FARUnxYyiLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qLz5xM/XPTrnlq6Hq84TMS0/YbAH9jSxIFTeUm+/LhjC2OJskfwh8pupWcGN0S5fGsaDOkQ+3/pgnDwcVIfP2aHN11aeWJ7Q8qGvLGwpfc+ERu3WAtRNZRuBCjKlDWeoA4ac/gTR1iyvtZijOeN+F0xmwe2pAA4CKJjmH+pmjFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Gv3urCNA; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Gv3urCNA"
Received: from macsyma.thunk.org (pool-173-48-119-176.bstnma.fios.verizon.net [173.48.119.176])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 637EmAXB003208
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 7 Apr 2026 10:48:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775573292; bh=B6mytxkR/pP/+KrUuQ4BEVU8OOl8s75NsKAPt+dhBVQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Gv3urCNAhxv19PmA9S/iTKCp+SiVD2aAaDI7e3In5igU7PNU9MDX2OPeagQCItyz8
	 +IO/nF1XWVRA8hHojKbTJX6eHtxITSHmyF/A7frFN87n3+qWFbmtsZ/lhU4uKWkVKF
	 L/SAQRS7vJFFr4RdteQa+N753FGdm9uVqMnYpiyWVymkGQFT6GiBCEzIgAEZZ9kDQ3
	 riW+P+99kQKKAqRFGTRPAhaqXEjV8GuWbgdMuMUQ/dDgv7MOIqmShvaANvfrbraOCf
	 e4rD4yLseMo8U/DxiV1u4CREIwbmX0HncxM4xIegfOkEA5PCMrgtKeYnxl+Z/d8XK2
	 ACfNFgAOslwvg==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 9E5586226E6E; Tue,  7 Apr 2026 10:47:09 -0400 (EDT)
Date: Tue, 7 Apr 2026 10:47:09 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Anand Jain <anajain.sg@gmail.com>, "Darrick J. Wong" <djwong@kernel.org>,
        linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, Anand Jain <asj@kernel.org>
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
Message-ID: <20260407144709.GA81690@macsyma-wired.lan>
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
 <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
 <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
 <adSUiB9L0sFAd04U@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adSUiB9L0sFAd04U@infradead.org>

On Mon, Apr 06, 2026 at 10:22:16PM -0700, Christoph Hellwig wrote:
> > Dilemma:
> > While statfs(2) [1] suggests f_fsid is "some random stuff," we know
> > userspace (NFS, systemd) often treats it as a persistent handle.
> > 
> > Do you prefer one of the names above, or is there a more idiomatic ext4
> > naming convention I should follow?
> > 
>
> My take is that anything that should persist should be an on-disk
> feature flag, not a mount option.  But I'm not in charge for ext4

My take is that f_fsid is random stuff, as documented by the
specification, so anyone who tries to depend on it needs to be kept in
a padding room where they can't hurt themselves or their users.

And as far as NFS is concerned, file handles should be based on
the super block UUID, not statfs's f_fsid, and anyone who wants to
mount a snapshot as an NFS exported file system at the same time that
the original file system is mounted is _also_ should be gently coaxed
into a padding room where they can't hurt themselves or their users.

The solution that we've used for people who are cloning block devices
for things like cloud images has been for *years* has been to use
"tune2fs -U random /dev/sda1".  And this works on mounted file system,
and (for example) built into various cloud images for Google Cloud
Engine.

If we want to change statfs's f_fsid, from one set of "Random stuff"
to another set of "Random stuff", I don't really mind, but I don't
think it's worth *either* a mount option, *or* a feature flag, as
either would be confusing for system adminsitrators when some file
systems behave one way, and other file systems behave another.

	       	   	    	  - Ted
