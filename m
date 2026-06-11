Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19023EAC9B
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 14:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781186754; cv=none; b=anSpFgFbD38kkNXlU/toA6BV6nFGVdLBjbQ6UU2ys0pK8kxOX6fBM5OlS2h1U6rBUEqIgDNab574rTo8BXcUL5OgJy0FnBhuzOUsokVmROCRFG/PM9EDOOFem6OjJLKCWhrpFat14pIDMq6tvQfVl8sUC7lLs763b5iaK7/7qxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781186754; c=relaxed/simple;
	bh=zOGkKj1Nh6ue3ni3y4xdmKFAJYNmFbQcbfwNL+F87mA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h+r8oGULIIhItI2lKnxX39e1xRla9SlrvW3fbj12y3qCpm9ewlV9yPz6VaKHvNAsTauXn7JSA7/0lbbgIAOi0VAFZAsI9LYm0PMRWjzVS3aqoBUTPMxSi1B4nYWsu8lsND81QxWqmiiJYlfz95zl4ywAAGpk/nb1WFHvUBDH9bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c/V3/rdM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c/V3/rdM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BAA7E1F00898;
	Thu, 11 Jun 2026 14:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781186753;
	bh=iW+QkwGc7vAxyr9vPiwjlrBkIPxYc6GI7Y3OgGd0GfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=c/V3/rdMfPfOvlaMbX54nQoifj7Cb/e1e9W+0qEhBrUB/igAvYbAcJSrLV24h1vA1
	 U07W2wdqvjpGJMQIvnFEyHeylh4PiQ4AWWyQAmEeoKLFD639hEhl/R+XZvleRviGrM
	 DOFBnV+KDt3XN2OcjuIMcicPPYJrFCmW/8N9GLY6Iuw7G7M6vW0Kp8zVHZg+jQzMwG
	 PkUfg0Ez+7gJ2yVi1mat59y2CRU4Adn8M6zWazIDBW8vptDanfkVgMSBB0/uUcehL+
	 c+QWmdBsC6Z/U7MovDQ10/vt0UPUD4IQ8dF9wuPqetAPwCWFVDyOzy/7uylUXee1JN
	 PsOb/403ap7QA==
Date: Thu, 11 Jun 2026 07:05:53 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 10/21] xfs_scrub: don't report media errors in
 specially-owned areas as file data
Message-ID: <20260611140553.GI6078@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303293.2608728.8048137726163765459.stgit@frogsfrogsfrogs>
 <aip8bIhSvpgEtqvF@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aip8bIhSvpgEtqvF@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On Thu, Jun 11, 2026 at 11:14:39AM +0200, Andrey Albershteyn wrote:
> On 2026-06-03 23:06:56, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If a media error occurs for some disk space that has a "special" owner,
> > we mustn't try to walk parent pointers because special owners are not
> > files.  If it's an extent map, we shouldn't accidentally fall into
> > reporting that as file data loss.  This was, like the rest, found by
> > Codex.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> 
> Looks good to me
> Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

Hey, thanks for reviewing this!  I have a few more fixes on the way...

--D

> -- 
> - Andrey
> 
