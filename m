Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40FF32FA19
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 11:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771586705; cv=none; b=pT15RxDiLgTjp4FGbFMLgJi+VkfeOpKpcY7s2Q073McIP5E3BnsQ04cFO1eUf6WqkxaDs/vUiUcGDuuCaQYAFYKmILcV7BpB4MBj5frzUGA8P1/Pop6kczIomcJnfGPU+w997NxBydvcgi3dRw6NDxvoNzjSx71+n9j5ME3yDpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771586705; c=relaxed/simple;
	bh=2dennQKMkRJCynngueyP9oPrnxBtQuWhbz8YfdeXqEc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Mime-Version; b=K95ri5KIoRf0GbL9corEy1kpYoSSkiwSndYKOZP8J17cPwVvNV0MouwvZ87LLbwJ+SR1+DOZj7V5m18MeOj2zYgY0oy/tMfLLqZoWk5TpvWAdkIkfwwJVIxNxNPzAp4V2tvQv1V8/rVu1FxHHN6D8fWafRB8JhmsrXMlE26pl98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JXtwsGov; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JXtwsGov"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c6e734ba92bso988765a12.3
        for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 03:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771586703; x=1772191503; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YDelXhPZsDHZGWlu8wIOsqxxLfVdFCkPWhNyGRd3dA8=;
        b=JXtwsGovHAvImavawUPlvLkKZ9+x7JnrBQL05SoGPNdueAPRaTLVMfk45Lhp4gdetM
         Momv47mkGPN9U4vNQEEPcuPfrO3uznyaERrfaasLqkCCngCe2N4gQM+fcxc5520WHLi5
         OMEKwUAjecVX2cgIe8nae8IDld7MvdAbb6OVHrgX/VEkod9lFnnFm2zpyNYfHZLazeZF
         8uPTbkBfkJP6gyJIbY1nPn8H77JuolfYo0KwOC8BikdAhE9aBfrtAXDUrMLzi1na1Bcf
         C8q6ojt/UyGz9l6Ceo8DxXpHO2L83ucYSRufL1jPj7OrjcGRRZvF7o0wEG+4UxXIDsjz
         4wLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771586703; x=1772191503;
        h=content-transfer-encoding:mime-version:references:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YDelXhPZsDHZGWlu8wIOsqxxLfVdFCkPWhNyGRd3dA8=;
        b=evVEhNoIBWX+GsHBvUCsfmmWwDcavurYhTlYd9GngmwqeOcYeEL2okcnpEL0D9NMw9
         U4JyNmb8xHi0qtMf4dbONSyMIj0GLo6c/rrLcjLFQi01lUSQEXVHzv4hmhHSv7EQcRSp
         TBM6P5avXuwh3ojPQ5JBuNMJCmNKgRFRq7WcN1YEQbFeqmBGHZ6PrLAvW3DTZUud90/I
         wR+OFpZiICU6SBoFKc9FEA4WRSIjCQ88XBRWWOpICD3CkvZQFYypw4W2T/MmyQp5O5/H
         2uAtXK80PPxkyktAeTjvuS2ZHFgoj2NPSbqDlGgtoQ9fdnMf/aag9OlyvFe8PG+a5ab8
         0/tw==
X-Forwarded-Encrypted: i=1; AJvYcCUU1A2iSiu1me8lSYL33EQNd8YB2H6WTGhuGuQK4YW7GVHYwQJV7k91GhFLFlXoFQ1sOqpGWUOJR4c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4LHJ5SQIeTby0wpMRYIuZUF7BtM3PUTTed19sl89qliE4+Jwg
	vqCvXc0FZvKvlco2fydGeouBjTeUmnnexcJ0yenZdoN/nXm4Gqvb5evq
X-Gm-Gg: AZuq6aKwSaCvhinxKKv7WKYZERhfYf3XALSEouEFMpRU5aNknPawD5MHVwg4CvXTAwI
	ztGX2DAEvyyHePL9xoTPilUEcWHh7417NazUykYA3/VXTSZx1SbgQjRpfo3EqGSwAdbLyLOWOm/
	4AmJN5COHTw9rWFco8/Fu5gwzGIJn8/LmYliC5ovmtViFzLsPXIxoamieuXxuAmAg5Ogd08o9B4
	RccxI56/U3nv+oC3a2ZJa8zDqjRyptkwGv4hcM3In8z2lC0dvSeA9i/UVLu3tnDtB1TnuXIQnKN
	bmgFa28GtGPSIIF09HYdc/otI0yMqh4bZvD8qdDRN19AYGzD4XmUF+dmLTgnsZ3RJIEAkDUewfh
	PRoYnoaHnMl79ITwZc6i12tJpqWIFSKm2qpoHqHslKyhQeR0jmZsQG1hW/M3zrJUsel0TcnFSp9
	D/I7jenaKdcD0F0H8ZNQjvMvfQc0v8T8DS0hUhg376jSPw6fpG8+Rc8f7GTRx4LOOXys7DszgLr
	GWB
X-Received: by 2002:a17:903:1a8d:b0:2aa:d5ea:4cfb with SMTP id d9443c01a7336-2ad1740c597mr172658085ad.9.1771586703054;
        Fri, 20 Feb 2026 03:25:03 -0800 (PST)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com ([49.207.233.114])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3589d7f1b9dsm4391561a91.4.2026.02.20.03.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 03:25:02 -0800 (PST)
Message-ID: <a3c85a2e0dff0d43ec66621c6fa530c66ec1c88e.camel@gmail.com>
Subject: Re: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
To: "Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>
Cc: hch@infradead.org, david@fromorbit.com, zlang@kernel.org, 
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com, 
	ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
Date: Fri, 20 Feb 2026 16:54:57 +0530
In-Reply-To: <20260219154936.GF6490@frogsfrogsfrogs>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
	 <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
	 <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
	 <dd1b584b-987c-4dce-b84c-c9fe74687e95@gmail.com>
	 <aZci9Fz8NgXhrUSa@nidhogg.toxiclabs.cc>
	 <20260219154936.GF6490@frogsfrogsfrogs>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-27.el8_10) 
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2026-02-19 at 07:49 -0800, Darrick J. Wong wrote:
> On Thu, Feb 19, 2026 at 03:55:02PM +0100, Carlos Maiolino wrote:
> > On Thu, Feb 19, 2026 at 08:10:50PM +0530, Nirjhar Roy (IBM) wrote:
> > > On 2/19/26 18:25, Carlos Maiolino wrote:
> > > > On Thu, Feb 19, 2026 at 06:10:48AM +0000, Nirjhar Roy (IBM) wrote:
> > > > > From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> > > > > 
> > > > > This series adds several tests to validate the XFS realtime fs growth and
> > > > > shrink functionality.
> > > > > It begins with the introduction of some preconditions and helper
> > > > > functions, then some tests that validate realtime group growth, followed
> > > > > by realtime group shrink/removal tests and ends with a test that
> > > > > validates both growth and shrink functionality together.
> > > > > Individual patches have the details.
> > > > Please don't send new versions in reply to the old one, it just make
> > > > hard to pull patches from the list. b4 usually doesn't handle it
> > > > gracefully.
> > > 
> > > This entire series is new i.e, the kernel changes, fstests and the xfsprogs
> > > changes. Can you please explain as to what do you mean by the old version?
> > > Which old are version are you referring to?
> > 
> > Sure, I said 'old version' but the same applies to sending them in reply
> > to other series/patches.
> > 
> > This series was sent:
> > 
> > In-Reply-To: <20260219055737.769860-1-nirjhar@linux.ibm.com>
> > 
> > which is:
> > 
> > Subject: xfs: Add support for multi rtgroup shrink+removal
> > 
> > 
> > In better wording, please don't nest series under other series/patches,
> > or things like that. It works in some point cases, but in general it
> > just makes my life difficult to pull them from the list.
> 
> Pull requests, perhaps?
> 
> Or is the problem here that you're using b4/korgalore/etc to download
> patchmails so that you can read them outside of a MUA?
> 
> ((Again, I'll express a wish that people push their branches to
> git.kernel.org and send a link in the cover letter; that's much easier
> for me to pull and examine than reading emails or prying individual
> maybe-MTA-corrupted emails out of mutt into applyable form...))

Okay, I will keep this in mind. I was under the impression that only maintainers can have their
private branches in git.kernel.org. I will check on how to create a branch in git.kernel.org. For
now, is it okay to just send the branch link as a separate email reply and you can take a look -
next revision onwards I will have the link in the cover letter itself?
--NR
> 
> --D
> 
> > > --NR
> > > 
> > > > > Nirjhar Roy (IBM) (7):
> > > > >    xfs: Introduce _require_realtime_xfs_{shrink,grow} pre-condition
> > > > >    xfs: Introduce helpers to count the number of bitmap and summary
> > > > >      inodes
> > > > >    xfs: Add realtime group grow tests
> > > > >    xfs: Add multi rt group grow + shutdown + recovery tests
> > > > >    xfs: Add realtime group shrink tests
> > > > >    xfs: Add multi rt group shrink + shutdown + recovery tests
> > > > >    xfs: Add parallel back to back grow/shrink tests
> > > > > 
> > > > >   common/xfs        |  65 +++++++++++++++-
> > > > >   tests/xfs/333     |  95 +++++++++++++++++++++++
> > > > >   tests/xfs/333.out |   5 ++
> > > > >   tests/xfs/539     | 190 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > >   tests/xfs/539.out |  19 +++++
> > > > >   tests/xfs/611     |  97 +++++++++++++++++++++++
> > > > >   tests/xfs/611.out |   5 ++
> > > > >   tests/xfs/654     |  90 ++++++++++++++++++++++
> > > > >   tests/xfs/654.out |   5 ++
> > > > >   tests/xfs/655     | 151 ++++++++++++++++++++++++++++++++++++
> > > > >   tests/xfs/655.out |  13 ++++
> > > > >   11 files changed, 734 insertions(+), 1 deletion(-)
> > > > >   create mode 100755 tests/xfs/333
> > > > >   create mode 100644 tests/xfs/333.out
> > > > >   create mode 100755 tests/xfs/539
> > > > >   create mode 100644 tests/xfs/539.out
> > > > >   create mode 100755 tests/xfs/611
> > > > >   create mode 100644 tests/xfs/611.out
> > > > >   create mode 100755 tests/xfs/654
> > > > >   create mode 100644 tests/xfs/654.out
> > > > >   create mode 100755 tests/xfs/655
> > > > >   create mode 100644 tests/xfs/655.out
> > > > > 
> > > > > -- 
> > > > > 2.34.1
> > > > > 
> > > > > 
> > > -- 
> > > Nirjhar Roy
> > > Linux Kernel Developer
> > > IBM, Bangalore
> > > 

