Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21C83F7A9F;
	Tue, 25 Aug 2026 11:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787658589; cv=none; b=LyAXR8QlJYIufe/Uec+g3X8Fb3IHJ1lqb0anH99TRGXOEoQSOf1Z20U+LRS/qxRsDyVP7k60MVQTGu5qFoPaJ7Xb3GiGISBptYd7Ljlb1GCFrrH0A+7NA7uGmnzFYPKiwFi1HfNAy/W2bdz29+TLu2ZMbUbc5po5m5ixG5K5xvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787658589; c=relaxed/simple;
	bh=JbBXzRFycmY4S3NWsQai8RiVbF724BMidBw7DmD+dwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJjgZcMEMeq4AALtAIpOM0+eXOmo9Psq6RUL/bGX9DNwT4zxd3ZA7vw8GnfZuWZaJpZjm/rupgSL8NgttHAgdurBNRxtAssBhC9cozDcxaSWmGZsmZkWR5GyPWhVHiUJpjhT7BlsELR+jQLU2JrYQ569Tv+G1NmUkZepGkdYr7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUVLsqgI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUVLsqgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD00E1F00A3E;
	Tue, 25 Aug 2026 11:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787658585;
	bh=pGsMf342zeMGHdOXE/moYI66XDqk2BCoh5HhxRCWIeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUVLsqgIeCbShWJKxOUCyGmH3/EBGoBLRnW9lfCJYIURGMv/LtouH05aBb1hlM5h/
	 a/NkNUBT6rOSU8cm52g1UUZ7FNoS5g8DhbJ/5flkMbRU0kQzAKnOYBFPAQUL1h+M7O
	 Dr7Eg250nfzLMl9U2MoPzq7sOc2XZYQWgM+kWI/6Nx2JQDYWcbw2fbiqY+MO6rO0pg
	 oK339Bwd0F+52T/ZHfj2MeDr5dh6E1QsP55xC1BjQrVkCUJhKKMpmaa4vCARFCfN//
	 TEFUmjgEaJKyi6PUlVsEPNuZPWNMhAmHuA/upkfP7+xJdwxbEt3y/gtzGC+mDjfktM
	 75F+k0z+cNn2A==
From: Sasha Levin <sashal@kernel.org>
To: "Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	linux-kernel@vger.kernel.org,
	Joanne Koong <joannelkoong@gmail.com>,
	syzbot@syzkaller.appspotmail.com,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Greg KH <greg@kroah.com>
Subject: Re: [PATCH 5.10.y] iomap: adjust read range correctly for non-block-aligned positions
Date: Tue, 25 Aug 2026 07:49:27 -0400
Message-ID: <202608250005.0b3345f7a7f0ed5a@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026082434-freeway-legwarmer-84e6@gregkh>
References: <2026082434-freeway-legwarmer-84e6@gregkh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Aug 24, 2026 at 03:52:45PM +0200, Greg KH wrote:
> Don't we also need this for 5.15.y first?

Queued for 5.15 first and then 5.10, thanks.

-- 
Thanks,
Sasha
