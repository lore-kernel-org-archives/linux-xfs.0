Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A362045AE
	for <linux-xfs@vger.kernel.org>; Wed, 12 Feb 2025 22:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739399062; cv=none; b=MMc+iit9eYXnWKHNCsYn5K3qaTQ2Ng6v3Ix8K8eB32ge/kAAwWd+xjJAKUTyTCFunOSrV9rMe0wYtnRGgY0OQcXVQhPz+WfBGckj8WmURrzkIA6xiY8pWavTtCeaRvCHPXnqh3/rnH4q1oLmFD5HVF2QmaBUCPqxRD6Pmf6z8po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739399062; c=relaxed/simple;
	bh=w9I54y9Hk1MvQoZbN5Tlx/D2YClWpuDrdgP2OEr7KHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rLu3FT9ATG2l8zqR2Bif0SaotUSzzzoQlQlMTkjyZ+xr8tIWda5CcL/utOeBhIwsw8yWmOShq+FLojQR8H55oZrUJhDXua/8XDZTkrwLYcTgR2fpk7cJC+01KLAZ2z4YEG966D61CTgnA0Qix4cEMNf+Q7sfzy411CE7mYT90Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ee/haZru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ee/haZru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC61C4CEEA;
	Wed, 12 Feb 2025 22:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739399062;
	bh=w9I54y9Hk1MvQoZbN5Tlx/D2YClWpuDrdgP2OEr7KHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ee/haZruftS4Jsv6KlvcD2bqfK/Ck4CNonmI1SOt0GiPGRRdHOUPIncofQgXymNou
	 96heFVSNc04tkY2SnnUVbROLKk/jZC/IN4J4dnXAm+6pEU4BolZiER0ZVU/4S93zLf
	 4XTtVGi2HZk+Kq+AokrfjFv0+3BgJMobYfQumOWWDwRBKCJ6PngZUVa17Jy0RX0LGL
	 RfKrwljEJNCI8aBmHMyD8A+IDkYidQC+1g3XC5GcQUh1NSHqm6agrmNVy5vRMpF7Ry
	 P5DtEZDr6n+7Q7WcFyr3TjvACkojQzsGvHz5lWX5pOyEQ31BkMy3b/GGY91308xqtM
	 PnLew8CP7dEOw==
Date: Wed, 12 Feb 2025 14:24:21 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH v3 5/8] Add git-contributors script to notify about merges
Message-ID: <20250212222421.GM21808@frogsfrogsfrogs>
References: <20250211-update-release-v3-0-7b80ae52c61f@kernel.org>
 <20250211-update-release-v3-5-7b80ae52c61f@kernel.org>
 <20250211185804.GD21808@frogsfrogsfrogs>
 <rzlzwjixwg7i442ohupcovrtol4awuhwusdm6uwx36jphf4sqy@2qx3yccpkqba>
 <okfajiswjiwtarmobpkjuce7wjyyccr44mzghryehtb7w6iqp4@wj6j54wsmxxk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <okfajiswjiwtarmobpkjuce7wjyyccr44mzghryehtb7w6iqp4@wj6j54wsmxxk>

On Wed, Feb 12, 2025 at 12:37:45PM +0100, Andrey Albershteyn wrote:
> On 2025-02-12 12:16:46, Andrey Albershteyn wrote:
> > On 2025-02-11 10:58:04, Darrick J. Wong wrote:
> > > On Tue, Feb 11, 2025 at 06:26:57PM +0100, Andrey Albershteyn wrote:
> > > > Add python script used to collect emails over all changes merged in
> > > > the next release.
> > > > 
> > > > CC: Darrick J. Wong <djwong@kernel.org>
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > > > ---
> > > >  tools/git-contributors.py | 94 +++++++++++++++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 94 insertions(+)
> > > > 
> > > > diff --git a/tools/git-contributors.py b/tools/git-contributors.py
> > > > new file mode 100755
> > > > index 0000000000000000000000000000000000000000..83bbe8ce0ee1dcbd591c6d3016d553fac2a7d286
> > > > --- /dev/null
> > > > +++ b/tools/git-contributors.py
> > > > @@ -0,0 +1,94 @@
> > > > +#!/usr/bin/python3
> > > > +
> > > > +# List all contributors to a series of git commits.
> > > > +# Copyright(C) 2025 Oracle, All Rights Reserved.
> > > > +# Licensed under GPL 2.0 or later
> > > > +
> > > > +import re
> > > > +import subprocess
> > > > +import io
> > > > +import sys
> > > > +import argparse
> > > > +import email.utils
> > > > +
> > > > +DEBUG = False
> > > > +
> > > > +def backtick(args):
> > > > +    '''Generator function that yields lines of a program's stdout.'''
> > > > +    if DEBUG:
> > > > +        print(' '.join(args))
> > > > +    p = subprocess.Popen(args, stdout = subprocess.PIPE)
> > > > +    for line in io.TextIOWrapper(p.stdout, encoding="utf-8"):
> > > > +        yield line
> > > > +
> > > > +class find_developers(object):
> > > > +    def __init__(self):
> > > > +        tags = '%s|%s|%s|%s|%s|%s|%s|%s' % (
> > > > +            'signed-off-by',
> > > > +            'acked-by',
> > > > +            'cc',
> > > > +            'reviewed-by',
> > > > +            'reported-by',
> > > > +            'tested-by',
> > > > +            'suggested-by',
> > > > +            'reported-and-tested-by')
> > > > +        # some tag, a colon, a space, and everything after that
> > > > +        regex1 = r'^(%s):\s+(.+)$' % tags
> > > > +
> > > > +        self.r1 = re.compile(regex1, re.I)
> > > > +
> > > > +    def run(self, lines):
> > > > +        addr_list = []
> > > > +
> > > > +        for line in lines:
> > > > +            l = line.strip()
> > > > +
> > > > +            # emailutils can handle abominations like:
> > > > +            #
> > > > +            # Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
> > > > +            # Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
> > > > +            # Reviewed-by: bogus@simpson.com
> > > > +            # Cc: <stable@vger.kernel.org> # v6.9
> > > > +            # Tested-by: Moo Cow <foo@bar.com> # powerpc
> > > > +            m = self.r1.match(l)
> > > > +            if not m:
> > > > +                continue
> > > > +            (name, addr) = email.utils.parseaddr(m.expand(r'\g<2>'))
> > > > +
> > > > +            # This last split removes anything after a hash mark,
> > > > +            # because someone could have provided an improperly
> > > > +            # formatted email address:
> > > > +            #
> > > > +            # Cc: stable@vger.kernel.org # v6.19+
> > > > +            #
> > > > +            # emailutils doesn't seem to catch this, and I can't
> > > > +            # fully tell from RFC2822 that this isn't allowed.  I
> > > > +            # think it is because dtext doesn't forbid spaces or
> > > > +            # hash marks.
> > > > +            addr_list.append(addr.split('#')[0])
> > > 
> > > I think it's the case that the canonical stable cc tag format for kernel
> > > patches as provided by the stable kernel process rules document:
> > > 
> > > Cc: <stable@vger.kernel.org> # vX.Y
> > > 
> > > is not actually actually rfc5322 compliant, so strings like that break
> > > Python's emailutils parsers.  parseaddr() completely chokes on this, and
> > > retuns name=='' and addr=='', because the only thing that can come after
> > > the address portion are whitespace, EOL, or a comma followed by more
> > > email addresses.  There's definitely not supposed to be an octothorpe
> > > followed by even more text.
> > > 
> > > In the end I let myself be nerdsniped with even more string parsing bs,
> > > and this loop body is the result:
> > > 
> > > 		l = line.strip()
> > > 
> > > 		# First, does this line match any of the headers we
> > > 		# know about?
> > > 		m = self.r1.match(l)
> > > 		if not m:
> > > 			continue
> > > 
> > > 		# The split removes everything after an octothorpe
> > > 		# (hash mark), because someone could have provided an
> > > 		# improperly formatted email address:
> > > 		#
> > > 		# Cc: stable@vger.kernel.org # v6.19+
> > > 		#
> > > 		# This, according to my reading of RFC5322, is allowed
> > > 		# because octothorpes can be part of atom text.
> > > 		# However, it is interepreted as if there weren't any
> > > 		# whitespace ("stable@vger.kernel.org#v6.19+").  The
> > > 		# grammar allows for this form, even though this is not
> > > 		# a correct Internet domain name.
> > > 		#
> > > 		# Worse, if you follow the format specified in the
> > > 		# kernel's SubmittingPatches file:
> > > 		#
> > > 		# Cc: <stable@vger.kernel.org> # v6.9
> > > 		#
> > > 		# emailutils will not know how to parse this, and
> > > 		# returns empty strings.  I think this is because the
> > > 		# angle-addr specification allows only whitespace
> > > 		# between the closing angle bracket and the CRLF.
> > > 		#
> > > 		# Hack around both problems by ignoring everything
> > > 		# after an octothorpe, no matter where it occurs in the
> > > 		# string.  If someone has one in their name or the
> > > 		# email address, too bad.
> > > 		a = m.expand(r'\g<2>').split('#')[0]
> > > 
> > > 		# emailutils can extract email addresses from headers
> > > 		# that roughly follow the destination address field
> > > 		# format:
> > > 		#
> > > 		# Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
> > > 		# Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
> > > 		# Reviewed-by: bogus@simpson.com
> > > 		# Tested-by: Moo Cow <foo@bar.com>
> > > 		#
> > > 		# Use it to extract the email address, because we don't
> > > 		# care about the display name.
> > > 		(name, addr) = email.utils.parseaddr(a)
> > > 		addr_list.append(addr)
> > > 
> > > <shrug> but maybe we should try that on a few branches first before
> > > committing to this string parsing mess ... ?  Not that this is any less
> > > stupid than the previous version I shared out. :(
> > 
> > Can we just drop anything with 'stable@'? These are patches from
> > libxfs syncs, do they have any value for stable@ list?
> > 
> > But the change is still make sense if anyone uses hash mark for
> > something else, I will apply your change.
> > 
> 
> Hmm, there's seems to be more cases to handle:
> 
> Cc: 1000974@bugs.debian.org, gustavoars@kernel.org, keescook@chromium.org

Ugh, ok, will go handle that one.

> Reported-by: Xu, Wen <wen.xu@gatech.edu>
> 
> Both fail to parse, the first one as it need to be split and second
> one due to comma

Technically speaking people are supposed to be quoting name punctuation
in the manner specified by the RFC ("Xu, Wen" <wen.xu@gatech.edu>) but
there's basically zero validation of any freeform git commit trailers
so everyone is stuck with inconsistent piles of regular expression
hacks.

(No, I'm not a fan of "be liberal in what you accept"; one ought to have
a strong motivation for taking on extra work)

Does this work?  Note the change from --delimiter to --separator.

--D

#!/usr/bin/env python3

# List all contributors to a series of git commits.
# Copyright(C) 2025 Oracle, All Rights Reserved.
# Licensed under GPL 2.0 or later

import re
import subprocess
import io
import sys
import argparse
import email.utils

DEBUG = False

def backtick(args):
	'''Generator function that yields lines of a program's stdout.'''
	if DEBUG:
		print(' '.join(args))
	p = subprocess.Popen(args, stdout = subprocess.PIPE)
	for line in io.TextIOWrapper(p.stdout, encoding="utf-8"):
		yield line

class find_developers(object):
	def __init__(self):
		tags = '%s|%s|%s|%s|%s|%s|%s|%s' % (
			'signed-off-by',
			'acked-by',
			'cc',
			'reviewed-by',
			'reported-by',
			'tested-by',
			'suggested-by',
			'reported-and-tested-by')
		# some tag, a colon, a space, and everything after that
		regex1 = r'^(%s):\s+(.+)$' % tags

		self.r1 = re.compile(regex1, re.I)

		# regex to guess if this is a list of multiple addresses.
		# Not sure why the initial "^.*" is needed here.
		self.r2 = re.compile(r'^.*,[^,]*@[^@]*,[^,]*@', re.I)

		# regex to match on anything inside a pair of angle brackets
		self.r3 = re.compile(r'^.*<(.+)>', re.I)

	def _handle_addr(self, addr):
		# The next split removes everything after an octothorpe (hash
		# mark), because someone could have provided an improperly
		# formatted email address:
		#
		# Cc: stable@vger.kernel.org # v6.19+
		#
		# This, according to my reading of RFC5322, is allowed because
		# octothorpes can be part of atom text.  However, it is
		# interepreted as if there weren't any whitespace
		# ("stable@vger.kernel.org#v6.19+").  The grammar allows for
		# this form, even though this is not a correct Internet domain
		# name.
		#
		# Worse, if you follow the format specified in the kernel's
		# SubmittingPatches file:
		#
		# Cc: <stable@vger.kernel.org> # v6.9
		#
		# emailutils will not know how to parse this, and returns empty
		# strings.  I think this is because the angle-addr
		# specification allows only whitespace between the closing
		# angle bracket and the CRLF.
		#
		# Hack around both problems by ignoring everything after an
		# octothorpe, no matter where it occurs in the string.  If
		# someone has one in their name or the email address, too bad.
		a = addr.split('#')[0]

		# emailutils can extract email addresses from headers that
		# roughly follow the destination address field format:
		#
		# Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
		# Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
		# Reviewed-by: bogus@simpson.com
		#
		# Use it to extract the email address, because we don't care
		# about the display name.
		(name, addr) = email.utils.parseaddr(a)
		if DEBUG:
			print(f'A:{a}:NAME:{name}:ADDR:{addr}:')
		if len(addr) > 0:
			return addr

		# If emailutils fails to find anything, let's see if there's
		# a sequence of characters within angle brackets and hope that
		# is an email address.  This works around things like:
		#
		# Reported-by: Xu, Wen <wen.xu@gatech.edu>
		#
		# Which should have had the name in quotations because there's
		# a comma.
		m = self.r3.match(a)
		if m:
			addr = m.expand(r'\g<1>')
			if DEBUG:
				print(f"M3:{addr}:M:{m}:")
			return addr

		# No idea, just spit the whole thing out and hope for the best.
		return a


	def run(self, lines):
		addr_list = []

		for line in lines:
			l = line.strip()

			# First, does this line match any of the headers we
			# know about?
			m = self.r1.match(l)
			if not m:
				continue
			rightside = m.expand(r'\g<2>')

			n = self.r2.match(rightside)
			if n:
				# Break the line into an array of addresses,
				# delimited by commas, then handle each
				# address.
				addrs = rightside.split(',')
				if DEBUG:
					print(f"0LINE:{rightside}:ADDRS:{addrs}:M:{n}")
				for addr in addrs:
					a = self._handle_addr(addr)
					addr_list.append(a)
			else:
				# Otherwise treat the line as a single email
				# address.
				if DEBUG:
					print(f"1LINE:{rightside}:M:{n}")
				a = self._handle_addr(rightside)
				addr_list.append(a)

		return sorted(set(addr_list))

def main():
	global DEBUG

	parser = argparse.ArgumentParser(description = "List email addresses of contributors to a series of git commits.")
	parser.add_argument("revspec", nargs = '?', default = None, \
			help = "git revisions to process.")
	parser.add_argument("--separator", type = str, default = '\n', \
			help = "Separate each email address with this string.")
	parser.add_argument('--debug', action = 'store_true', default = False, \
			help = argparse.SUPPRESS)
	args = parser.parse_args()

	if args.debug:
		DEBUG = True

	fd = find_developers()
	if args.revspec:
		# read git commits from repo
		contributors = fd.run(backtick(['git', 'log', '--pretty=medium',
				  args.revspec]))
	else:
		# read patch from stdin
		contributors = fd.run(sys.stdin.readlines())

	print(args.delimiter.join(sorted(contributors)))
	return 0

if __name__ == '__main__':
	sys.exit(main())
