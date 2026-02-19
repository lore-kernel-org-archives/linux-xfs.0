Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D56340A41;
	Thu, 19 Feb 2026 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771512907; cv=none; b=NNOw5PedzzQEG4jne777/sT6TLT6IlspnJApO+RnkhqvWrwAFj/zf4zqXx6JMeQSaN3x5E4Ig5uQBm1bRD1OHuxdBogZiEhfXPIRnL/yj74tXZBgBcP8YGVZ0lwEMzfO578ihL/NDH1ELIeXzEa+kcCUJVxW4WdTStLs7hFZOKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771512907; c=relaxed/simple;
	bh=06mXK+IUiNxgJCIWsDvTsADe49n8+9BLC2r3oL7Rs+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qpwjdt97r0nabdCGBLSPnvJ+upO58nivm0kMLUOtnjah3WztC4IMfA09gz+Kr4fm/GOjO7AP2i++Nc8wRSTOCXxQqJ6M5lVLEEzcmTyE/p5OXB93WpOmnLiQQxieJMex8Dffgd8AlPhqMeXxZvsBRzoE7E7fYbCVI5EjmAfS42o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c33aXwNU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c33aXwNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF83C116D0;
	Thu, 19 Feb 2026 14:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771512907;
	bh=06mXK+IUiNxgJCIWsDvTsADe49n8+9BLC2r3oL7Rs+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c33aXwNUEw3ujB1kAFI0BG+KfHUAynHPPvZYyZO1nShIoPvMpdxdSRedTzEkW5Bzz
	 WKIClv0R6mbATpm2yJH4oMONAPlUZtSwJIzQ8fpKSP91ZShzs4+dpobSyZVweF4Z2W
	 j01oKbE/5sJIry4DTtLjx5dGShJ7HN0JouBt61Ub8Qdqyi59g4k2ZDOZqzgQh3BAqu
	 OmORoffmVLiYy0ZqAzxfBVx8FL1nKQLIaYPOBhMK0gEv1gbUkOgZQxkVPX/dh8CnZT
	 MlvqkxtK22RvZKszVEH1pCWXMJAM1qax4MXJ2jGiMrnHxVOj3LpLBSAQybQ163TSXk
	 3y6FNkZVbgemA==
Date: Thu, 19 Feb 2026 15:55:02 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>, djwong@kernel.org, 
	hch@infradead.org, david@fromorbit.com, zlang@kernel.org, linux-xfs@vger.kernel.org, 
	fstests@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com, 
	hsiangkao@linux.alibaba.com
Subject: Re: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
Message-ID: <aZci9Fz8NgXhrUSa@nidhogg.toxiclabs.cc>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
 <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
 <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
 <dd1b584b-987c-4dce-b84c-c9fe74687e95@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd1b584b-987c-4dce-b84c-c9fe74687e95@gmail.com>

On Thu, Feb 19, 2026 at 08:10:50PM +0530, Nirjhar Roy (IBM) wrote:
> 
> On 2/19/26 18:25, Carlos Maiolino wrote:
> > On Thu, Feb 19, 2026 at 06:10:48AM +0000, Nirjhar Roy (IBM) wrote:
> > > From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> > > 
> > > This series adds several tests to validate the XFS realtime fs growth and
> > > shrink functionality.
> > > It begins with the introduction of some preconditions and helper
> > > functions, then some tests that validate realtime group growth, followed
> > > by realtime group shrink/removal tests and ends with a test that
> > > validates both growth and shrink functionality together.
> > > Individual patches have the details.
> > Please don't send new versions in reply to the old one, it just make
> > hard to pull patches from the list. b4 usually doesn't handle it
> > gracefully.
> 
> This entire series is new i.e, the kernel changes, fstests and the xfsprogs
> changes. Can you please explain as to what do you mean by the old version?
> Which old are version are you referring to?

Sure, I said 'old version' but the same applies to sending them in reply
to other series/patches.

This series was sent:

In-Reply-To: <20260219055737.769860-1-nirjhar@linux.ibm.com>

which is:

Subject: xfs: Add support for multi rtgroup shrink+removal


In better wording, please don't nest series under other series/patches,
or things like that. It works in some point cases, but in general it
just makes my life difficult to pull them from the list.


> 
> --NR
> 
> > 
> > > Nirjhar Roy (IBM) (7):
> > >    xfs: Introduce _require_realtime_xfs_{shrink,grow} pre-condition
> > >    xfs: Introduce helpers to count the number of bitmap and summary
> > >      inodes
> > >    xfs: Add realtime group grow tests
> > >    xfs: Add multi rt group grow + shutdown + recovery tests
> > >    xfs: Add realtime group shrink tests
> > >    xfs: Add multi rt group shrink + shutdown + recovery tests
> > >    xfs: Add parallel back to back grow/shrink tests
> > > 
> > >   common/xfs        |  65 +++++++++++++++-
> > >   tests/xfs/333     |  95 +++++++++++++++++++++++
> > >   tests/xfs/333.out |   5 ++
> > >   tests/xfs/539     | 190 ++++++++++++++++++++++++++++++++++++++++++++++
> > >   tests/xfs/539.out |  19 +++++
> > >   tests/xfs/611     |  97 +++++++++++++++++++++++
> > >   tests/xfs/611.out |   5 ++
> > >   tests/xfs/654     |  90 ++++++++++++++++++++++
> > >   tests/xfs/654.out |   5 ++
> > >   tests/xfs/655     | 151 ++++++++++++++++++++++++++++++++++++
> > >   tests/xfs/655.out |  13 ++++
> > >   11 files changed, 734 insertions(+), 1 deletion(-)
> > >   create mode 100755 tests/xfs/333
> > >   create mode 100644 tests/xfs/333.out
> > >   create mode 100755 tests/xfs/539
> > >   create mode 100644 tests/xfs/539.out
> > >   create mode 100755 tests/xfs/611
> > >   create mode 100644 tests/xfs/611.out
> > >   create mode 100755 tests/xfs/654
> > >   create mode 100644 tests/xfs/654.out
> > >   create mode 100755 tests/xfs/655
> > >   create mode 100644 tests/xfs/655.out
> > > 
> > > -- 
> > > 2.34.1
> > > 
> > > 
> -- 
> Nirjhar Roy
> Linux Kernel Developer
> IBM, Bangalore
> 
