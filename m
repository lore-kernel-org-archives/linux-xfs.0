Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE9937F306
	for <linux-xfs@vger.kernel.org>; Mon, 14 Sep 2026 05:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789364887; cv=none; b=WA4YSQoVYUJGjx/5L27GxbUdDhlBRogCITHeZdTjkCi5O571LTRXGS+/+BuVsqGmqU/GRMfRACn6ShhuMC5zHSl8UKN20GcuYOyeQlzJxDQ6hJMpHIo0LkmLocpEY1xAIsNm/f5GXUVFLM5E4GUpdVG/B/09kYtlX2yAcNWfnIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789364887; c=relaxed/simple;
	bh=gfPFrUQVlQuzDfiXl3GNsJ9GGH2jB0daos7JRXb+9jo=;
	h=Date:Subject:From:To:Cc:Message-ID:MIME-Version:Content-Type; b=HRj33V2ZKUkOI+P+AqNrHw8jjSCNw8gN9l3C/Ab5cUGPxZsemK3/ab1hmcAiklglsA9Sc80S8z2xRvW325Zd6ziXac33qXW5bP+NOAmy5f3ntsiA94jiuym7qj8hqbYa2+03l12RMCAbr2rsisj8AIaroJDy+rHsIlDqmxiTaWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hUEVRbQK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hUEVRbQK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E19181F000FF;
	Mon, 14 Sep 2026 05:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789364886;
	bh=sAEoKMpHv+5gfHpEsB6SfeN0rqiOSJVA/8BKb2dL3Gs=;
	h=Date:Subject:From:To:Cc;
	b=hUEVRbQKqWXwqONiYKNenqrt+X5khHWR6wDtL95NhCzshwqm/+OXd4htNAoAeabRG
	 VQd8IiCX1xi4h9632aSD8QDX5nI7OHlSZU37edVndYJervi6KTDyht4TPVqmmK+ebn
	 UMih6J21f4GxrBj1q4szGzquyLNy6ysTPDZB5lyI18cg8aUS8SGyO/SvMlRuaIcN7G
	 6/sVgf0qSG17qC4cbOuVRsCwMy0wCZw2+DVQVFZvwo7qz/5aoyqy6oHN+jTk371wxl
	 3uISk7I6RozG8qW/QzjUVFealYRENXPbipgM7hp6rTKYPyc1ydgXZQyAQweFvbLfaV
	 an1LGleVOrAbA==
Date: Sun, 13 Sep 2026 22:48:05 -0700
Subject: [PATCHSET v4 1/2] xfsprogs: generate mkfs.xfs config files
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: tytso@mit.edu, hch@lst.de, hch@infradead.org, linux-xfs@vger.kernel.org
Message-ID: <178936484431.2108437.14645667775156303668.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Every year, we generate a new mkfs.xfs configuration file to match the
stable feature set of that year's LTS kernel.  Right now I just do this
by copying the old configuration file and tweaking the values by hand.

Instead, let's create some library code that can emit the same
configuration variables that we've been shipping for some years now,
and hook that up to mkfs/xfs_db/xfs_spaceman so that we can generate
them either from the mkfs defaults or pre-existing filesystems.

v2: add rvb tags, add the defaults file patch from before, add a few
    more metadata/v4 feature bits for spice
v3: add more file-related options and default config files
v4: address comments about manpage updates, split the quotactl_fd parts
    into a separate series, compact all the makecfg patches into one

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=generate-cfgfiles
---
Commits in this patchset:
 * mkfs: automatically upgrade autofsck earlier
 * mkfs: print config file for a given mkfs configuration
 * xfs_db: print configuration file for mounted filesystems
 * xfs_spaceman: print configuration file for mounted filesystems
 * xfs_admin: print configuration file for mounted filesystems
 * mkfs: allow specification of default options via configuration file
---
 libfrog/fsgeom.h        |    4 
 db/info.c               |  201 +++++++++++++++
 db/xfs_admin.sh         |   15 +
 libfrog/fsgeom.c        |  629 +++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/mkfs.xfs.8.in  |   33 ++
 man/man8/xfs_admin.8    |    8 +
 man/man8/xfs_db.8       |    7 +
 man/man8/xfs_spaceman.8 |    7 +
 mkfs/xfs_mkfs.c         |  213 ++++++++++++++--
 spaceman/info.c         |  201 +++++++++++++++
 10 files changed, 1284 insertions(+), 34 deletions(-)

