Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF155256
	for <linux-xfs@vger.kernel.org>; Thu,  6 Jun 2024 00:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717633603; cv=none; b=mS4nI0Y7ZDMaZTQ2ME8jc/zOmynV+oteaS39/1crfx64ZU6uKIJYLJbH5295VEifMrV2+zSPjwudWAkPEursdGPGoMe/Ps0Q7rU/B8SL9ONRO7dIPG/BYl/S0MRUFrDT7AYybSY639v9J+aM2xkMMmm989NgnKi1K26c/F7aEQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717633603; c=relaxed/simple;
	bh=EvahCWUU3uI6ScLr8pYbodIFXpTT6JDrsz7E4QmsjMM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mAGy+Wv6XWfjV6Z7+1OMvEQ+TzGJ/iv9b14xYnBl1AX43K7unwm+YFPbrpZ0KstySyBdLWGuejE5h8Ek0aUq1MZpUAHzU0xVQ/b1rRAdg53KHfyxDFjFTKShXkM4Bp/ihDBHWbdFA9LmvZxE3UMSEqwLdFsiFZxm5I9xeCgEdxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JA6CJevy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JA6CJevy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C474C2BD11;
	Thu,  6 Jun 2024 00:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717633602;
	bh=EvahCWUU3uI6ScLr8pYbodIFXpTT6JDrsz7E4QmsjMM=;
	h=Date:From:To:Cc:Subject:From;
	b=JA6CJevy+tLluffwjcDEQMYIe7+hdOY/tumbCTIiyTnjxzV5nJimlEu5RF/zpqkxM
	 leATOXRMKEkSBE1TgF/QpzfVW+8tJcOKWngfrFjBaSmnNQ+SXbtfJqdjYdbspj9vFL
	 9yHDodW0JNtW9xprJ26RU6Op9mFDkGlxbGRVlfM2K0QPUgxmkvErVWyedJuTUKKzwf
	 CqsU9eKwC5DSDXqACutdg9NmCDOhbwBz8mZIIW/1oFQc6aEWFfSZCIqlpqj0xeql0F
	 qQMT+nZcW13nHiOZCm/BlB+B7LnO4JhhciQdBqwlAQMpxmI+jY3/vCR3aB6e8Bp1or
	 kiFbD+y2s7T4Q==
Date: Wed, 5 Jun 2024 17:26:41 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: xfs <linux-xfs@vger.kernel.org>
Cc: sweettea@dorminy.me, Leah Rumancik <lrumancik@google.com>,
	neal@gompa.dev, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Shirley Ma <shirley.ma@oracle.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: setting up xfs office hours
Message-ID: <20240606002641.GJ52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

At the XFS BoF during LSFMMBPF last month, I restated my longstanding
opinion that given my experiences trying to get online fsck designed and
merged, our feedback cycles are far too long; and my lament that we do
not have a community conference call where people can discuss what
they're working on, ask for new projects, etc.

As part of stepping back from an active development role to focus on
leading my team, I declare that I will host open office hours for
people to:

 0. Run down the bug list and QA testing results
 1. Drop by and talk about whatever xfs-related issues they have
 2. Find things for themselves to work on
 3. Inquire about adjacent work being done by other people
 4. Engage in transfers of information and institutional knowledge

My intent is to have a defined hour every week where anyone can drop in.
However, given the global scope of the xfs participants, I declare that
anyone who cannot make whatever time I pick should contact me to
schedule an appointment.

The first office hours will be on 11 June 2024 at 8am PDT (aka 1500 GMT)
https://oracle.zoom.us/j/92930934955?pwd=wsEYPkj7WOpvIT0E1Bb0cCBaHvj8JW.1

Immediate topics: I want to give away a bunch of projects: the ones that
have been festering in djwong-dev; and the ones merely written down on
paper.  Also the actual scheduling for this meeting since the biggest
blocker has been the near impossibility of finding any good timeslot.

--Darrick
