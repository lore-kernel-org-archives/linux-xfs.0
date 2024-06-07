Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9671115534F
	for <linux-xfs@vger.kernel.org>; Fri,  7 Jun 2024 22:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717800268; cv=none; b=TbWOKuK4SKNKt0RsPy9oYKU4zWrO6xJFgIo8MjZFQh+TD6Qa/4uZP8bolOFTboHxh7mwCtYJsQWbmM732Vf8pQbZMG1SdtyPqARzRGhFV3Ku70mC9mt4X8TuvqHZ27xDHTfFrLMGxqsn/Gff4lXr8OKPeEanfB/mgFAuJvQvp+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717800268; c=relaxed/simple;
	bh=uP+IqbkpG/ZZHDg0jYt/NZMUGZ2sn8pev9PQ6SyTF34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W342/MuH4KOKwW9KRsdRAPLBaGJmJZnJsUuP29Kd/QidgLnv7GbYs8tIzSAI853bEhmbxlwFVDtHkNOSl9bQkHJIZrV0o8oxUAY09gCn3XfMPLb41PbuzV+w0SAMN1HYen7UmN4Tz1gLO0bIy82dI12pJhU+gORxKgpuWM/a0bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s6JkSXGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s6JkSXGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31084C2BBFC;
	Fri,  7 Jun 2024 22:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717800268;
	bh=uP+IqbkpG/ZZHDg0jYt/NZMUGZ2sn8pev9PQ6SyTF34=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s6JkSXGI4K4HbpsMhRsuGlV7QG8wZjmAVV/FQ/6U0gWfw5I+JLoL6ip3VBiuHBYC6
	 eQJRKwGjKKGJzcuWSpnhecUGSiW0XFd0rCqTvKGyC22Si0fm3YPgltz6NcpRDDLOHD
	 nBFEo0mxRqrOZkJ/BoILPBR2Tkc97GjpvYyqEhddHxiHsRxDvyCr4mkRictUrfdetH
	 vZoWYVZbhvc/KSA2//2qPQX3fu1bwt/fRVb8D/J4tbhDwPRTnYK+YTqoXUReJ0nql+
	 jPbH++gt0hV3MNNnbBAmSmR0+sLIVYgpkDGUIKISq288raRtDVFcWhYl0iYrU8EwDw
	 37lsDRebSZaMg==
Date: Fri, 7 Jun 2024 15:44:27 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>
Cc: sweettea@dorminy.me, Leah Rumancik <lrumancik@google.com>,
	neal@gompa.dev, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Shirley Ma <shirley.ma@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: setting up xfs office hours
Message-ID: <20240607224427.GS52987@frogsfrogsfrogs>
References: <20240606002641.GJ52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606002641.GJ52987@frogsfrogsfrogs>

On Wed, Jun 05, 2024 at 05:26:41PM -0700, Darrick J. Wong wrote:
> Hi everyone,
> 
> At the XFS BoF during LSFMMBPF last month, I restated my longstanding
> opinion that given my experiences trying to get online fsck designed and
> merged, our feedback cycles are far too long; and my lament that we do
> not have a community conference call where people can discuss what
> they're working on, ask for new projects, etc.
> 
> As part of stepping back from an active development role to focus on
> leading my team, I declare that I will host open office hours for
> people to:
> 
>  0. Run down the bug list and QA testing results
>  1. Drop by and talk about whatever xfs-related issues they have
>  2. Find things for themselves to work on
>  3. Inquire about adjacent work being done by other people
>  4. Engage in transfers of information and institutional knowledge
> 
> My intent is to have a defined hour every week where anyone can drop in.
> However, given the global scope of the xfs participants, I declare that
> anyone who cannot make whatever time I pick should contact me to
> schedule an appointment.
> 
> The first office hours will be on 11 June 2024 at 8am PDT (aka 1500 GMT)
> https://oracle.zoom.us/j/92930934955?pwd=wsEYPkj7WOpvIT0E1Bb0cCBaHvj8JW.1

...and I'll repeat it at 6pm PDT (aka 0100 GMT on the 12th) to see which
one gets more participants. ;)

--D

> 
> Immediate topics: I want to give away a bunch of projects: the ones that
> have been festering in djwong-dev; and the ones merely written down on
> paper.  Also the actual scheduling for this meeting since the biggest
> blocker has been the near impossibility of finding any good timeslot.
> 
> --Darrick
> 
