Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3F22E633;
	Fri, 26 Jul 2024 18:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722017505; cv=none; b=EJOxh0LQ784RjgHgtavtEij+4l8dhsjKDE8gppD1I1aFRwWbsp+lFWaGEvCrIqAKCHeTsvw9Q3aQ0F1c6AF6tfCh/UXQoZzeNlk7rB8Asqexd+9rALmPHP6S1Jea8oMWlvwImLCMpHDkq+NIjNPDkJ/gs/3iFb/rIDs6nX/koeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722017505; c=relaxed/simple;
	bh=BnKLLumQ4AtdAjcWQRkT9U/bLBG/9rt2h3UPlcWcbsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tw1jR5QoB/Lv5RAPaGqPxi/9d/o2noJTvwAM1TRxE+Ll4wRqeciKeDYZxKOJ+nmbo+iJNu3NH+SwcSh2s89VkVdANakU1kZOM1pHr8CZUPMF+XOPG7EOiFWRczGWF7lpfBmVA2qqvikBnvx3J21jULZeEHWpfWhD68onXkDx1j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AF3B268AFE; Fri, 26 Jul 2024 20:11:39 +0200 (CEST)
Date: Fri, 26 Jul 2024 20:11:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zorro Lang <zlang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] common: _notrun if _scratch_mkfs_xfs failed
Message-ID: <20240726181139.GA28749@lst.de>
References: <20240723000042.240981-1-hch@lst.de> <20240723000042.240981-3-hch@lst.de> <20240726171434.kwgmlksglw4yolyb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240726171434.kwgmlksglw4yolyb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Jul 27, 2024 at 01:14:34AM +0800, Zorro Lang wrote:
> So most of cases (on xfs) will be not changed, only those cases call
> _scratch_mkfs_xfs directly will be _notrun (if it fails to mkfs before).

Yes.

> I'm still thinking about if this behavior is needed. Last time we
> just let _scratch_mkfs_sized calls _fail if it fails to mkfs. And
> we hope to get a fail report generally, if a mkfs fails. But
> now we hope to _notrun? With this patchset, some mkfs failures will
> cause _fail, but some will cause _notrun. There'll be two kind of
> behaviors.

Only the ones that have explicit fail code.

But yes, that change is the point of this series - incompatible
options will cause mkfs to fail, and the reason for that is that
the test case can't work for that configuration.  We could try
to explicitly catch those cases, but it would be pretty messy.
(We actually do that for a bunch of tests, and it doesn't look
very nice)

