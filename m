Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AB819CCF5
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 17:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760377339; cv=none; b=s+vi1UBZLE27a9k/2A2f8HnUlXVL3WILKiUUl8R9SPYyZubXInfwwepJkzRHhV0L0XctV1t7ja62BH5UKkxLZRCX8qW8ewnh5E0T0KtdVBiAlxKNmMUhVNF4Fjl0exUmLf2+wnDatZotndLC8hDfcOj7aOhIaDtKffWjbQPlRfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760377339; c=relaxed/simple;
	bh=GMp1nJ+GYWHugpMtuQ2nQSYV8rIMPNtCZeoPL1sfuYE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YFSA3/qavNnzXBbnK8TEIULgWBIBnNZIYKvSQ9ii0DVSNpVIMgSNq1WSy24Az7757TQ/sxGF3I9Ycv3dVnPekDRcUMTgDh0+WN+4dlNAEmEbeNSjtLOBHv4nU1vAKDq4lKmODH9b3PkG8fR/1X4tret9S154+0n9knalTIFDmIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VPDnRUma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VPDnRUma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43329C4CEE7;
	Mon, 13 Oct 2025 17:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760377339;
	bh=GMp1nJ+GYWHugpMtuQ2nQSYV8rIMPNtCZeoPL1sfuYE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VPDnRUmam+g9f0IuhwBn8eYtvozUv0tErMOmm2YrvA/vTXCWy765NjwtDELT/ZHrh
	 +a7HAwzdmkbxRNJATB4LtqnMFnEdxS5+l3I65qVZOnzNx3Fqj48Uf5VXBV7TbqpRK8
	 f8Otui1xblrrRuckGyX3rLzpXD25TKzBs17xnT9rEBNt66eZCMxPdNxU6ZgJdZWBik
	 X8kNCvFusiSpgkXKkMGrqy6ka/ha8jDail3uh8cg8zVbSH9FfaAtG/ws44AP3i8ibH
	 RulSGPoURMiQvEqLp7qSBBNyPXLsG6wYGXMQ1DITee9q9IgmQ8oUmbNYln1cdkcKRW
	 loupC79g9SFLg==
Date: Mon, 13 Oct 2025 10:42:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Debian Bug Tracking System <owner@bugs.debian.org>
Cc: Bastian Germann <bage@debian.org>, linux-xfs@vger.kernel.org,
	debian-bugs-forwarded@lists.debian.org, 1112588@bugs.debian.org
Subject: Re: Processed: Re: DeprecationWarning: datetime.datetime.utcnow() is
 deprecated
Message-ID: <20251013174218.GO6188@frogsfrogsfrogs>
References: <feb251c6-3ea1-4ca6-841f-70ce6216a22f@debian.org>
 <175662646685.178172.185590202459851084.reportbug@turing.verdier.eu>
 <handler.s.B1112588.17566725082401155.transcript@bugs.debian.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <handler.s.B1112588.17566725082401155.transcript@bugs.debian.org>

On Sun, Aug 31, 2025 at 08:37:02PM +0000, Debian Bug Tracking System wrote:
> Processing control commands:
> 
> > forwarded -1 https://marc.info/?l=linux-xfs&m=175667185613391&w=2
> Bug #1112588 [xfsprogs] DeprecationWarning: datetime.datetime.utcnow() is deprecated
> Set Bug forwarded-to-address to 'https://marc.info/?l=linux-xfs&m=175667185613391&w=2'.
> > tags -1 patch
> Bug #1112588 [xfsprogs] DeprecationWarning: datetime.datetime.utcnow() is deprecated
> Added tag(s) patch.

The patch in

https://lore.kernel.org/linux-xfs/20250831202547.2407-1-bage@debian.org/

I think will appear in xfsprogs 6.17.

--D

> 
> -- 
> 1112588: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1112588
> Debian Bug Tracking System
> Contact owner@bugs.debian.org with problems
> 
