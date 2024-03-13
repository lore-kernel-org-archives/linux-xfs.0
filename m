Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E61D6216B
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 17:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710350418; cv=none; b=p1HfLHMGFYXTLvzIm7BkVzTXIlD29owCWYcqgOPL9oAqG8mNNAhhfeWwUqWoFheWKY9C219yFrB2UaMaPImgyNpuUq+KmNfi4TOKDw0yrqQRBsZSOhmqPdrSOosP5fsRCznhhHPxkUZEkDI5y6pZO8ON1+3+lG9jb2ouE9APSKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710350418; c=relaxed/simple;
	bh=Vo5UT6aYXKApaViSqDMuObpUSD2P+4dU6cJjNvz7t6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qzmn89BDbRjVw8jMfEefh0sM25gLAx5Q6L2J1bNc9STTSNEzJjqdP/u7biVSeZXVSDEfJueYnA8i+6Fm1cV5yvi7YiiB+HAdWQJQwUomIan6YKIGCln7IC3JswR1ZWsS9CFGl07zrfQ5/k/A6TEXTK7o8brweJEGKPy97PwazNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GYB0YZSZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GYB0YZSZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710350415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UaVDj0NIwjCPhkJBNwKrNcIXu7KEll4iv+mJeaB3xzg=;
	b=GYB0YZSZVvl/+wTODWfHwdj1JwBCb0Zr+aqZ1uA4cOKZ3o+BeQ7+9B4o1zGJmwoT7RDGx6
	D/d6y5abejfd2RW2MmdgjHj4aJETGG1CFsK2QRyE94T7BAPwAsIcUFv7ION1llUSCmARwk
	w8HGL+0FBk5KIerG6HDv90t0hEq3Rq0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-115-wAXrNYzcPfWiVNeAAOZsEA-1; Wed, 13 Mar 2024 13:20:12 -0400
X-MC-Unique: wAXrNYzcPfWiVNeAAOZsEA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C81D4101A58F;
	Wed, 13 Mar 2024 17:20:11 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.77])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 810062166AE4;
	Wed, 13 Mar 2024 17:20:11 +0000 (UTC)
Date: Wed, 13 Mar 2024 12:20:10 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 01/10] xfsprogs: convert utilities to use new rt
 helpers
Message-ID: <ZfHgSvht12J_36mh@redhat.com>
References: <20240313014127.GJ1927156@frogsfrogsfrogs>
 <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029430538.2061422.12034783293720244471.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

On Tue, Mar 12, 2024 at 06:47:18PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> The patches in this series clean up a lot of realtime space usage code
> the userspace utilities.  This involves correcting incorrect type usage,
> renaming variables to reflect their actual usage; and converting open
> code logic to use the new helpers that were just added to libxfs.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D

For the series...
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fix-realtime-units
> ---
> Commits in this patchset:
>  * libxfs: fix incorrect porting to 6.7
>  * mkfs: fix log sunit rounding when external logs are in use
>  * xfs_repair: fix confusing rt space units in the duplicate detection code
>  * libxfs: create a helper to compute leftovers of realtime extents
>  * libxfs: use helpers to convert rt block numbers to rt extent numbers
>  * xfs_repair: convert utility to use new rt extent helpers and types
>  * mkfs: convert utility to use new rt extent helpers and types
>  * xfs_{db,repair}: convert open-coded xfs_rtword_t pointer accesses to helper
>  * xfs_repair: convert helpers for rtbitmap block/wordcount computations
>  * xfs_{db,repair}: use accessor functions for bitmap words
>  * xfs_{db,repair}: use helpers for rtsummary block/wordcount computations
>  * xfs_{db,repair}: use accessor functions for summary info words
>  * xfs_{db,repair}: use m_blockwsize instead of sb_blocksize for rt blocks
> ---
>  db/check.c               |   90 ++++++++++++++++++++++++++++++++++++----------
>  include/libxfs.h         |    4 ++
>  libxfs/Makefile          |    1 +
>  libxfs/init.c            |    8 ++--
>  libxfs/libxfs_api_defs.h |    8 ++++
>  libxfs/logitem.c         |    3 +-
>  libxfs/trans.c           |    3 +-
>  libxfs/xfs_rtbitmap.c    |    2 +
>  libxfs/xfs_rtbitmap.h    |    3 --
>  mkfs/proto.c             |   41 ++++++++++++++-------
>  mkfs/xfs_mkfs.c          |   16 ++++++--
>  repair/agheader.h        |    2 +
>  repair/dinode.c          |   21 ++++++-----
>  repair/globals.c         |    4 +-
>  repair/globals.h         |    4 +-
>  repair/incore.c          |   16 ++++----
>  repair/incore.h          |   15 +++-----
>  repair/incore_ext.c      |   74 ++++++++++++++++++++------------------
>  repair/phase4.c          |   16 ++++----
>  repair/phase6.c          |   28 +++++++++++---
>  repair/rt.c              |   64 ++++++++++++++++++++++-----------
>  repair/rt.h              |    6 +--
>  repair/scan.c            |    2 +
>  23 files changed, 278 insertions(+), 153 deletions(-)
> 
> 

