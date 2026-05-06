Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952353F54BE
	for <linux-xfs@vger.kernel.org>; Wed,  6 May 2026 16:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778085480; cv=none; b=R8iHRyMipQPQaZ84uN2fQ+Hgiudqze/88T4+MV3X1cVjr1Iq0hNxdccgDDXuKZUqfN4RmcaKBtmhlRCZ349Ax3KaEUlqoZK2ZHUYe1ftFE9OooqBGnkEd4Xgk2zt/crpUoID9E3rnGMTMVk0B59EC1n3Jt1zDO33pAvalur9AfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778085480; c=relaxed/simple;
	bh=6UXYIJ9A834c3zJWr0O6LZW5CnHgxxe8hN71Q16fpkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4CXrgh3H5DNy4XDJq9pHc2CdFD9AObP0TfLYgONFAK7z+3jxZgWYqaIM09ccH+8pVIKJP8HISzSxwUJipHYhwgL2ClYxHQXD38m8yAADONcysQ+ZskhBuL5DyxaAdIFLfHtDvUg8PTowUiwo1f77zf1LrKnlUi1rxg5rPrKTeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GOwzQzUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GOwzQzUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBB4C2BCB0;
	Wed,  6 May 2026 16:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778085480;
	bh=6UXYIJ9A834c3zJWr0O6LZW5CnHgxxe8hN71Q16fpkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOwzQzUlpLyqHZwTcAkgW0fvxEW6lzzhKnjQAYfkd3cXvUq/eQNX4NAU1THahWs2v
	 U+Bwu2NdwQNtVGyiA0RxmlgNU/8Z2pGwwzhnbXTUOSXeJNvAtxOshu3u0FQOipEmhz
	 BX2sCpVvIgtnfmiYzPDWG6ZZ2pswBvZ8WShYcrgXNaMlQREmB4ElbGJn8fILYxRvSc
	 V+RFnoietR6WQSEkmnyeLKan1lhZnLQt/XlCWbXa6FdXQTlzxmFmlnD5G/KGrNO2+4
	 3kSimdyAuTgva5JscISSBf4L76lOg6DDHhxSwGQAg1BwcBN4yJEYF4hTc8Kj8Kz1AT
	 tLuegcrkoO49w==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@kernel.org>
Subject: [PATCH 2/2] xfsdump: update release.sh
Date: Wed,  6 May 2026 18:37:44 +0200
Message-ID: <20260506163746.1083845-3-aalbersh@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260506163746.1083845-1-aalbersh@kernel.org>
References: <20260506163746.1083845-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update release.sh script to automate releases and for-next updates even
more.

This is copy-paste from xfsprogs repository with a few changes:
- update shebang
- s/xfsprogs/xfsdump/
- remove old comment
- remind maintainer to upload tarball
- remove "The for-next branch has also ..." from for-next update email

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
---
 release.sh                | 197 +++++++++++++++++++++++++++++++++++---
 tools/git-contributors.py | 168 ++++++++++++++++++++++++++++++++
 2 files changed, 351 insertions(+), 14 deletions(-)
 create mode 100755 tools/git-contributors.py

diff --git a/release.sh b/release.sh
index e34b397072d4..a17329c88548 100755
--- a/release.sh
+++ b/release.sh
@@ -1,30 +1,199 @@
-#!/bin/bash
-#
-# Automate generation a new release
+#!/usr/bin/env bash
 #
+# Automate generation of a new release
+
+set -e
+
+KUP=0
+COMMIT=1
+LAST_HEAD=""
+FOR_NEXT=0
+
+help() {
+	echo "$(basename $0) - prepare xfsdump release tarball or for-next update"
+	printf "\t[--kup|-k] upload final tarball with KUP\n"
+	printf "\t[--no-commit|-n] don't create release commit\n"
+	printf "\t[--last-head|-l] commit of the last release\n"
+	printf "\t[--for-next|-f] generate announce email for for-next update\n"
+}
+
+update_version() {
+	echo "Updating version files"
+	# doc/CHANGES
+	header="xfsdump-${version} ($(date +'%d %b %Y'))"
+	sed -i "1s/^/$header\n\t<TODO list user affecting changes>\n\n/" doc/CHANGES
+	$EDITOR doc/CHANGES
+
+	# ./configure.ac
+	CONF_AC="AC_INIT([xfsdump],[${version}],[linux-xfs@vger.kernel.org])"
+	sed -i "s/^AC_INIT.*/$CONF_AC/" ./configure.ac
+
+	# ./debian/changelog
+	sed -i "1s/^/\n/" ./debian/changelog
+	sed -i "1s/^/ -- Nathan Scott <nathans@debian.org>  `date -R`\n/" ./debian/changelog
+	sed -i "1s/^/\n/" ./debian/changelog
+	sed -i "1s/^/  * New upstream release\n/" ./debian/changelog
+	sed -i "1s/^/\n/" ./debian/changelog
+	sed -i "1s/^/xfsdump (${version}-1) unstable; urgency=low\n/" ./debian/changelog
+}
+
+prepare_mail() {
+	branch="$1"
+	mail_file=$(mktemp)
+	if [ -n "$LAST_HEAD" ]; then
+		if [ $branch == "master" ]; then
+			reason="$(git describe --abbrev=0 $branch) released"
+			for_next_update="\n\nThe for-next branch has also been updated to match the state of master."
+		else
+			reason="for-next updated to $(git log --oneline --format="%h" -1 $branch)"
+			for_next_update=""
+		fi;
+		cat << EOF > $mail_file
+To: linux-xfs@vger.kernel.org
+Cc: $(./tools/git-contributors.py $LAST_HEAD..$branch --separator ', ')
+Subject: [ANNOUNCE] xfsdump: $reason
+
+Hi folks,
+
+The xfsdump $branch branch in repository at:
+
+	git://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git
+
+has just been updated.
+
+Patches often get missed, so if your outstanding patches are properly reviewed
+on the list and not included in this update, please let me know.$(printf "%b" "$for_next_update")
+
+The new head of the $branch branch is commit:
+
+$(git log --oneline --format="%H" -1 $branch)
+
+New commits:
+
+$(git shortlog --format="[%h] %s" $LAST_HEAD..$branch)
+
+Code Diffstat:
+
+$(git diff --stat --summary -C -M $LAST_HEAD..$branch)
+EOF
+	fi
+}
+
+while [ $# -gt 0 ]; do
+	case "$1" in
+		--kup|-k)
+			KUP=1
+			;;
+		--no-commit|-n)
+			COMMIT=0
+			;;
+		--last-head|-l)
+			LAST_HEAD=$2
+			shift
+			;;
+		--for-next|-f)
+			FOR_NEXT=1
+			;;
+		--help|-h)
+			help
+			exit 0
+			;;
+		*)
+			>&2 printf "Error: Invalid argument\n"
+			exit 1
+			;;
+		esac
+	shift
+done
+
+if [ $FOR_NEXT -eq 1 ]; then
+	echo "Push your for-next branch:"
+	printf "\tgit push origin for-next:for-next\n"
+	prepare_mail "for-next"
+	if [ -n "$LAST_HEAD" ]; then
+		echo "Command to send ANNOUNCE email"
+		printf "\tneomutt -H $mail_file\n"
+	fi
+	exit 0
+fi
+
+if [ -z "$EDITOR" ]; then
+	EDITOR=$(command -v vi)
+fi
+
+if [ $COMMIT -eq 1 ]; then
+	if git diff --exit-code ./VERSION > /dev/null; then
+		$EDITOR ./VERSION
+	fi
+fi
 
 . ./VERSION
 
 version=${PKG_MAJOR}.${PKG_MINOR}.${PKG_REVISION}
 date=`date +"%-d %B %Y"`
 
+if [ $COMMIT -eq 1 ]; then
+	update_version
+
+	git diff --color=always | less -r
+	[[ "$(read -e -p 'All good? [Y/n]> '; echo $REPLY)" == [Nn]* ]] && exit 0
+
+	echo "Commiting new version update to git"
+	git commit --all --signoff --message="xfsdump: Release v${version}
+
+Update all the necessary files for a v${version} release."
+
+	echo "Tagging git repository"
+	git tag --annotate --sign --message="Release v${version}" v${version}
+fi
+
 echo "Cleaning up"
 make realclean
+rm -rf "xfsdump-${version}.tar" \
+	"xfsdump-${version}.tar.gz" \
+	"xfsdump-${version}.tar.asc" \
+	"xfsdump-${version}.tar.sign"
 
-echo "Updating CHANGES"
-sed -e "s/${version}.*/${version} (${date})/" doc/CHANGES > doc/CHANGES.tmp && \
-	mv doc/CHANGES.tmp doc/CHANGES
-
-echo "Commiting CHANGES update to git"
-git commit -s -a -m "${version} release"
-
-echo "Tagging git repository"
-git tag -s -a -m "${version} release" v${version}
 
 echo "Making source tarball"
 make dist
+gunzip -k "xfsdump-${version}.tar.gz"
 
 echo "Sign the source tarball"
-gpg --detach-sign xfsdump-${version}.tar.gz
+gpg \
+	--detach-sign \
+	--armor \
+	"xfsdump-${version}.tar"
 
-echo "Done.  Please remember to push out tags using \"git push --tags\""
+echo "Verify signature"
+gpg \
+	--verify \
+	"xfsdump-${version}.tar.asc"
+if [ $? -ne 0 ]; then
+	echo "Can not verify signature of tarball"
+	exit 1
+fi
+
+mv "xfsdump-${version}.tar.asc" "xfsdump-${version}.tar.sign"
+
+if [ $KUP -eq 1 ]; then
+	kup put \
+		xfsdump-${version}.tar.gz \
+		xfsdump-${version}.tar.sign \
+		pub/linux/utils/fs/xfs/xfsdump/
+fi;
+
+prepare_mail "master"
+
+echo ""
+echo "Done. Please remember to push out tags and the branch."
+printf "\tgit push origin v${version} master:master master:for-next\n"
+if [ -n "$LAST_HEAD" ]; then
+	echo "Command to send ANNOUNCE email"
+	printf "\tneomutt -H $mail_file\n"
+fi
+if [ $KUP -ne 1 ]; then
+	echo "Don't forget to upload tarball:"
+	echo -e "\tkup put xfsdump-${version}.tar.gz" \
+		"xfsdump-${version}.tar.sign pub/linux/utils/fs/xfs/xfsdump/"
+fi
diff --git a/tools/git-contributors.py b/tools/git-contributors.py
new file mode 100755
index 000000000000..01177a9af749
--- /dev/null
+++ b/tools/git-contributors.py
@@ -0,0 +1,168 @@
+#!/usr/bin/env python3
+
+# List all contributors to a series of git commits.
+# Copyright(C) 2025 Oracle, All Rights Reserved.
+# Licensed under GPL 2.0 or later
+
+import re
+import subprocess
+import io
+import sys
+import argparse
+import email.utils
+
+DEBUG = False
+
+def backtick(args):
+    '''Generator function that yields lines of a program's stdout.'''
+    if DEBUG:
+        print(' '.join(args))
+    p = subprocess.Popen(args, stdout = subprocess.PIPE)
+    for line in io.TextIOWrapper(p.stdout, encoding="utf-8"):
+        yield line
+
+class find_developers(object):
+    def __init__(self):
+        tags = '%s|%s|%s|%s|%s|%s|%s|%s' % (
+            'signed-off-by',
+            'acked-by',
+            'cc',
+            'reviewed-by',
+            'reported-by',
+            'tested-by',
+            'suggested-by',
+            'reported-and-tested-by')
+        # some tag, a colon, a space, and everything after that
+        regex1 = r'^(%s):\s+(.+)$' % tags
+
+        self.r1 = re.compile(regex1, re.I)
+
+        # regex to guess if this is a list of multiple addresses.
+        # Not sure why the initial "^.*" is needed here.
+        self.r2 = re.compile(r'^.*,[^,]*@[^@]*,[^,]*@', re.I)
+
+        # regex to match on anything inside a pair of angle brackets
+        self.r3 = re.compile(r'^.*<(.+)>', re.I)
+
+    def _handle_addr(self, addr):
+        # The next split removes everything after an octothorpe (hash
+        # mark), because someone could have provided an improperly
+        # formatted email address:
+        #
+        # Cc: stable@vger.kernel.org # v6.19+
+        #
+        # This, according to my reading of RFC5322, is allowed because
+        # octothorpes can be part of atom text.  However, it is
+        # interepreted as if there weren't any whitespace
+        # ("stable@vger.kernel.org#v6.19+").  The grammar allows for
+        # this form, even though this is not a correct Internet domain
+        # name.
+        #
+        # Worse, if you follow the format specified in the kernel's
+        # SubmittingPatches file:
+        #
+        # Cc: <stable@vger.kernel.org> # v6.9
+        #
+        # emailutils will not know how to parse this, and returns empty
+        # strings.  I think this is because the angle-addr
+        # specification allows only whitespace between the closing
+        # angle bracket and the CRLF.
+        #
+        # Hack around both problems by ignoring everything after an
+        # octothorpe, no matter where it occurs in the string.  If
+        # someone has one in their name or the email address, too bad.
+        a = addr.split('#')[0]
+
+        # emailutils can extract email addresses from headers that
+        # roughly follow the destination address field format:
+        #
+        # Reviewed-by: Bogus J. Simpson <bogus@simpson.com>
+        # Reviewed-by: "Bogus J. Simpson" <bogus@simpson.com>
+        # Reviewed-by: bogus@simpson.com
+        #
+        # Use it to extract the email address, because we don't care
+        # about the display name.
+        (name, addr) = email.utils.parseaddr(a)
+        if DEBUG:
+            print(f'A:{a}:NAME:{name}:ADDR:{addr}:')
+        if len(addr) > 0:
+            return addr
+
+        # If emailutils fails to find anything, let's see if there's
+        # a sequence of characters within angle brackets and hope that
+        # is an email address.  This works around things like:
+        #
+        # Reported-by: Xu, Wen <wen.xu@gatech.edu>
+        #
+        # Which should have had the name in quotations because there's
+        # a comma.
+        m = self.r3.match(a)
+        if m:
+            addr = m.expand(r'\g<1>')
+            if DEBUG:
+                print(f"M3:{addr}:M:{m}:")
+            return addr
+
+        # No idea, just spit the whole thing out and hope for the best.
+        return a
+
+    def run(self, lines):
+        addr_list = []
+
+        for line in lines:
+            l = line.strip()
+
+            # First, does this line match any of the headers we
+            # know about?
+            m = self.r1.match(l)
+            if not m:
+                continue
+            rightside = m.expand(r'\g<2>')
+
+            n = self.r2.match(rightside)
+            if n:
+                # Break the line into an array of addresses,
+                # delimited by commas, then handle each
+                # address.
+                addrs = rightside.split(',')
+                if DEBUG:
+                    print(f"0LINE:{rightside}:ADDRS:{addrs}:M:{n}")
+                for addr in addrs:
+                    a = self._handle_addr(addr)
+                    addr_list.append(a)
+            else:
+                # Otherwise treat the line as a single email
+                # address.
+                if DEBUG:
+                    print(f"1LINE:{rightside}:M:{n}")
+                a = self._handle_addr(rightside)
+                addr_list.append(a)
+
+        return sorted(set(addr_list))
+
+def main():
+    global DEBUG
+
+    parser = argparse.ArgumentParser(description = "List email addresses of contributors to a series of git commits.")
+    parser.add_argument("revspec", help = "git revisions to process.")
+    parser.add_argument("--separator", type = str, default = '\n', \
+            help = "Separate each email address with this string.")
+    parser.add_argument('--debug', action = 'store_true', default = False, \
+            help = argparse.SUPPRESS)
+    args = parser.parse_args()
+
+    if args.debug:
+        DEBUG = True
+
+    fd = find_developers()
+    if args.revspec:
+        # read git commits from repo
+        contributors = fd.run(backtick(['git', 'log', '--pretty=medium',
+                  args.revspec]))
+
+    print(args.separator.join(sorted(contributors)))
+    return 0
+
+if __name__ == '__main__':
+    sys.exit(main())
+
-- 
2.51.2

