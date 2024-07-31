Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54D43C099
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jul 2024 17:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722448607; cv=none; b=hBdEQdLAblhh/MwpPmfc4kVgv16Ay60Ta044Ph19VZRpKF2ZgahV2WncDdbN5urR+jZV5icxMNz1QV8mVBeIR79CDKhH0UFF/y8aJnxa4CRZmyYhsFGYHY1XESUedLV2ch6hYykl96+K7YpWFmwLeE3MmWG8uvgy+A2QPTOw0BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722448607; c=relaxed/simple;
	bh=1KggIxwFn7cLbgnmFS8qRgokJhSf6Rhq4zdk+E/d6PU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IveTiegtiLm180IXXANc+KOEYA7//jPGYZ8JgQoA785CYR94xc9gKYY2pPhIsjqLSLEytcUZGbgdWZkpsZ5Dl1k0iLBo0wHiDLgPia5NcBSL8DsrGPTMrnvuYzo9h4N76mi7DNe6S9MU7coOPgCCBSi5ss7I16ffNd0o/dihM7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PlgsmuPh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PlgsmuPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A049C116B1;
	Wed, 31 Jul 2024 17:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722448607;
	bh=1KggIxwFn7cLbgnmFS8qRgokJhSf6Rhq4zdk+E/d6PU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PlgsmuPhXkkXMromMAkKp6nb4NFHs1CdCuLLzAOFeJeJM+S6Mw+1SE1FPvB42Bd1a
	 WkWrKdbn2IVRXlF/ylPQpYf43NUZweq7wLJ5TxZR1WVYQ9WIn0iV0zgYWzubrZI+TI
	 zFC5L6YL1tyUTBL7CEsLuI8SYzN5sfOKpzcNxTunsfIJ7Y9RW6Vbdq6+eze1p8dnhf
	 /EjYkbp53p2vVEBuoEf758jF0nSXfqR4gZ9V3o9Lj8/3WOwZrFkVahXL8DCAfh3BZ2
	 MfTapyY2iiPL3/2n8p/YOt43J/1ET15454asWf01lAjEbdjk8Z66Pa/Y+e6Le3uHXa
	 nICZV9nQspLTg==
Date: Wed, 31 Jul 2024 10:56:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs_property: add a new tool to administer fs
 properties
Message-ID: <20240731175646.GS6352@frogsfrogsfrogs>
References: <172230940561.1543753.1129774775335002180.stgit@frogsfrogsfrogs>
 <172230940678.1543753.11215656166264361855.stgit@frogsfrogsfrogs>
 <ZqlegsIRSwlccyX8@infradead.org>
 <20240730222815.GK6352@frogsfrogsfrogs>
 <ZqpbcQyqlXI7fVme@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqpbcQyqlXI7fVme@infradead.org>

On Wed, Jul 31, 2024 at 08:42:41AM -0700, Christoph Hellwig wrote:
> On Tue, Jul 30, 2024 at 03:28:15PM -0700, Darrick J. Wong wrote:
> > I think you're asking if I could make xfs_spaceman expose the
> > {list,get,set}fsprops commands and db expose the -Z flag to
> > attr_{get,set,list} when someone starts them up with -p xfs_property ?
> 
> I was mostly concerned about spaceman.  I don't think it actually is so
> bad, just a bit confusing.  But if we do xfs_io and xfs_db that's not
> really an issue anyway.

Fair 'enough.  I'll see about switching spaceman -> io today.

--D
