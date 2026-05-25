Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C2D3D6467
	for <linux-xfs@vger.kernel.org>; Mon, 25 May 2026 07:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779695913; cv=none; b=FNBcAPkwQvwyEPwXGtHqTrIL6gMbvlaj452UyOb37rUovicWXBnkVXIwKDbzivgTaXl82jUF9kIbCeC4O1DcdGHP4y96GvUBXwb2ssJKYiBUfiRHPuLTkthvnNki4tNPvlZy5xlEMcdYD7lFavE32mP/cpr3WiuaGCbFIkIgtlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779695913; c=relaxed/simple;
	bh=rNsKUTUtmmU+YKYlWCIPnPsStFCAqWbdJr/xzT5z+J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNfjmM+EQP0sLNXzMJ23p8SU3I/XIdLHG46K4QDiqBeBdh5LC9yr5fMpbVgJD/TIqt/qjDd0CPeYfv/K3puucDD4UZte1lQZiF9tzhz6ro41vAGfeYArETHCPq4pHf4dEOA0QfvhPzdcQOKZR5RXR6tf+nmp2zYbPTPELVyK18k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id 397E2180F246;
	Mon, 25 May 2026 09:58:28 +0200 (CEST)
Received: from trufa.intra.herbolt.com.com ([172.168.31.30])
	by mx0.herbolt.com with ESMTPSA
	id rrOwOhUBFGoUrzcAKEJqOA:T5
	(envelope-from <lukas@herbolt.com>); Mon, 25 May 2026 09:58:28 +0200
From: Lukas Herbolt <lukas@herbolt.com>
To: djwong@kernel.org,
	sandeen@sandeen.net,
	aalbersh@kernel.org,
	dgc@kernel.org
Cc: linux-xfs@vger.kernel.org,
	Lukas Herbolt <lukas@herbolt.com>
Subject: [RFC PATCH v2 4/5] xfs_admin: add -d option to manage default mkfs config file
Date: Mon, 25 May 2026 09:57:51 +0200
Message-ID: <20260525075752.4159504-5-lukas@herbolt.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525075752.4159504-1-lukas@herbolt.com>
References: <20260525075752.4159504-1-lukas@herbolt.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add -d <file> to install a config file as the system-wide mkfs.xfs
default, and -d clear to remove it. The default config directory is
substituted at build time from the configured sysconfdir. The
xfs_admin.sh is now generated from xfs_admin.sh.in to set the default
config file location bsed on the ./configure.

Signed-off-by: Lukas Herbolt <lukas@herbolt.com>
---
 .gitignore                           |  3 +++
 db/Makefile                          | 11 ++++++++--
 db/{xfs_admin.sh => xfs_admin.sh.in} | 30 ++++++++++++++++++++++++++--
 3 files changed, 40 insertions(+), 4 deletions(-)
 rename db/{xfs_admin.sh => xfs_admin.sh.in} (70%)

diff --git a/.gitignore b/.gitignore
index eb3decd108be..fc695dbbd0b1 100644
--- a/.gitignore
+++ b/.gitignore
@@ -89,3 +89,6 @@ cscope.*
 # docs
 /man/man8/mkfs.xfs.8
 /man/man8/xfs_scrub_all.8
+
+#generated bash
+db/xfs_admin.sh
diff --git a/db/Makefile b/db/Makefile
index e36e775eee60..b9016d2a057b 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -67,7 +67,8 @@ CFILES = $(HFILES:.h=.c) \
 	iunlink.c \
 	rdump.c \
 	timelimit.c
-LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
+LSRCFILES = xfs_admin.sh.in xfs_ncheck.sh xfs_metadump.sh
+LDIRT = xfs_admin.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBURCU) \
 	  $(LIBPTHREAD)
@@ -79,10 +80,16 @@ LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 CFLAGS += -DENABLE_EDITLINE
 endif
 
-default: depend $(LTCOMMAND)
+default: depend $(LTCOMMAND) xfs_admin.sh
 
 include $(BUILDRULES)
 
+xfs_admin.sh: xfs_admin.sh.in $(TOPDIR)/include/builddefs
+	@echo "    [SED]    $@"
+	$(Q)$(SED) -e "s|@mkfs_syscfg_dir@|$(MKFS_SYSCFG_DIR)|g" \
+		< $< > $@
+	$(Q)chmod a+x $@
+
 install: default
 	$(INSTALL) -m 755 -d $(PKG_SBIN_DIR)
 	$(LTINSTALL) -m 755 $(LTCOMMAND) $(PKG_SBIN_DIR)
diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh.in
similarity index 70%
rename from db/xfs_admin.sh
rename to db/xfs_admin.sh.in
index 52a658ba4a54..e87a64467662 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh.in
@@ -13,11 +13,37 @@ REPAIR_OPTS=""
 IO_OPTS=""
 REPAIR_DEV_OPTS=""
 LOG_OPTS=""
-USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
+MKFS_DEFAULT_CFGDIR="@mkfs_syscfg_dir@"
+MKFS_DEFAULT_CFGFILE="$MKFS_DEFAULT_CFGDIR/default.conf"
+USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-d file|clear] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
 
-while getopts "c:efjlL:O:pr:uU:V" c
+while getopts "c:d:efjlL:O:pr:uU:V" c
 do
 	case $c in
+	d)	if [ "$OPTARG" = "clear" ]; then
+			rm -f "$MKFS_DEFAULT_CFGFILE"
+			status=$?
+			if [ $status -eq 0 ]; then
+				echo "Removed $MKFS_DEFAULT_CFGFILE"
+			else
+				echo "xfs_admin: failed to remove $MKFS_DEFAULT_CFGFILE" 1>&2
+			fi
+		else
+			if [ ! -f "$OPTARG" ]; then
+				echo "xfs_admin: cannot read '$OPTARG'" 1>&2
+				exit 2
+			fi
+			mkdir -p "$MKFS_DEFAULT_CFGDIR" &&
+			cp "$OPTARG" "$MKFS_DEFAULT_CFGFILE"
+			status=$?
+			if [ $status -eq 0 ]; then
+				echo "Installed $OPTARG as $MKFS_DEFAULT_CFGFILE"
+			else
+				echo "xfs_admin: failed to install $MKFS_DEFAULT_CFGFILE" 1>&2
+			fi
+		fi
+		exit $status
+		;;
 	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG
 		require_offline=1
 		;;
-- 
2.54.0

