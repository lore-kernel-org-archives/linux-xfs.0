Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E355A0F0;
	Sun,  3 Mar 2024 14:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709475339; cv=none; b=iIlp8XlucXv5Oo4hBsYX8aAIXAmpWwT9NvtRYR5zqTkRKBfl5Tk4Z3d6cjHhr7BDRbGYg0gSZA97dwlWMYHltO0vC3UaZ40fQaJ+Y18y/a/FeoQ1WHRRphi+RFF2Im4sVGUITTbqPqSIwRE//DSC/y+p+YnLOqJaH/NxFsdJjho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709475339; c=relaxed/simple;
	bh=S23aKX8/X+o9Vbt2qzY/JoHWJLWrY16CdMHbqcdxSqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AeS9pbggIOL1927kvf7r5HPW4sHRLuXHZzEDQvp7BdC9DPM5H8TJShFNy1vu4M6IBbGIOGJ79ViBeYvpdnjnhcmbhei9LpwSNqb3omF/64hujBvvHLKCWuZto10jaEXKAvn4vkBCDxQTAgRgdUW6gbyJBICVP7XDMNBulDf3yts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C60D768B05; Sun,  3 Mar 2024 15:15:26 +0100 (CET)
Date: Sun, 3 Mar 2024 15:15:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] shared/298: run xfs_db against the loop device instead
 of the image file
Message-ID: <20240303141526.GA26420@lst.de>
References: <20240301152820.1149483-1-hch@lst.de> <20240303131048.kx4a4b2463deud7t@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240303131048.kx4a4b2463deud7t@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Mar 03, 2024 at 09:10:48PM +0800, Zorro Lang wrote:
> >  	# Convert free space (agno, block, length) to (start sector, end sector)
> >  	_umount $loop_mnt
>         ^^^^^^^
> Above line causes a conflict, due to it doesn't match the current shared/298 code. It's
> "$UMOUNT_PROG $loop_mnt" in current fstests. So you might have another patch to do this
> change.

That line actually is from a patch in Darrick's patch queue that I'm
working ontop of right now for some feture development.  Sorry for not
remembering to rebase against current for-next first.

