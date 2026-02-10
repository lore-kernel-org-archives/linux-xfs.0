Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31426481DD;
	Tue, 10 Feb 2026 04:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770699441; cv=none; b=IbawuV3YZF6amDInsIoklo5ohNuflL4Dzw4KwWXDRsCIif1AsRhY9wp34R9Ma51h2LsyHaQNUbNX9vIq0S+rRbT31lEaosri/LffXUdaiyMJEXEzl39BkQflBBB6lEpShpbCL3oRBOH5Aoo4ZYy/kzJg9/VvMHfTwb8tPZ+o5e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770699441; c=relaxed/simple;
	bh=WS/moM7rlZakyQptE8rxBBNJ+so3t5AyWNkklBp+RGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZhrD3GJwR+9JieGt49dduY6aG7YorFo5/gQmHnk3CCoG1n8dqvDcG+Fqp68TZH1FRM40z/bSvN+YrxCIaNZZPWL8scFOa9nYVnvrgJkZTXyNzmBpZ2u0TD0AmpdJxBcwyWgU4/IqDac25fw3kJm+rJpWKrpskrn1Z8lWZF1wJ1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=msd99RWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="msd99RWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4547C116C6;
	Tue, 10 Feb 2026 04:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770699440;
	bh=WS/moM7rlZakyQptE8rxBBNJ+so3t5AyWNkklBp+RGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=msd99RWfwgBjQJ5TuxkZga5M+/DOxu2h245qQMjztjcIzQeL4Un2qUDhRrJkRYL3I
	 cKlH6kPyymY4tO61Dv+L/JYX6sc9bYQTumaIuoCX5tVNcxbFKOiKXrzYMGk226L7iO
	 vmGt+SV33yZXofD8J9FgfTia7X5FldvzkIUGmuiuSQ3ftaEK8VwcL6dKdvcrs4EB1n
	 c8ORqP5CIRUnRgJOWiAMDZ7pUB4PwDDWCno1o7EwJPCcVJvcJM0HUh8uCWWwQ0bXOm
	 lgVtQO8GmKMLJNQOBbzCXX1j9sQCARDYu0fbQdF/SJhdujK85WAdlic7EgHc6ghZIX
	 pMyevXnzfJK6A==
Date: Mon, 9 Feb 2026 20:57:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Pankaj Raghav <pankaj.raghav@linux.dev>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	p.raghav@samsung.com
Subject: Re: [PATCH 02/11] xfs: start creating infrastructure for health
 monitoring
Message-ID: <20260210045720.GD7712@frogsfrogsfrogs>
References: <176852588473.2137143.1604994842772101197.stgit@frogsfrogsfrogs>
 <176852588582.2137143.1283636639551788931.stgit@frogsfrogsfrogs>
 <tq3nyswm72gackesz6v476qqvin5eaa67f4hf6lg52exzv7k7p@tczjh5n777tc>
 <20260206174742.GI7693@frogsfrogsfrogs>
 <37e584d1-1256-46ad-9ddf-0c4b8186db08@linux.dev>
 <20260206204135.GA7712@frogsfrogsfrogs>
 <20260209063421.GA9202@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209063421.GA9202@lst.de>

On Mon, Feb 09, 2026 at 07:34:21AM +0100, Christoph Hellwig wrote:
> On Fri, Feb 06, 2026 at 12:41:35PM -0800, Darrick J. Wong wrote:
> > > So just a barrier() call in rcu_read_lock is enough to make sure this
> > > doesn't happen and probably adding a READ_ONCE() is not needed?
> > 
> > Nope.  You're right, we do need READ_ONCE here.
> 
> The right thing is to use rcu_dereference / rcu_assign_pointer and add a
> __rcu annotation to m_healthmon.

Noted, will change my fixpatch to do that.  Thanks for the pointer!

--D
