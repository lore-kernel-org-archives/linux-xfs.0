Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D892022CBE6
	for <linux-xfs@vger.kernel.org>; Fri, 16 May 2025 23:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747438743; cv=none; b=tvt6l9lVJ2CcbT3Wr3enss/zQXu50xNvu4JvI4HdUCbWXFys5qDjBjks/sKW4KpyrZ/ieiKQ9eoyozU6vTfZLj314V9Qs0L52a2oPYhWdylUpX+zbIp5tOCHLm00pDVv+NvqwVK642bVxHBDHgPloUI6O1uGkpxgsn+HavxjZTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747438743; c=relaxed/simple;
	bh=JWmbwYTzynxNc1VvLYMrf9iVNtS131ywCaOwMZgpPF4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LthT5AYNCdYecJcjpYghTma3xLrO5h9bKcR86Pi3M4XBdWh+9gQgARvkWJ6rswFWNBqrI/KKgmA/GxWjUIPWhh+G0vIl4YLjbV744vxTQDnKWaoOYDO3NhvfGvgM9x/8mhuZcH/DMDCJyvuXfSuKFoTbucVe0qTvHcd/HRT3NgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G5U8jIeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G5U8jIeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437B4C4CEE4;
	Fri, 16 May 2025 23:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747438743;
	bh=JWmbwYTzynxNc1VvLYMrf9iVNtS131ywCaOwMZgpPF4=;
	h=Date:From:To:Cc:Subject:From;
	b=G5U8jIeADqx6vuCLriMkTSWSU+gIpPiT8u6KSG9LrLieKxOJOepiESa7Hihu5prOo
	 22snAMBi5WpTpk5zc1vFbWTfMS0IYLtEbWtZBANQ0VuwsMGr06dWg8UFgnKCvGIdLG
	 /9dBbYWRlNsF7ekMKqjqiGN9dJWDpnWgU9JuEky/yB8cPV++bmgwmIPWKgRdA06fTW
	 a4Pi1tiHsEmL+r/uye51xbfy6ZM7gCnKnqLpCO/Q8c+RxAgiaW9Vih655J914EY4fQ
	 qRDVYpNuSs3cE+xm7o4jPGJ85s5lXVq9ayXJReh7mcj9XhobvOG1ZipCMK1DYNTvDk
	 5VEPulnkFLEBQ==
Date: Fri, 16 May 2025 16:39:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
Subject: xfs office hours meeting minutes
Message-ID: <20250516233902.GA9705@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi everyone,

For background, Dave asked this on IRC on Tuesday:

[15:03] <dchinner> djwong: can you publish updated minutes for what is
discussed during the office hours meeting?

After a couple of days of doing some research and thinking about this,
I've decided that the answer is no, I cannot simultaneously facilitate
the meeting /and/ produce a detailed minute-by-minute record of what was
discussed.  I welcome someone volunteering to function as a scribe,
though I'll note that for most of the other community meetings (e.g.
LSFMM, LPC, etc) minutes are not produced.

Like the ext4 community call, the weekly hour is spent on asking fairly
mundane procedure questions of the release managers, people asking
questions when they get stuck, a roundtable of what everyone's working
on, and discussion of ideas.  This last thing is what I gather is the
sticking point -- people are allergic to backroom settlement of
conflicts that everyone is then bound to live with.

For those situations, I prefer to roughly follow the practice of ext4
community call.  To my observation, that practice is that if we think
we've settled a question, then a summary of that discussion will be sent
to the list for broader examination.  That to me feels like a reasonable
compromise between the unstructured conversations that occur on the call
vs. maintaining a public record.

Also, for people who have been attending the calls, I have numerous
conflicts for the next month or two, so the next office hours will be:

May 20
June 10
July 1

(and back to weekly starting July 1)

--D
