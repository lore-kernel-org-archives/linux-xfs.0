Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB81253B43
	for <linux-xfs@vger.kernel.org>; Tue, 11 Feb 2025 18:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739300285; cv=none; b=AIaAjBTWoOIWh3QPpWCG+df4UoWaUJWj8qPuC20C4eAo5Wd8dPVHov0I1qhpye5L1k6vSNN75mnokTX0tPE7aIt+oiXyu/TIxVcawUDLIKe+LI44nDO5WQXKhTK3ZNJuBsm1CXBBmbQugC34Yi6fKWNfjc0lX4MitarqFSiVDHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739300285; c=relaxed/simple;
	bh=uEecqZVqbMwA7oPAT3mOCquTd1+pUwi4Jl2VShQj6Bw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yy9nvpcVU8+fTvWETBqtjYlbMjFGO+ac55a1qRfiEe5NOLavf6yl1IIpwMmL4YEpaATza025RQ+yiZigvuoSrI5eUfcnvCQfaOOpl8TD+3z0VbpytUcENQrpR9K4CZpqE+AovjFL7PtOxeqFGugTjxgPc7FEyF096tnUY9FMhzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJMqLEgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJMqLEgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C960FC4CEDD;
	Tue, 11 Feb 2025 18:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739300284;
	bh=uEecqZVqbMwA7oPAT3mOCquTd1+pUwi4Jl2VShQj6Bw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GJMqLEgbmhj2U2x3tsmxe6/6b7nvaZ/UxIQ+eFSc0XFmEme3a1W+lftpIS5RYT5XD
	 LigiEbBht08W9Xmwk+n2aPSoa9GGoe740Ej7Sf7ApY+vJUsMcDzWuljZBO+kqOJHen
	 L0BlLmeUnYthzl6Ve2cXNQaFWrIqKq4sdzydkKCaHIm357+bFxryDOlTACSq6j9u9R
	 k0ED+H7MkCrsyzJ2/3gxGMdD5yVCveKb9utsA6rXsS0kLanmn1cUlSrZEz7ynOGYJ8
	 iHYLjv76Lrnc+J0MLiwpAaO6VkMfIFDDfe0M6FR+e8GthTfnj0hV4FLLbo4r01fTlp
	 kX8My/0Rb9ueQ==
Date: Tue, 11 Feb 2025 10:58:04 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v3 5/8] Add git-contributors script to notify about merges
Message-ID: <20250211185804.GD21808@frogsfrogsfrogs>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
 <20250211-update-release-v3-5-7b80ae52c61f@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211-update-release-v3-5-7b80ae52c61f@kernel.org>

On Tue, Feb 11, 2025 at 06:26:57PM +0100, Andrey Albershteyn wrote:
> Add python script used to collect emails over all changes merged in
> the next release.
> 
> CC: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  tools/git-contributors.py | 94 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 94 insertions(+)
> 
> diff --git a/tools/git-contributors.py b/tools/git-contributors.py
> new file mode 100755
> index 0000000000000000000000000000000000000000..83bbe8ce0ee1dcbd591c6d3016d553fac2a7d286
> --- /dev/null
> +++ b/tools/git-contributors.py
> @@ -0,0 +1,94 @@
> +#!/usr/bin/python3
> +
> +# List all contributors to a series of git commits.
> +# Copyright(C) 2025 Oracle, All Rights Reserved.
> +# Licensed under GPL 2.0 or later
> +
> +import re
> +import subprocess
> +import io
> +import sys
> +import argparse
> +import email.utils
> +
> +DEBUG = False
> +
> +def backtick(args):
> +    '''Generator function that yields lines of a program's stdout.'''
> +    if DEBUG:
> +        print(' '.join(args))
> +    p = subprocess.Popen(args, stdout = subprocess.PIPE)
> +    for line in io.TextIOWrapper(p.stdout, encoding="utf-8"):
> +        yield line
> +
> +class find_developers(object):
> +    def __init__(self):
> +        tags = '%s|%s|%s|%s|%s|%s|%s|%s' % (
> +            'signed-off-by',
> +            'acked-by',
> +            'cc',
> +            'reviewed-by',
> +            'reported-by',
> +            'tested-by',
> +            'suggested-by',
> +            'reported-and-tested-by')
> +        # some tag, a colon, a space, and everything after that
> +        regex1 = r'^(%s):\s+(.+)$' % tags
> +
> +        self.r1 = re.compile(regex1, re.I)
> +
> +    def run(self, lines):
> +        addr_list = []
> +
> +        for line in lines:
> +            l = line.strip()
> +
> +            # emailutils can handle abominations like:
> +            #
> +            # Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
> +            # Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
> +            # Reviewed-by: bogus@simpson.com
> +            # Cc: <stable@vger.kernel.org> # v6.9
> +            # Tested-by: Moo Cow <foo@bar.com> # powerpc
> +            m = self.r1.match(l)
> +            if not m:
> +                continue
> +            (name, addr) = email.utils.parseaddr(m.expand(r'\g<2>'))
> +
> +            # This last split removes anything after a hash mark,
> +            # because someone could have provided an improperly
> +            # formatted email address:
> +            #
> +            # Cc: stable@vger.kernel.org # v6.19+
> +            #
> +            # emailutils doesn't seem to catch this, and I can't
> +            # fully tell from RFC2822 that this isn't allowed.  I
> +            # think it is because dtext doesn't forbid spaces or
> +            # hash marks.
> +            addr_list.append(addr.split('#')[0])

I think it's the case that the canonical stable cc tag format for kernel
patches as provided by the stable kernel process rules document:

Cc: <stable@vger.kernel.org> # vX.Y

is not actually actually rfc5322 compliant, so strings like that break
Python's emailutils parsers.  parseaddr() completely chokes on this, and
retuns name=='' and addr=='', because the only thing that can come after
the address portion are whitespace, EOL, or a comma followed by more
email addresses.  There's definitely not supposed to be an octothorpe
followed by even more text.

In the end I let myself be nerdsniped with even more string parsing bs,
and this loop body is the result:

		l = line.strip()

		# First, does this line match any of the headers we
		# know about?
		m = self.r1.match(l)
		if not m:
			continue

		# The split removes everything after an octothorpe
		# (hash mark), because someone could have provided an
		# improperly formatted email address:
		#
		# Cc: stable@vger.kernel.org # v6.19+
		#
		# This, according to my reading of RFC5322, is allowed
		# because octothorpes can be part of atom text.
		# However, it is interepreted as if there weren't any
		# whitespace ("stable@vger.kernel.org#v6.19+").  The
		# grammar allows for this form, even though this is not
		# a correct Internet domain name.
		#
		# Worse, if you follow the format specified in the
		# kernel's SubmittingPatches file:
		#
		# Cc: <stable@vger.kernel.org> # v6.9
		#
		# emailutils will not know how to parse this, and
		# returns empty strings.  I think this is because the
		# angle-addr specification allows only whitespace
		# between the closing angle bracket and the CRLF.
		#
		# Hack around both problems by ignoring everything
		# after an octothorpe, no matter where it occurs in the
		# string.  If someone has one in their name or the
		# email address, too bad.
		a = m.expand(r'\g<2>').split('#')[0]

		# emailutils can extract email addresses from headers
		# that roughly follow the destination address field
		# format:
		#
		# Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
		# Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
		# Reviewed-by: bogus@simpson.com
		# Tested-by: Moo Cow <foo@bar.com>
		#
		# Use it to extract the email address, because we don't
		# care about the display name.
		(name, addr) = email.utils.parseaddr(a)
		addr_list.append(addr)

<shrug> but maybe we should try that on a few branches first before
committing to this string parsing mess ... ?  Not that this is any less
stupid than the previous version I shared out. :(

--D

> +
> +        return sorted(set(addr_list))
> +
> +def main():
> +    parser = argparse.ArgumentParser(description = "List email addresses of contributors to a series of git commits.")
> +    parser.add_argument("revspec", nargs = '?', default = None, \
> +            help = "git revisions to process.")
> +    parser.add_argument("--delimiter", type = str, default = '\n', \
> +            help = "Separate each email address with this string.")
> +    args = parser.parse_args()
> +
> +    fd = find_developers()
> +    if args.revspec:
> +        # read git commits from repo
> +        contributors = fd.run(backtick(['git', 'log', '--pretty=medium',
> +                  args.revspec]))
> +    else:
> +        # read patch from stdin
> +        contributors = fd.run(sys.stdin.readlines())
> +
> +    print(args.delimiter.join(sorted(contributors)))
> +    return 0
> +
> +if __name__ == '__main__':
> +    sys.exit(main())
> +
> 
> -- 
> 2.47.2
> 
> 
