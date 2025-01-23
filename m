Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DD91CAA62;
	Thu, 23 Jan 2025 21:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737667376; cv=none; b=DKAzZl3ao662EG1wbFdbrRzNQFIfPOH1amd2Mdo0Lcvlxe5xB1DyibBYdTNMdJ4RBBp0UChbRvuV97rqwNSHiHotfdLvfYtbjBCWE6hakFMJ9LeuTFeOhKU9vyYZd6gDoVAAn+eQS+Y1cFNXJCMJ4H99aWyYB/4gh8AJPZUBXkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737667376; c=relaxed/simple;
	bh=pcCYUQti3zxLorlvGwMMCsDLeOXvWxsfjOp/gwgugyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bDDcNkosV+Y6iN2EhitmfzLvocuaXpi1r0bpt2hNf0vw/zl9R2LUaeqISo+N34TwNwjuCagsT2crJT+PsRrz4bi5vWexG6ZDP1Cq0C1rRRJzSLMXDP0RKM1J6JaKRu/6XvUE3GZq3izkbwNqYvJGPOMoBG7KZmd8607xLVnkxKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JjuaNpZl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JjuaNpZl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E70C4CED3;
	Thu, 23 Jan 2025 21:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737667375;
	bh=pcCYUQti3zxLorlvGwMMCsDLeOXvWxsfjOp/gwgugyA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JjuaNpZlMQhyjxo5Sr3S2k+So8VnuJZIbhOugCoTvi0cHgW0SMXjSmvgJyOQ7T7A2
	 VM/W3RQubRWHn9ITIFooCCksZReGitNdagEyjkKSBj49qoaEcbRhx6yorbFtFZNL+n
	 1gtEQdp92IuXzypv2n587MXnV7zve8dFirTIkxJ11P8EccHB1N4ITCqG0U6HWlR+Fz
	 gO7tpEle4QlOcJjKf/DduCG6RxfKI5+9PGQotF51nku6KZ5Yj8kbkbHKLvI0dmCLo6
	 ZUK0wBJJSC3GsRj03ZEzmxE9SV0spq9ntfgBg/e//RJjdBDcN8ZIRMdVX3NIthlL/7
	 +cLyFHwnfxDyA==
Date: Thu, 23 Jan 2025 13:22:55 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: xfs: new code for 6.14 (needs [GIT PULL]?)
Message-ID: <20250123212255.GG1611770@frogsfrogsfrogs>
References: <i6yf5ledzs4qdt5zhrpg7nz5neyygktthupap6uulpuojcx7un@phdanup4alqb>
 <20250123183848.GF1611770@frogsfrogsfrogs>
 <CAHk-=whUe3wH4J1YGrdokVEgtb2hjteOdBttF=6ffHSYzakcBQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whUe3wH4J1YGrdokVEgtb2hjteOdBttF=6ffHSYzakcBQ@mail.gmail.com>

On Thu, Jan 23, 2025 at 12:46:47PM -0800, Linus Torvalds wrote:
> On Thu, 23 Jan 2025 at 10:38, Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > It's been a couple of days and this PR hasn't been merged yet.  Is there
> > a reason to delay the merge, or is it simply that the mail was missing
> > the usual "[GIT PULL]" tag in the subject line and it didn't get
> > noticed?
> 
> No, it's in my queue. You don't need to have the "git pull" in the
> subject, as long as it says "git" and "pull" _somewhere_, and the xfs
> pull request email does say that.
> 
> But I tend to batch up merge window requests by area, and I did my
> initial filesystem pulls on Monday. The xfs pull hadn't come in at
> that point, and then I went on to different areas.
> 
> I'm getting back to filesystems today, but since I have great
> time-planning abilities (not!) I also am on the road today at an
> Intel/AMD architecture meeting, so my pulls today are going to be a
> bit sporadic.

Ah, ok.  Thanks for pulling! :)

--D

> 
>                Linus
> 
