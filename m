Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39F420B38;
	Thu,  7 Mar 2024 23:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709853890; cv=none; b=puLJGyATfgKd2PJdzkDiGJJpAM+kZZLZCwskHzH0InEUfnI3aHcTi44AAFTzogWU+tNca8X8kOWLsetJoMOzNNudK/wQQhZR9CjToS/lsZUw5P4Yx+7ETul3dgubZuQFrIYliqjpJxuWxolEqNvTDAPgzn1mZLRFWHPSKdYOeWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709853890; c=relaxed/simple;
	bh=hyCQH1SrWUWG7cJmQVuoDz0pk9ny2gCu80iptk89Qb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ToXRSc9y48fkSk6kAnqoEyRvR/LX4RJq1C8YImdYxtxD0wBnLUFLpFXNlybR4ShVpA8As/x9nRID9gAfwpmw5EtN03cFWqGYZaQKdFWMRjfBL+rVSew7qbccqWezFxms/IZ2KvqPnoke5LnyjFeIWvo1qU9qNKij8V4pecBPTjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BaBcSf8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BaBcSf8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E46CC433C7;
	Thu,  7 Mar 2024 23:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709853889;
	bh=hyCQH1SrWUWG7cJmQVuoDz0pk9ny2gCu80iptk89Qb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BaBcSf8l15/k1JL/HwzzUj0bbieihhfCQ8X02CcdjggRmGVfMZgWvkSs8g5l7pJLM
	 WTRJpr8eucNm5bdq37K2u/XX4S8ZaGYi3ic8Od/U+CRIgdAAHVieEux2aXv4Xe6xcx
	 5SdAZ4LcYtDEk7KhJzhV67ldcyFnF95QsV2yV6hk3LmiWV6q5AbTVdAhxbPWiO446X
	 VCdzL2lDQpQe4Pfr3sN4CNAQWg/bMET3y2PrlzSBXT4cZk82mqs9oX8w0Z0H4qhGRc
	 E6kerWQmpMbUObneMNIbsI2Lfapw+xswBID+oA6R4NQKdofU4ONFlwgomObhYaIOdu
	 YcNtJ2tKdS5TQ==
Date: Thu, 7 Mar 2024 15:24:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 6/8] xfs/122: update test to pick up rtword/suminfo
 ondisk unions
Message-ID: <20240307232448.GH1927156@frogsfrogsfrogs>
References: <170899915207.896550.7285890351450610430.stgit@frogsfrogsfrogs>
 <170899915304.896550.17104868811908659798.stgit@frogsfrogsfrogs>
 <Zd33sVBc4GSA5y1I@infradead.org>
 <20240228012704.GU6188@frogsfrogsfrogs>
 <Zd9TsVxjRTXu8sa5@infradead.org>
 <20240229174831.GB1927156@frogsfrogsfrogs>
 <ZeDeD9v9m8C0PsvG@infradead.org>
 <20240301131848.krj2cdt4u6ss74gz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240301175020.GI1927156@frogsfrogsfrogs>
 <20240302045552.cq4dmvvyrkfm2fmv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240302045552.cq4dmvvyrkfm2fmv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Sat, Mar 02, 2024 at 12:55:52PM +0800, Zorro Lang wrote:
> On Fri, Mar 01, 2024 at 09:50:20AM -0800, Darrick J. Wong wrote:
> > On Fri, Mar 01, 2024 at 09:18:48PM +0800, Zorro Lang wrote:
> > > On Thu, Feb 29, 2024 at 11:42:07AM -0800, Christoph Hellwig wrote:
> > > > On Thu, Feb 29, 2024 at 09:48:31AM -0800, Darrick J. Wong wrote:
> > > > > It turns out that xfs/122 also captures ioctl structure sizes, and those
> > > > > are /not/ captured by xfs_ondisk.h.  I think we should add those before
> > > > > we kill xfs/122.
> > > > 
> > > > Sure, I can look into that.
> > > 
> > > Hi Darrick,
> > > 
> > > Do you still want to have this patch?
> > > 
> > > Half of this patchset got RVB. As it's a random fix patchset, we can choose
> > > merging those reviewed patches at first. Or you'd like to have them together
> > > in next next release?
> > 
> > I was about to resend the second to last patch.  If you decide to remove
> > xfs/122 then I'll drop this one.
> 
> xfs/122 is a xfs specific test case, it's more important for xfs list than me.
> As it doesn't break the fstests testing, I respect the decision from xfs folks,
> about keeping or removing it :)

I think we shouldn't consider dropping this until there's an xfsprogs
release with xfs_ondisk.h in the build process.  Even then, my
preference would be to leave a mark in xfs_db somewhere so that we keep
running this test for old userspace (i.e. the mark isn't found).

--D

> Thanks,
> Zorro
> 
> > 
> > --D
> > 
> > > Thanks,
> > > Zorro
> > > 
> > > > 
> > > > 
> > > 
> > > 
> > 
> 
> 
