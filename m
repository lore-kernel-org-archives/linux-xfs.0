Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73433349B18;
	Thu, 19 Feb 2026 15:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771516177; cv=none; b=SuYyeUZWK4FCVfzDLYSVYjKlFalR+/o2nb+ye5x/splWjKLHtmAItyXS28BeNh2vTRJ8aOa3IUIFuHJjg9zk9FdMFaOrvUQ3NMjVussmw+Z+lQCjX0G0Xer60q4FsXiciIzcpOEYGz1O/thRYFWfDey9ELEaJ1TaEC/beMCDwFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771516177; c=relaxed/simple;
	bh=RGzbez7Ye+88S+2gcVYh43f/hCKecH1Aq+DkrRCTB30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBQzICGBvCvEwl1c07uWGB8+5cnkz3+jOytMGvI2j3FmrH1DbGEyIS92sjbLnILDrHSvE+1jCS2mUZIZG5g/sI97aYvDWKVtyzKNFkP8hieuXViW4hLPCGINZqDzc1/ESBisdbzRxp3XoveeMfesoVtbFKfCp91swZ5OL1yxTCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A0w7lZOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0w7lZOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F288C4CEF7;
	Thu, 19 Feb 2026 15:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771516177;
	bh=RGzbez7Ye+88S+2gcVYh43f/hCKecH1Aq+DkrRCTB30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A0w7lZOCAXkgndj9kOsTcyFY2aTO/R8IJR7zLlngv1BPyiEXNDVRLf9r2Zy4APR1H
	 Atu2A9blRlAH+zSfwZayQ9ZMrCDM5dR/VqlTBlrutDr3qpR5XqPAX/HFeaXTqkbxjo
	 rVUSIhn7ZxHwQHjj8l2yvvFAQgUX3m7RkW1JOByTNmLq/+rj2E2MS1NPKSEYlioNUb
	 EZaehpC+tmzFj4vhGeJalKPIlaUxqWVl1t8Hjr0yPUaKtDDznvtgjUJF3AT6aGAFJx
	 NJjkcsiFfUBJoilrXJg3/aSNhvV0ub55fFccBn2gHU8W8bLxuge/R7+bQN/hDFM4mU
	 xcQAGwSa7xzew==
Date: Thu, 19 Feb 2026 07:49:36 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	"Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>, hch@infradead.org,
	david@fromorbit.com, zlang@kernel.org, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
Subject: Re: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
Message-ID: <20260219154936.GF6490@frogsfrogsfrogs>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
 <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
 <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
 <dd1b584b-987c-4dce-b84c-c9fe74687e95@gmail.com>
 <aZci9Fz8NgXhrUSa@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZci9Fz8NgXhrUSa@nidhogg.toxiclabs.cc>

On Thu, Feb 19, 2026 at 03:55:02PM +0100, Carlos Maiolino wrote:
> On Thu, Feb 19, 2026 at 08:10:50PM +0530, Nirjhar Roy (IBM) wrote:
> > 
> > On 2/19/26 18:25, Carlos Maiolino wrote:
> > > On Thu, Feb 19, 2026 at 06:10:48AM +0000, Nirjhar Roy (IBM) wrote:
> > > > From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> > > > 
> > > > This series adds several tests to validate the XFS realtime fs growth and
> > > > shrink functionality.
> > > > It begins with the introduction of some preconditions and helper
> > > > functions, then some tests that validate realtime group growth, followed
> > > > by realtime group shrink/removal tests and ends with a test that
> > > > validates both growth and shrink functionality together.
> > > > Individual patches have the details.
> > > Please don't send new versions in reply to the old one, it just make
> > > hard to pull patches from the list. b4 usually doesn't handle it
> > > gracefully.
> > 
> > This entire series is new i.e, the kernel changes, fstests and the xfsprogs
> > changes. Can you please explain as to what do you mean by the old version?
> > Which old are version are you referring to?
> 
> Sure, I said 'old version' but the same applies to sending them in reply
> to other series/patches.
> 
> This series was sent:
> 
> In-Reply-To: <20260219055737.769860-1-nirjhar@linux.ibm.com>
> 
> which is:
> 
> Subject: xfs: Add support for multi rtgroup shrink+removal
> 
> 
> In better wording, please don't nest series under other series/patches,
> or things like that. It works in some point cases, but in general it
> just makes my life difficult to pull them from the list.

Pull requests, perhaps?

Or is the problem here that you're using b4/korgalore/etc to download
patchmails so that you can read them outside of a MUA?

((Again, I'll express a wish that people push their branches to
git.kernel.org and send a link in the cover letter; that's much easier
for me to pull and examine than reading emails or prying individual
maybe-MTA-corrupted emails out of mutt into applyable form...))

--D

> 
> > 
> > --NR
> > 
> > > 
> > > > Nirjhar Roy (IBM) (7):
> > > >    xfs: Introduce _require_realtime_xfs_{shrink,grow} pre-condition
> > > >    xfs: Introduce helpers to count the number of bitmap and summary
> > > >      inodes
> > > >    xfs: Add realtime group grow tests
> > > >    xfs: Add multi rt group grow + shutdown + recovery tests
> > > >    xfs: Add realtime group shrink tests
> > > >    xfs: Add multi rt group shrink + shutdown + recovery tests
> > > >    xfs: Add parallel back to back grow/shrink tests
> > > > 
> > > >   common/xfs        |  65 +++++++++++++++-
> > > >   tests/xfs/333     |  95 +++++++++++++++++++++++
> > > >   tests/xfs/333.out |   5 ++
> > > >   tests/xfs/539     | 190 ++++++++++++++++++++++++++++++++++++++++++++++
> > > >   tests/xfs/539.out |  19 +++++
> > > >   tests/xfs/611     |  97 +++++++++++++++++++++++
> > > >   tests/xfs/611.out |   5 ++
> > > >   tests/xfs/654     |  90 ++++++++++++++++++++++
> > > >   tests/xfs/654.out |   5 ++
> > > >   tests/xfs/655     | 151 ++++++++++++++++++++++++++++++++++++
> > > >   tests/xfs/655.out |  13 ++++
> > > >   11 files changed, 734 insertions(+), 1 deletion(-)
> > > >   create mode 100755 tests/xfs/333
> > > >   create mode 100644 tests/xfs/333.out
> > > >   create mode 100755 tests/xfs/539
> > > >   create mode 100644 tests/xfs/539.out
> > > >   create mode 100755 tests/xfs/611
> > > >   create mode 100644 tests/xfs/611.out
> > > >   create mode 100755 tests/xfs/654
> > > >   create mode 100644 tests/xfs/654.out
> > > >   create mode 100755 tests/xfs/655
> > > >   create mode 100644 tests/xfs/655.out
> > > > 
> > > > -- 
> > > > 2.34.1
> > > > 
> > > > 
> > -- 
> > Nirjhar Roy
> > Linux Kernel Developer
> > IBM, Bangalore
> > 
> 
