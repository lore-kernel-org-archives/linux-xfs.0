Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E5060BB2
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 18:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710353961; cv=none; b=OmOu+IBIGuHYTa+hWQ2oA2WYiQqIsDEkrzgj1SAk8DUwxhq3PzT62YjUzXZAI0HWA1bXu9xMJtSPLN8r2Rw6KDwAxXxeBb6wacZA1UItqTV0dzajm5Vb37Nf7CZx4BKc8ZzSvCoGDRtTSjzExYf0EcmeLarncaxhyb2c22YCjN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710353961; c=relaxed/simple;
	bh=KFTjhJ+siAOQvNpvJE3ZDmPKE3oIhq4aBi8qK/HFnXQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i1Yr9I+/d39lmtd1NUDL5G5IZ37I/fV/YQEWoQ/H3WpnL9Ek0TVGJe2rFAZBbaUQPBM7kZajrtRZT2f9pZMkNXMLYl8HYBKphb8R4DJidOGUCxUfhW64buSDz2cdi8dxsMWNOKVqVT6KiaNu6n0Ob5/zMo+zELpqA24X8asGHd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CBHZmKfB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CBHZmKfB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710353958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AAGDgi2+IscTrHwZUEtWIz4dUPnAVfRqDbcjsT3jRpo=;
	b=CBHZmKfBsJXNMB5wASVIt5hTBCaKaqXzsPRumLrPguqRfIOB6Kcos3YUeLyCQsECUH3C87
	APt5lwSeFVhpwNons0vOSYxwaCCxW1lW3Ls7Cy41rrzMTtU90fU56SO/1MR4xdud8OszVd
	hDkgG+uaxgS9MK5aa6j+XGei2u15E6U=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-567-MNh0ZeFCNAmlsAD2PT9XCA-1; Wed,
 13 Mar 2024 14:19:14 -0400
X-MC-Unique: MNh0ZeFCNAmlsAD2PT9XCA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA86B1C01E91;
	Wed, 13 Mar 2024 18:19:13 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.77])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5B892492BC6;
	Wed, 13 Mar 2024 18:19:13 +0000 (UTC)
Date: Wed, 13 Mar 2024 13:19:11 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v29.4 07/10] xfs_scrub: scan metadata files in parallel
Message-ID: <ZfHuH7oKCCM3b-f5@redhat.com>
References: <20240313014127.GJ1927156@frogsfrogsfrogs>
 <171029433946.2065570.16411233810474878821.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029433946.2065570.16411233810474878821.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Tue, Mar 12, 2024 at 06:48:52PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> At this point, we need to clean up the libfrog and xfs_scrub code a
> little bit.  First, correct some of the weird naming and organizing
> choices I made in libfrog for scrub types and fs summary counter scans.
> Second, break out metadata file scans as a separate group, and teach
> xfs_scrub that it can ask the kernel to scan them in parallel.  On
> filesystems with quota or realtime volumes, this can speed up that part
> significantly.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D

Series...
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>

> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-metafile-parallel
> ---
> Commits in this patchset:
>  * libfrog: rename XFROG_SCRUB_TYPE_* to XFROG_SCRUB_GROUP_*
>  * libfrog: promote XFROG_SCRUB_DESCR_SUMMARY to a scrub type
>  * xfs_scrub: scan whole-fs metadata files in parallel
> ---
>  io/scrub.c      |   13 +++--
>  libfrog/scrub.c |   51 ++++++++++-----------
>  libfrog/scrub.h |   24 ++++------
>  scrub/phase2.c  |  135 ++++++++++++++++++++++++++++++++++++++++++-------------
>  scrub/phase4.c  |    2 -
>  scrub/phase7.c  |    4 +-
>  scrub/scrub.c   |   75 ++++++++++++++++++-------------
>  scrub/scrub.h   |    6 ++
>  8 files changed, 194 insertions(+), 116 deletions(-)
> 
> 

