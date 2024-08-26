Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBE1B677
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 18:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724696131; cv=none; b=MWZu1kFS1mx4Eh6sOk8EAJD3OC5E35jdTxu0yaMnVxp+9jPTeo+/LRbOcA0JLYMWRjDuqHSwS8Y2U+WmZ+2rYAixgOd/mEmHyY34AzMgRE2ce/SV/gvtT07ZgGaXwfNf652n6Yn4OF8XZ8/qkdBRffiDkNMZPVfRqSe85cgA1mM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724696131; c=relaxed/simple;
	bh=6jjFZdyWKi51hKNRS180wdm+f4tC0IC7/Aid9SKS30Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ts9B1CaUdtdT2ipIEjRKN/avzHHK/nSA8nSPi5nO7mCoVnCUsq3AXLuI8f6P87To/64Vn9qJkUCRQiUBNSKT/T1l6OQHC0VvobibbCpcf6vxKjIHTtjbFSrbhw3loyIUBdosVJ9+pSkWKbJSdit2dBDPi/ZhEEQ3IX/nHsTqKWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DWebyzAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DWebyzAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2DBC8B7A5;
	Mon, 26 Aug 2024 18:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724696131;
	bh=6jjFZdyWKi51hKNRS180wdm+f4tC0IC7/Aid9SKS30Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DWebyzAaSddNi+5vTATY87Z2/Qu3r4ueR42D9BL8icubeTbNhVi29lSgtp2aY+ieh
	 3JZC7zuEA2PbgOKG2c/sCBTcl4ki5aD0NpiF8O0vKz+DpqJrSvabBxyn7Lt3yyzfCO
	 ZHJO7bMKRJ1kGnIvKeS+YTYZwFBK/wy5L26qyNw91nagMHX5TQAnDgeRn6gEL61r9R
	 12nZY0fKGXOR5DtrzJHcmqZIk4PaYZHT9QbxXDFdm2qkViTmTF2qRE5yYkPR3shpDX
	 O+umjx4uZNqLyN4Jsf1rMFeyEGitEjOpTsMzSlMatu39rAxljyd74yWP/MBtcREA+W
	 0GTN3ZtSiwpAg==
Date: Mon, 26 Aug 2024 11:15:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: persist quota flags with metadir
Message-ID: <20240826181530.GZ865349@frogsfrogsfrogs>
References: <172437089342.61495.12289421749855228771.stgit@frogsfrogsfrogs>
 <172437089432.61495.8117184114353548540.stgit@frogsfrogsfrogs>
 <ZsxOGGFb1oa7IEXB@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsxOGGFb1oa7IEXB@dread.disaster.area>

On Mon, Aug 26, 2024 at 07:42:48PM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2024 at 05:28:59PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > It's annoying that one has to keep reminding XFS about what quota
> > options it should mount with, since the quota flags recording the
> > previous state are sitting right there in the primary superblock.  Even
> > more strangely, there exists a noquota option to disable quotas
> > completely, so it's odder still that providing no options is the same as
> > noquota.
> > 
> > Starting with metadir, let's change the behavior so that if the user
> > does not specify any quota-related mount options at all, the ondisk
> > quota flags will be used to bring up quota.  In other words, the
> > filesystem will mount in the same state and with the same functionality
> > as it had during the last mount.
> 
> This means the only way to switch quota off completely with this
> functionality is to explicitly unmount the filesystem and then mount
> it again with the "-o noquota" option instead of mounting it again
> without any quota options.
> 
> If so, this will need clear documentation in various man pages
> because users will not expect this change of quota admin behaviour
> caused by enabling some other unrelated functionality (like
> rtgroups).....

Yeah, manpage updates are in progress.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
