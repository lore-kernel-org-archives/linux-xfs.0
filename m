Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B55EF56465
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 22:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gAu3fWMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A99BC433C8;
	Mon, 11 Dec 2023 22:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702335026;
	bh=eb1QZRNCZbalbWknwFs2UgfGcV133eZLDO881GVwpnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gAu3fWMd7vVJzogGlc6ATyZ5Ia+mEqbm+oP34YAdjpAajzFLV5iLNjzRqwJPyKLCq
	 9TFaZakYrUosPEL12GQOSV9la48pf7D7fPF5H7mVkcKQIWPhSafZ9WcCsPK+qNW+eZ
	 5Kz7gGGbCT2NyjM5Eu2QWY2IrsWnvJgU48vhmo3uklLswZpHxfP6DQOu5tSDViHBw+
	 nWumBpFCj6OGg9Rn/LO7fR2KcMw2CqAFZWDSSpx3m4LYM/emVg33Wl7d5bZ4XdgQ9b
	 drakPFIvEOb63uCA1/qIjmd20gDVC1JrJ8DAceHIdIyNIkiUMS51P548769ZrUfDVQ
	 Daof4L7tB6EaA==
Date: Mon, 11 Dec 2023 14:50:26 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: skip the rmapbt search on an empty attr fork
 unless we know it was zapped
Message-ID: <20231211225026.GZ361584@frogsfrogsfrogs>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666238.1182270.18118442139749127193.stgit@frogsfrogsfrogs>
 <ZXFhCHxQD/9GuQiI@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXFhCHxQD/9GuQiI@infradead.org>

On Wed, Dec 06, 2023 at 10:07:04PM -0800, Christoph Hellwig wrote:
> On Wed, Dec 06, 2023 at 06:43:47PM -0800, Darrick J. Wong wrote:
> > +			if ((VFS_I(sc->ip)->i_mode & 0777) != 0)
> > +				return false;
> > +			if (!uid_eq(VFS_I(sc->ip)->i_uid, GLOBAL_ROOT_UID))
> > +				return false;
> > +			if (!gid_eq(VFS_I(sc->ip)->i_gid, GLOBAL_ROOT_GID))
> > +				return false;
> 
> Having this in a well-documented helper would be nice to have,
> but otherwise this looks good:

Ok, I'll split the attr and data fork paths into separate helpers.
That'll make them more coherent and cut down on the indenting here.

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
