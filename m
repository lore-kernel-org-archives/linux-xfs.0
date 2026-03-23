Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7FD1DF75B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 04:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774239435; cv=none; b=R6ESSb3vgXSU0fMfK/FG0FIAMr/PhCRpdcj0axJ3MSyA8S8sJBHJnTyTYSHB6tWIW9ILUKh4qZRJeDzEy4DJPrqWTbEvpX1KDfwetCfPRH/lPP48Eh/Ra9aVjq2YRuoPDiX/q5yGLzyiJi6+qHiuEEId+RrLojGIyfg1Cvclk/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774239435; c=relaxed/simple;
	bh=zRqey/N6H/3SBDXw1/PahbKVSm4cZKMQ+1uV2IdBlJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnzfHkR3Tl9Hi5UlHrYJnM1EQRUzbSA36mnQHAD/rnJibELLQmJ8t+gS4dbUAYvf3T6SI3SRo9SFQ/q1ZX4TshiAKuelWBBR8zhn464/y3GHG/LLyo4Z5rKJrvQkkgykHklDAbtcBsvRVd0SstwLRko9ZibxZ07ss8aeQtfMFoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=j2JYJKKH; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="j2JYJKKH"
Received: from macsyma.thunk.org (c-73-9-28-129.hsd1.il.comcast.net [73.9.28.129])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62N4GPhx029184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Mar 2026 00:16:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774239388; bh=nic3aVwcVeurbIvUZF6NESYjPiZr7nwKGGsmRTdtT2o=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=j2JYJKKHAfrS0seO/fsdaQIZxuj1z2Kwt774DYtiIhzQPhkgrvFK4y/0CrpSmWa8T
	 bvxpsCMDHuPYd2YxuBEQqtf5VX/yDVt70+ozz4lbrY/BrEfPq0iCM49tW2N1rh53W3
	 JuMRjxtxxikbTLEqIRKfHNSkjKam8DHcTImnUllL3iV0VgwkLYL0PXirwiE4hwIUf9
	 lI4KE8JD3vj9W1fkV96XHDiv5WPjHAo7BPjF42tKCzf9zCcmnybK4hbYwARnI+Kz6D
	 FjE+9/2cNBoOm5CBiizq4h9rFtx5jQbW5S7cT8+NbXt2RrF07cXhvJVrXeW3xMccR/
	 YQxWuX4TEUqXA==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id CD6DB5ED844A; Sun, 22 Mar 2026 23:16:24 -0500 (CDT)
Date: Sun, 22 Mar 2026 23:16:24 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Anand Jain <asj@kernel.org>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 3/3] ext4: derive f_fsid from block device to avoid
 collisions
Message-ID: <20260323041624.GA11453@mac.lan>
References: <cover.1774092915.git.asj@kernel.org>
 <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33e8eb64c304a4d42b60f608c26497bf9a2e9e19.1774092915.git.asj@kernel.org>

On Sat, Mar 21, 2026 at 07:55:19PM +0800, Anand Jain wrote:
> statfs() currently reports f_fsid derived from the on-disk UUID.
> Cloned block devices share the same UUID, so distinct ext4 instances
> can return identical f_fsid values. This leads to collisions in
> fanotify.
> 
> Encode sb->s_dev into f_fsid instead of using the superblock UUID.
> This provides a per-device identifier and avoids conflicts when
> filesystem is cloned, matching the behavior with xfs.

As I observed in [1] this leads to collisions when for removable block
devices which can be used to mount different file systems.

[1] https://lore.kernel.org/all/20260322203151.GA98947@mac.lan/

> Place this change behind the new mount option "-o nouuid" for ABI
> compatibility.

I *really* hate this mount option.  It's not at all obvious what it
means for a system administrator who hasn't had the context of reading
the e-mail discussion on this subject.

As I stated in [1], I think the f_fsid is a terrible interface that
was promulgated by history, and future usage should be strongly
discouraged, and the wise programmer won't use it because it has
significant compatibility issues.

As such, my personal preference is that we not try to condition it on
a mount option, which in all likelihood almost no one will use, and
instead just change it so that we hash the file system's UUID and
block device number together and use that for ext4's f_fsid.

Thoughts, comments?

						- Ted
