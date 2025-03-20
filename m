Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3087919F49E
	for <linux-xfs@vger.kernel.org>; Thu, 20 Mar 2025 06:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742453924; cv=none; b=IfCp6e+JsYPj7Pgxd7HTYMByHdWCdHRkBzYWP0UeLiGT8UiIWtpMSjW8qh7sUH7Ar5BAXsK30xu15vSXwccYBHLtijr1buE4BBjCOgOYsqbpGtB1Tg4ntOZ4EdVxn082fQfFBv33sgalDHk6Vvznd1r6uMtEKNLUXOobk44XMGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742453924; c=relaxed/simple;
	bh=SvjeAXgxIqmzLMUdoauhye3njKiczapGTzbU05BNaac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t6uqnpD3N5lTQdQrbkTrwFaNjfRNMD+a/XOg0ac3Egh32uk1abLhktaY36SwUbBDMcy+AMlTPDcUUB1/FnjcBiANlVG4Bv9VZpUTLbWPPX5xEtt9ruILkPuqGMBbs6e8kI7FU9LqagXbLAYBbaohU624ySQ5Y78JXJWMI04uLXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 346E568AA6; Thu, 20 Mar 2025 07:58:37 +0100 (CET)
Date: Thu, 20 Mar 2025 07:58:36 +0100
From: hch <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Hans Holmberg <Hans.Holmberg@wdc.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, hch <hch@lst.de>
Subject: Re: [RFC PATCH] xfs: add mount option for zone gc pressure
Message-ID: <20250320065836.GA14071@lst.de>
References: <20250319081818.6406-1-hans.holmberg@wdc.com> <Z9qKUt1iPsQTTKu-@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9qKUt1iPsQTTKu-@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Mar 19, 2025 at 08:11:46PM +1100, Dave Chinner wrote:
> It seems to me that this is runtime workload dependent, and so maybe
> a tunable variable in /sys/fs/xfs/<dev>/.... might suit better?
> 
> That way it can be controlled by a userspace agent as the filesystem
> fills and empties rather than being fixed at mount time and never
> really being optimal for a changing workload...

Yes.  In theory a remount could also change the paramter, but that
is very heavy handed.

