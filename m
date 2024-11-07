Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C392119B5B1
	for <linux-xfs@vger.kernel.org>; Thu,  7 Nov 2024 23:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731021692; cv=none; b=Gsye7t6oP4kRhP3biRHIMMTvQPlAX5wOrFGt+JAlGb6Nc99s3dxWYeNhDUUA47wpndYw0iN1xR3V4/DbVTiXxx04m1AtnNfTv5O7+SfnBuIEbKl/iVkqlO4S8DhBLPzc9K3fIaRpUqLOwTMTg/oZ/arRs1MHXmuCgGgY+mTSB6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731021692; c=relaxed/simple;
	bh=JLyiGzAuIMs41ofcyUPdiKRwk4T5jhDaXKQoGK8DQOc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ELL/ucKuTT53zjqvC+Rof8OugWa8pY31Z9IRvEtWOQyi32xiM1/L/qRbxxvyO+7blXi7f8cQhenLdE1VG2C/RM/H2LmMsRlsRsAtyohXhGIzBW2lbU6owyI7vl+QJwSahT7nOWcbdDccHseq0nBC1/Tt4hEzg5B1tJrKsD5ts48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P1BO5zG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P1BO5zG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F650C4CECC;
	Thu,  7 Nov 2024 23:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731021692;
	bh=JLyiGzAuIMs41ofcyUPdiKRwk4T5jhDaXKQoGK8DQOc=;
	h=Date:From:To:Cc:Subject:From;
	b=P1BO5zG0hOKCAkhoeC+RECaH/XqDfrLa7Ln+anwhXZxbKjW1anDTRVqRc4H+6XtjV
	 IEATejIHF7HIgIbvfK15kyUX1zM4Gq8kgOeN1p5CYh5hGyi9TMTiT1nARcL2Em6oFb
	 2pji+xaZBkQ99ZHaFrOiMAYY0gHs4XVsaj5653sjeYBLkCJhnQasj8X4q4M4zM4v6g
	 YOWIZBijCoJyKYdJjJuyF5zdhLUREfvsSQmXzHGzT5+WuzD0CXTf4gl2zxhKVz9C7I
	 +lZaJwB82zi5TiXWtFb5gRgRUjXStBSsjUMp8IjKgsVw02OVaEOtjrvft6qzRUn30j
	 WIGFR8oRw/yHA==
Date: Thu, 7 Nov 2024 15:21:31 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCHBOMB 6.13 v5.6] xfs-docs: metadata directories and realtime
 groups
Message-ID: <20241107232131.GS2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

Here's a minor revision to yesterday's metadir/rtgroups ondisk format
documentation updates to move the superblock docs to a separate file,
and to remove a few feature flag bits that were removed before the final
release.  The last bits of online fsck haven't changed, so I've left
them out for brevity.

Nobody likes asciidoc, so if you want an easy to read version of the
ondisk documentation, try either:
http://djwong.org/docs/xfs_filesystem_structure.pdf
http://djwong.org/docs/xfs_filesystem_structure.html

Please have a look at the git tree links for code changes:
https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-groups_2024-11-07

--D
