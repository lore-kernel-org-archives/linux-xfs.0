Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6EC1D6DA9;
	Wed, 22 Apr 2026 20:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776891140; cv=none; b=cgOvnSQ5XEyzq0M3sk3HODRx6Vtf2etWOZTz+leFQlYa/5C/autjdjTCwF6cfO7dZ4KFm/xPwHpx21QDGdi/MHqzCbQP9Y/LZaCIqhg/FOpRxe6lxRS5Zzzij0dNBUAOu8m5y1yzpQICere2MFAc/he3m2Ck6EKuIi8KcloyonI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776891140; c=relaxed/simple;
	bh=GmrHhiFFa9avyZuJ1/pqSvIn7nS5A42kAxLYzXSQYAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s8goHJSck8UQsxCEWO5WVBR4GiVEVJSitTZNSzzhr4IRzNimOUO/YKi5zEvZgF9EiZBwlkVH14e8hnsolcDBpP3RG7thMENsplh0wsiEBaytAmY+9qvZdiJPwMcMpNPMGYwCSlm78ue1jjReKVYnBf1hxplSKxWubVihseLSZmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aoADLG6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aoADLG6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1880C19425;
	Wed, 22 Apr 2026 20:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776891140;
	bh=GmrHhiFFa9avyZuJ1/pqSvIn7nS5A42kAxLYzXSQYAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aoADLG6Tw5tN1TnehbuP+2Z8WayVS6TQeGPKXxBxSmEFAGBJg18GltlleA7PBoGT5
	 fpL4gwh7AWy5V3YOS6fBfrCVo9+zGEJUGKNdwhK5v2O5uvKVDU3MOSTVFwICkZbFEh
	 S32ss91Rm5mieDH3xC6cadTe/vJJ9uUPVLnwYZlyDfj2Ua8cMIBwM1C+88FSjG6Zh3
	 xsTZYKmxjDQZjlDsuSTGHCvJohvEhLtpQSOsJ/KEUcX3vf626iljrzvfPc0dCDi1h/
	 8/qLfCMyWyudRsGAKD9MpR9dLAQRgyTtkTgVP6cHlP+Fy+ajNc/TEaJUFGC1sdHkrg
	 P8ZazPw1Bry/Q==
Date: Thu, 23 Apr 2026 06:52:10 +1000
From: Dave Chinner <dgc@kernel.org>
To: Ammar Faizi <ammarfaizi2@openresty.com>
Cc: Linux XFS Mailing List <linux-xfs@vger.kernel.org>,
	Linux FSdevel Mailing List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Yichun Zhang <yichun@openresty.com>,
	Junlong Li <lijunlong@openresty.com>,
	Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
	gwml@gnuweeb.org
Subject: Re: XFS Deadlock on Linux 6.12.82
Message-ID: <aek0-rq8zX-ta6aW@dread>
References: <20260422152505.818254-1-ammarfaizi2@openresty.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422152505.818254-1-ammarfaizi2@openresty.com>

On Wed, Apr 22, 2026 at 10:25:05PM +0700, Ammar Faizi wrote:
> Hi,
> 
> While running Linux 6.12.82 with CONFIG_PROVE_LOCKING enabled, I
> encountered the following lockdep splat. Based on the call trace, the
> potential deadlock appears to be related to the XFS subsystem.

Well known false positive.

Lockdep knows nothing about inode reference counts and how they
interact with memory reclaim. i.e. A referenced locked inode doing
memory allocation cannot be found by memory reclaim processing
unreferenced inodes, so reclaim cannot deadlock on inode locks held
by referenced inodes when doing memory allocation.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
