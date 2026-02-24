Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E331D38E12A;
	Tue, 24 Feb 2026 13:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771938273; cv=none; b=aAYMjQoSYkBiB0owmf9wll+/uiJKt9S3lJbI/yDUOAD9oLiORdOrdgHmvTEJn/2CI/Vq2CwQiPosa3MIzpRGsVagI/1vgeUdCiEYIkwnwZ41KF9GWyZeBrdC9HEO9LiEaxnjjq3Lyz+92Q4BuOfdEZt8NWUmlEOtmYfIvvnTkEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771938273; c=relaxed/simple;
	bh=xgLyZAQhQw3pnjAeT+R/MYvLmWliB0F6fJY5uRziFfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NsBP1um7Khjz0l+4n/iYXd2VQ5HeunDYxmjK/1VVMUzf3qiNG9/Vta9BYK9kntJtXBXfp++x46G/ZxXg7njxc6+b1vzlIKNTxKZ7ZBwRP/0TZJm+R6pC4mMQvv85EBp4/Y1m1cx85ha0+lq6oBfcJe3D7ZwMftvGibPZGW4rnlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rdOP9Sdo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rdOP9Sdo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10227C116D0;
	Tue, 24 Feb 2026 13:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771938272;
	bh=xgLyZAQhQw3pnjAeT+R/MYvLmWliB0F6fJY5uRziFfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rdOP9SdowZhEVeiU4LUkDrySCcyRnry33x+bjs8H6gxtSLNoixoMOpxRRVLknMqZF
	 J7KsLD4Fl7A6OUQ6l/M75Dv+gymdZtv41ruop61ORRPef27yfZPUowC04qzGW18rRT
	 GIHI3rdwawPShUmhh/MyHGDAg0V3aAYkpQ/lfdiiDmUXjR2ix07xvMK2WZCBZzZeaG
	 iUtCGPeY5HQ01IQwYZvu7c7/27/bNmVY5gWaX4oB2jPARLO9nyf9RGFGKEhaqONUjc
	 ZKFd922+EfMPpg/QDKvXgQ8EZgOZ1LlxcClNj843+zCUnrXEDQ3DvM+4P2on8AxLvF
	 B2OByyJSIWJOw==
Date: Tue, 24 Feb 2026 14:04:27 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, hch@infradead.org, 
	david@fromorbit.com, zlang@kernel.org, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com, 
	hsiangkao@linux.alibaba.com
Subject: Re: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
Message-ID: <aZ2hkUiwLa-7ZoVd@nidhogg.toxiclabs.cc>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
 <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
 <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
 <dd1b584b-987c-4dce-b84c-c9fe74687e95@gmail.com>
 <aZci9Fz8NgXhrUSa@nidhogg.toxiclabs.cc>
 <20260219154936.GF6490@frogsfrogsfrogs>
 <a3c85a2e0dff0d43ec66621c6fa530c66ec1c88e.camel@gmail.com>
 <20260220161015.GV6490@frogsfrogsfrogs>
 <9f4acd07-b8dd-45ff-b40a-4d135be3155d@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9f4acd07-b8dd-45ff-b40a-4d135be3155d@gmail.com>

On Fri, Feb 20, 2026 at 11:42:06PM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 2/20/26 21:40, Darrick J. Wong wrote:
> > On Fri, Feb 20, 2026 at 04:54:57PM +0530, Nirjhar Roy (IBM) wrote:
> > > On Thu, 2026-02-19 at 07:49 -0800, Darrick J. Wong wrote:
> > > > On Thu, Feb 19, 2026 at 03:55:02PM +0100, Carlos Maiolino wrote:
> > > > > On Thu, Feb 19, 2026 at 08:10:50PM +0530, Nirjhar Roy (IBM) wrote:
> > > > > > On 2/19/26 18:25, Carlos Maiolino wrote:
> > > > > > > On Thu, Feb 19, 2026 at 06:10:48AM +0000, Nirjhar Roy (IBM) wrote:
> > > > > > > > From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> > > > > > > > 
> > > > > > > > This series adds several tests to validate the XFS realtime fs growth and
> > > > > > > > shrink functionality.
> > > > > > > > It begins with the introduction of some preconditions and helper
> > > > > > > > functions, then some tests that validate realtime group growth, followed
> > > > > > > > by realtime group shrink/removal tests and ends with a test that
> > > > > > > > validates both growth and shrink functionality together.
> > > > > > > > Individual patches have the details.
> > > > > > > Please don't send new versions in reply to the old one, it just make
> > > > > > > hard to pull patches from the list. b4 usually doesn't handle it
> > > > > > > gracefully.
> > > > > > This entire series is new i.e, the kernel changes, fstests and the xfsprogs
> > > > > > changes. Can you please explain as to what do you mean by the old version?
> > > > > > Which old are version are you referring to?
> > > > > Sure, I said 'old version' but the same applies to sending them in reply
> > > > > to other series/patches.
> > > > > 
> > > > > This series was sent:
> > > > > 
> > > > > In-Reply-To: <20260219055737.769860-1-nirjhar@linux.ibm.com>
> > > > > 
> > > > > which is:
> > > > > 
> > > > > Subject: xfs: Add support for multi rtgroup shrink+removal
> > > > > 
> > > > > 
> > > > > In better wording, please don't nest series under other series/patches,
> > > > > or things like that. It works in some point cases, but in general it
> > > > > just makes my life difficult to pull them from the list.
> > > > Pull requests, perhaps?
> > > > 
> > > > Or is the problem here that you're using b4/korgalore/etc to download
> > > > patchmails so that you can read them outside of a MUA?
> > > > 
> > > > ((Again, I'll express a wish that people push their branches to
> > > > git.kernel.org and send a link in the cover letter; that's much easier
> > > > for me to pull and examine than reading emails or prying individual
> > > > maybe-MTA-corrupted emails out of mutt into applyable form...))
> > > Okay, I will keep this in mind. I was under the impression that only
> > > maintainers can have their private branches in git.kernel.org. I will
> > Anyone with a kernel.org account can push git repos.
> 
> https://korg.docs.kernel.org/accounts.html
> 
> It says the following:
> 
> Getting a kernel.org account
> Kernel.org accounts are reserved for Linux kernel maintainers or
> high-profile developers. If you do not fall under one of these two
> categories, it’s unlikely that an account will be issued to you.
> 
> 
> In that case, should I use GitHub?

No, I'm not taking pull requests from github. Please keep sending
patches to the list.

> 
> > 
> > github kinda works too, though I am a Bad Microsoft Citizen(tm) so they
> > arbitrarily claim on first access that I'm over a rate limit that they
> > do not specify.  Granted that makes them a Bad Provider(tm) but I doubt
> > they hear me above all the AI noise.
> Okay.
> > 
> > > check on how to create a branch in git.kernel.org. For now, is it okay
> > > to just send the branch link as a separate email reply and you can
> > > take a look - next revision onwards I will have the link in the cover
> > > letter itself?
> > Sounds fine to me.
> 
> Thank you.
> 
> --NR
> 
> > 
> > --D
> > 
> > > --NR
> > > > --D
> > > > 
> > > > > > --NR
> > > > > > 
> > > > > > > > Nirjhar Roy (IBM) (7):
> > > > > > > >     xfs: Introduce _require_realtime_xfs_{shrink,grow} pre-condition
> > > > > > > >     xfs: Introduce helpers to count the number of bitmap and summary
> > > > > > > >       inodes
> > > > > > > >     xfs: Add realtime group grow tests
> > > > > > > >     xfs: Add multi rt group grow + shutdown + recovery tests
> > > > > > > >     xfs: Add realtime group shrink tests
> > > > > > > >     xfs: Add multi rt group shrink + shutdown + recovery tests
> > > > > > > >     xfs: Add parallel back to back grow/shrink tests
> > > > > > > > 
> > > > > > > >    common/xfs        |  65 +++++++++++++++-
> > > > > > > >    tests/xfs/333     |  95 +++++++++++++++++++++++
> > > > > > > >    tests/xfs/333.out |   5 ++
> > > > > > > >    tests/xfs/539     | 190 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > > > > >    tests/xfs/539.out |  19 +++++
> > > > > > > >    tests/xfs/611     |  97 +++++++++++++++++++++++
> > > > > > > >    tests/xfs/611.out |   5 ++
> > > > > > > >    tests/xfs/654     |  90 ++++++++++++++++++++++
> > > > > > > >    tests/xfs/654.out |   5 ++
> > > > > > > >    tests/xfs/655     | 151 ++++++++++++++++++++++++++++++++++++
> > > > > > > >    tests/xfs/655.out |  13 ++++
> > > > > > > >    11 files changed, 734 insertions(+), 1 deletion(-)
> > > > > > > >    create mode 100755 tests/xfs/333
> > > > > > > >    create mode 100644 tests/xfs/333.out
> > > > > > > >    create mode 100755 tests/xfs/539
> > > > > > > >    create mode 100644 tests/xfs/539.out
> > > > > > > >    create mode 100755 tests/xfs/611
> > > > > > > >    create mode 100644 tests/xfs/611.out
> > > > > > > >    create mode 100755 tests/xfs/654
> > > > > > > >    create mode 100644 tests/xfs/654.out
> > > > > > > >    create mode 100755 tests/xfs/655
> > > > > > > >    create mode 100644 tests/xfs/655.out
> > > > > > > > 
> > > > > > > > -- 
> > > > > > > > 2.34.1
> > > > > > > > 
> > > > > > > > 
> > > > > > -- 
> > > > > > Nirjhar Roy
> > > > > > Linux Kernel Developer
> > > > > > IBM, Bangalore
> > > > > > 
> > > 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 
> 
