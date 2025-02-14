Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627271802AB
	for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 06:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739515312; cv=none; b=AlXH5KUijjQDlCArulyL9NPzsg0TYJZxSVacVS55uyulDeiwgBuKuijJqsxTkgE/O140BEuTiu3XFvyGy+KLfSiyZOqNsl2U+LgI7wJYUd+SdI/uKlPWf0EAk2BlS0pasimC2AKIvBc/+Hp7XWKh8ZlzH6weWHcjVqmhE/rOfNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739515312; c=relaxed/simple;
	bh=ZYXgMm3sIUvjIxRm0ixFLGtO4XRtPn8j23IeIixp8lc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zg1zN2flgdcLhTvjsC8fO8o7kTC+kE468sOd7ZgY/lFcDcmGHYcAGSal8y/qdu61JMEh7QKJpjjsxL8mQEVJbeZcTByAh9eAm3k5DbjaiuKdWGeB3UqqAlakPP7LkWhsF3QrlEIsWGdUTxEQrvXa/7cqbWjcDMLR7YxzVgCcZNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B73F268D07; Fri, 14 Feb 2025 07:41:45 +0100 (CET)
Date: Fri, 14 Feb 2025 07:41:45 +0100
From: hch <hch@lst.de>
To: Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, hch <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 39/43] xfs: support write life time based data placement
Message-ID: <20250214064145.GA26187@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-40-hch@lst.de> <20250212002726.GG21808@frogsfrogsfrogs> <c909769d-866d-46fe-98fd-951df055772f@wdc.com> <20250213044247.GH3028674@frogsfrogsfrogs> <25ded64f-281d-4bc6-9984-1b5c14c2a052@wdc.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25ded64f-281d-4bc6-9984-1b5c14c2a052@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 13, 2025 at 01:03:31PM +0000, Hans Holmberg wrote:
> That sounds like good idea. Christoph: could you fold in the above lines
> into the commit message for the next iteration of the series?

It needed a bit of editing to fit into the commit messages.  This is what
I have now, let me know if this is ok:

fs: support write life time based data placement

Add a file write life time data placement allocation scheme that aims to
minimize fragmentation and thereby to do two things:

 a) separate file data to different zones when possible.
 b) colocate file data of similar life times when feasible.

To get best results, average file sizes should align with the zone
capacity that is reported through the XFS_IOC_FSGEOMETRY ioctl.

This improvement in data placement efficiency reduces the number of 
blocks requiring relocation by GC, and thus decreases overall write 
amplification.  The impact on performance varies depending on how full 
the file system is.

For RocksDB using leveled compaction, the lifetime hints can improve
throughput for overwrite workloads at 80% file system utilization by
~10%, but for lower file system utilization there won't be as much
benefit in application performance as there is less need for garbage
collection to start with.

Lifetime hints can be disabled using the nolifetime mount option.

