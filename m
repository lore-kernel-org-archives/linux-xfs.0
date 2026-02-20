Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F291A254E;
	Fri, 20 Feb 2026 16:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771603816; cv=none; b=m9a6Urqz147S1+/mrbvYpgM7qPjJoKKnnoUlXl3yFs5j5s2yK+Sf2yS8uY/A3jVLYFzx4L/k+j4qrRQ+MULIC0fKUR8CT/2FyyRPaQN3SQ2q4vTdbTDGXbCPvevmaN5A78YV91jP/+r1/dXHdl5z+TU/4TtIK2rUHngryzAnMbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771603816; c=relaxed/simple;
	bh=OT1Vm5Kv1fNHgyFZ14JyV/Oztuo+aoBWV8e3GREWcI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R4VsqK0gHFJ6qpcY/EG343/jkp6B2/9jQl9gz+n8P4r73F1kvNPxmPrDLQL0+koqxhLwChGXOtbZipv5bn9lhQanCCW2yWmdjndANPspGz265Cteq830eSIoKijEIv4Orio54UzXiQcDgjlEZnHotIm8QLGw8VnBEiZQBzyg15c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EFapNoHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EFapNoHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D631C116C6;
	Fri, 20 Feb 2026 16:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771603816;
	bh=OT1Vm5Kv1fNHgyFZ14JyV/Oztuo+aoBWV8e3GREWcI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EFapNoHfAHQhDJ/BYQEZHYIItbEiAKIQRQrqX4dO8LqSeBzsKn3JdhYyz3wW+gWXo
	 riXm2g5KAZxcwLUuUzfahzxRgng2hk9ywIb9IOZTAp6FP9RucpowiIEwJn0SlSbVEX
	 X3AyeiG53Gqvz3LvISGutd9P9M5zO0OfZhPdlxtvgDEmPE23StyBatd/h+2BQpZxrc
	 /qRxi8KzIITAlsVclkyRjzdLkRRaZpEgT+8EI6//WAv2Tw1WKHw5QCzNrYWhMjK53q
	 pjfLyYWSsZUOv15Aya1sdgfeoNcbfb2qk0v0gdD4kiHw5EDKga0scxbw3ZhzE/HpsN
	 th0x9PyCqEJ7w==
Date: Fri, 20 Feb 2026 08:10:15 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, hch@infradead.org,
	david@fromorbit.com, zlang@kernel.org, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
Subject: Re: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
Message-ID: <20260220161015.GV6490@frogsfrogsfrogs>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
 <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
 <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
 <dd1b584b-987c-4dce-b84c-c9fe74687e95@gmail.com>
 <aZci9Fz8NgXhrUSa@nidhogg.toxiclabs.cc>
 <20260219154936.GF6490@frogsfrogsfrogs>
 <a3c85a2e0dff0d43ec66621c6fa530c66ec1c88e.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3c85a2e0dff0d43ec66621c6fa530c66ec1c88e.camel@gmail.com>

On Fri, Feb 20, 2026 at 04:54:57PM +0530, Nirjhar Roy (IBM) wrote:
> On Thu, 2026-02-19 at 07:49 -0800, Darrick J. Wong wrote:
> > On Thu, Feb 19, 2026 at 03:55:02PM +0100, Carlos Maiolino wrote:
> > > On Thu, Feb 19, 2026 at 08:10:50PM +0530, Nirjhar Roy (IBM) wrote:
> > > > On 2/19/26 18:25, Carlos Maiolino wrote:
> > > > > On Thu, Feb 19, 2026 at 06:10:48AM +0000, Nirjhar Roy (IBM) wrote:
> > > > > > From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> > > > > > 
> > > > > > This series adds several tests to validate the XFS realtime fs growth and
> > > > > > shrink functionality.
> > > > > > It begins with the introduction of some preconditions and helper
> > > > > > functions, then some tests that validate realtime group growth, followed
> > > > > > by realtime group shrink/removal tests and ends with a test that
> > > > > > validates both growth and shrink functionality together.
> > > > > > Individual patches have the details.
> > > > > Please don't send new versions in reply to the old one, it just make
> > > > > hard to pull patches from the list. b4 usually doesn't handle it
> > > > > gracefully.
> > > > 
> > > > This entire series is new i.e, the kernel changes, fstests and the xfsprogs
> > > > changes. Can you please explain as to what do you mean by the old version?
> > > > Which old are version are you referring to?
> > > 
> > > Sure, I said 'old version' but the same applies to sending them in reply
> > > to other series/patches.
> > > 
> > > This series was sent:
> > > 
> > > In-Reply-To: <20260219055737.769860-1-nirjhar@linux.ibm.com>
> > > 
> > > which is:
> > > 
> > > Subject: xfs: Add support for multi rtgroup shrink+removal
> > > 
> > > 
> > > In better wording, please don't nest series under other series/patches,
> > > or things like that. It works in some point cases, but in general it
> > > just makes my life difficult to pull them from the list.
> > 
> > Pull requests, perhaps?
> > 
> > Or is the problem here that you're using b4/korgalore/etc to download
> > patchmails so that you can read them outside of a MUA?
> > 
> > ((Again, I'll express a wish that people push their branches to
> > git.kernel.org and send a link in the cover letter; that's much easier
> > for me to pull and examine than reading emails or prying individual
> > maybe-MTA-corrupted emails out of mutt into applyable form...))
> 
> Okay, I will keep this in mind. I was under the impression that only
> maintainers can have their private branches in git.kernel.org. I will

Anyone with a kernel.org account can push git repos.

github kinda works too, though I am a Bad Microsoft Citizen(tm) so they
arbitrarily claim on first access that I'm over a rate limit that they
do not specify.  Granted that makes them a Bad Provider(tm) but I doubt
they hear me above all the AI noise.

> check on how to create a branch in git.kernel.org. For now, is it okay
> to just send the branch link as a separate email reply and you can
> take a look - next revision onwards I will have the link in the cover
> letter itself?

Sounds fine to me.

--D

> --NR
> > 
> > --D
> > 
> > > > --NR
> > > > 
> > > > > > Nirjhar Roy (IBM) (7):
> > > > > >    xfs: Introduce _require_realtime_xfs_{shrink,grow} pre-condition
> > > > > >    xfs: Introduce helpers to count the number of bitmap and summary
> > > > > >      inodes
> > > > > >    xfs: Add realtime group grow tests
> > > > > >    xfs: Add multi rt group grow + shutdown + recovery tests
> > > > > >    xfs: Add realtime group shrink tests
> > > > > >    xfs: Add multi rt group shrink + shutdown + recovery tests
> > > > > >    xfs: Add parallel back to back grow/shrink tests
> > > > > > 
> > > > > >   common/xfs        |  65 +++++++++++++++-
> > > > > >   tests/xfs/333     |  95 +++++++++++++++++++++++
> > > > > >   tests/xfs/333.out |   5 ++
> > > > > >   tests/xfs/539     | 190 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > > >   tests/xfs/539.out |  19 +++++
> > > > > >   tests/xfs/611     |  97 +++++++++++++++++++++++
> > > > > >   tests/xfs/611.out |   5 ++
> > > > > >   tests/xfs/654     |  90 ++++++++++++++++++++++
> > > > > >   tests/xfs/654.out |   5 ++
> > > > > >   tests/xfs/655     | 151 ++++++++++++++++++++++++++++++++++++
> > > > > >   tests/xfs/655.out |  13 ++++
> > > > > >   11 files changed, 734 insertions(+), 1 deletion(-)
> > > > > >   create mode 100755 tests/xfs/333
> > > > > >   create mode 100644 tests/xfs/333.out
> > > > > >   create mode 100755 tests/xfs/539
> > > > > >   create mode 100644 tests/xfs/539.out
> > > > > >   create mode 100755 tests/xfs/611
> > > > > >   create mode 100644 tests/xfs/611.out
> > > > > >   create mode 100755 tests/xfs/654
> > > > > >   create mode 100644 tests/xfs/654.out
> > > > > >   create mode 100755 tests/xfs/655
> > > > > >   create mode 100644 tests/xfs/655.out
> > > > > > 
> > > > > > -- 
> > > > > > 2.34.1
> > > > > > 
> > > > > > 
> > > > -- 
> > > > Nirjhar Roy
> > > > Linux Kernel Developer
> > > > IBM, Bangalore
> > > > 
> 
> 
