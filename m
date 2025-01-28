Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0322919D8A3
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jan 2025 17:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738086189; cv=none; b=Vowfal6pU8jN2kkVkWMSXHB3IwLzZRcKrXUo1lIwPl3AbCwIDgTIhci4qfox19r32A7Rs0sGMEs+n9mQkPmX9wuwzFmrvX0ZLA0wVo0SdJrYN2PPClNk3fG8+ssj1fqpJmx7InF07s/2ZOHC+hQazztbPbbWV6xhKVuMcHJX7q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738086189; c=relaxed/simple;
	bh=D6+qeCxbUmFCc/llwuSN3oSedFtSs6/uNLeTozo/buk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iDDpS+Pm54ZqJkvUPDztH46Bd0AcgKPkmcVjCL8/Rl5AggSeeDpukgBluh+DsPZ0LkDRjgVXscpUMcsvGdNk2k1aheTOsai+ZjcuIZTEwu3b4lQoZcwoZi1GzkNA6mxuCy4SVxxNrTSKa2jTujktYCD5X5wsEbh15yc0dZt3m98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ka0hJXh/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ka0hJXh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A66C4CED3;
	Tue, 28 Jan 2025 17:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738086188;
	bh=D6+qeCxbUmFCc/llwuSN3oSedFtSs6/uNLeTozo/buk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ka0hJXh/hWZdClxUCoLjyESbqCSvdnMq2F/Rz5YUxGPLyRJOR/nbgcskTVhey8Hhb
	 CRuh9jH4Af0oCuduuEG5jTs2ZZR1B1NC5oAAclsahwJIFzEbRLJxZYWQj6SGrlqXTS
	 c8wiJHLS50eg29Sb12h0NuWvCDxT4NciHjZWwHpAI7W924WOxgpNegNzni5qoCPedo
	 a4GpQPMf+zp+QKZIC+NdX5WPnWRxDCVnfRU5eW80f8crma7go/jXXm3I9dC7khS9Ng
	 QHJAIe9tDCKZgm7b4YFFMVvTokv+CFPN14b7o/YIxeNT9nozus9sHz+O5fQ00ojMNk
	 kuVXwLEem6nFg==
Date: Tue, 28 Jan 2025 09:43:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v2 5/7] Add git-contributors script to notify about merges
Message-ID: <20250128174306.GO1611770@frogsfrogsfrogs>
References: <20250122-update-release-v2-0-d01529db3aa5@kernel.org>
 <20250122-update-release-v2-5-d01529db3aa5@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122-update-release-v2-5-d01529db3aa5@kernel.org>

On Wed, Jan 22, 2025 at 04:01:31PM +0100, Andrey Albershteyn wrote:
> Add python script used to collect emails over all changes merged in
> the next release.
> 
> CC: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

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
> 2.47.0
> 
> 
