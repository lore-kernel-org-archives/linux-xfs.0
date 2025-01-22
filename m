Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D79B38B
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 02:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737511344; cv=none; b=pU1YKWWsQo3SToyTqgme++OgU7xHB5kGUn7R19NcB07kMPv03yVfok53cu0VlvC2V/66gg6k9Z+Tn49nZ3T9cUaKBLaNNeQeMlYtVpEAG9SrpNY0bb/dWUuqy3xztDD5WsP9AV33LygsO95RqU+5T2pjw8mb4YOTkGSVt2ugRTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737511344; c=relaxed/simple;
	bh=gP6sr8zD+Wa58eskcFpMuDuo1I7XTJBjoSugpp/pPjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a1k8qu+m7ase8auIl0mMuFv1rbx+eONdHv1iDRiKGrYovZtcYPcc2VHzDKx5hrzsJHGHq2FtbJFuM3RdLmbGnMysbOtuhcpz8pO1jkLq+DGnIk/LL/C+dwfwLTvXKukJNKnjbKf/Z69hNyzjz6Q/qxLb4cmjYO3/Nh5wjKoNBT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIjW7jxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIjW7jxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9716C4CEDF;
	Wed, 22 Jan 2025 02:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737511343;
	bh=gP6sr8zD+Wa58eskcFpMuDuo1I7XTJBjoSugpp/pPjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lIjW7jxL7vBMroeHFLYCSEhIzhQGxwvSxc1a2SqaPG5fTsuLdAYuO/HQu+YyYVTdd
	 auy3PyKP11pBjbr5t4RKKjrbkiHwW8v/MODjpKPnIgBNWDG1CLux1QmaAOPUajFUrV
	 MKuGo2gJCM4BMKZb4IloPo8jwlZdIAW/48xfgClMUCXiSNebSiIQtCmu+HlcaZCu5+
	 ip0+Zyd8wbW0ZfwKTckXku8CM88oynn3m0f1wfIKip4kdimXAjILAe1ba1qrKejVej
	 CuyJmI7Ma/v61r5++3IeAXcP4DPhy8q8uh0gH9lhLuNjblyUpoL4IM9td5jME2tZAy
	 xBXcTX69b3wfQ==
Date: Tue, 21 Jan 2025 18:02:23 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, Andrey Albershteyn <aalbersh@kernel.org>
Subject: Re: [PATCH 4/4] release.sh: generate ANNOUNCE email
Message-ID: <20250122020223.GM1611770@frogsfrogsfrogs>
References: <20250110-update-release-v1-0-61e40b8ffbac@kernel.org>
 <20250110-update-release-v1-4-61e40b8ffbac@kernel.org>
 <20250116224148.GF1611770@frogsfrogsfrogs>
 <xmsug3nmcya5exv3uq6osooysh7qjjoqh7zz6duqbyxgh5uh75@p4brhy2gdomx>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xmsug3nmcya5exv3uq6osooysh7qjjoqh7zz6duqbyxgh5uh75@p4brhy2gdomx>

On Mon, Jan 20, 2025 at 01:14:18PM +0100, Andrey Albershteyn wrote:
> On 2025-01-16 14:41:48, Darrick J. Wong wrote:
> > On Fri, Jan 10, 2025 at 12:05:09PM +0100, Andrey Albershteyn wrote:
> > > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > > ---
> > >  release.sh | 46 +++++++++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 45 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/release.sh b/release.sh
> > > index c34efcbcdfcaf50a08853e65542e8f16214cfb4e..40ecfaff66c3e9f8d794e7543750bd9579b7c6c9 100755
> > > --- a/release.sh
> > > +++ b/release.sh
> > > @@ -13,11 +13,13 @@ set -e
> > >  
> > >  KUP=0
> > >  COMMIT=1
> > > +LAST_HEAD=""
> > >  
> > >  help() {
> > >  	echo "$(basename) - create xfsprogs release"
> > >  	printf "\t[--kup|-k] upload final tarball with KUP\n"
> > >  	printf "\t[--no-commit|-n] don't create release commit\n"
> > > +	printf "\t[--last-head|-h] commit of the last release\n"
> > >  }
> > >  
> > >  update_version() {
> > > @@ -48,6 +50,10 @@ while [ $# -gt 0 ]; do
> > >  		--no-commit|-n)
> > >  			COMMIT=0
> > >  			;;
> > > +		--last-head|-h)
> > > +			LAST_HEAD=$2
> > > +			shift
> > > +			;;
> > >  		--help|-h)
> > >  			help
> > >  			exit 0
> > > @@ -122,7 +128,45 @@ if [ $KUP -eq 1 ]; then
> > >  		pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-${version}.tar.gz
> > >  fi;
> > >  
> > > +mail_file=$(mktemp)
> > > +subject=""
> > > +if [ -n "$LAST_HEAD" ]; then
> > > +	subject="[ANNOUNCE] xfsprogs $(git describe --abbrev=0) released"
> > > +
> > > +	cat << EOF > $mail_file
> > > +Hi folks,
> > > +
> > > +The xfsprogs repository at:
> > > +
> > > +	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> > > +
> > > +has just been updated.
> > > +
> > > +Patches often get missed, so if your outstanding patches are properly reviewed
> > > +on the list and not included in this update, please let me know.
> > > +
> > > +The for-next branch has also been updated to match the state of master.
> > > +
> > > +The new head of the master branch is commit:
> > > +
> > > +$(git log --oneline --format="%H" -1)
> > > +
> > > +New commits:
> > > +
> > > +$(git shortlog --format="[%h] %s" $LAST_HEAD..HEAD)
> > > +
> > > +Code Diffstat:
> > > +
> > > +$(git diff --stat --summary -C -M $LAST_HEAD..HEAD)
> > > +EOF
> > > +fi
> > 
> > Looks pretty similar to my git-announce tool. ;)
> > 
> > > +
> > >  echo ""
> > > -echo "Done. Please remember to push out tags and the branch."
> > > +echo "Done."
> > > +echo "Please remember to push out tags and the branch."
> > >  printf "\tgit push origin v${version}\n"
> > >  printf "\tgit push origin master\n"
> > > +if [ -n "$LAST_HEAD" ]; then
> > > +	echo "Command to send ANNOUNCE email"
> > > +	printf "\tneomutt linux-xfs@vger.kernel.org -s \"$subject\" -i $mail_file\n"
> > 
> > Note: if you put the headers in $mail_file, like this:
> > 
> > cat << EOF > $mail_file
> > To: linux-xfs@vger.kernel.org
> > Subject: $subject
> > 
> > Hi folks,
> > ...
> > ENDL
> > 
> > then you can do:
> > 
> > 	neomutt -H $mail_file
> 
> Neat, will update this
> 
> > 
> > to edit the message and send it out.  I also wonder if you'd like a copy
> > of my git-contributors script that spits out a list of emails to cc
> > based on the git diff?
> 
> sure, is it small enough to be a part of this file?

Er.... maybe part of the patch, but it's a python script:

--D

#!/usr/bin/python3

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

	def run(self, lines):
		addr_list = []

		for line in lines:
			l = line.strip()

			# emailutils can handle abominations like:
			#
			# Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
			# Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
			# Reviewed-by: bogus@simpson.com
			# Cc: <stable@vger.kernel.org> # v6.9
			# Tested-by: Moo Cow <foo@bar.com> # powerpc
			m = self.r1.match(l)
			if not m:
				continue
			(name, addr) = email.utils.parseaddr(m.expand(r'\g<2>'))

			# This last split removes anything after a hash mark,
			# because someone could have provided an improperly
			# formatted email address:
			#
			# Cc: stable@vger.kernel.org # v6.19+
			#
			# emailutils doesn't seem to catch this, and I can't
			# fully tell from RFC2822 that this isn't allowed.  I
			# think it is because dtext doesn't forbid spaces or
			# hash marks.
			addr_list.append(addr.split('#')[0])

		return sorted(set(addr_list))

def main():
	parser = argparse.ArgumentParser(description = "List email addresses of contributors to a series of git commits.")
	parser.add_argument("revspec", nargs = '?', default = None, \
			help = "git revisions to process.")
	parser.add_argument("--delimiter", type = str, default = '\n', \
			help = "Separate each email address with this string.")
	args = parser.parse_args()

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
