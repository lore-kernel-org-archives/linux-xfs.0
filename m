Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952EB266B56
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 21:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739483271; cv=none; b=d/vGAo+fxD8kz7wfJDB1OmxQz/2Efb2J910Bo5ZnX/BMESud3kmsKoDWK3R3VUEFEfMC+I51F7MI8hXQNk4YZFkA5qCHNMbEyMMOQarh7W37Zxkrmtl5+QcA6ws8tjPMkGMgFzxFOIbHm4bzaFMwliPmDOVjVCK4TVTb3N6X9fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739483271; c=relaxed/simple;
	bh=72vLKIaweeu+Eh/PFQBxAclODG0vrU58gwpBO6Yuqjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwZTA+AKsdfsYASgp6f4eI1rxsDJIlKWuGRJLmcHXyk5Obdqg3ta1HIbFobPxPowHGa6PnQPMB9KFWwk6XbLmtW8QaKmzDIzywPslB/1JRjcGK9lCnnc+gTzihJTqE0viM5oI4FO8dG6QtwS6W1mtgrmlAB+tSmIepx8Y049Sj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FtMyKCc9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FtMyKCc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD3CC4CED1;
	Thu, 13 Feb 2025 21:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739483271;
	bh=72vLKIaweeu+Eh/PFQBxAclODG0vrU58gwpBO6Yuqjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FtMyKCc93i2fkrB/+7obdJOc6P1IK5JGp70IqZJpKISuaYHDbylrcnbcALm4gRj8x
	 HRmzVvoZCizBjzNqsfoNx078byrh3a9OPAS7XQPUYnKWYV77p+2nGhUEsJl8yDWPA5
	 r3pzs0Z5makPhOiu8Mn9c3VH/75AipugWM+oYdnqTwrWzjyuUfIzU1CU9yjqvDOc1+
	 XIGvGuNgWUWQkAond+C6MJ7MNu8LfvmQHuUV2axq/NId6b03YIYCSWJWZZKuOsRzQq
	 Oco3GHFmwt/omHtcuXkCcsB4vNkEnWskErVE9k2EZAfALo3ttNbVMIGRvrWBbEsrK6
	 J+XMkAPubIC8Q==
Date: Thu, 13 Feb 2025 13:47:50 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v4 05/10] git-contributors: better handling of hash
 mark/multiple emails
Message-ID: <20250213214750.GS21808@frogsfrogsfrogs>
References: <20250213-update-release-v4-0-c06883a8bbd6@kernel.org>
 <20250213-update-release-v4-5-c06883a8bbd6@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213-update-release-v4-5-c06883a8bbd6@kernel.org>

On Thu, Feb 13, 2025 at 09:14:27PM +0100, Andrey Albershteyn wrote:
> Better handling of hash mark, tags with multiple emails and not
> quoted names in emails. See comments in the script.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Matches my original git-contributors script, good enough for now
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  tools/git-contributors.py | 109 ++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 90 insertions(+), 19 deletions(-)
> 
> diff --git a/tools/git-contributors.py b/tools/git-contributors.py
> index 70ac8abb26c8ce65de336c5ae48abcfee39508b2..1a0f2b80e3dad9124b86b29f8507389ef91fe813 100755
> --- a/tools/git-contributors.py
> +++ b/tools/git-contributors.py
> @@ -37,35 +37,106 @@ class find_developers(object):
>  
>          self.r1 = re.compile(regex1, re.I)
>  
> +        # regex to guess if this is a list of multiple addresses.
> +        # Not sure why the initial "^.*" is needed here.
> +        self.r2 = re.compile(r'^.*,[^,]*@[^@]*,[^,]*@', re.I)
> +
> +        # regex to match on anything inside a pair of angle brackets
> +        self.r3 = re.compile(r'^.*<(.+)>', re.I)
> +
> +    def _handle_addr(self, addr):
> +        # The next split removes everything after an octothorpe (hash
> +        # mark), because someone could have provided an improperly
> +        # formatted email address:
> +        #
> +        # Cc: stable@vger.kernel.org # v6.19+
> +        #
> +        # This, according to my reading of RFC5322, is allowed because
> +        # octothorpes can be part of atom text.  However, it is
> +        # interepreted as if there weren't any whitespace
> +        # ("stable@vger.kernel.org#v6.19+").  The grammar allows for
> +        # this form, even though this is not a correct Internet domain
> +        # name.
> +        #
> +        # Worse, if you follow the format specified in the kernel's
> +        # SubmittingPatches file:
> +        #
> +        # Cc: <stable@vger.kernel.org> # v6.9
> +        #
> +        # emailutils will not know how to parse this, and returns empty
> +        # strings.  I think this is because the angle-addr
> +        # specification allows only whitespace between the closing
> +        # angle bracket and the CRLF.
> +        #
> +        # Hack around both problems by ignoring everything after an
> +        # octothorpe, no matter where it occurs in the string.  If
> +        # someone has one in their name or the email address, too bad.
> +        a = addr.split('#')[0]
> +
> +        # emailutils can extract email addresses from headers that
> +        # roughly follow the destination address field format:
> +        #
> +        # Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
> +        # Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
> +        # Reviewed-by: bogus@simpson.com
> +        #
> +        # Use it to extract the email address, because we don't care
> +        # about the display name.
> +        (name, addr) = email.utils.parseaddr(a)
> +        if DEBUG:
> +            print(f'A:{a}:NAME:{name}:ADDR:{addr}:')
> +        if len(addr) > 0:
> +            return addr
> +
> +        # If emailutils fails to find anything, let's see if there's
> +        # a sequence of characters within angle brackets and hope that
> +        # is an email address.  This works around things like:
> +        #
> +        # Reported-by: Xu, Wen <wen.xu@gatech.edu>
> +        #
> +        # Which should have had the name in quotations because there's
> +        # a comma.
> +        m = self.r3.match(a)
> +        if m:
> +            addr = m.expand(r'\g<1>')
> +            if DEBUG:
> +                print(f"M3:{addr}:M:{m}:")
> +            return addr
> +
> +        # No idea, just spit the whole thing out and hope for the best.
> +        return a
> +
>      def run(self, lines):
>          addr_list = []
>  
>          for line in lines:
>              l = line.strip()
>  
> -            # emailutils can handle abominations like:
> -            #
> -            # Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
> -            # Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
> -            # Reviewed-by: bogus@simpson.com
> -            # Cc: <stable@vger.kernel.org> # v6.9
> -            # Tested-by: Moo Cow <foo@bar.com> # powerpc
> +            # First, does this line match any of the headers we
> +            # know about?
>              m = self.r1.match(l)
>              if not m:
>                  continue
> -            (name, addr) = email.utils.parseaddr(m.expand(r'\g<2>'))
> +            rightside = m.expand(r'\g<2>')
>  
> -            # This last split removes anything after a hash mark,
> -            # because someone could have provided an improperly
> -            # formatted email address:
> -            #
> -            # Cc: stable@vger.kernel.org # v6.19+
> -            #
> -            # emailutils doesn't seem to catch this, and I can't
> -            # fully tell from RFC2822 that this isn't allowed.  I
> -            # think it is because dtext doesn't forbid spaces or
> -            # hash marks.
> -            addr_list.append(addr.split('#')[0])
> +            n = self.r2.match(rightside)
> +            if n:
> +                # Break the line into an array of addresses,
> +                # delimited by commas, then handle each
> +                # address.
> +                addrs = rightside.split(',')
> +                if DEBUG:
> +                    print(f"0LINE:{rightside}:ADDRS:{addrs}:M:{n}")
> +                for addr in addrs:
> +                    a = self._handle_addr(addr)
> +                    addr_list.append(a)
> +            else:
> +                # Otherwise treat the line as a single email
> +                # address.
> +                if DEBUG:
> +                    print(f"1LINE:{rightside}:M:{n}")
> +                a = self._handle_addr(rightside)
> +                addr_list.append(a)
>  
>          return sorted(set(addr_list))
>  
> 
> -- 
> 2.47.2
> 
> 
