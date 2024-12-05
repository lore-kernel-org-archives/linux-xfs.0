Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29F284A22
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 01:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733362024; cv=none; b=abx57VvzG+phXbAx4kdgievcdoJeiKnv41+LbDgHXLfe6bPrQm+WDMGXHSQwXKHxfldaO+g3kVpZdaBTu7oUjCFASyiiaaKZvwqDym7E8mqvV+pPm9XL3UvxHmNU1s3Q/IYxv04X0DXmHl1rgULMc6PGrvgRWAMj9y08foc4lu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733362024; c=relaxed/simple;
	bh=L438MqHB1Lzc+kZ8gwgHIgBQEde5wvvXOFnhmyjN7bE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/OvleKENd/JkdzNGmYFYkBTX2p/zfzT76zuxE2vARqSalik2z9YiXVkV8zHsnuPgRXFAuRHB+FuHF1h1PwzPGW5/Zg4gA0MtzwEv6Owmnn8ar6OnmRZQUBeX0Iq1HpAgblQD7XWwtlcp9EiHKk+LJVJsqhGud747UXKPao6D6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UIJlXdKK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UIJlXdKK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733362021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VRzCKUh57lh2RbsskuLfk2Sa3SyCxeQEj/TMWD4N4MA=;
	b=UIJlXdKKcp2eU9zc1F8xJTpzCIvA0qm00wBtOFwRpS2QhDvd5WU6o9ToXVcHc49qwwe6bL
	IBSTlMVBwS9fxp7NML1v3QzhhLuUl2RHOiXxxuSv7mqijpZLEvQwbT8rq7PN6bzUjVahat
	vBPMirbBHaGbO+9SWUYi+6SXVtxikbE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-364-SnaIFmbfPOy0W8VSdmU-Eg-1; Wed,
 04 Dec 2024 20:27:00 -0500
X-MC-Unique: SnaIFmbfPOy0W8VSdmU-Eg-1
X-Mimecast-MFC-AGG-ID: SnaIFmbfPOy0W8VSdmU-Eg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 82D9F19560B6;
	Thu,  5 Dec 2024 01:26:58 +0000 (UTC)
Received: from redhat.com (unknown [10.22.64.4])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF0D71956054;
	Thu,  5 Dec 2024 01:26:56 +0000 (UTC)
Date: Wed, 4 Dec 2024 19:26:54 -0600
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, jlayton@kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET v2] xfs: proposed bug fixes for 6.13
Message-ID: <Z1EBXqpMWGL306sh@redhat.com>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Tue, Dec 03, 2024 at 07:02:23PM -0800, Darrick J. Wong wrote:
> Hi all,
> 
> Here are even more bugfixes for 6.13 that have been accumulating since
> 6.12 was released.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> With a bit of luck, this should all go splendidly.
> Comments and questions are, as always, welcome.
> 
> --D

Hi Darrick-

I must ask, why are these constant bug fixes and fixes for fixes, and fixes for fixes for fixes
often appearing? It's worrying that xfs is becoming rather dodgy these days. Do things need to be
this complicated?

-Bill


> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=proposed-fixes-6.13
> ---
> Commits in this patchset:
>  * xfs: don't move nondir/nonreg temporary repair files to the metadir namespace
>  * xfs: don't crash on corrupt /quotas dirent
>  * xfs: check pre-metadir fields correctly
>  * xfs: fix zero byte checking in the superblock scrubber
>  * xfs: return from xfs_symlink_verify early on V4 filesystems
>  * xfs: port xfs_ioc_start_commit to multigrain timestamps
> ---
>  fs/xfs/libxfs/xfs_symlink_remote.c |    4 ++
>  fs/xfs/scrub/agheader.c            |   66 ++++++++++++++++++++++++++++--------
>  fs/xfs/scrub/tempfile.c            |    3 ++
>  fs/xfs/xfs_exchrange.c             |   14 ++++----
>  fs/xfs/xfs_qm.c                    |    7 ++++
>  5 files changed, 71 insertions(+), 23 deletions(-)
> 
> 

