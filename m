Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31A64A4984
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 13:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466363; cv=none; b=RZOzVh1IcvvWJY1XOx+61j0XaZyJkzGrQP7rChsoU87u3VNUWPQyky05gpimKOXkQHVP3Fsr7bTe4lWP39OH8R0QYw9OHtDOr99vaJrGQc/SNayPuiX0HMj8j4HsCO1OyppPyigzPh1njywq2/OVd8w5buJvAzxk2WKklPUHm84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466363; c=relaxed/simple;
	bh=eKqdTD0CXFWtw5trOH2tOGnSGVNE02giX+gdW04gK8I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pKks4x+F0FcRlH9f7eUUqQUHPrBToGFgm1yR18FwLeryYmYgFKXR/8v+YeNzQw24RoFHr8z+J6jpQC3CV5YwYYqLwv3gjGaidAlV6hLO92FMC3jrjoGco3WMChBcrDn6xX5gfWhWEZ87g4Vco+EvQf7oLEPoe/Zs5NS6iEAKEr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+WfWF0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+WfWF0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DBA1F00893;
	Thu,  8 Oct 2026 13:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791466362;
	bh=zrMl43H0yWM8ONqARgemQskPCbtQUcthSyFZEYmKHGA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=P+WfWF0mrF/EHMockiQG+/D+ET8fZx5okDvCAUSAaSJ0gIVLAspLTrJ8+RXhOffwF
	 Nxn7llOmnBhQ0DjSAcGS8fK9JF3a9boFfovMMqAKC45TiHBI+ZqurQgQLChTUKi9i0
	 QdJiFpHJD/bRFG42IWO9utY69lKPGf3uTTZAXg8/PozOASXXBrYL56uTgv1em34Fes
	 VhVEI8FvcBzBz32AUNQ6MWOA4Ro6NxHcN43Hwjyph+vj2S/JeFbe+L4QWcJgMMr/oD
	 djN93VueAzdE6++2fCQEXnXYc+1v+18uiEYIrLVmdeuYzQodRTdB9vpChy11QpnGr9
	 AFXe4JDGuP2og==
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J . Wong" <djwong@kernel.org>, 
 Hans Holmberg <hans.holmberg@wdc.com>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org
In-Reply-To: <20261005115917.36378-1-hans.holmberg@wdc.com>
References: <20261005115917.36378-1-hans.holmberg@wdc.com>
Subject: Re: [PATCH v2] xfs: don't let racing writers consume the free
 zones reserved for GC
Message-Id: <179146636069.378461.9788651999814450426.b4-ty@kernel.org>
Date: Thu, 08 Oct 2026 15:32:40 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 05 Oct 2026 13:59:17 +0200, Hans Holmberg wrote:
> xfs_try_open_zone() checks the free zone count to avoid grabbing zones
> required for GC forward progress, but does so without decreasing the
> counter, letting multiple user writers through to call xfs_open_zone()
> and collectively gobble up all free zones, stalling gc and eventually
> leading to user threads getting stuck waiting for free space.
> 
> Fold the check and the accounting into a single atomic claim in
> xfs_open_zone() instead.  The free zone count is decremented before the
> zone is looked up and given back if none could be grabbed, so the reserve
> can no longer be raced away.  User allocations only claim a zone if that
> leaves the reserve behind, while GC just needs one free zone and thus can
> still use the zones that are kept for it. Also add a warning if we end
> up not finding a free zone in the xarray, as this should never happen.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: don't let racing writers consume the free zones reserved for GC
      commit: 197f678cccbaaf8a5f52a91e6fc914d4c57be7f7

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

