Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9229E3BBC9;
	Tue,  7 Jan 2025 00:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736209581; cv=none; b=ioKs+Par+/cWCfyW/mUhRYJjYzchIGuER4jve2eEIDRopMzlKgdE/bOaoKck+jR8kVu5NPjPNq5mkYoyrFXm1iKseyAnoDzmyFRMzJJ75gThtijuLisn5rktmRgpvbZ7bjL7TxKGn/FE4hnOI8bKhgrZhJcMlf+OFbQy44oDEOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736209581; c=relaxed/simple;
	bh=dMihavZXwGXrpKPs25ME8WFq7ZI/Q8skhM8Byrkfbuo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pb+wmepBUGhTFEsdXGBRupqTva+ReZRu8Axj07uuSkOiRqmrmhjR5ywmt0F/pwqLUJ2wDQOaingBgk+gOoCWGZ25X0AqZ2uQl3dsyY0vvFj+HF3Y+ig0EtDhjqgfvC8KCwemRRgOI4hh5m0fEZnl9+ExjUmRWyvEWtyInQ9jcqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BF5XzXrL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BF5XzXrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D23FC4CED2;
	Tue,  7 Jan 2025 00:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736209580;
	bh=dMihavZXwGXrpKPs25ME8WFq7ZI/Q8skhM8Byrkfbuo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BF5XzXrLITV816ltA3tl3CbxuCnGSwi0uWpjyD53DUoEOnWitNy6IBeM5mBXLXLNx
	 TtelTp0bfLNYQSJx6//5GNt+PEFfMcD0ZieGU+KI4RvPXPp0WmHTuT7J1kCmR+iG5q
	 jtYGw2EvdxGkeVGyjtEoGnjXlxSoTfVyMH28pffRQq63Lc8vEIK2jxuocncAvaodzB
	 FwL0Qhn3kO5655pgv5U9oiGmdJZ6SCLppE5Qi5OEZpcs3mxhRGuntMWZqaWWKWcwJ/
	 jddcIffyZVHZIij/5GYgBYOvRyc1gmeKRENpzT+VQc1JVsy+sZYO/zoRPM6cej4d6o
	 8cjPdZpjEnCdQ==
Date: Mon, 6 Jan 2025 16:26:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Stephen Zhang <starzhangzsd@gmail.com>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, Zorro Lang <zlang@redhat.com>,
	Andrey Albershteyn <aalbersh@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>, xfs <linux-xfs@vger.kernel.org>,
	greg.marsden@oracle.com, shirley.ma@oracle.com,
	konrad.wilk@oracle.com, fstests <fstests@vger.kernel.org>
Subject: Re: [NYE PATCHCYCLONE] xfs: free space defrag and autonomous self
 healing
Message-ID: <20250107002619.GO6174@frogsfrogsfrogs>
References: <20241231232503.GU6174@frogsfrogsfrogs>
 <CANubcdXWHOtTW4PjJE1qjAJHEg48LS7MFc065gcQwoH7s0Ybqw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANubcdXWHOtTW4PjJE1qjAJHEg48LS7MFc065gcQwoH7s0Ybqw@mail.gmail.com>

On Thu, Jan 02, 2025 at 09:37:47AM +0800, Stephen Zhang wrote:
> Darrick J. Wong <djwong@kernel.org> 于2025年1月1日周三 07:25写道：
> >
> > Hi everyone,
> >
> > Thank you all for helping get online repair, parent pointers, and
> > metadata directory trees, and realtime allocation groups merged this
> > year!  We got a lot done in 2024.
> >
> > Having sent pull requests to Carlos for the last pieces of the realtime
> > modernization project, I have exactly two worthwhile projects left in my
> > development trees!  The stuff here isn't necessarily in mergeable state
> > yet, but I still believe everyone ought to know what I'm up to.
> >
> > The first project implements (somewhat buggily; I never quite got back
> > to dealing with moving eof blocks) free space defragmentation so that we
> > can meaningfully shrink filesystems; garbage collect regions of the
> > filesystem; or prepare for large allocations.  There's not much new
> > kernel code other than exporting refcounts and gaining the ability to
> > map free space.
> >
> > The second project initiates filesystem self healing routines whenever
> > problems start to crop up, which means that it can run fully
> > autonomously in the background.  The monitoring system uses some
> > pseudo-file and seqbuf tricks that I lifted from kmo last winter.
> >
> > Both of these projects are largely userspace code.
> >
> > Also I threw in some xfs_repair code to do dangerous fs upgrades.
> > Nobody should use these, ever.
> >
> > Maintainers: please do not merge, this is a dog-and-pony show to attract
> > developer attention.
> >
> 
> [Add Dave to the list]
> 
> Hi, Darrick and all,
> 
> Recently, I have been considering implementing the XFS shrink feature based
> on the AF concept, which was mentioned in this link:
> 
> https://lore.kernel.org/linux-xfs/20241104014439.3786609-1-zhangshida@kylinos.cn/
> 
> In the lore link, it stated:
> The rules used by AG are more about extending outwards.
> whilst
> The rules used by AF are more about restricting inwards.
> 
> where the AF concept implicitly and naturally involves the semantics of
> compressing/shrinking(restricting).
> 
> AG(for xfs extend) and AF(for xfs shrink) are constructed in a symmetrical way,
> in which it is more elegant and easier to build more complex features on it.
> 
> To elaborate further, for example, AG should not be seen as
> independent entities in
> the shrink context. That means each AG requires separate
> managements(flags or something to indicate the state of that
> AG/region), which would increase the system complexity compared to the
> idea behind AF. AF views several AGs as a whole.
> 
> And when it comes to growfs, things start to get a little more
> complicated, and AF
> can handle it easily and naturally.
> 
> However talk is too cheap, to validate our point, we truly hope to have the
> opportunity to participate in developing these features by integrating
> the existing
> infrastructure you have already established with the AF concept.

Hmm, now that's interesting -- using the AF ("allocation fencing"?)
capability to constrain allocations to a subset of AGs, and then slowly
rewriting files and whatnot to migrate data to other AGs.  Eventually
you end up with an AG that's empty and therefore ready for shrink.

That's definitely a different way to do that than what I did (add a
"mapfree" ioctl to pin space to a file).  I'll ponder these 2 approaches
a bit more.

--D

> Best regards,
> Shida
> 
> 
> 
> > --D
> >
> > PS: I'll be back after the holidays to look at the zoned/atomic/fsverity
> > patches.  And finally rebase fstests to 2024-12-08.
> >
> 
