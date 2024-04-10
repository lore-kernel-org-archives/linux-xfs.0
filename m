Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2DF158D70;
	Wed, 10 Apr 2024 15:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712762288; cv=none; b=Mukn/Mr4Da2mmrzd0Z9ziHC+R3PLf+J3UR4p+Skrj8pqXIGmIhnupF6ELpaqt2zdUD9PEOXxWyKwLayBgJ7MKA+C0fu/FtLFPGgaH9SPXUa6KBLpPLV8Q46I8bZkmvLiqP6V/A8Xee4U0lA8XLCBi2+NCY8OlVP99eQsN0RYLZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712762288; c=relaxed/simple;
	bh=uj1VhrruMlOKV81veKEYnrUZyPrdA9f6wVYDOqGRwYs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iPje1FeTFZtWpqKzfmPVXzH4Vjb+ebBuzTiT9l9nRWTg6Art8/mXKxJSwpIsSQO4P2K+M6PG9BhtHixUKTO8Xb53zuprYitxn2E4jIdH25hLsH0IBZaUOcLcQl1JaC6I8JdvMlHYAlQQfxf4ewR6NreQV3piVE+kyruf55BLtAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3C82568C4E; Wed, 10 Apr 2024 17:18:01 +0200 (CEST)
Date: Wed, 10 Apr 2024 17:18:00 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@redhat.com>,
	Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: fix kernels without v5 support
Message-ID: <20240410151800.GA10081@lst.de>
References: <20240408133243.694134-1-hch@lst.de> <20240408145554.ezvbgolzjppua4in@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20240408145939.GA26949@lst.de> <20240408190043.oib4lmiri7ssw3ez@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20240410144254.iiqrxlm64xc6mqa6@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com> <20240410145140.GA8219@lst.de> <20240410151600.GV6390@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410151600.GV6390@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 10, 2024 at 08:16:00AM -0700, Darrick J. Wong wrote:
> I second that.  I'll deal with xfs/158, 160, and 526, but the other
> patches that were ok could go in.

Should I resend with the other review comments fixed but the
_require_xfs_nocrc left in those for now?
