Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CD3168482
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 18:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718994417; cv=none; b=Wjwvlpu25h0A45dsiPiGO47T1hB8DlEC2DHmlIHbzFWoCfQNr+2j/3KkdZcVtnMZmyfIkOXEBV9hGNCeBMCHRSC73PZDvHr256K2ghNPCW1xYaLP6EnfxdsaiI7amWQmrjhxhMV1r38SFFaUoU+rgFSmcPs24sWG9YMEBA8lQrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718994417; c=relaxed/simple;
	bh=8fCGsl8LMwopvWl91fAtTlatTgK79nhWItlzSwRrJoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sgIe93w1kg7VW1+I3Guvj8Xlco00/b4XfuxRoWoCWQvxuBDK2gpaUa6YbaYrz67xknwg9mt62XY7i5OxpLJ+AieyCGtl+Qowm0DClc5bMqvfmBmlyvx4hvBtzQME1N2AWAYrD8PLUrjFIjro1E1a7nq9y+m0/ndO49YMv6S9Ob8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNHao139; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNHao139"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6383AC2BBFC;
	Fri, 21 Jun 2024 18:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718994416;
	bh=8fCGsl8LMwopvWl91fAtTlatTgK79nhWItlzSwRrJoo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mNHao139PslZc8lwNLmGFf/Ptb382yMWbjjMtRmoW6wgOLQN9Eaovd9Q2+VIw3JIe
	 NnKpK9NAFWtSD8DZzAtWn95eC43DLm1ukpXzCOzMOSV/MpYM8J5Lyc1VGD1dmtTsab
	 2eAs/hc04bcVSQinZBiB0aVFWAu2NM7wU1DpsD54nzM+SOXxlOUTgJy/sqfXzjUJ93
	 hp1DrGMLZlCsk67aQZsvDh36NqakXAnDcY+YWt9bIXQGZY0sqwoN7n4DAofhQ4y5zb
	 LQ9wd/WVPDW4RyG7oWqIvCjlqykR73eCRScKEoGpVhypdqTLwH1Tl1tv7lvgNFqi4/
	 4pCQLvsQUrHcg==
Date: Fri, 21 Jun 2024 11:26:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Konst Mayer <cdlscpmv@gmail.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET v3.0 5/5] xfs: enable FITRIM for the realtime section
Message-ID: <20240621182655.GK3058325@frogsfrogsfrogs>
References: <20240620225033.GD103020@frogsfrogsfrogs>
 <171892420288.3185132.3927361357396911761.stgit@frogsfrogsfrogs>
 <3UX9HUQVFM4SL.33XVNIAMTWYDJ@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3UX9HUQVFM4SL.33XVNIAMTWYDJ@gmail.com>

On Fri, Jun 21, 2024 at 10:09:07AM +0700, Konst Mayer wrote:
> Hi Darrick,
> 
> Thanks for the patch. Is there a reason why it is not in the mainline yet?

Lack of review bandwidth, I'm sorry to say.

--D

> Best regards,
> Konst
> 
> "Darrick J. Wong" <djwong@kernel.org> wrote:
> > Hi all,
> > 
> > One thing that's been missing for a long time is the ability to tell
> > underlying storage that it can unmap the unused space on the realtime
> > device.  This short series exposes this functionality through FITRIM.
> > Callers that want ranged FITRIM should be aware that the realtime space
> > exists in the offset range after the data device.  However, it is
> > anticipated that most callers pass in offset=0 len=-1ULL and will not
> > notice or care.
> > 
> > If you're going to start using this code, I strongly recommend pulling
> > from my git trees, which are linked below.
> > 
> > This has been running on the djcloud for months with no problems.  Enjoy!
> > Comments and questions are, as always, welcome.
> > 
> > --D
> > 
> > kernel git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-discard
> > 
> > fstests git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-discard
> > ---
> > Commits in this patchset:
> >  * xfs: enable FITRIM on the realtime device
> > ---
> >  fs/xfs/xfs_discard.c |  252 +++++++++++++++++++++++++++++++++++++++++++++++++-
> >  fs/xfs/xfs_trace.h   |   29 ++++++
> >  2 files changed, 274 insertions(+), 7 deletions(-)
> 
> 
> 
