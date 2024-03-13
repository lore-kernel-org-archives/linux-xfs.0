Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9BF6FE1B
	for <linux-xfs@vger.kernel.org>; Wed, 13 Mar 2024 17:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710352456; cv=none; b=CiFirn/aT07T99Xuh1PLAeNIgpdvWSHdSzwGGP6gKBzfQq1clK7gsqqGZJVXdEwCw359ZzLzMm+wFMB6IsBsuLf+V5CA5UCd+0FnmNvDleiIBnjKJc8VlN36/dSrbOL8bEHPQT35imBG4d6jabU1oH7T+1az3oGD/KcBNlmaCNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710352456; c=relaxed/simple;
	bh=RpcUNisbZ7iyBkYrZ3Mu4OsCSTGVWsUTgYeAznMLbUg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=boTdSHNfaAJPxACSWKoBrlUafYfEVOBt7WzTwoL5fLBaF0O/UUm4x3QKM4NBqW6JPPCT2vMYocLthsRldC2S92uGNzwDrv0upR0TOdKW5c5kTEEeXgKjyfHgQwfj1pHkSeHe3A2S2IlvQjpq48MJwo9OEMTm9EEI49LKXxkyul0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eqg21GLp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eqg21GLp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710352454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H0gwYALgPhjMVxcLsR7SpoQ6L8cq3wwx7ci75qStaqQ=;
	b=eqg21GLpZNzXfIFWMRg2IAmQSggZDNYRPVOVHeIFZL5vCJu8C0XFH/jPFtgtG8wcO4RUEs
	HjUjBA9pq3/uHsjP/HsdqJKQW9rsmd6ytc5Vhzd2FsfDF/7/+ym1GxMQn4pz921QMRojFm
	XhGAm3X5WuXN6FrCMedpKLgZsGemuLQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-330-b7-O0sfpPmKR29HWWOg4Tw-1; Wed,
 13 Mar 2024 13:54:10 -0400
X-MC-Unique: b7-O0sfpPmKR29HWWOg4Tw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA7093C0C10F;
	Wed, 13 Mar 2024 17:54:09 +0000 (UTC)
Received: from redhat.com (unknown [10.22.16.77])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FFF1492BD0;
	Wed, 13 Mar 2024 17:54:09 +0000 (UTC)
Date: Wed, 13 Mar 2024 12:54:07 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET V2 05/10] xfsprogs: fix log sector size detection
Message-ID: <ZfHoPzA_fUr2LJDZ@redhat.com>
References: <20240313014127.GJ1927156@frogsfrogsfrogs>
 <171029433208.2063634.9779947272100308270.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171029433208.2063634.9779947272100308270.stgit@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Tue, Mar 12, 2024 at 06:48:21PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> From Christoph Hellwig,
> 
> this series cleans up the libxfs toplogy code and then fixes detection
> of the log sector size in mkfs.xfs, so that it doesn't create smaller
> than possible log sectors by default on > 512 byte sector size devices.
> 
> Note that this doesn't cleanup the types of the topology members, as
> that creeps all the way into platform_findsize.  Which has a lot more
> cruft that should be dealth with and is worth it's own series.
> 
> Changes since v1:
>  - fix a spelling mistake
>  - add a few more cleanups
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
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=mkfs-fix-log-sector-size
> ---
> Commits in this patchset:
>  * libxfs: remove the unused fs_topology_t typedef
>  * libxfs: refactor the fs_topology structure
>  * libxfs: remove the S_ISREG check from blkid_get_topology
>  * libxfs: also query log device topology in get_topology
>  * mkfs: use a sensible log sector size default
> ---
>  libxfs/topology.c |  124 ++++++++++++++++++++++++++---------------------------
>  libxfs/topology.h |   19 +++++---
>  mkfs/xfs_mkfs.c   |   71 ++++++++++++++----------------
>  repair/sb.c       |    2 -
>  4 files changed, 107 insertions(+), 109 deletions(-)
> 
> 

