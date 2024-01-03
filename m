Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0285C10F1
	for <linux-xfs@vger.kernel.org>; Wed,  3 Jan 2024 01:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AzfOiMUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56914C433C7;
	Wed,  3 Jan 2024 01:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704244993;
	bh=ZjvKjmaxzpBtRc14BbdWJpy2dF4/DbggKKYt/IOvt5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AzfOiMUgwqK800AI0MdIByDRJDZFNFvi0MU97NHDzgHmSJjVyBWS+alVdVU7nGk2d
	 p+pcVLumfCormnkimpAcwJgvyiBlDasGwNDSVZROj5CYvM5xf2dtxsOgncagjdvaZ9
	 Q0rHqQnhHX8j3Kr2bP1eor/30S64urb4+mwvQYW8KzVCrsSaE1Otj4T91iQL7oxQTA
	 oHPTSwuZmPN7uv5Q1BT11n4R+s/skFwERkPjksWJcLOy6ww2vdx1LcFwQKXpYWjbYv
	 EvwthDiypxOvN8vQq4vqYoqT5qS+r24jEwU+flNeYe1ppR8sStxNNxS/MDVYiTDD1c
	 7Rall3nwFiYMg==
Date: Tue, 2 Jan 2024 17:23:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Neal Gompa <neal@gompa.dev>
Cc: cem@kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET v29.0 34/40] xfs_scrub: fixes for systemd services
Message-ID: <20240103012312.GD361584@frogsfrogsfrogs>
References: <20231231181215.GA241128@frogsfrogsfrogs>
 <170405001841.1800712.6745668619742020884.stgit@frogsfrogsfrogs>
 <CAEg-Je_ynMS2Xz+kWje7Ym=BMaK=_hvHfymj2SOvG-icxJ7vkw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEg-Je_ynMS2Xz+kWje7Ym=BMaK=_hvHfymj2SOvG-icxJ7vkw@mail.gmail.com>

On Sun, Dec 31, 2023 at 03:25:41PM -0500, Neal Gompa wrote:
> On Sun, Dec 31, 2023 at 2:48 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > Hi all,
> >
> > This series fixes deficiencies in the systemd services that were created
> > to manage background scans.  First, improve the debian packaging so that
> > services get installed at package install time.  Next, fix copyright and
> > spdx header omissions.
> >
> > Finally, fix bugs in the mailer scripts so that scrub failures are
> > reported effectively.  Finally, fix xfs_scrub_all to deal with systemd
> > restarts causing it to think that a scrub has finished before the
> > service actually finishes.
> >
> > If you're going to start using this code, I strongly recommend pulling
> > from my git trees, which are linked below.
> >
> > This has been running on the djcloud for months with no problems.  Enjoy!
> > Comments and questions are, as always, welcome.
> >
> > --D
> >
> > xfsprogs git tree:
> > https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-service-fixes
> > ---
> >  debian/rules                     |    1 +
> >  include/builddefs.in             |    2 +-
> >  scrub/Makefile                   |   26 ++++++++++++++------
> >  scrub/xfs_scrub@.service.in      |    6 ++---
> >  scrub/xfs_scrub_all.in           |   49 ++++++++++++++++----------------------
> >  scrub/xfs_scrub_fail.in          |   12 ++++++++-
> >  scrub/xfs_scrub_fail@.service.in |    4 ++-
> >  7 files changed, 55 insertions(+), 45 deletions(-)
> >  rename scrub/{xfs_scrub_fail => xfs_scrub_fail.in} (62%)
> >
> 
> In your Makefile changes, you should be able to drop
> PKG_LIB_SCRIPT_DIR entirely from your Makefiles since it should be
> unused now, can you fold that into
> https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/commit/?h=scrub-service-fixes&id=1e0dce5c54270f1813f5661c266989917f08baf8
> ?

Already done in:

https://lore.kernel.org/linux-xfs/170405001964.1800712.10514067731814883862.stgit@frogsfrogsfrogs/

Sorry I forgot to cc you there.

--D

> 
> 
> -- 
> 真実はいつも一つ！/ Always, there's only one truth!
> 
