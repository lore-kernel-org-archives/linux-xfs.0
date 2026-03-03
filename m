Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4114D8DA7
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 16:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772555081; cv=none; b=H+MwwxlcbXxC3JbPOZwkI0HVjOgkoKpMALiBi1W5G/oHrGLP2lSdzA61EzRfe6h/ac6N0bamXyryvE7sjb3/774JggS+0BVKFIY5LizPIzfR0G+PJd/KbYyCMbyyu/XaGLLY4to29GvVfVeq6QLNwckOAYlD7BgRMDG2XVIVj5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772555081; c=relaxed/simple;
	bh=wzgsrGjmasuXITkCzZ13Fhxhz4cL5DD2J9g2wgjwVCI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kSOe8z47JFqXYyEhwM40RruU8swp/UVYZkIhMtXGMXKeAUCSLxwvs3IKycdjQrCo5+qXEOtEFbAZxKkl73hi3pD4vTFwI7Zd6tujuzk/QWWjFq8BXg96iGSqXn5NFcix9cNugWZSmxIeK9Emuc87QSGn5ryDe8klyFC602j/CyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pI5BmLkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pI5BmLkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5B6C116C6;
	Tue,  3 Mar 2026 16:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772555081;
	bh=wzgsrGjmasuXITkCzZ13Fhxhz4cL5DD2J9g2wgjwVCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pI5BmLkl8D5PaMqrkGKCeQ80AeKkNB0HsDuIukJnDBLm8dxhHTn6HlscFs90KMvir
	 uf/rYWq9qMobudj4qXfKGOlRBAKKPmtlZalL39S+pkB+QlYGcnjqEnQEwb1yd6ZJ4I
	 X3UsU3AAghUgojCMtkgKlupf0M2ZhGU7YnYD/qRTwViDnjPS7SmDymhQ4gqdnJ/x71
	 5G94EFPrIYOxkoXCzgR56lQDIRkjtAB79apxHCXt6IX1iQfDa7YmcSxhLoK60LQONv
	 plOqeXT4kPCVO1qez5rdEMO7hQ7FGoHxwW4IpJHlXLQQ/MbCWWS7/Sd5vO2gPaRAuD
	 gqOHcrq/MEj/w==
Date: Tue, 3 Mar 2026 08:24:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, cem@kernel.org, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/36] xfs: remove metafile inodes from the active inode
 stat
Message-ID: <20260303162440.GG57948@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
 <177249638385.457970.8057539261074430844.stgit@frogsfrogsfrogs>
 <aab03-37QcwSKu0u@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aab03-37QcwSKu0u@infradead.org>

On Tue, Mar 03, 2026 at 06:49:03AM -0800, Christoph Hellwig wrote:
> On Mon, Mar 02, 2026 at 04:20:47PM -0800, Darrick J. Wong wrote:
> > -#define XFS_STATS_DEC(mp, count, x)	do { (mp) = (mp); } while (0)
> > +#define XFS_STATS_DEC(mp, count)	do { (mp) = (mp); } while (0)
> 
> Looks like XFS_STATS_DEC has been around for a while like this.  Maybe
> split that fix out?

Will do, though AFAICT all the previous "callsites" were all #ifdef'd
out of existence anyway.

--D
