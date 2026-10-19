Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792425285;
	b=S3WlGGxQiI0Wz9sQLULcseUA+hOn1iZvEDFDCkBD4QIWZaVFizzkZx5+J0cTIFHVZR7R
	 yY7Udn+UbubmkD162QbwiJzXItZxAOwUX8i/FYUyM8jEbyn1oeA0qcIBwGGXysxTjczRc
	 quMOaGOLbUnBlOVRVjybYHsG/yPi+6+k1ZK5tQqZqn8BeLzqzcnB/RpranSIK3cTYMY+B
	 f1FX8WYp8AetrqG6YTgcJeszIE32XKhBloOwUnSwgqof0Z4OU2kRYZ5jFRSsSaE1Icns/
	 naNg0YDO7ilLZJetFTqSsn7oL7mf5mAa3JYGg5V4lmaQ9JFVfAQNz19lsbVSs8pvm8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792425285;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=P/7P/I5BgkuTLirjW/ltZ8h7zrfRlL+fIYd6Yse1IoU=;
	b=3f5ItxdyfSV1b6p73yWrrt823WGJsSHIRnERt+WR6jMNwWn0x2z6hPlMKk8PFv4gqVtR
	 oFKHQzqANR0/++t4JA2k9xlr+39hakllXw+RW72Qlkd0/RcrxpjsEN2bvfCp5mnU6Zadf
	 COD7AnSXrnuZvxF0h23v/blE2wYtQlVzfbHlmPXCeQRBlVUe5V33f6LHxC4mqZ4SlTGdQ
	 dwXUi7MDdIg/m6gAQUnekEBcl/V0mKwStBHxgznqwBLPrJDxnfCzMgxu+97orpaoNeWr7
	 M9V4+VB+myJeeXy8AF4InPHgJqC/4qCP8qiKPlhJBFWXQAwn1uj6YNpb8lYl3mWJJNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PQKLOjyu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id D7ED8606C928
	for <linux-xfs@vger.kernel.org>; Mon, 19 Oct 2026 15:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PQKLOjyu
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 61F821F000C4;
	Mon, 19 Oct 2026 15:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425284;
	bh=P/7P/I5BgkuTLirjW/ltZ8h7zrfRlL+fIYd6Yse1IoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PQKLOjyuH05lRsWp+aQO7TJYoQnc32I1AS0951BEZv68NMqqqqwLBhJ6ZrhlTnbd/
	 jerQOLpW/eAygQxN/kGqUvSgSZwPMB5A5BszRUV65GBqvSiVMk4cvgNrlJ6RsMmQ5H
	 WwN1wb5q3L6i2d5sg61UHdHN2uqYOIwcBGCGXmUcM16vbEhKGelnBw/9jR5xXLvVvJ
	 4Uwo6+eL551EXS8wyVyYoMYidREUs88VmMABOfUMiL0LancMnyuGMcb1g/NTHOfXbO
	 a5/rterjTbKM1/ibKKWPJiylIESB0gVeRaS39PTpMVAn0viFVcKanFl1onxW8gWo/w
	 9PeIBmlCVU6JQ==
Date: Mon, 19 Oct 2026 08:54:43 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] tools: add a new script to generate fixes tags
Message-ID: <20261019155443.GC1612213@frogsfrogsfrogs>
References: <179158948269.3720929.14224184767079938461.stgit@frogsfrogsfrogs>
 <179158948300.3720929.2141793283079787803.stgit@frogsfrogsfrogs>
 <atXMAL0VDq8La3wh@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atXMAL0VDq8La3wh@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On Mon, Oct 19, 2026 at 10:12:42AM +0200, Andrey Albershteyn wrote:
> On 2026-10-09 16:53:10, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a program that can generate Fixes: tags for a new bugfix commit to
> > cite an older buggy commit.
> > 
> > Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> > ---
> >  tools/git-fixes |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 61 insertions(+)
> >  create mode 100755 tools/git-fixes
> > 
> > 
> > diff --git a/tools/git-fixes b/tools/git-fixes
> > new file mode 100755
> > index 00000000000000..5729de462e7183
> > --- /dev/null
> > +++ b/tools/git-fixes
> > @@ -0,0 +1,61 @@
> > +#!/bin/bash
> > +
> > +# SPDX-License-Identifier: GPL-2.0-or-later
> > +
> > +# Copyright (c) 2026 Oracle.  All Rights Reserved.
> > +# Author: Darrick J. Wong <djwong@kernel.org>
> > +
> > +# Cite a list of git hashes in Fixes: tag format.
> > +
> > +if [ -z "$1" ] || [ "$1" = "--help" ]; then
> > +	echo "Usage: $0 commit [commits...]"
> > +	exit 1
> > +fi
> 
> I miss a bit more description on the use of this, so, the output of
> this script is Fixes: for the first <commit> description and the
> rest [commits...] are targets to be in Fixes:?

No, each @commit specified gets its own Fixes tag:

$ git fixes 8293528fb1899a d0b6cb4fbea7b1 116961aa98bea1
Cc: <mason@kernel.org>
Fixes: 8293528fb1899a ("xfs: keep FICLONERANGE from overwriting the source")
Cc: <djwong@kernel.org>
Fixes: d0b6cb4fbea7b1 ("xfs: refactor inode forkoff to byte conversions")
Cc: <djwong@kernel.org>
Fixes: 116961aa98bea1 ("xfs: drop unnecessary sr parameter from xchk_rtgroup init functions")

Generally you'd only pass in a single commit, but there's no reason not
to keep going, IMO.

> Also, would be nice to see user.stableSubmissionTarget and
> versionsort.suffix mentioned in the description above

I'll add a description of user.stableSubmisionTaret.  versionsort.suffix
is part of standard git; see git-config(1).

--D
