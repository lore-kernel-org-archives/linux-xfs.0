Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F75433C1
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 03:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722309031; cv=none; b=tCLixWJ6OKeUeKqvNEUvBWYydyjVzLLP3OlZsOaWiJozneLO/GTf9JaI9pUDFH2DN7Zb3Q9Z6zeFmoMmM9zQDFYAm/X0shyZbLhP5zUsaCZi7JQkkSuWFdXfgbNSAby8A0koFKTzn18plvKs8TYknbusdxKB3mfpq2nJgnaucPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722309031; c=relaxed/simple;
	bh=3OIMgfcZz7+/NtStYM7wRh+4rgmxfOOvKm7H1L4FoiI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=aeoFq3SeIFMKMvTOlF63bq15gxAo0BkAfYik/ZC8K7dMpGtc5eCJunrFCBJEU/ZOxbSSsOQqwnj6QD2NhihsK1aMWoI2gRCMgMDX/ZWfHdLKSdz7PqPbvrteGnWCyxTOQdhPuFjmOPI1R0dx53UCslOlzajvf+G32JOiDF/ODAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JAH+Pzex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JAH+Pzex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521B7C32786;
	Tue, 30 Jul 2024 03:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722309031;
	bh=3OIMgfcZz7+/NtStYM7wRh+4rgmxfOOvKm7H1L4FoiI=;
	h=Date:From:To:Cc:Subject:From;
	b=JAH+PzexCG03xmOjcj/3zPKRtm4Mh2kwqBMWbAQLu4Ye6QEHSCt2Ja7D+XjFH3PIC
	 xkyBHSAEbke4kMk5i9PKvGY3nTOx59wgFMN4Ze9ZguZzyTjYOZz55m8e+elH71S/iG
	 8jKGA3fVO1opwuxFnT/uXgbP6kToBJzStsF7dGMN9QGUDOBqBl72EERdxqDRE7KqJ2
	 ZM8jXIcUPH5I2dfChT2m+w6nx8cmsQEF6GKZjpBZmQgpg4YOvtntQAusQIoUZuWSS5
	 o/QJ5me7cSHSE33cg8gofd+ErJCxqYuC/zftbIGc+p8ynYPvCe//+lx/ZWTQAu+mlb
	 lF/MxdFftgGzA==
Date: Mon, 29 Jul 2024 20:10:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: [RFC PATCHSET] xfsprogs: filesystem properties
Message-ID: <20240730031030.GA6333@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi all,

After last week's discussion about how to allow sysadmins to opt in or
out of autonomous self healing XFS[1], I now have an RFC patchset that
implements the filesystem properties that we talked about.

As a refresher, the design I settled on is to add ATTR_ROOT (aka
"trusted") xattrs to the root directory.  ATTR_ROOT xattrs can only be
accessed by processes with CAP_SYS_ADMIN, so unprivileged userspace
can't mess with the sysadmin's configured preferences.

I decided that all fs properties should have "xfs:" in the name to make
them look distinct, and defined "trusted.xfs:self_healing" as the
property that controls the amount of autonomous self healing.  There's a
new wrapper program "xfs_property" that one can use to administer the
properties.  xfs_scrub{,bed} uses the property; and mkfs.xfs can set it
for you at format time.

# mkfs.xfs -m self_healing /dev/sda

# xfs_property /dev/sda get self_healing
repair

# mount /dev/sda /mnt

# xfs_property /mnt set self_healing=check

# xfs_scrub -o fsprops_advise /mnt
Info: /mnt: Checking per self_healing directive.

--D

[1] https://lore.kernel.org/linux-xfs/20240724213852.GA612460@frogsfrogsfrogs/
