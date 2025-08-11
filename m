Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150B82DECA3
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 15:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754925933; cv=none; b=MA1Y1LFHDSiY0KYyhJnPnL8ZMYwUxkCwkvxyduWuCKKezcc4LcM1G6eXDjzDsBA8ooF+yBfKsY6YWIf9Yev3ZjYyvhX5OoubVSx1xCyDFvMJjsBgrN+S0BTIrI8JAZzhuG05FrrqGRlAkd4s5u2T1Io7eGtb+9Tx6hYKKqI1vWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754925933; c=relaxed/simple;
	bh=31LY9u2VmBQ7Ooq6uVLDkW22B93dYyQSl6gGbJcjB5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xf0aOjTnvcURVXJtxg46bsk5UHL8qRipPSbEakttmEMYdYXa9i0Q1CZOSnIGaXaEPCnbzTURCgKoSvDvjPyTJHZj/qP/4qz0hVWhYbFQdSrUbZhbnzqkMdDhAPoKuWEH0x12g4XiwOSdKAmFB+0XL+OoBtkGUxNT5lfQDhhoU3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tUvpd8BK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tUvpd8BK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91127C4CEED;
	Mon, 11 Aug 2025 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754925932;
	bh=31LY9u2VmBQ7Ooq6uVLDkW22B93dYyQSl6gGbJcjB5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tUvpd8BKDyhDzvqtORH+KJw1VwVvrqSEYZ8MjCArnpxsINwwI5VabvfUM91HnIFg6
	 U9ssyEJEDEOCdddDc23uBRnZ/5G91W+WlEowrBaG1Sd9ADr5akahIrn+Vv/GKJSngE
	 sV4HTqX32nSa5EnYEjfWvvx8kiDdJcKO+vGlspjzALo15Wu1KUlBo3HGL9OXvAz1fx
	 v/pJL+XzRq3Wz02sCsue1Za5IuyoVqLU1pw7oebZXbN26Ur+hcJuYr0i2OI1QJzJqk
	 C/Bkcy72C6lu2qNyWuRjkz4J7TpiA4WXCDjGwcMj2byx8TmJcKnfG191q4xjQUH8tU
	 bX3JSKDW6qG9A==
Date: Mon, 11 Aug 2025 08:25:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	Roy Sigurd Karlsbakk <roy@karlsbakk.net>, linux-xfs@vger.kernel.org
Subject: Re: Shrinking XFS - is that happening?
Message-ID: <20250811152532.GH7965@frogsfrogsfrogs>
References: <B96A5598-3A5F-4166-8566-2792E5AADB3E@karlsbakk.net>
 <8a9071104eec47d91ab44c86465d08d76e0cf808.camel@gmail.com>
 <aJnKcktFW6jPBETP@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJnKcktFW6jPBETP@infradead.org>

On Mon, Aug 11, 2025 at 03:48:18AM -0700, Christoph Hellwig wrote:
> On Tue, Aug 05, 2025 at 10:20:15AM +0530, Nirjhar Roy (IBM) wrote:
> > On Mon, 2025-08-04 at 17:13 +0200, Roy Sigurd Karlsbakk wrote:
> > > Hi all!
> > > 
> > > I beleive I heard something from someone some time back about work in progress on shrinking xfs filesystems. Is this something that's been worked with or have I been lied to or just had a nice dream?
> > > 
> > > roy
> > I have recently posted an RFC[1]. The work is based/inspired from an old RFC[2] by Gao and ideas
> > given by Dave Chinner.
> 
> Like the previous attempts it doesn't seem to include an attempt to
> address the elephant in the room:  moving inodes out of the to be
> removed AGs or tail blocks of an AG.

Anyone who wants to finish the evacuation part is welcome to pick this
up:
https://lore.kernel.org/linux-xfs/173568777852.2709794.6356870909327619205.stgit@frogsfrogsfrogs/

--D
