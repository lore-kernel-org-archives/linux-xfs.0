Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B1E2F30
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 06:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734243410; cv=none; b=lnwi6exOrSHKmAvts0lbEs8FNNDAW9AtSCO24FEcHqxu3+zLRHAegnQQuMMw2hVoTZhLj1UARVJm6TC+WUarA5ZAUG8Pi4ImyPWED0c4m3S32Dsv74wuz+WUjSkTFiMhgRGM5sYflPXoGwP+OdyoAF3t5l02XI/2swFYAjR225A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734243410; c=relaxed/simple;
	bh=6QFebge/wgSyXY2chYefgyYSo0Vnk+sFdWs528BFfVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IHA1IWtNv9luCyzroPFiILIyQQGvi2/4D6rpc1dlLwrejJA/r5UAIN91hgmltKl3ECff2V3XAkLb50MoqhkUrFCikBXazhiDcEfNNMB8yO85M4MyEM2+dUerPexdg8dI9+5YAc7RdNCjw3nJM9HNTrC9v10Y68drqx5Z54nlYn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4144F68C7B; Sun, 15 Dec 2024 07:16:45 +0100 (CET)
Date: Sun, 15 Dec 2024 07:16:44 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 40/43] xfs: add a max_open_zones mount option
Message-ID: <20241215061644.GD10855@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-41-hch@lst.de> <20241213225711.GA6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213225711.GA6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 02:57:11PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 11, 2024 at 09:55:05AM +0100, Christoph Hellwig wrote:
> > Allow limiting the number of open zones used below that exported by the
> > device.  This is required to tune the number of write streams when zoned
> > RT devices are used on conventional devices, and can be useful on zoned
> > devices that support a very large number of open zones.
> 
> Can this be changed during a remount operation?  Do we have to
> revalidate the value?

Right no it can't be changed during remount as there is no code added for
it in xfs_fs_reconfigure.  If a strong use case to change it shows up
we could support it, but it's going to require some nasty code especially
for reducing the limit, so I'd rather not do it unless I have to.

