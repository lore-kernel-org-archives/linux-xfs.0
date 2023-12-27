Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EB1BA35;
	Mon,  1 Jan 2024 00:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NdrMCCDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FFCC433C8;
	Mon,  1 Jan 2024 00:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704070053;
	bh=WnWELLq8dqgHMltBcFkzJ1HXhEcgpAd9kgk5fPAD3Wo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NdrMCCDaQ80yuTFv4z8U4C1ciQkcBg2y2mDbfIb2EDtArRPkpxfbylG6eU3liF0L+
	 T7qLpCHzmZfNxQRAWz/RaKH775vHk7djqRiZ9BYmWHP+mxfC8KIERtHziE60CN0cw7
	 82YR3Fij8J+/bjJlV3TwYC8LowfjvhbFJ9K9F2XbPNDXlTNnqckUeXFJ8+nHokdrGC
	 iR98p5GQwaQWELWM3O29A4wEYlgsl+y5y6CRC88+MHMwOQb/AOs64JmPszUYgtN8ka
	 gDSQnsDk+TiZPK1PG+fykndKDVhplfwlkIHbOGVS1iTXkJbQEhZDBBGXIVRz1u+GiH
	 bK+8hAO5be9Tw==
Date: Sun, 31 Dec 2023 16:47:33 +9900
Subject: [PATCH 05/11] xfs/021: adapt golden output files for parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@redhat.com, djwong@kernel.org
Cc: fstests@vger.kernel.org, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, guan@eryu.me, linux-xfs@vger.kernel.org
Message-ID: <170405028493.1824869.12702469178835351613.stgit@frogsfrogsfrogs>
In-Reply-To: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
References: <170405028421.1824869.17871351204326094851.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Parent pointers change the xattr structure dramatically, so fix this
test to handle them.  For the most part we can get away with filtering
out the parent pointer fields (which xfs_db decodes for us), but the
namelen/valuelen/attr_filter fields still show through.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc                 |    4 +++
 tests/xfs/021             |   15 +++++++++--
 tests/xfs/021.cfg         |    1 +
 tests/xfs/021.out.default |    0 
 tests/xfs/021.out.parent  |   62 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 80 insertions(+), 2 deletions(-)
 create mode 100644 tests/xfs/021.cfg
 rename tests/xfs/{021.out => 021.out.default} (100%)
 create mode 100644 tests/xfs/021.out.parent


diff --git a/common/rc b/common/rc
index 969ff93de7..0898ac08eb 100644
--- a/common/rc
+++ b/common/rc
@@ -3419,6 +3419,8 @@ _get_os_name()
 
 _link_out_file_named()
 {
+	test -n "$seqfull" || _fail "need to set seqfull"
+
 	local features=$2
 	local suffix=$(FEATURES="$features" perl -e '
 		my %feathash;
@@ -3454,6 +3456,8 @@ _link_out_file()
 {
 	local features
 
+	test -n "$seqfull" || _fail "need to set seqfull"
+
 	if [ $# -eq 0 ]; then
 		features="$(_get_os_name),$FSTYP"
 		if [ -n "$MOUNT_OPTIONS" ]; then
diff --git a/tests/xfs/021 b/tests/xfs/021
index 9432e2acb0..ef307fc064 100755
--- a/tests/xfs/021
+++ b/tests/xfs/021
@@ -67,6 +67,13 @@ _scratch_mkfs_xfs >/dev/null \
 echo "*** mount FS"
 _scratch_mount
 
+seqfull=$0
+if _xfs_has_feature $SCRATCH_MNT parent; then
+	_link_out_file "parent"
+else
+	_link_out_file ""
+fi
+
 testfile=$SCRATCH_MNT/testfile
 echo "*** make test file 1"
 
@@ -108,7 +115,10 @@ _scratch_unmount >>$seqres.full 2>&1 \
 echo "*** dump attributes (1)"
 
 _scratch_xfs_db -r -c "inode $inum_1" -c "print a.sfattr"  | \
-	sed -e '/secure = /d' | sed -e '/parent = /d'
+	perl -ne '
+/\.secure/ && next;
+/\.parent/ && next;
+	print unless /^\d+:\[.*/;'
 
 echo "*** dump attributes (2)"
 
@@ -124,10 +134,11 @@ s/info.hdr/info/;
 /hdr.info.uuid/ && next;
 /hdr.info.lsn/ && next;
 /hdr.info.owner/ && next;
+/\.parent/ && next;
 s/^(hdr.info.magic =) 0x3bee/\1 0xfbee/;
 s/^(hdr.firstused =) (\d+)/\1 FIRSTUSED/;
 s/^(hdr.freemap\[0-2] = \[base,size]).*/\1 [FREEMAP..]/;
-s/^(entries\[0-2] = \[hashval,nameidx,incomplete,root,local]).*/\1 [ENTRIES..]/;
+s/^(entries\[0-[23]] = \[hashval,nameidx,incomplete,root,local]).*/\1 [ENTRIES..]/;
 	print unless /^\d+:\[.*/;'
 
 echo "*** done"
diff --git a/tests/xfs/021.cfg b/tests/xfs/021.cfg
new file mode 100644
index 0000000000..73b127260c
--- /dev/null
+++ b/tests/xfs/021.cfg
@@ -0,0 +1 @@
+parent: parent
diff --git a/tests/xfs/021.out b/tests/xfs/021.out.default
similarity index 100%
rename from tests/xfs/021.out
rename to tests/xfs/021.out.default
diff --git a/tests/xfs/021.out.parent b/tests/xfs/021.out.parent
new file mode 100644
index 0000000000..1af1301061
--- /dev/null
+++ b/tests/xfs/021.out.parent
@@ -0,0 +1,62 @@
+QA output created by 021
+*** mkfs
+*** mount FS
+*** make test file 1
+# file: <TESTFILE>.1
+user.a1
+user.a2--
+
+*** make test file 2
+1+0 records in
+1+0 records out
+# file: <TESTFILE>.2
+user.a1
+user.a2-----
+user.a3
+
+Attribute "a3" had a 65535 byte value for <TESTFILE>.2:
+size of attr value = 65536
+
+*** unmount FS
+*** dump attributes (1)
+a.sfattr.hdr.totsize = 53
+a.sfattr.hdr.count = 3
+a.sfattr.list[0].namelen = 16
+a.sfattr.list[0].valuelen = 10
+a.sfattr.list[0].root = 0
+a.sfattr.list[1].namelen = 2
+a.sfattr.list[1].valuelen = 3
+a.sfattr.list[1].root = 0
+a.sfattr.list[1].name = "a1"
+a.sfattr.list[1].value = "v1\d"
+a.sfattr.list[2].namelen = 4
+a.sfattr.list[2].valuelen = 5
+a.sfattr.list[2].root = 0
+a.sfattr.list[2].name = "a2--"
+a.sfattr.list[2].value = "v2--\d"
+*** dump attributes (2)
+hdr.info.forw = 0
+hdr.info.back = 0
+hdr.info.magic = 0xfbee
+hdr.count = 4
+hdr.usedbytes = 84
+hdr.firstused = FIRSTUSED
+hdr.holes = 0
+hdr.freemap[0-2] = [base,size] [FREEMAP..]
+entries[0-3] = [hashval,nameidx,incomplete,root,local] [ENTRIES..]
+nvlist[0].valuelen = 8
+nvlist[0].namelen = 2
+nvlist[0].name = "a1"
+nvlist[0].value = "value_1\d"
+nvlist[1].valueblk = 0x1
+nvlist[1].valuelen = 65535
+nvlist[1].namelen = 2
+nvlist[1].name = "a3"
+nvlist[2].valuelen = 10
+nvlist[2].namelen = 16
+nvlist[3].valuelen = 8
+nvlist[3].namelen = 7
+nvlist[3].name = "a2-----"
+nvlist[3].value = "value_2\d"
+*** done
+*** unmount

