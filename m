Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134971CF8B
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 17:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711473294; cv=none; b=QxpZNWxwRbjaUFJZkXGwNUlNuaPkT+Q9PguZM+6s5qZtD4PJY5I3JtD6xaPIQt6mG/bmlTbj4cYJ/7/dmkBVAZIGS9+H5kIY18KiTTbc5QDdtIeUxN1DqYu0SRWD/c1U+KHhwskGTBE+NDScZsyrNt4zU4LsnI6t8oNC5LZMbGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711473294; c=relaxed/simple;
	bh=9xIyZm+FR6fc6MsXUCFAtv/2c6OWGAGK+XGb3DLkUzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aX7vvZOgKRc3YOMhSLUHQ+qGvK8zITo9LnpowrIIF7YGAEmx1zVftYcD+QORhDUUyVfGeTTRn6Thu19ENU5DaK66aXFAAS9NXZMttaJrPk6RAt3tL8cEeZ6CjX7r3wYIscTr4GN//8vUHw4YJtaoMfKoZrDkbE+g2zvBWE0cbiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QObUw1yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QObUw1yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852F5C433C7;
	Tue, 26 Mar 2024 17:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711473293;
	bh=9xIyZm+FR6fc6MsXUCFAtv/2c6OWGAGK+XGb3DLkUzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QObUw1yy0MQtUr2iTFkRVCKjBwzyt/0yIJTqa6jngY9quAaqy2r6Cg382AUn1GqST
	 X8Bupz/cYwEAJ/yF+JrieiCKl71uiIKIY7QXwAB5Df2ulFlf1TQlzUolZqhPIp2mkz
	 XjcWH91UWj5n2N98K7VJI77EpcFtbyY+b4iNX+kkkk1W311GBukwoENq+usWFm2+jA
	 2sq78a+hKsHaw7tLaM3gc2sSQC+4iF0QgFoyfpvPe2XFmlEi9JezNaLyJym0msCAPX
	 o6vfwSBN7XOaIil0YNA8SqVWjcrsLWQDTcGNM60pL+pFIqLMtb1F9jin1UhlNyYeG7
	 T8PUry9DjJpSA==
Date: Tue, 26 Mar 2024 10:14:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs_repair: convert regular rmap repair to use
 in-memory btrees
Message-ID: <20240326171452.GP6390@frogsfrogsfrogs>
References: <171142134672.2220026.18064456796378653896.stgit@frogsfrogsfrogs>
 <171142134693.2220026.17221087060563357898.stgit@frogsfrogsfrogs>
 <ZgJh2fqdEUu6r_o_@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZgJh2fqdEUu6r_o_@infradead.org>

On Mon, Mar 25, 2024 at 10:49:13PM -0700, Christoph Hellwig wrote:
> On Mon, Mar 25, 2024 at 09:00:31PM -0700, Darrick J. Wong wrote:
> > +char *kvasprintf(const char *fmt, va_list ap)
> 
> > +char *kasprintf(const char *fmt, ...)
> 
> Any reason these implementations don't simply use vasprinf/asprintf?
> The calling conventions are a little differet, but the wrappers are
> pretty trivial, e.g.:
> 
> http://git.infradead.org/?p=users/hch/xfsprogs.git;a=commitdiff;h=1f66530b2104b2f5e47aef76fce62df436a8f004
> 
> for asprintf.

In that case I'll just steal your patch, please and thank you. :)

> Also in general іt's nice to split such infrastruture additions into
> separate commits.
> 
> The rest looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Cool, thanks!

--D
