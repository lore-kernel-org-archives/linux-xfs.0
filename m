Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD45760877
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 18:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710353861; cv=none; b=SHuERG093jUPtHtOwjJYF/iLtgSMohrb3rXW/q6AAN5rbYQFu+VZtkL6x7nK+0pB0PF1vm3l23E0v3lzXKAXvjzk5EIC8C08JKpiOMp59/RW5c+tkjRPc3bJhtuZrunAY6y/8Nnk2kunz0SwzOXAgd6jSDUV4YQU/mpSslpmN48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710353861; c=relaxed/simple;
	bh=GNDeUD2x0vLSr13aadR80j7ZCBI4JWZLI9wJTNpHNPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LrnGXgZ7OX8S95h+ICbXkRcCb+GKYl7SvMKtswngOJ92V2zGRjkBprU2ctVWd3coUWeTyKURUJVt/YyDHHsGvrIDO/GuiuZhqRjP6xgElKIeUTAT6duUSVPNu/LCxtJa+xSa1nZQXvTo1I2A263vzlIIMQ619hm1pAA6BoLg+uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RrQ/H7zC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RrQ/H7zC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710353858;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1hAQXTUcAiywJoqM+i1Rxf1T8UkFK8cEN5YY48yKtI4=;
	b=RrQ/H7zCi8LSeuFz/HnHlvYUXGIyS9gmGsLQKbuWPF0RiKrDr6GCZ2Dce1QwV68kMa7bsq
	VKMBlI10gpOMrbJUyqgRD2Y/DQ2ZZCr8G2WJ11fgO4UCeG+N5+llfvUFcgTgYfNrkoLDbz
	xMimp2h2HSm7MwSx1J07eDMFs/UnMSc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-482-Gp4GwwfnPk2m3KHawOciwA-1; Wed,
 13 Mar 2024 14:17:35 -0400
X-MC-Unique: Gp4GwwfnPk2m3KHawOciwA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8EB941C07821;
	Wed, 13 Mar 2024 18:17:34 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.77])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F2531C04221;
	Wed, 13 Mar 2024 18:17:33 +0000 (UTC)
Date: Wed, 13 Mar 2024 13:17:32 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 06/10] mkfs: scale shards on ssds
Message-ID: <ZfHtvBbxUt4Xa2z6@redhat.com>
References: <20240313014127.GJ1927156@frogsfrogsfrogs>
 <171029433596.2064472.12750332076033168727.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029433596.2064472.12750332076033168727.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Tue, Mar 12, 2024 at 06:48:36PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> For a long time, the maintainers have had a gut feeling that we could
> optimize performance of XFS filesystems on non-mechanical storage by
> scaling the number of allocation groups to be a multiple of the CPU
> count.
> 
> With modern ~2022 hardware, it is common for systems to have more than
> four CPU cores and non-striped SSDs ranging in size from 256GB to 4TB.
> The default mkfs geometry still defaults to 4 AGs regardless of core
> count, which was settled on in the age of spinning rust.
> 
> This patchset adds a different computation for AG count and log size
> that is based entirely on a desired level of concurrency.  If we detect
> storage that is non-rotational (or the sysadmin provides a CLI option),
> then we will try to match the AG count to the CPU count to minimize AGF
> contention and make the log large enough to minimize grant head
> contention.
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
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-scale-geo-on-ssds
> 
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=mkfs-scale-geo-on-ssds
> ---
> Commits in this patchset:
>  * mkfs: allow sizing allocation groups for concurrency
>  * mkfs: allow sizing internal logs for concurrency
> ---
>  man/man8/mkfs.xfs.8.in |   46 +++++++++
>  mkfs/xfs_mkfs.c        |  251 +++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 291 insertions(+), 6 deletions(-)
> 
> 

