Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08C22DECA1
	for <linux-xfs@vger.kernel.org>; Thu,  9 Apr 2026 04:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775707924; cv=none; b=q0ldkylXUhPtPYnOMllkp5aK7Zv6f17zsJHmQbsmNWUZhI6Fz4ddI197fOux5mYvXld2GLJDoDU+IUUbaxEp/aeS1PQ5oc8ixu/qHNCwJjV9G29nffecXsTpZIw8YO4UtYdtrtT/ElA0IJzToHDUXzhns0uefU6z3BOEGrIaBQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775707924; c=relaxed/simple;
	bh=6YHfrpk1CLmgitkyrjwN+HR9dP3AJnFyvTSvr+bFdDY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YAxVIU9EHKby7N31NSlGdgHPPoEv8jgR56UNXaTdfqsdv0Ep57yniVA9nd2WnX+EawwnTVa9KFpSU/tJ97HUZ2MOaQT7lTvdtV5dFCMKrz4hOg7cTplS8o7Gu5/uz/cmi75TQqtGw7qkY1EEfKb1lDzBa0XamW4MIsvcTDuUutg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=PQurBuLz; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="PQurBuLz"
Received: from macsyma.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6394Bakp013983
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 9 Apr 2026 00:11:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775707899; bh=NBFukzxQNIlbpu4dR1BAdcrERQuSpFgXbePc35/CAcQ=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=PQurBuLzZ1AJBBaBEtKJQ2CAbaNk78ZzQ/69Sr7DZbFPK+9IJybrvvx8OEoBmt0K/
	 zZu31CKmU5WLkwCcTmVy29QPU8jaAGhUWRbnsm18GtjIxGjrcrWZKRcJAHI9xQNQfp
	 DnHbaJ7lF1dRStlbJL+qQlHVCeI+leVoZ+ee+4GXaTkxm/NKeWB6pgyiYzetQYAgtL
	 JfWWBFoKDi8Mu9On1wilzEsFAjM/K3XL7RbyiGetEYu5UtiZRJOIXmI2SQkDv/Xtei
	 NeECjPfMgW+OdGkv5wnbai8oA4DyT0njG5I56F96F15ZWwLxUQHWKXNheb9YV3Grex
	 iLe9tyRKGI8bw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id C9709625964A; Thu,  9 Apr 2026 00:10:35 -0400 (EDT)
Date: Thu, 9 Apr 2026 00:10:35 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Anand Jain <anajain.sg@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        Anand Jain <asj@kernel.org>
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
Message-ID: <20260409041035.GC99725@macsyma-wired.lan>
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
 <20260323041624.GA11453@mac.lan>
 <d4a9970b-e7ed-4e74-be9d-2d08400f9d79@gmail.com>
 <5bda3d00-df35-4ea1-b313-2fef6e5c5682@gmail.com>
 <adSUiB9L0sFAd04U@infradead.org>
 <20260407144709.GA81690@macsyma-wired.lan>
 <3c9e478a-42ef-446f-a8cc-1b4ac970d2ef@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c9e478a-42ef-446f-a8cc-1b4ac970d2ef@gmail.com>

On Thu, Apr 09, 2026 at 06:28:32AM +0800, Anand Jain wrote:
> Some A/B testing use cases require the filesystem to remain
> byte-for-byte identical. In those scenarios, changing the UUID
> isn't an option.

But in that case, where the file systems A and B are bit-fot-bit
identical, why do we care whether statfs returns different fsid's for
statfs(A) and statfs(B).  After all, f_fsid is only defined as "File
system ID", and there is no other definition.  Which is why I say that
people *really* shouldn't depending on its semantics, because it's not
well defined.

Quoting from the statfs(2) man page:

    Nobody knows what f_fsid is supposed to contain (but see below).

    ...

    The general idea is that f_fsid contains some random stuff such
    that the pair (f_fsid,ino) uniquely determines a file. Some
    operating systems use (a variation on) the device number, or the
    device number combined with the filesystem type. Several operating
    systems restrict giving out the f_fsid field to the superuser only
    (and zero it for unprivileged users), because this field is used
    in the filehandle of the filesystem when NFS-exported, and giving
    it out is a security concern.

So if the two file systems are identical, the (f_fsid, ino) will
uniquely determines a file.  And that's *fine* if f_fsid is the same
for statfs(A) and statfs(B).

No?

					- Ted
