Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974273CA49D;
	Fri, 24 Jul 2026 23:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784936745; cv=none; b=gWyuTkBp1Hyq2EZqXfZJNWE30vohN3yOysKblKBTekg65wMXJYcoKRH1/p4nL0lZp8MDC31GBCFkC75Uud/6vn5u3mCA78SdoPj4ipH0Tvlau4DcirJ7ZpYshprvgbPVJBZx/5AV/XtssrS+Qd+Wetxw6Q1YaTvSiWchSSh4RAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784936745; c=relaxed/simple;
	bh=qcTERRUkxQ+CrTC1g+xD4PgNJwU/MfWA++PGb141F0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oVI7ePLvleji10CgFXzJ0mUWmKNa9CwmiruIbFkcFkVDGxVJYcoBCCJZJbllK38Pdm/XDKbgBwfvSWpgWTUOFoSHk1MQsVReyJpU5cvTBqJ9MBtXSs5JazefizmqQzBwPv77ZZZuDd3xLh5x0PQJbSAEPFgNeQ/vxl/HrdJ8rAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nm7MZYo9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nm7MZYo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53B01F000E9;
	Fri, 24 Jul 2026 23:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784936742;
	bh=UButzxL7Kw/j5kopPBpah4WDYkmBhSrmLzL/921+7Ng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nm7MZYo9+tnTIlCeT+kz73KmCi3UyfhyR8CfNACCQlOic6dpLpdkLGe1Qm3lgu6ZW
	 QrDtWKBRfpWwvRUQxzekj/1Jh50mBNyhveWcEtk00jeQTMnJgp16mUwMGI6GpSRszy
	 z2GtEJTJllfyh5xb8aHxTHgwP4qej6KhoHAE+RdwyooRJQSSNiY9Ry3G7p3i8Q7cKJ
	 0b91gJ6QeJSGvUa4OJZ1pQPrldqAb1MNi76N01EwAg5wbxD51W1tPHkoD640Pmw8Ij
	 ETpvlh6FR7maGjn7oDpZ6pV0XnnC25YH0KmjgRApUoKES04uNKppnq7Cd6WWtX8J+R
	 TPvRzJ0yoJJ2g==
Date: Fri, 24 Jul 2026 16:43:49 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v13 08/23] fsverity: hoist statx reporting of fs-verity
 flag
Message-ID: <20260724234349.GC1901@sol>
References: <20260721184346.416657-1-aalbersh@kernel.org>
 <20260721184346.416657-9-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721184346.416657-9-aalbersh@kernel.org>

On Tue, Jul 21, 2026 at 08:40:45PM +0200, Andrey Albershteyn wrote:
> All filesystems supporting fsverity report this status by checking inode
> flag. Also, BTRFS was missing stat->attributes_mask, which is fixed now.
> 
> Fixes: 146054090b08 ("btrfs: initial fsverity support")
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/btrfs/inode.c | 3 ---
>  fs/ext4/inode.c  | 5 +----
>  fs/f2fs/file.c   | 5 +----
>  fs/stat.c        | 6 +++++-
>  4 files changed, 7 insertions(+), 12 deletions(-)

Acked-by: Eric Biggers <ebiggers@kernel.org>

- Eric
