Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B4B1C4612;
	Wed, 11 Dec 2024 19:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733946023; cv=none; b=cPY0liOnudAP9nEVZn4uuRV3+9blI6oK/sI7ibv49vd5BZzpyvUUnb1F0o+NCdkZW985f/sIBjvXUk84mGgrJBIHlz3tszAV2rdoF0UKKw4QMO8dfxyIwL8kv2cBGgOv0Dsfnsn+ga3s6V5z7ikPan4+1sXXD4In2NjBLZTbkes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733946023; c=relaxed/simple;
	bh=pF9yeK2U0N4zuHzn6i9qzQDvsoImqm8+N5CgxpYnPzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LuaMrRSHQ9KaTdoO5oF5OjCNZMUr7VojAWN6GPkKH//s9n2yUjPEKerSr1Tx4mzynW8bZlLlwyrjzFHiNGJbKpGTERCqgpYpgxIbQHxUJXipe1TJiwcYjE7EhjxvxNY7Ro5wrI55LZYjRkzWaUFFQ1744L/6Vb7QjEO/w2k6hBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rc5bLUQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rc5bLUQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21279C4CED2;
	Wed, 11 Dec 2024 19:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733946023;
	bh=pF9yeK2U0N4zuHzn6i9qzQDvsoImqm8+N5CgxpYnPzY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rc5bLUQAActr8VJjzmZKrml9+cWr+D+GwRe9KGWM9jXuPqYxq5uIxHjEl6ycYKIFi
	 UiicwAJiKp3yZIx4GIz3DNL6woKJcb/xYj22/tCv/AijLdTUElcj67OJ4VqL3eIctW
	 sIhK1Os9uZ5sYYYc8vEl5CYR6h8pbwJG4HbujZH5dx4cuxcbm02MVSaZqDrIXSkICm
	 WPYM0KzkFdJJR0DFG1mYuDlpmW10TsiDoOGOxbDB/r3YdIRcvSN67k6UuY3U+q7bv6
	 V4XQDEVPp0g/m8MS0B+juS0RuRptr3amRvZ7KROA6dKhWnO/nBcFSArxbBd8xsPQ5R
	 s0maofjTdz7hQ==
Date: Wed, 11 Dec 2024 11:40:22 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, dan.carpenter@linaro.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCHSET 6/9] xfsprogs: bug fixes for 6.13
Message-ID: <20241211194022.GH6678@frogsfrogsfrogs>
References: <20241206232259.GO7837@frogsfrogsfrogs>
 <173352751190.126106.5258055486306925523.stgit@frogsfrogsfrogs>
 <Z1fQruaMo-kQU6KK@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fQruaMo-kQU6KK@infradead.org>

On Mon, Dec 09, 2024 at 09:25:02PM -0800, Christoph Hellwig wrote:
> Shouldn't the bug fix series go first?

Something got messed up in the patchbombing sequence.  Patchset 5/9
should have sorted before this one (6/9) but instead it came at the end.

Ohhh, right.  Long Li add a "Cc: stable@vger.kernel.org # v4.19+"
tag.  This isn't rfc2822 compliant, so the stgit subcommand that
converts Cc: tags in the commit message to actual cc: headers tried to
put the entire string (minus spaces!) in the cc line, which caused the
msmtp to reject the cover letter.  I stripped out the stable@ entirely
and resent just that message, but forgot that my patchbombing script
always updates the send time for each attempt, so the mutt sort order is
now incorrect.

String parsing sucks, and our automated tools don't catch it either:

  $ ./scripts/checkpatch.pl ../xfsprogs/patches-djwong-dev10/129*
  ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")'
  - ie: 'commit 652f03db897b ("xfs: remove unknown compat feature check in superblock write validation")'
  #4:
  Source kernel commit: 652f03db897ba24f9c4b269e254ccc6cc01ff1b7

  total: 1 errors, 0 warnings, 13 lines checked

  NOTE: For some of the reported defects, checkpatch may be able to
        mechanically convert to the typical style using --fix or --fix-inplace.

  ../xfsprogs/patches-djwong-dev10/129-xfs__remove_unknown_compat_feature_check_in_superblock_write_validation.patch has style problems, please review.

  NOTE: If any of the errors are false positives, please report
        them to the maintainer, see CHECKPATCH in MAINTAINERS.

Yeah, it whines about the commit hash being **too long** which is
totally inconsequential but totally misses the incorrect Cc: header
specification that confuses the hyell out of MTAs.

Sorry about that.

--D
