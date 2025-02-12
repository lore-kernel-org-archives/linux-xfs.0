Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BAFF201025
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 21:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739395776; cv=none; b=NB2vEPOSP+L42y8mXmSvAXNzr8GHKsW8KXQNTIvoL73vbXfItzVaTmMSAecsIwQ8XIUMXh5CAb5mjL4r++jvVk4r0EhPSZVmMMtCSHdaU7PROw4MH5RLVCzhr/l1jcjRXqUvmmVdQ8hJ8LI00mSz+m8+Slqdxji54YYXry0VZh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739395776; c=relaxed/simple;
	bh=Tz6QoWm1j/BLQtUCh61qLrUZSojkBSngwEYs6uJpWrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eAYjoO9ojc48IxOdZPgkWLsju5ak/OTQhX7cuEJp23us1mCGU2XEnVOcCjRSIWKVlf7reL3fVgg5/CnCF8LlmXNsm2sH53R6oa255uLyQKXv8ttatF589Vcb4yxUDCUXftpaj6rX3u+yuva6/x56rRQFoPZBBX2QPihi4JoK3LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGWKH4wH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGWKH4wH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFD36C4CEDF;
	Wed, 12 Feb 2025 21:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739395775;
	bh=Tz6QoWm1j/BLQtUCh61qLrUZSojkBSngwEYs6uJpWrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GGWKH4wHsruI4raB471OWCMYeG6wWnwPK404ZkhMxAZrm0Ig3dT+HQEYaOgdr0U3h
	 fonM4zhfI5o9gE1fj9W0MIMamPPboeug/XdnEQ++mWf2nSKJpW2sUZrYWkYF7E4dVs
	 s1uZUX7knK9vUTKl3+qofa3uw9agqNS7rEY6y7evnQfFc6308YjcxNDL6Wx9M//LBK
	 5c93nb+Sg7BC8PQXgm+V6uBQiNQ4WkUrVZvk+hk01AZJOsMXlFQrZI8mx0qS/QwjNa
	 dWpRzaDEOPntxoj/oo90p24JHHJIt/WpMGnAPHLwG5TJ2hV1NaKqT+2LErkIoDFM9n
	 8EM2S84l+vpJQ==
Date: Wed, 12 Feb 2025 13:29:35 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v3 5/8] Add git-contributors script to notify about merges
Message-ID: <20250212212935.GL21808@frogsfrogsfrogs>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
 <20250211-update-release-v3-5-7b80ae52c61f@kernel.org>
 <20250211185804.GD21808@frogsfrogsfrogs>
 <rzlzwjixwg7i442ohupcovrtol4awuhwusdm6uwx36jphf4sqy@2qx3yccpkqba>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rzlzwjixwg7i442ohupcovrtol4awuhwusdm6uwx36jphf4sqy@2qx3yccpkqba>

On Wed, Feb 12, 2025 at 12:16:46PM +0100, Andrey Albershteyn wrote:
> On 2025-02-11 10:58:04, Darrick J. Wong wrote:
> > On Tue, Feb 11, 2025 at 06:26:57PM +0100, Andrey Albershteyn wrote:
> > > Add python script used to collect emails over all changes merged in
> > > the next release.
> > > 
> > > CC: Darrick J. Wong <djwong@kernel.org>
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > > ---
> > >  tools/git-contributors.py | 94 +++++++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 94 insertions(+)
> > > 
> > > diff --git a/tools/git-contributors.py b/tools/git-contributors.py
> > > new file mode 100755
> > > index 0000000000000000000000000000000000000000..83bbe8ce0ee1dcbd591c6d3016d553fac2a7d286
> > > --- /dev/null
> > > +++ b/tools/git-contributors.py
> > > @@ -0,0 +1,94 @@
> > > +#!/usr/bin/python3
> > > +
> > > +# List all contributors to a series of git commits.
> > > +# Copyright(C) 2025 Oracle, All Rights Reserved.
> > > +# Licensed under GPL 2.0 or later
> > > +
> > > +import re
> > > +import subprocess
> > > +import io
> > > +import sys
> > > +import argparse
> > > +import email.utils
> > > +
> > > +DEBUG = False
> > > +
> > > +def backtick(args):
> > > +    '''Generator function that yields lines of a program's stdout.'''
> > > +    if DEBUG:
> > > +        print(' '.join(args))
> > > +    p = subprocess.Popen(args, stdout = subprocess.PIPE)
> > > +    for line in io.TextIOWrapper(p.stdout, encoding="utf-8"):
> > > +        yield line
> > > +
> > > +class find_developers(object):
> > > +    def __init__(self):
> > > +        tags = '%s|%s|%s|%s|%s|%s|%s|%s' % (
> > > +            'signed-off-by',
> > > +            'acked-by',
> > > +            'cc',
> > > +            'reviewed-by',
> > > +            'reported-by',
> > > +            'tested-by',
> > > +            'suggested-by',
> > > +            'reported-and-tested-by')
> > > +        # some tag, a colon, a space, and everything after that
> > > +        regex1 = r'^(%s):\s+(.+)$' % tags
> > > +
> > > +        self.r1 = re.compile(regex1, re.I)
> > > +
> > > +    def run(self, lines):
> > > +        addr_list = []
> > > +
> > > +        for line in lines:
> > > +            l = line.strip()
> > > +
> > > +            # emailutils can handle abominations like:
> > > +            #
> > > +            # Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
> > > +            # Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
> > > +            # Reviewed-by: bogus@simpson.com
> > > +            # Cc: <stable@vger.kernel.org> # v6.9
> > > +            # Tested-by: Moo Cow <foo@bar.com> # powerpc
> > > +            m = self.r1.match(l)
> > > +            if not m:
> > > +                continue
> > > +            (name, addr) = email.utils.parseaddr(m.expand(r'\g<2>'))
> > > +
> > > +            # This last split removes anything after a hash mark,
> > > +            # because someone could have provided an improperly
> > > +            # formatted email address:
> > > +            #
> > > +            # Cc: stable@vger.kernel.org # v6.19+
> > > +            #
> > > +            # emailutils doesn't seem to catch this, and I can't
> > > +            # fully tell from RFC2822 that this isn't allowed.  I
> > > +            # think it is because dtext doesn't forbid spaces or
> > > +            # hash marks.
> > > +            addr_list.append(addr.split('#')[0])
> > 
> > I think it's the case that the canonical stable cc tag format for kernel
> > patches as provided by the stable kernel process rules document:
> > 
> > Cc: <stable@vger.kernel.org> # vX.Y
> > 
> > is not actually actually rfc5322 compliant, so strings like that break
> > Python's emailutils parsers.  parseaddr() completely chokes on this, and
> > retuns name=='' and addr=='', because the only thing that can come after
> > the address portion are whitespace, EOL, or a comma followed by more
> > email addresses.  There's definitely not supposed to be an octothorpe
> > followed by even more text.
> > 
> > In the end I let myself be nerdsniped with even more string parsing bs,
> > and this loop body is the result:
> > 
> > 		l = line.strip()
> > 
> > 		# First, does this line match any of the headers we
> > 		# know about?
> > 		m = self.r1.match(l)
> > 		if not m:
> > 			continue
> > 
> > 		# The split removes everything after an octothorpe
> > 		# (hash mark), because someone could have provided an
> > 		# improperly formatted email address:
> > 		#
> > 		# Cc: stable@vger.kernel.org # v6.19+
> > 		#
> > 		# This, according to my reading of RFC5322, is allowed
> > 		# because octothorpes can be part of atom text.
> > 		# However, it is interepreted as if there weren't any
> > 		# whitespace ("stable@vger.kernel.org#v6.19+").  The
> > 		# grammar allows for this form, even though this is not
> > 		# a correct Internet domain name.
> > 		#
> > 		# Worse, if you follow the format specified in the
> > 		# kernel's SubmittingPatches file:
> > 		#
> > 		# Cc: <stable@vger.kernel.org> # v6.9
> > 		#
> > 		# emailutils will not know how to parse this, and
> > 		# returns empty strings.  I think this is because the
> > 		# angle-addr specification allows only whitespace
> > 		# between the closing angle bracket and the CRLF.
> > 		#
> > 		# Hack around both problems by ignoring everything
> > 		# after an octothorpe, no matter where it occurs in the
> > 		# string.  If someone has one in their name or the
> > 		# email address, too bad.
> > 		a = m.expand(r'\g<2>').split('#')[0]
> > 
> > 		# emailutils can extract email addresses from headers
> > 		# that roughly follow the destination address field
> > 		# format:
> > 		#
> > 		# Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
> > 		# Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
> > 		# Reviewed-by: bogus@simpson.com
> > 		# Tested-by: Moo Cow <foo@bar.com>
> > 		#
> > 		# Use it to extract the email address, because we don't
> > 		# care about the display name.
> > 		(name, addr) = email.utils.parseaddr(a)
> > 		addr_list.append(addr)
> > 
> > <shrug> but maybe we should try that on a few branches first before
> > committing to this string parsing mess ... ?  Not that this is any less
> > stupid than the previous version I shared out. :(
> 
> Can we just drop anything with 'stable@'? These are patches from
> libxfs syncs, do they have any value for stable@ list?

None at all; we should probably make libxfs-apply filter those out.

> But the change is still make sense if anyone uses hash mark for
> something else, I will apply your change.

<shrug> I've occasionally seen people leave trailers such as:

Acked-by: "Cowmoo Userguy" <cow@user.com> # xfs

On treewide changes, so I think we should handle hashmarks correctly
even if we rip out the stable@vger cc's.

--D

> 
> -- 
> - Andrey
> 
> 
