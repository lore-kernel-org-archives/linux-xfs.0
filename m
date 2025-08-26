Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DD018A6C4
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 13:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214901; cv=none; b=pbAEhnEeYIccxRNHQiQQHeOsHqc9NuhstMMiDBH4YXxsl3U6/cWbQ8QJoZsWLqzPVMGU4xyLYIRWxb+zmhyvORPLSBSsSU7znoX/CpJ2roLGcaatSHTvuaLG53j83zKsBGGJZnY5k27wVslfwHMvlGbv2iQVPEfJzTnkVS/vyKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214901; c=relaxed/simple;
	bh=2IfAVlgIOdVAgpm6bhb+A77KDlaUz1YB6hEUimBA5ac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XbJ8gepn+wVZlX5ARzdMfAHLIn9J1jo0M6uKRBu+EA7xVn4/oOPzdHCBGfURT6NI+6a6GSRO5+OhhO80mYMeFXZgBQGT2HE0eSdK36viExhT18Wr9jGSZxoHupv3l9z9R8/LaJbnOnn5BF9GzhHubrz1UWgSmiLzjXtAj7PK9oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0961A67373; Tue, 26 Aug 2025 15:28:16 +0200 (CEST)
Date: Tue, 26 Aug 2025 15:28:15 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: track the number of blocks in each buftarg
Message-ID: <20250826132815.GA1946@lst.de>
References: <20250825111944.460955-1-hch@lst.de> <20250825111944.460955-2-hch@lst.de> <20250825152649.GA812310@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825152649.GA812310@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 25, 2025 at 08:26:49AM -0700, Darrick J. Wong wrote:
> > +	mp->m_ddev_targp->bt_nr_blocks = mp->m_sb.sb_dblocks;
> > +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp)
> > +		mp->m_rtdev_targp->bt_nr_blocks = mp->m_sb.sb_dblocks;
> 
> Crazy question here: say we start with dblocks==1G on a 2GB disk.  Then
> we start growfs to double the size of the filesystem, but crash midway
> through.  Then in the process of restarting the system, some harried
> sysadmin accidentally shrinks the disk to 1GB before letting the
> filesystem mount.  Log recovery will try to replay the expansion, but
> now the disk is no longer large enough to contain the filesystem.
> 
> Should we be checking for that here and erroring out?

I don't think having tons of sanity checks here hurts, but I also
don't volunteer to implement it as there's a lot of bigger fish to
fry :)

