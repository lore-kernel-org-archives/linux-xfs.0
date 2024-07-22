Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EBA3A8D0
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jul 2024 12:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721651699; cv=none; b=fVj4MeUKb/H2gAaUOO0+G/ivKiPo664gavh4E9Ihe5hZpu/AnknKL2UQ3gYn/fniq6Eh6se9V4thQuwCaqkU/m2H3Xowog4f2Nxjsy0AGp5yhEF+gWZMBILSjiW/bdRoCCzEfhAEYdcA1Zos0ghdOWq5jl9C2sZZuGPOtQ52xS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721651699; c=relaxed/simple;
	bh=VJE2R9iaDlbP4ILnYHD9VorOUfrXB74nMc5VdCIyvQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQcRk4T2mxzfZYYCu/load+SnUnkLJDeVyGDPEuVKDhsFq1fk4ADviWZtVnmyoLl+ogfY8N70r+g+12G4i1oXR48bY9L7IhrV+YCE5CDeWwFrNzNzBnbhnOPsIFm9gN9L0AzjaxvOLeecHS51mlzZeWN7BZr/L8XkjA4B3whOzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3890668C7B; Mon, 22 Jul 2024 14:34:49 +0200 (CEST)
Date: Mon, 22 Jul 2024 14:34:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] debian: enable xfs_scrub_all systemd timer
 services by default
Message-ID: <20240722123449.GB12518@lst.de>
References: <20240703025929.GV612460@frogsfrogsfrogs> <20240703043123.GD24160@lst.de> <20240703050154.GB612460@frogsfrogsfrogs> <20240709225306.GE612460@frogsfrogsfrogs> <20240710061838.GA25875@lst.de> <20240716164629.GB612460@frogsfrogsfrogs> <20240717045904.GA8579@lst.de> <20240717161546.GH612460@frogsfrogsfrogs> <20240717164544.GA21436@lst.de> <20240722041229.GM612460@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240722041229.GM612460@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jul 21, 2024 at 09:12:29PM -0700, Darrick J. Wong wrote:
> You could also do:
> 
> for x in <ephemeral mountpoints>; do
> 	systemctl mask xfs_scrub@$(systemd-escape --path $x)
> done

That assumes I actually know about them.

> (Though iirc xfs_scrub_all currently treats masked services as
> failures; maybe it shouldn't.)

Independent of the rest of the discussion it probably shouldn't.
