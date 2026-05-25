Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50543A963A;
	Mon, 25 May 2026 07:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779692982; cv=none; b=MZwkliTKR+8uGfXMhJ+cfpjLCuPfiN1XfR8l1Ps6jb9fyfJQ4jX1SsVsVgRmNT7sN+VT3lzpBcHvIf1723fEpWRT7jVVxng+V1BnN7DNt+JyUW2SfTVC2uSCjx/6vDTRUk6Usnv1A+y0zJSPAt6hs+v/meclutYJX9JYIfdsYws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779692982; c=relaxed/simple;
	bh=IiDlTcyO2SJCYRMFYXQ7ytnIRPuE9RU5ODmFZ8AgMmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vut/PQtBYD+H7I5kjaftCKZ6xg5KaggY0vfullz9HcjypV0+wg9A18+YQUIAiKYUrBbdOP2v8aKTL1nnqlzMwGbyizrIu2ndkshWvrMtcr293nC/tgSlZjArp3jiy3i9J8c2FhTBk08BHn2BfOfoWP6mWUkxJt2jJywajnT7eJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CUzhw2KT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CUzhw2KT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=syRvi07sgur66zfha9AI/lR4MWGyK8TIBCUS+OGxqFY=; b=CUzhw2KTZ4UKg6JJLG5dangK8J
	Q3ktpouecNWzjHpJe94UQahLJxM/3Db1lfDqSytbmItYe+lMJsCCdK0MQxbSXRNhcOxAGratAzAIB
	0qy12kFFfdjr2WpaRsh08W9CXxnyKVavYJHWHVpI2mYCyKRgmORPzfWYmEGRShdtlXkMS9LqNOxvk
	3U/sNUoBt/IAFKCio2uziR0yfOwLq1mmdX5+hMTVdCavWFBfrWiC4EhTj8Y9pVXe9s5G/5TQ9sQkS
	BIAcVuNYZPt3EdpB13WSA8Nru44ke/NsPMxoFNb/jYVkXvSdL6AlR2Q/Mz0A6k+MBLu28PtNNZ9DS
	EqbS9Y9g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRPRU-0000000GV0l-0me5;
	Mon, 25 May 2026 07:09:40 +0000
Date: Mon, 25 May 2026 00:09:40 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, amir73il@gmail.com,
	zlang@redhat.com, hch@infradead.org
Subject: Re: [PATCH v5 03/10] fstests: add test for inotify isolation on
 cloned devices
Message-ID: <ahP1tCc81ascjwxJ@infradead.org>
References: <cover.1779367627.git.asj@kernel.org>
 <1c60be06ce79778404079c8b1c1d2e09f64cb38e.1779367627.git.asj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c60be06ce79778404079c8b1c1d2e09f64cb38e.1779367627.git.asj@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> diff --git a/common/config b/common/config
> index 4fd4c2c8af11..605a57947a40 100644
> --- a/common/config
> +++ b/common/config
> @@ -242,6 +242,7 @@ export BTRFS_MAP_LOGICAL_PROG=$(type -P btrfs-map-logical)
>  export PARTED_PROG="$(type -P parted)"
>  export XFS_PROPERTY_PROG="$(type -P xfs_property)"
>  export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
> +export INOTIFYWAIT_PROG="$(type -P inotifywait)"

Usually we try to split infrastructure changes like this out into
separate patches.

Also any reason to rely on the obsolete inotify instead of fsnotify?

