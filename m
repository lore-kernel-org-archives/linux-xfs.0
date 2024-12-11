Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522F844384
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733953479; cv=none; b=arzFhZx0d5TnXSaZbNmFlkk/AJOUEhF+DRlzYrnmnOMzHZBmk5Xzeb7/SQCVf/5+h3Is0jbbG/5btZj5xtfIfSw+srL5awmxM8+TdM1Ct9Zbl6r8TzhT0inhtctWZ/EiqgWtjsvQCfHhPm7v1fkf6Xwec2+3O0Czp3JRInhqT7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733953479; c=relaxed/simple;
	bh=zsBrNI5EQlBDS2CvQlyw+kQaGN2GnRjiYUmJaDFQBv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a5csCTW9ou7VcX+WfpWIKfegAb5IdbwhjXZh11OmCaUxVUepFN8QAFzBgaHQbHLFUMoxOqn+Jve78gGv0Kxjxpy8KtwlTouth4h3ev6kCMHsbJt6cWs3nDNh1QgwCs/Tyaley4b4z9aWdbCOCmPYRGPwJIbFuyAb24Evxu59u/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Oh43R/Xq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Oh43R/Xq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DFAC4CED2;
	Wed, 11 Dec 2024 21:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733953478;
	bh=zsBrNI5EQlBDS2CvQlyw+kQaGN2GnRjiYUmJaDFQBv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Oh43R/XqweeAkpeb1JGjHbD5MSrRXgI2q0Qh/D6aidDsciQpyfctqn0+h2MuvKQun
	 TaaZQqhQjLgH1efpWKL8MZOgyoRLWXX0I3SqTuBO9R2U2fTApUySvhNJ6voN4G+Wur
	 l6RORs9eJlGMLxCcPNVjTgAwRJnka7pvbMjbZ1uN7OsNRXiCdE7RcXmjh9kirbwIy/
	 keIj71OKq2MJSSdUg+aLecALUHuHajlTKMT8VgKcSRfiSicDSgBFDIxMmQlFKihkPK
	 r7y9LFl/+Pflm+UQjIctbo/pTA1A4s//vf9qVdFvIMTdbBzwS2P3dmsMZIXD0xxDEz
	 Uebjm+4a3+1dA==
Date: Wed, 11 Dec 2024 13:44:38 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 32/50] xfs_db: metadump realtime devices
Message-ID: <20241211214438.GV6678@frogsfrogsfrogs>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752434.126362.4802798668828712862.stgit@frogsfrogsfrogs>
 <Z1fV1nKis3nsTsoB@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fV1nKis3nsTsoB@infradead.org>

On Mon, Dec 09, 2024 at 09:47:02PM -0800, Christoph Hellwig wrote:
> > +	/* The realtime device only contains metadata if rtgroups is enabled. */
> > +	if (mp->m_rtdev_targp->bt_bdev && xfs_has_rtgroups(mp))
> 
> As you pointed out when looking at my follow on series, this should be
> xfs_has_rtsb instead of xfs_has_rtgroups (for cosmetic reasons).
> 
> > +		metadump.realtime_data = true;
> > +
> > +	if (metadump.realtime_data && !version_opt_set)
> > +		metadump.version = 2;
> > +
> > +	if (metadump.version == 2 && xfs_has_realtime(mp) &&
> > +	    xfs_has_rtgroups(mp) &&
> > +	    !metadump.realtime_data) {
> > +		print_warning("realtime device not loaded, use -R");
> > +		return 1;
> > +	}
> 
> Also this whole flow looks a bit weird.  This is what I ended up with
> removing my later changes:
> 
> 	/*
> 	 * The realtime device only contains metadata if the RT superblock is
> 	 * enabled.
> 	 */
> 	if (xfs_has_realtime(mp) && xfs_has_rtsb(mp)) {
> 		if (mp->m_rtdev_targp->bt_bdev) {
> 			metadump.realtime_data = true;
> 			if (!version_opt_set)
> 				metadump.version = 2;
> 		} else if (metadump.version == 2 && !metadump.realtime_data) {
> 			print_warning("realtime device not loaded, use -R")
> 			return 1;
> 		}
> 	}

Oh, yeah, that is a lot more straightforward.  Thank you for correcting
that.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

<nod>

--D
