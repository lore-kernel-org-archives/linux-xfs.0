Received: from sandeen.net (sandeen.net [63.231.237.45])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06D06F068
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 22:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.231.237.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721861421; cv=none; b=GK75ujTUNUssO0wKI3QojZdvbUkwMHRSIOG+ZhKI3fEH8J2q8zvk7ZygDxnqw4hUGHy5ukEwdiZw/DhPA0CdbRFAB9Ddv2OiAp4r/1PRNbXKAUJYetloOtzU+ookQZDjiN1AXfWB/WM8fKp/ElkG9H1RFOmyryi/HXmL8nXNZmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721861421; c=relaxed/simple;
	bh=PfFg7bI0qhUQv/OUqtWMYVKydwqZbPfiWq821R30bYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PMBFiZUR9WPZLBj5jM+X1SL4LL9x/lQHVKcKWzLhk2l9rVkR2aVDqshLZyrlb9sFjtsYSuG5haNYIYfs13NqKtt1Kxju1ESnq0yaCQADuONVNE8rvPbznmJI4oV7pGwnN1CWo9V2k329WpNdy4EpYk4g07D6d0K4IBuW+Zrrn4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=cTxkG8KZ; arc=none smtp.client-ip=63.231.237.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="cTxkG8KZ"
Received: from [10.0.0.71] (usg [10.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id D3A635CCE30;
	Wed, 24 Jul 2024 17:50:18 -0500 (CDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 sandeen.net D3A635CCE30
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net;
	s=default; t=1721861418;
	bh=lUtWqvsgavK594FX+epIG8TWiXuWNREXBgeawtuPMfk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cTxkG8KZSO4rqUn1YR1NCnptL8IyYxBltXXTE/yXNUP0Z/PrSaGOmrbYhAK+bfyvB
	 lo0IQuYuLAW+m9S/3kqyniwjSQQA0ROqWXqpRA9PotbcNHmSMEDLy/j2LlszGEL8ts
	 ivUt6CMKbeJzLqKdgnq1htsfidNknj05wvLXnzRF1IoszJVQXCorNBIsKSqnoaC3db
	 fUwghsh+qWDClYryTt0OyigBtePjqZTVBPd3a+xYVWXqSKRkMUSISgrJtCbseFWZay
	 ZtGKXp944Hn7trWLHiyQC63nMJDNKC9D1eksXkkRwpkOmqf1BBwlXSUY5c+viIZM/H
	 slv7eNKB74Q5w==
Message-ID: <7c1f47f5-dbf9-4e89-9355-6adc9fad2166@sandeen.net>
Date: Wed, 24 Jul 2024 17:50:18 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
To: "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
References: <20240721230100.4159699-1-david@fromorbit.com>
 <20240723235801.GU612460@frogsfrogsfrogs>
 <ZqBO177pPLbovguo@dread.disaster.area>
 <20240724210833.GZ612460@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20240724210833.GZ612460@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/24/24 4:08 PM, Darrick J. Wong wrote:
> On Wed, Jul 24, 2024 at 10:46:15AM +1000, Dave Chinner wrote:

...

> Counter-proposal: Instead of remapping the AGs to higher LBAs, what if
> we allowed people to create single-AG filesystems with large(ish)
> sb_agblocks.  You could then format a 2GB image with (say) a 100G AG
> size and copy your 2GB of data into the filesystem.  At deploy time,
> growfs will expand AG 0 to 100G and add new AGs after that, same as it
> does now.

And that could be done oneline...

> I think all we'd need is to add a switch to mkfs to tell it that it's
> creating one of these gold master images, which would disable this
> check:
> 
> 	if (agsize > dblocks) {
> 		fprintf(stderr,
> 	_("agsize (%lld blocks) too big, data area is %lld blocks\n"),
> 			(long long)agsize, (long long)dblocks);
> 			usage();
> 	}

(plus removing the single-ag check)

> and set a largeish default AG size.  We might want to set a compat bit
> so that xfs_repair won't complain about the single AG.
> 
> Yes, there are drawbacks, like the lack of redundant superblocks.  But
> if growfs really runs at firstboot, then the deployed customer system
> will likely have more than 1 AG and therefore be fine.

Other drawbacks are that you've fixed the AG size, so if you don't grow
past the AG size you picked at mkfs time, you've still got only one
superblock in the deployed image.

i.e. if you set it to 100G, you're OK if you're growing to 300-400G.
If you are only growing to 50G, not so much.

(and vice versa - if you optimize for gaining superblocks, you have to
pick a fairly small AG size, then run the risk of growing thousands of them)

In other words, it requires choices at mkfs time, whereas Dave's proposal
lets those choices be made per system, at "expand" time, when the desired
final size is known.

(And, you start right out of the gate with poorly distributed data and inodes,
though I'm not sure how much that'd matter in practice.)

(I'm not sure the ideas are even mutually exclusive; I think you could have
a single AG image with dblocks << agblocks << 2^agblocklog, and a simple
growfs adds agblocks-sized AGs, whereas an "expand" could adjust agblocks,
then growfs to add more?)

> As for validating the integrity of the GM image, well, maybe the vendor
> should enable fsverity. ;)

And host it on ext4, LOL.

-Eric
