Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 66E2229E2A
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:11:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 48FD6304053
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:11:05 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 8dtGxVfzjnQtl6Z8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:11:02 -0800 (PST)
Subject: [PATCH 01/11] test-scripts: test migration scripts
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:10:59 -0800
Message-ID: <20151219091059.15320.77475.stgit@birch.djwong.org>
In-Reply-To: <20151219091052.15320.94973.stgit@birch.djwong.org>
References: <20151219091052.15320.94973.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Add two scripts: "nextid" finds the next available test ID number in a
group, and "mvtest" relocates a test, fixes the golden output, and
moves the group entry for that test.

v2: sorting group files should preserve group order; nextid should use
the same algorithm as new; move both tools to tools/.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/mvtest     |   55 +++++++++++++++++++++++++++
 tools/nextid     |    1 
 tools/sort-group |  112 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 168 insertions(+)
 create mode 100755 tools/mvtest
 create mode 120000 tools/nextid
 create mode 100755 tools/sort-group


diff --git a/tools/mvtest b/tools/mvtest
new file mode 100755
index 0000000..af601d6
--- /dev/null
+++ b/tools/mvtest
@@ -0,0 +1,55 @@
+#!/bin/sh
+
+# Renumber a test
+dir="$(dirname "$0")"
+
+if [ -z "$1" ] || [ "$1" = "--help" ]; then
+	echo "Usage: $0 path_to_test new_path_to_test"
+	exit 1
+fi
+
+src="$1"
+dest="$2"
+
+die() {
+	echo "$@"
+	exit 1
+}
+
+append() {
+	out="$1"
+	shift
+	echo "$@" >> "${out}"
+}
+
+test "${src}" != "${dest}" || die "Test \"${src}\" is the same as dest."
+test -e "tests/${src}" || die "Test \"${src}\" does not exist."
+test ! -e "tests/${dest}" || die "Test \"${src}\" already exists."
+
+sid="$(basename "${src}")"
+did="$(basename "${dest}")"
+
+sgroup="$(basename "$(dirname "tests/${src}")")"
+dgroup="$(basename "$(dirname "tests/${dest}")")"
+
+sgroupfile="tests/${sgroup}/group"
+dgroupfile="tests/${sgroup}/group"
+
+git mv "tests/${src}" "tests/${dest}"
+git mv "tests/${src}.out" "tests/${dest}.out"
+sed -e "s/^# FS QA Test No. ${sid}$/# FS QA Test No. ${did}/g" -i "tests/${dest}"
+sed -e "s/^QA output created by ${sid}$/QA output created by ${did}/g" -i "tests/${dest}.out"
+sed -e "s/test-${sid}/test-${did}/g" -i "tests/${dest}.out"
+
+grpline="$(grep "^${sid} " "${sgroupfile}")"
+newgrpline="$(echo "${grpline}" | sed -e "s/^${sid} /${did} /g")"
+
+sed -e "/^${sid}.*$/d" -i "${sgroupfile}"
+cp "${dgroupfile}" "${dgroupfile}.new"
+append "${dgroupfile}.new" "${newgrpline}"
+"${dir}/sort-group.py" "${dgroupfile}.new"
+mv "${dgroupfile}.new" "${dgroupfile}"
+
+echo "Moved \"${src}\" to \"${dest}\"."
+
+exit 0
diff --git a/tools/nextid b/tools/nextid
new file mode 120000
index 0000000..5c31d60
--- /dev/null
+++ b/tools/nextid
@@ -0,0 +1 @@
+sort-group
\ No newline at end of file
diff --git a/tools/sort-group b/tools/sort-group
new file mode 100755
index 0000000..84944ed
--- /dev/null
+++ b/tools/sort-group
@@ -0,0 +1,112 @@
+#!/usr/bin/env python
+import sys
+
+# Sort a group list, carefully preserving comments.
+
+def xfstest_key(key):
+	'''Extract the numeric part of a test name if possible.'''
+	k = 0
+
+	assert type(key) == str
+
+	# No test number at all...
+	if not key[0].isdigit():
+		return key
+
+	# ...otherwise extract as much number as we can.
+	for digit in key:
+		if digit.isdigit():
+			k = k * 10 + int(digit)
+		else:
+			return k
+	return k
+
+def read_group(fd):
+	'''Read the group list, carefully attaching comments to the next test.'''
+	tests = {}
+	comments = None
+
+	for line in fd:
+		sline = line.strip()
+		tokens = sline.split()
+		if len(tokens) == 0 or tokens[0] == '#':
+			if comments == None:
+				comments = []
+			comments.append(sline)
+		else:
+			tests[tokens[0]] = (comments, tokens[1:])
+			comments = None
+	return tests
+
+def sort_keys(keys):
+	'''Separate keys into integer and non-integer tests.'''
+	int_keys = []
+	int_xkeys = []
+	str_keys = []
+
+	# Sort keys into integer(ish) tests and other
+	for key in keys:
+		xkey = xfstest_key(key)
+		if type(xkey) == int:
+			int_keys.append(key)
+			int_xkeys.append(xkey)
+		else:
+			str_keys.append(key)
+	return (int_keys, int_xkeys, str_keys)
+
+def write_sorted(tests, fd):
+	def dump_xkey(xkey):
+		(comments, tokens) = tests[key]
+		if comments:
+			for c in comments:
+				fd.write('%s\n' % c)
+		fd.write('%s %s\n' % (key, ' '.join(tokens)))
+	'''Print tests (and comments) in number order.'''
+
+	(int_keys, ignored, str_keys) = sort_keys(tests.keys())
+	for key in sorted(int_keys, key = xfstest_key):
+		dump_xkey(key)
+	for key in sorted(str_keys):
+		dump_xkey(key)
+
+def sort_main():
+	if '--help' in sys.argv[1:]:
+		print('Usage: %s groupfiles' % sys.argv[0])
+		sys.exit(0)
+
+	for arg in sys.argv[1:]:
+		with open(arg, 'r+') as fd:
+			x = read_group(fd)
+			fd.seek(0, 0)
+			write_sorted(x, fd)
+
+def nextid_main():
+	if '--help' in sys.argv[1:]:
+		print('Usage: %s group[/startid] ' % sys.argv[0])
+		sys.exit(0)
+
+	if len(sys.argv) != 2:
+		print('Specify exactly one group name.')
+		sys.exit(1)
+
+	c = sys.argv[1].split('/')
+	if len(c) > 1:
+		startid = int(c[1])
+	else:
+		startid = 1
+	group = c[0]
+
+	with open('tests/%s/group' % group, 'r') as fd:
+		x = read_group(fd)
+		xkeys = {int(x) for x in sort_keys(x.keys())[1]}
+
+		xid = startid
+		while xid in xkeys:
+			xid += 1
+		print('%s/%d' % (group, xid))
+
+if __name__ == '__main__':
+	if 'nextid' in sys.argv[0]:
+		nextid_main()
+	else:
+		sort_main()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
