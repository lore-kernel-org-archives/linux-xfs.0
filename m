Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3E31EEF9;
	Tue, 29 Apr 2025 12:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745929273; cv=none; b=V7LwX66+//xjAzk92JvFHRJgccpacVsfBM7FWYwrqpR69wN7aBTrjZ/Y5IgvrKU9UjXpGBl5m24nAqdTdpIh5Ywz6dvJ9ZkkJR64net341RLOTjtG8kdd9WQmJ4Sc6TletZvJg9EmUjMI0etaxbj5/PxmvSWP85jsKxLn57Rhok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745929273; c=relaxed/simple;
	bh=DC0aTXhhoWmpIEPa7Hz685vjS+D+REZ0uS+r300WJns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TFs2evcm2/ao/4tSeR1K8EgpkzeW82qEQSHOgKgNUOhlNdj7TLa3L6+Kq+qjseL8wWBPGgtTPTBxEqwI2kfbvl89ME2ZrT6e4JH7F4o/O/6YIzBDED5kNBPx3NyJ8r4SgFLZXKdWesjlIlqzTZIFM2dpAn38xGpq69SQb4Nbbpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EE84668AA6; Tue, 29 Apr 2025 14:21:05 +0200 (CEST)
Date: Tue, 29 Apr 2025 14:21:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: brauner@kernel.org, djwong@kernel.org, hch@lst.de,
	viro@zeniv.linux.org.uk, jack@suse.cz, cem@kernel.org,
	linux-fsdevel@vger.kernel.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	ojaswin@linux.ibm.com, ritesh.list@gmail.com,
	martin.petersen@oracle.com, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, catherine.hoang@oracle.com,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v9 05/15] xfs: ignore HW which cannot atomic write a
 single block
Message-ID: <20250429122105.GA12603@lst.de>
References: <20250425164504.3263637-1-john.g.garry@oracle.com> <20250425164504.3263637-6-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250425164504.3263637-6-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Apr 25, 2025 at 04:44:54PM +0000, John Garry wrote:
> +	/* Configure hardware atomic write geometry */
> +	xfs_buftarg_config_atomic_writes(mp->m_ddev_targp);
> +	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
> +		xfs_buftarg_config_atomic_writes(mp->m_logdev_targp);
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp)
> +		xfs_buftarg_config_atomic_writes(mp->m_rtdev_targp);

So this can't be merged into xfs_setsize_buftarg as suggeted last round
instead of needing yet another per-device call into the buftarg code?
