Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE1F34DCE4;
	Tue, 21 Jul 2026 22:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673378; cv=none; b=cP2rdKEE7N0078xFGtSXsp4vUPocxshOZyyVj/teyYmIFKGVjVP7z8G4DNi3wR9VvQp852wFwNXzTkjtgBjmlbquqxZBbM5SAkqiaovRbj4xhMBvEtVMXtXi6FnsHMq5hmw37tLD7tUtiGu/qxoyvMdY5Z74MVhXaF2/+Ddq1T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673378; c=relaxed/simple;
	bh=T7pfiRcgw1Q6inrjKcz+jYww0y++Dltfy7TTqDUuW0Y=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=gteaInwk0orH0w4G0b0luEwXOXhT8ht360bdbCXX7eHAHE/sfNlvQ3b6/6whKpE/ZeVNiSVfh4RXy/oZq1lICsi9NFFS21X5WpP+fNOkYyKTFgPAGnKzmCcPuyySbWBjHKj4qw2+NxbCo/Fx+Izrawi2L5b0YncwWu0nsA9tPqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FeUEUmhb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FeUEUmhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87681F00A3A;
	Tue, 21 Jul 2026 22:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784673377;
	bh=9xR7aJnjzbB0cYi+HaNX5c/+Q8nLrvfNR2N4MpRwZ98=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=FeUEUmhbdNSPNuGvEeQbCU3d9I3vpKGzmnK+ikTxAY4qi/sTc+8fe97jlDEgL26fD
	 Msl1Jsk0SufN02KXKiDCFkzYbxAy1TMhwangB6K7CKYi6oFnumjIrclNOix7AZREmW
	 qxKT48odeELUJ6vlc7Z7Hh2TQWQVYT5PSyBHzghrYpE3qvjeQtt8pkbxkl916sFs6X
	 vpcLMTLhnKfsY0DMdVfm8DiBIZqHvmnrdDBoGO+KdD6P0F5NG/mAZhD185LYJIDvxe
	 uoLaPb741UAkxpblp3pqQgza9D0SJE6wdXB99GVsXeJ73hFtHbHWtWQ++Re+kmPvbj
	 xt/YxciBvWE/w==
Message-ID: <328de723-6f9c-4f09-a68a-da24d49300d5@kernel.org>
Date: Wed, 22 Jul 2026 06:36:13 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Anand Suveer Jain <asj@kernel.org>
Subject: Re: [PATCH v7 06/11] fstests: verify f_fsid for cloned filesystems
To: "Darrick J. Wong" <djwong@kernel.org>, Anand Jain <asj@kernel.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, zlang@redhat.com, hch@infradead.org
References: <cover.1781694879.git.asj@kernel.org>
 <2ac5fb22fd6b51973d11082a1ee8fe354926c63c.1781694879.git.asj@kernel.org>
 <20260701173314.GH6517@frogsfrogsfrogs>
Content-Language: en-US
In-Reply-To: <20260701173314.GH6517@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



> This is where I continue getting stuck on this patchset -- fsid is so
> poorly defined that I don't think the rest of these fsid tests make
> sense at all.  Nobody mandates that fsid is persistent or stable across
> remounts.  Nobody even mandates that two cloned filesystems don't have
> the same fsid value.
> 
> The statfs manpage says:
> 
> "Nobody knows what f_fsid is supposed to contain (but see below)"
> 
> and then:
> 
> "The general idea is that f_fsid contains some random stuff such that
> the pair (f_fsid,ino) uniquely determines a file."

Which is exactly why we need fstests guardrails.
Keeps filesystem's implementation consistent across kernel versions.
Embarrassingly, I introduced a bug around this that is now fixed.
The commit IDs are in the test cases.
Thus motivation for this fstests patch.

> Based on that very weak statement, at most it might make sense to check
> that two separate and simultaneously mounted filesystems don't end up
> with the same fsid 

Yes, for xfs, btrfs and f2fs. However for ext4 cloned filesystems can
share the same fsid and ino because the images are identical.
It is then up to the usecase to change the UUID for either filesystem if
it gets modified.
Commit ("fstests: add _require_unique_f_fsid() helper") captures this,
and the link in that commit includes the discussion.

> just in case there *are* programs foolish enough to
> use (fsid,ino) as a uniqueness check.

On the other hand, if a program needs a unique ID, do we currently have
any way to get one?

Thanks, Anand


