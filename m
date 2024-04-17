Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29ABBE4E
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 05:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713330053; cv=none; b=qx6W33rZ6ReX7RT3hm9Ev3HPt4qr3KvJdl5CwHmD0bOtcdvur9wGx3srUiqW15Gyt6NDYbuswnbCD44MgMI3aK43LmrXvoJpwhs+xVLE6JrlOjbx+ifaV9V0F4njf20tdadhuqpp72Rl79kC0QXd6EbJLkQIBq7DeJRBeW7dYtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713330053; c=relaxed/simple;
	bh=Xx5lj9/7C9IxFUkI5bwMAggnH/yuThzFswjetQSFy14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ocxGklyiPf2v+JzJE8jG09ciEf98XSescsb9v/R54/kGUhNOK68E6/5SAZ6LzM6R9EGltc0Gjw3aA0nCeiMHHU0a3+ZtIoS7GhnCnzoIqbcOKbLTDfHfPPaSrCQjit5C4j47CoW8SlA2+qTl/kKbH511O3lrJntMEojsCfK4Grk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=B0Mw+5fy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B0Mw+5fy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=B4y9iOzhu7ZknSLp3gFPSxi4clrzL/YcEQPlRRG/GpM=; b=B0Mw+5fyUOTLV1RG1qizoRWcie
	zMeH0ndsIw3So9xVxfy+TGyc3Y2hA8QPFOerL4b2/FG/4LSYyE9nZbUyKY5Cxc4eU3eiSGDoU0eqa
	7J40dzI2c2k1q3djRG2tWrAZVMmIs8ISOAGZPAbNt7alwg3rN2sKCtj+ySXJIe0XFA40TpK14c6MG
	KHVJHc8d4ZJ5YRjJtJdq/E613FuhYu8vMUIqh8fMEAvEqQ9psJ+CKE4nX4IqddqjT53bPUjQRrZ7D
	QvCXxPMHImdPRLJHZYKt23O0a1ZcxDJmZRm/Ew98KuzC2HAKwK9li50HV1t+e+1aianrX/umy2AQK
	5gtYw+0A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwxPd-0000000Ej5g-2kbR;
	Wed, 17 Apr 2024 05:00:49 +0000
Date: Tue, 16 Apr 2024 22:00:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 03/17] xfs: use xfs_attr_defer_parent for calling
 xfs_attr_set on pptrs
Message-ID: <Zh9XgZkF_hZJbQKC@infradead.org>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
 <171323029234.253068.15430807629732077593.stgit@frogsfrogsfrogs>
 <Zh4MtaGpyL0qf5Pa@infradead.org>
 <20240416160555.GI11948@frogsfrogsfrogs>
 <Zh6nGaPvk3tKf3gg@infradead.org>
 <20240416184110.GX11948@frogsfrogsfrogs>
 <Zh7IsJE1HJdzQSZJ@infradead.org>
 <20240417025407.GN11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240417025407.GN11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 07:54:07PM -0700, Darrick J. Wong wrote:
> On Tue, Apr 16, 2024 at 11:51:28AM -0700, Christoph Hellwig wrote:
> > This looks sensible to me.
> 
> Ok.  I merged the two functions in the patch where we introduce the new
> pptr log op codes, because that made more sense to me:
> 
> https://lore.kernel.org/linux-xfs/20240417025208.GM11948@frogsfrogsfrogs/

Yes, this looks sensible to me.

