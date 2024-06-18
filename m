Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AF77D51E
	for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2024 00:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718670794; cv=none; b=Tu0wimrGfJvRAegP+CGjV0oe04ga5kyzaa/ZNMlq+2/zeRdBodwc1no7W7OlfDjZKSCHZzKbCdaD0XcdSmKkCBOFKp7yMKt0KeEpzKO6WswC4D8vsG7znwC/3vgEWyGSrhqwmHdongMU5MTSby5RBi2MtLbgfDuxF9lHinZIBbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718670794; c=relaxed/simple;
	bh=sU+hihjZSykBiULwHrMEpgfArL2tedwLpg7rHHXekc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8pKBWVPQvtSl4lVFuJOLDlNXrzbBJZ8euhf2IBwXz7fOqcDwwoPRCQ+eSIBoh6BYQAqAStxcV2xTPPG//AT2rVfuPvwZIwgaQIoyxEddRWOouv6kGugLwVWE/PV1gEGOM2RF56CnsLXBY/B+bai+mj9He91T2Bc6tkokA+GYZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rWilLv/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rWilLv/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1D8C2BD10;
	Tue, 18 Jun 2024 00:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718670793;
	bh=sU+hihjZSykBiULwHrMEpgfArL2tedwLpg7rHHXekc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rWilLv/yJTSe5h0dKZTLPNyMLUlr3k+DOPcIlzS8svu9XiAueMPjqm3NeL/3hhxK1
	 ZQ25CAAjprmdPvT4fvhlFTwUCXKa+/GyirkDDA1dvkdjb6gnzsXkZYzqGuCYvy+yC5
	 JRDZr35ozdQ5YP8DRUm+MbNZuXNwKJglvF1b8tEYp3WhrM5amaz56us9Cb8/QCDj8/
	 lIqbQZ7SWO+8jvJDcEvsvWJVmt2ui09WGKxuPetY3HVgSFwr8ZRChdT6Q00L/IIVbP
	 uul4FXrANQIUAHiRpLWDRKLWBpbokUE+wiaEoeggrRqmwufjAN20gNWPpTEg1vaG12
	 lDagcPCrW3hpA==
Date: Mon, 17 Jun 2024 17:33:12 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>
Cc: sweettea@dorminy.me, Leah Rumancik <lrumancik@google.com>,
	neal@gompa.dev, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Shirley Ma <shirley.ma@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: xfs office hours 18 June 2024
Message-ID: <20240618003312.GB103034@frogsfrogsfrogs>
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

Last week's office hours went pretty well, so let's do it again.

The second set of office hours will be tomorrow, 18 June 2024 at 8am and
repeating 10 hours later at 6pm PDT.  We're using the same URL as last
time.

https://oracle.zoom.us/j/92930934955?pwd=wsEYPkj7WOpvIT0E1Bb0cCBaHvj8JW.1

This time I'll poke #xfs on oftc a few minutes beforehand, to try to
avoid some of the waiting room issues last week.

--D

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
> 
> Immediate topics: I want to give away a bunch of projects: the ones that
> have been festering in djwong-dev; and the ones merely written down on
> paper.  Also the actual scheduling for this meeting since the biggest
> blocker has been the near impossibility of finding any good timeslot.
> 
> --Darrick
> 
