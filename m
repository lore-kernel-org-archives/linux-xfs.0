Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 82D117F61
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 12:24:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 50BFE8F8065
	for <xfs@oss.sgi.com>; Thu, 11 Jun 2015 10:24:30 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id VWuHmYXNiT9gydRf (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 11 Jun 2015 10:24:22 -0700 (PDT)
Date: Thu, 11 Jun 2015 10:24:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfsprogs for-next build error on Debian Wheezy / amd64
Message-ID: <20150611172419.GA23760@infradead.org>
References: <20150610070604.GA9855@infradead.org>
	<20150610081914.GV9143@dastard>
	<20150610082415.GA23860@infradead.org>
	<20150610083441.GW9143@dastard>
	<20150610084043.GA31392@infradead.org>
	<20150610091952.GE24666@dastard>
	<20150611160335.GA28312@infradead.org>
	<5579B3E3.2080400@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5579B3E3.2080400@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

FYI, here is a WIP patch that makes platform_defs.h a properly
installable regular header and instead has a local generated
config.h.  Still needs more than build testing and proper
documentation, though.

diff --git a/.gitignore b/.gitignore
index 913b371..90d9ffa 100644
--- a/.gitignore
+++ b/.gitignore
@@ -6,7 +6,7 @@
 # build system
 .census
 .gitcensus
-/include/platform_defs.h
+/include/config.h
 /include/builddefs
 /install-sh
 
diff --git a/Makefile b/Makefile
index d04f853..d50710f 100644
--- a/Makefile
+++ b/Makefile
@@ -33,7 +33,7 @@ SRCTARINC = m4/libtool.m4 m4/lt~obsolete.m4 m4/ltoptions.m4 m4/ltsugar.m4 \
            m4/ltversion.m4 po/xfsprogs.pot .gitcensus $(CONFIGURE)
 LDIRT = config.log .ltdep .dep config.status config.cache confdefs.h \
 	conftest* built .census install.* install-dev.* *.gz \
-	autom4te.cache/* libtool include/builddefs include/platform_defs.h
+	autom4te.cache/* libtool include/builddefs include/config.h
 
 ifeq ($(HAVE_BUILDDEFS), yes)
 LDIRDIRT = $(SRCDIR)
@@ -48,7 +48,7 @@ TOOL_SUBDIRS = copy db estimate fsck fsr growfs io logprint mkfs quota \
 
 SUBDIRS = include $(LIB_SUBDIRS) $(TOOL_SUBDIRS)
 
-default: include/builddefs include/platform_defs.h
+default: include/builddefs include/config.h
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
@@ -91,7 +91,7 @@ configure:
 include/builddefs: configure
 	./configure $$LOCAL_CONFIGURE_OPTIONS
 
-include/platform_defs.h: include/builddefs
+include/config.h: include/builddefs
 ## Recover from the removal of $@
 	@if test -f $@; then :; else \
 		rm -f include/builddefs; \
@@ -127,14 +127,14 @@ realclean: distclean
 #
 # All this gunk is to allow for a make dist on an unconfigured tree
 #
-dist: include/builddefs include/platform_defs.h default
+dist: include/builddefs include/config.h default
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
 	$(Q)$(MAKE) $(MAKEOPTS) $(SRCTAR)
 endif
 
-deb: include/builddefs include/platform_defs.h
+deb: include/builddefs include/config.h
 ifeq ($(HAVE_BUILDDEFS), no)
 	$(Q)$(MAKE) $(MAKEOPTS) -C . $@
 else
diff --git a/configure.ac b/configure.ac
index ae17c68..8d8418a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,7 @@ AC_PREREQ(2.50)
 AC_CONFIG_AUX_DIR([.])
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_SRCDIR([include/libxfs.h])
-AC_CONFIG_HEADER(include/platform_defs.h)
+AC_CONFIG_HEADER(include/config.h)
 AC_PREFIX_DEFAULT(/usr)
 
 AC_PROG_LIBTOOL
diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 279527c..d5865da 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
diff --git a/db/addr.c b/db/addr.c
index 9bea1c7..be57a44 100644
--- a/db/addr.c
+++ b/db/addr.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "addr.h"
 #include "command.h"
diff --git a/db/agf.c b/db/agf.c
index d9a07ca..5392702 100644
--- a/db/agf.c
+++ b/db/agf.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "command.h"
 #include "type.h"
diff --git a/db/agfl.c b/db/agfl.c
index b29538f..a66c4ca 100644
--- a/db/agfl.c
+++ b/db/agfl.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "command.h"
 #include "type.h"
diff --git a/db/agi.c b/db/agi.c
index 6f167ac..352ca0a 100644
--- a/db/agi.c
+++ b/db/agi.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "command.h"
 #include "type.h"
diff --git a/db/attr.c b/db/attr.c
index 41c0db0..5194486 100644
--- a/db/attr.c
+++ b/db/attr.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "bit.h"
 #include "type.h"
diff --git a/db/attrset.c b/db/attrset.c
index ea5261a..b4e0e50 100644
--- a/db/attrset.c
+++ b/db/attrset.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "command.h"
 #include "attrset.h"
diff --git a/db/attrshort.c b/db/attrshort.c
index 72f73dd..c3e3af3 100644
--- a/db/attrshort.c
+++ b/db/attrshort.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "type.h"
 #include "faddr.h"
diff --git a/db/bit.c b/db/bit.c
index e8adab3..5c468a9 100644
--- a/db/bit.c
+++ b/db/bit.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "bit.h"
 
diff --git a/db/block.c b/db/block.c
index 59a6265..5cc8ebc 100644
--- a/db/block.c
+++ b/db/block.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "block.h"
 #include "bmap.h"
diff --git a/db/bmap.c b/db/bmap.c
index 2a49380..f857cb5 100644
--- a/db/bmap.c
+++ b/db/bmap.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "command.h"
 #include "type.h"
diff --git a/db/bmroot.c b/db/bmroot.c
index e2194aa..2ac6861 100644
--- a/db/bmroot.c
+++ b/db/bmroot.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "type.h"
 #include "faddr.h"
diff --git a/db/btblock.c b/db/btblock.c
index 982b52b..cca8747 100644
--- a/db/btblock.c
+++ b/db/btblock.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "type.h"
 #include "faddr.h"
diff --git a/db/check.c b/db/check.c
index 1822905..c17a62a 100644
--- a/db/check.c
+++ b/db/check.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <math.h>
 #include <sys/time.h>
diff --git a/db/command.c b/db/command.c
index b7e3165..73c218b 100644
--- a/db/command.c
+++ b/db/command.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "addr.h"
 #include "attrset.h"
diff --git a/db/convert.c b/db/convert.c
index de4bfbf..80d35b8 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "command.h"
 #include "convert.h"
diff --git a/db/debug.c b/db/debug.c
index 07a2482..605ae22 100644
--- a/db/debug.c
+++ b/db/debug.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "command.h"
 #include "debug.h"
diff --git a/db/dir2.c b/db/dir2.c
index 18a54b6..68fd79e 100644
--- a/db/dir2.c
+++ b/db/dir2.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "bit.h"
 #include "type.h"
diff --git a/db/dir2sf.c b/db/dir2sf.c
index bbe6080..f23a296 100644
--- a/db/dir2sf.c
+++ b/db/dir2sf.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "type.h"
 #include "faddr.h"
diff --git a/db/dquot.c b/db/dquot.c
index 2f7d463..fe91144 100644
--- a/db/dquot.c
+++ b/db/dquot.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "bit.h"
 #include "bmap.h"
diff --git a/db/echo.c b/db/echo.c
index 813187b..db2f9a5 100644
--- a/db/echo.c
+++ b/db/echo.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "command.h"
 #include "echo.h"
diff --git a/db/faddr.c b/db/faddr.c
index d40717d..5898710 100644
--- a/db/faddr.c
+++ b/db/faddr.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "type.h"
 #include "fprint.h"
diff --git a/db/field.c b/db/field.c
index 52d9d9b..ae68fcc 100644
--- a/db/field.c
+++ b/db/field.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "type.h"
 #include "faddr.h"
diff --git a/db/flist.c b/db/flist.c
index 33f7da7..7d9684f 100644
--- a/db/flist.c
+++ b/db/flist.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "type.h"
 #include "faddr.h"
diff --git a/db/fprint.c b/db/fprint.c
index 52782e2..ad7b696 100644
--- a/db/fprint.c
+++ b/db/fprint.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <ctype.h>
 #include <time.h>
diff --git a/db/frag.c b/db/frag.c
index d8ad25e..acafe7d 100644
--- a/db/frag.c
+++ b/db/frag.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <sys/time.h>
 #include "bmap.h"
diff --git a/db/freesp.c b/db/freesp.c
index 361fa96..ea210dc 100644
--- a/db/freesp.c
+++ b/db/freesp.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "command.h"
 #include "freesp.h"
diff --git a/db/hash.c b/db/hash.c
index 02376e6..25a6437 100644
--- a/db/hash.c
+++ b/db/hash.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "addr.h"
 #include "command.h"
diff --git a/db/help.c b/db/help.c
index 7913100..8a650b5 100644
--- a/db/help.c
+++ b/db/help.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "command.h"
 #include "help.h"
diff --git a/db/init.c b/db/init.c
index f93ab15..5c5ca5b 100644
--- a/db/init.c
+++ b/db/init.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <signal.h>
 #include "command.h"
diff --git a/db/inode.c b/db/inode.c
index fbae0bd..3714dc9 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "command.h"
 #include "type.h"
diff --git a/db/input.c b/db/input.c
index b73a1f8..ba07007 100644
--- a/db/input.c
+++ b/db/input.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <signal.h>
 #include "command.h"
diff --git a/db/io.c b/db/io.c
index b55a5fb..5f6bd9d 100644
--- a/db/io.c
+++ b/db/io.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "command.h"
 #include "type.h"
diff --git a/db/malloc.c b/db/malloc.c
index fe1eacf..5d8e2b1 100644
--- a/db/malloc.c
+++ b/db/malloc.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "init.h"
 #include "malloc.h"
diff --git a/db/metadump.c b/db/metadump.c
index cca9b49..282b46a 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include <libxlog.h>
 #include "bmap.h"
diff --git a/db/output.c b/db/output.c
index 36669f4..270d6ed 100644
--- a/db/output.c
+++ b/db/output.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <stdarg.h>
 #include "command.h"
diff --git a/db/print.c b/db/print.c
index b865d64..8a9c752 100644
--- a/db/print.c
+++ b/db/print.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "command.h"
 #include "type.h"
diff --git a/db/quit.c b/db/quit.c
index 5e4413c..9f395d5 100644
--- a/db/quit.c
+++ b/db/quit.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "command.h"
 #include "quit.h"
diff --git a/db/sb.c b/db/sb.c
index b6c0c4e..cafe5a5 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <xfs/libxlog.h>
 #include "command.h"
diff --git a/db/sig.c b/db/sig.c
index 338c706..4bd10fd 100644
--- a/db/sig.c
+++ b/db/sig.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <signal.h>
 #include "sig.h"
diff --git a/db/strvec.c b/db/strvec.c
index 8aa4e34..5d55ac6 100644
--- a/db/strvec.c
+++ b/db/strvec.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "strvec.h"
 #include "output.h"
diff --git a/db/symlink.c b/db/symlink.c
index a4f420f..6ad8d24 100644
--- a/db/symlink.c
+++ b/db/symlink.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "type.h"
 #include "faddr.h"
diff --git a/db/text.c b/db/text.c
index 12084a2..d7e5894 100644
--- a/db/text.c
+++ b/db/text.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <ctype.h>
 #include "block.h"
diff --git a/db/type.c b/db/type.c
index 28535de..a561160 100644
--- a/db/type.c
+++ b/db/type.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include "block.h"
 #include "command.h"
diff --git a/db/write.c b/db/write.c
index 655b618..954529b 100644
--- a/db/write.c
+++ b/db/write.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <ctype.h>
 #include <time.h>
diff --git a/debian/rules b/debian/rules
index 2be2773..9718d49 100755
--- a/debian/rules
+++ b/debian/rules
@@ -36,14 +36,14 @@ config: .census
 	@echo "== dpkg-buildpackage: configure" 1>&2
 	$(checkdir)
 	AUTOHEADER=/bin/true dh_autoreconf
-	$(options) $(MAKE) include/platform_defs.h
+	$(options) $(MAKE) include/config.h
 	touch .census
 
 dibuild:
 	$(checkdir)
 	@echo "== dpkg-buildpackage: installer" 1>&2
 	if [ ! -f mkfs/mkfs.xfs-$(bootpkg) ]; then \
-		$(diopts) $(MAKE) include/platform_defs.h; \
+		$(diopts) $(MAKE) include/config.h; \
 		for dir in include libxfs libdisk mkfs; do \
 			$(MAKE) -C $$dir; \
 		done; \
diff --git a/estimate/xfs_estimate.c b/estimate/xfs_estimate.c
index c574a08..6fcc8d8 100644
--- a/estimate/xfs_estimate.c
+++ b/estimate/xfs_estimate.c
@@ -21,6 +21,7 @@
  *
  * XXX: assumes dirv1 format.
  */
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <sys/stat.h>
 #include <ftw.h>
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index 2fc94c7..9cb0b4a 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include <xfs/xfs.h>
 #include <xfs/xfs_types.h>
diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index 4a344fe..9730d31 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <xfs/path.h>
 
diff --git a/include/Makefile b/include/Makefile
index 70e43a0..688fe5e 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -30,13 +30,13 @@ QAHFILES = libxfs.h libxlog.h \
 	xfs_trace.h \
 	xfs_trans.h
 
-HFILES = handle.h jdm.h xqm.h xfs.h
+HFILES = handle.h jdm.h xqm.h xfs.h platform_defs.h
 HFILES += $(PKG_PLATFORM).h
 PHFILES = darwin.h freebsd.h irix.h linux.h gnukfreebsd.h
 DKHFILES = volume.h fstyp.h dvh.h
 LIBHFILES = command.h input.h path.h project.h
 LSRCFILES = $(shell echo $(PHFILES) | sed -e "s/$(PKG_PLATFORM).h//g")
-LSRCFILES += platform_defs.h.in builddefs.in buildmacros buildrules install-sh
+LSRCFILES += config.h.in builddefs.in buildmacros buildrules install-sh
 LSRCFILES += $(DKHFILES) $(LIBHFILES)
 LDIRT = disk
 LDIRDIRT = xfs
@@ -62,7 +62,6 @@ include $(BUILDRULES)
 install-dev: default
 	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
 	$(INSTALL) -m 644 $(HFILES) $(PKG_INC_DIR)
-	$(INSTALL) -m 644 platform_defs.h $(PKG_INC_DIR)
 
 install-qa: install-dev
 	$(INSTALL) -m 644 $(QAHFILES) $(PKG_INC_DIR)
diff --git a/include/config.h.in b/include/config.h.in
new file mode 100644
index 0000000..92d5b7d
--- /dev/null
+++ b/include/config.h.in
@@ -0,0 +1,85 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * @configure_input@
+ */
+#ifndef _XFS_CONFIG_H
+#define _XFS_CONFIG_H
+
+#include <limits.h>
+
+/* long and pointer must be either 32 bit or 64 bit */
+#undef SIZEOF_LONG
+#undef SIZEOF_CHAR_P
+#define BITS_PER_LONG (SIZEOF_LONG * CHAR_BIT)
+
+/* Check if __psint_t is set to something meaningful */
+#undef HAVE___PSINT_T
+#ifndef HAVE___PSINT_T
+# if (SIZEOF_CHAR_P * CHAR_BIT) == 32
+typedef int __psint_t;
+# elif (SIZEOF_CHAR_P * CHAR_BIT) == 64
+#  if BITS_PER_LONG == 64
+typedef long __psint_t;
+#  else
+/* This is a very strange architecture, which has 64 bit pointers but */
+/* not 64 bit longs.  So, just punt here and assume long long is OK.  */
+typedef long long __psint_t;
+#  endif
+# else
+#  error Unknown pointer size
+# endif
+#endif
+
+/* Check if __psunsigned_t is set to something meaningful */
+#undef HAVE___PSUNSIGNED_T
+#ifndef HAVE___PSUNSIGNED_T
+# if (SIZEOF_CHAR_P * CHAR_BIT) == 32
+typedef unsigned int __psunsigned_t;
+# elif (SIZEOF_CHAR_P * CHAR_BIT) == 64
+#  if BITS_PER_LONG == 64
+typedef long __psunsigned_t;
+#  else
+/* This is a very strange architecture, which has 64 bit pointers but */
+/* not 64 bit longs.  So, just punt here and assume long long is OK.  */
+typedef unsigned long long __psunsigned_t;
+#  endif
+# else
+#  error Unknown pointer size
+# endif
+#endif
+
+/* Check whether to define umode_t ourselves. */
+#ifndef HAVE_UMODE_T
+typedef unsigned short umode_t;
+#endif
+
+/* Define if you want gettext (I18N) support */
+#undef ENABLE_GETTEXT
+#ifdef ENABLE_GETTEXT
+# include <libintl.h>
+# define _(x)                   gettext(x)
+# define N_(x)			 x
+#else
+# define _(x)                   (x)
+# define N_(x)			 x
+# define textdomain(d)          do { } while (0)
+# define bindtextdomain(d,dir)  do { } while (0)
+#endif
+#include <locale.h>
+
+#endif	/* _XFS_CONFIG_H */
diff --git a/include/darwin.h b/include/darwin.h
index 95f865b..dda1111 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -109,6 +109,15 @@ static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
 	memcpy(dst, src, sizeof(uuid_t));
 }
 
+typedef unsigned char		__u8;
+typedef signed char		__s8;
+typedef unsigned short		__u16;
+typedef signed short		__s16;
+typedef unsigned int		__u32;
+typedef signed int		__s32;
+typedef unsigned long long int	__u64;
+typedef signed long long int	__s64;
+
 #define __int8_t	int8_t
 #define __int16_t	int16_t
 #define __int32_t	int32_t
diff --git a/include/freebsd.h b/include/freebsd.h
index b51688b..3973618 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -55,6 +55,15 @@ typedef __int64_t	xfs_daddr_t;
 typedef char*		xfs_caddr_t;
 typedef off_t		loff_t;
 
+typedef unsigned char		__u8;
+typedef signed char		__s8;
+typedef unsigned short		__u16;
+typedef signed short		__s16;
+typedef unsigned int		__u32;
+typedef signed int		__s32;
+typedef unsigned long long int	__u64;
+typedef signed long long int	__s64;
+
 #ifndef	_UCHAR_T_DEFINED
 typedef unsigned char	uchar_t;
 #define	_UCHAR_T_DEFINED	1
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index 2140acd..0ac8105 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -45,6 +45,15 @@ typedef __int64_t	xfs_daddr_t;
 typedef char*		xfs_caddr_t;
 typedef off_t		loff_t;
 
+typedef unsigned char		__u8;
+typedef signed char		__s8;
+typedef unsigned short		__u16;
+typedef signed short		__s16;
+typedef unsigned int		__u32;
+typedef signed int		__s32;
+typedef unsigned long long int	__u64;
+typedef signed long long int	__s64;
+
 #ifndef	_UCHAR_T_DEFINED
 typedef unsigned char	uchar_t;
 #define	_UCHAR_T_DEFINED	1
diff --git a/include/irix.h b/include/irix.h
index 5040451..68fb054 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -49,6 +49,15 @@ typedef __int32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
 typedef char*		xfs_caddr_t;
 
+typedef unsigned char		__u8;
+typedef signed char		__s8;
+typedef unsigned short		__u16;
+typedef signed short		__s16;
+typedef unsigned int		__u32;
+typedef signed int		__s32;
+typedef unsigned long long int	__u64;
+typedef signed long long int	__s64;
+
 #define xfs_flock64	flock64
 #define xfs_flock64_t	struct flock64
 
diff --git a/include/linux.h b/include/linux.h
index 5586290..91d1161 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -17,6 +17,7 @@
 #ifndef __XFS_LINUX_H__
 #define __XFS_LINUX_H__
 
+#include <asm/types.h>
 #include <uuid/uuid.h>
 #include <sys/vfs.h>
 #include <sys/ioctl.h>
diff --git a/include/platform_defs.h b/include/platform_defs.h
new file mode 100644
index 0000000..43d7ce0
--- /dev/null
+++ b/include/platform_defs.h
@@ -0,0 +1,107 @@
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * @configure_input@
+ */
+#ifndef __XFS_PLATFORM_DEFS_H__
+#define __XFS_PLATFORM_DEFS_H__
+
+#include <stdio.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <stdarg.h>
+#include <assert.h>
+#include <stddef.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <pthread.h>
+#include <ctype.h>
+#include <sys/types.h>
+#include <limits.h>
+#include <stdbool.h>
+
+#if defined(__linux__)
+#include <xfs/linux.h>
+#elif defined(__FreeBSD__)
+#include <xfs/freebsd.h>
+#elif defined(__FreeBSD_kernel__)
+#include <xfs/gnukfreebsd.h>
+#elif defined(__APPLE__)
+#include <xfs/darwin.h>
+#elif defined(__sgi__) || defined(__sgi)
+#include <xfs/irix.h>
+#else
+# error unknown platform... have fun porting!
+#endif
+
+#ifdef __CHECKER__
+#define __bitwise		__attribute__((bitwise))
+#define __force			__attribute__((force))
+#else
+#define __bitwise
+#define __force
+#endif
+
+typedef __u16	__bitwise	__le16;
+typedef __u32	__bitwise	__le32;
+typedef __u64	__bitwise	__le64;
+
+typedef __u16	__bitwise	__be16;
+typedef __u32	__bitwise	__be32;
+typedef __u64	__bitwise	__be64;
+
+typedef struct filldir		filldir_t;
+
+#ifdef DEBUG
+# define ASSERT(EX)	assert(EX)
+#else
+# define ASSERT(EX)	((void) 0)
+#endif
+
+/*
+ * sparse kernel source annotations
+ */
+#ifndef __user
+#define __user
+#endif
+
+#define IRIX_DEV_BITSMAJOR      14
+#define IRIX_DEV_BITSMINOR      18
+#define IRIX_DEV_MAXMAJ         0x1ff
+#define IRIX_DEV_MAXMIN         0x3ffff
+#define IRIX_DEV_MAJOR(dev)	((int)(((unsigned)(dev) >> IRIX_DEV_BITSMINOR) \
+					& IRIX_DEV_MAXMAJ))
+#define IRIX_DEV_MINOR(dev)	((int)((dev) & IRIX_DEV_MAXMIN))
+#define IRIX_MKDEV(major,minor)	((xfs_dev_t)(((major) << IRIX_DEV_BITSMINOR) \
+					| (minor&IRIX_DEV_MAXMIN)))
+#define IRIX_DEV_TO_KDEVT(dev)	makedev(IRIX_DEV_MAJOR(dev),IRIX_DEV_MINOR(dev))
+
+/* ARM old ABI has some weird alignment/padding */
+#if defined(__arm__) && !defined(__ARM_EABI__)
+#define __arch_pack __attribute__((packed))
+#else
+#define __arch_pack
+#endif
+
+#ifndef min
+#define min(a,b)	(((a)<(b))?(a):(b))
+#define max(a,b)	(((a)>(b))?(a):(b))
+#endif
+
+#endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
deleted file mode 100644
index ac260bc..0000000
--- a/include/platform_defs.h.in
+++ /dev/null
@@ -1,181 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU Lesser General Public License
- * as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU Lesser General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
- * @configure_input@
- */
-#ifndef __XFS_PLATFORM_DEFS_H__
-#define __XFS_PLATFORM_DEFS_H__
-
-#include <stdio.h>
-#include <errno.h>
-#include <fcntl.h>
-#include <stdarg.h>
-#include <assert.h>
-#include <stddef.h>
-#include <stdlib.h>
-#include <string.h>
-#include <stdint.h>
-#include <unistd.h>
-#include <pthread.h>
-#include <ctype.h>
-#include <sys/types.h>
-#include <limits.h>
-#include <stdbool.h>
-
-#undef HAVE___U32
-#ifdef HAVE___U32
-#include <asm/types.h>
-#else
-typedef unsigned char		__u8;
-typedef signed char		__s8;
-typedef unsigned short		__u16;
-typedef signed short		__s16;
-typedef unsigned int		__u32;
-typedef signed int		__s32;
-typedef unsigned long long int	__u64;
-typedef signed long long int	__s64;
-#endif
-
-#ifdef __CHECKER__
-#define __bitwise		__attribute__((bitwise))
-#define __force			__attribute__((force))
-#else
-#define __bitwise
-#define __force
-#endif
-
-typedef __u16	__bitwise	__le16;
-typedef __u32	__bitwise	__le32;
-typedef __u64	__bitwise	__le64;
-
-typedef __u16	__bitwise	__be16;
-typedef __u32	__bitwise	__be32;
-typedef __u64	__bitwise	__be64;
-
-typedef struct filldir		filldir_t;
-
-#if defined(__linux__)
-#include <xfs/linux.h>
-#elif defined(__FreeBSD__)
-#include <xfs/freebsd.h>
-#elif defined(__FreeBSD_kernel__)
-#include <xfs/gnukfreebsd.h>
-#elif defined(__APPLE__)
-#include <xfs/darwin.h>
-#elif defined(__sgi__) || defined(__sgi)
-#include <xfs/irix.h>
-#else
-# error unknown platform... have fun porting!
-#endif
-
-/* long and pointer must be either 32 bit or 64 bit */
-#undef SIZEOF_LONG
-#undef SIZEOF_CHAR_P
-#define BITS_PER_LONG (SIZEOF_LONG * CHAR_BIT)
-
-/* Check if __psint_t is set to something meaningful */
-#undef HAVE___PSINT_T
-#ifndef HAVE___PSINT_T
-# if (SIZEOF_CHAR_P * CHAR_BIT) == 32
-typedef int __psint_t;
-# elif (SIZEOF_CHAR_P * CHAR_BIT) == 64
-#  if BITS_PER_LONG == 64
-typedef long __psint_t;
-#  else
-/* This is a very strange architecture, which has 64 bit pointers but */
-/* not 64 bit longs.  So, just punt here and assume long long is OK.  */
-typedef long long __psint_t;
-#  endif
-# else
-#  error Unknown pointer size
-# endif
-#endif
-
-/* Check if __psunsigned_t is set to something meaningful */
-#undef HAVE___PSUNSIGNED_T
-#ifndef HAVE___PSUNSIGNED_T
-# if (SIZEOF_CHAR_P * CHAR_BIT) == 32
-typedef unsigned int __psunsigned_t;
-# elif (SIZEOF_CHAR_P * CHAR_BIT) == 64
-#  if BITS_PER_LONG == 64
-typedef long __psunsigned_t;
-#  else
-/* This is a very strange architecture, which has 64 bit pointers but */
-/* not 64 bit longs.  So, just punt here and assume long long is OK.  */
-typedef unsigned long long __psunsigned_t;
-#  endif
-# else
-#  error Unknown pointer size
-# endif
-#endif
-
-/* Check whether to define umode_t ourselves. */
-#ifndef HAVE_UMODE_T
-typedef unsigned short umode_t;
-#endif
-
-/* Define if you want gettext (I18N) support */
-#undef ENABLE_GETTEXT
-#ifdef ENABLE_GETTEXT
-# include <libintl.h>
-# define _(x)                   gettext(x)
-# define N_(x)			 x
-#else
-# define _(x)                   (x)
-# define N_(x)			 x
-# define textdomain(d)          do { } while (0)
-# define bindtextdomain(d,dir)  do { } while (0)
-#endif
-#include <locale.h>
-
-#ifdef DEBUG
-# define ASSERT(EX)	assert(EX)
-#else
-# define ASSERT(EX)	((void) 0)
-#endif
-
-/*
- * sparse kernel source annotations
- */
-#ifndef __user
-#define __user
-#endif
-
-#define IRIX_DEV_BITSMAJOR      14
-#define IRIX_DEV_BITSMINOR      18
-#define IRIX_DEV_MAXMAJ         0x1ff
-#define IRIX_DEV_MAXMIN         0x3ffff
-#define IRIX_DEV_MAJOR(dev)	((int)(((unsigned)(dev) >> IRIX_DEV_BITSMINOR) \
-					& IRIX_DEV_MAXMAJ))
-#define IRIX_DEV_MINOR(dev)	((int)((dev) & IRIX_DEV_MAXMIN))
-#define IRIX_MKDEV(major,minor)	((xfs_dev_t)(((major) << IRIX_DEV_BITSMINOR) \
-					| (minor&IRIX_DEV_MAXMIN)))
-#define IRIX_DEV_TO_KDEVT(dev)	makedev(IRIX_DEV_MAJOR(dev),IRIX_DEV_MINOR(dev))
-
-/* ARM old ABI has some weird alignment/padding */
-#if defined(__arm__) && !defined(__ARM_EABI__)
-#define __arch_pack __attribute__((packed))
-#else
-#define __arch_pack
-#endif
-
-#ifndef min
-#define min(a,b)	(((a)<(b))?(a):(b))
-#define max(a,b)	(((a)>(b))?(a):(b))
-#endif
-
-#endif	/* __XFS_PLATFORM_DEFS_H__ */
diff --git a/io/attr.c b/io/attr.c
index 9b26f31..df9f4ab 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/bmap.c b/io/bmap.c
index a78cbb1..a76506e 100644
--- a/io/bmap.c
+++ b/io/bmap.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include "init.h"
diff --git a/io/fadvise.c b/io/fadvise.c
index a27b8f7..ba982e4 100644
--- a/io/fadvise.c
+++ b/io/fadvise.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/fiemap.c b/io/fiemap.c
index e76be97..2448ce6 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <linux/fiemap.h>
diff --git a/io/file.c b/io/file.c
index 73b893f..b5fca5f 100644
--- a/io/file.c
+++ b/io/file.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/freeze.c b/io/freeze.c
index 89cd303..d981cde 100644
--- a/io/freeze.c
+++ b/io/freeze.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/fsync.c b/io/fsync.c
index 5ed8d25..63d8db8 100644
--- a/io/fsync.c
+++ b/io/fsync.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include "init.h"
diff --git a/io/getrusage.c b/io/getrusage.c
index 32f2a7e..80723a3 100644
--- a/io/getrusage.c
+++ b/io/getrusage.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/imap.c b/io/imap.c
index 4f3f883..b99e1bc 100644
--- a/io/imap.c
+++ b/io/imap.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/init.c b/io/init.c
index 1b07518..8aa38b7 100644
--- a/io/init.c
+++ b/io/init.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/inject.c b/io/inject.c
index 1e078ae..a4fa6c7 100644
--- a/io/inject.c
+++ b/io/inject.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/link.c b/io/link.c
index 9c2d1f8..bb81a7c 100644
--- a/io/link.c
+++ b/io/link.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/madvise.c b/io/madvise.c
index 87f619d..4427188 100644
--- a/io/madvise.c
+++ b/io/madvise.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/mincore.c b/io/mincore.c
index eac8699..fb27987 100644
--- a/io/mincore.c
+++ b/io/mincore.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/mmap.c b/io/mmap.c
index 565a541..b2fde0f 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/open.c b/io/open.c
index c106fa7..7d027fe 100644
--- a/io/open.c
+++ b/io/open.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/parent.c b/io/parent.c
index 0313119..f88ccfd 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/pread.c b/io/pread.c
index cff3275..b04c924 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <sys/uio.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
diff --git a/io/prealloc.c b/io/prealloc.c
index 4ab3d8c..38b8a79 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #if defined(HAVE_FALLOCATE)
 #include <linux/falloc.h>
 #endif
diff --git a/io/pwrite.c b/io/pwrite.c
index 0674c01..5444b2c 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <sys/uio.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
diff --git a/io/readdir.c b/io/readdir.c
index 7133204..f34a914 100644
--- a/io/readdir.c
+++ b/io/readdir.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/resblks.c b/io/resblks.c
index 2e54776..9baeb8c 100644
--- a/io/resblks.c
+++ b/io/resblks.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/seek.c b/io/seek.c
index 526b7b8..86e91e8 100644
--- a/io/seek.c
+++ b/io/seek.c
@@ -16,6 +16,7 @@
  * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/sendfile.c b/io/sendfile.c
index 426b75d..c904e1c 100644
--- a/io/sendfile.c
+++ b/io/sendfile.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/shutdown.c b/io/shutdown.c
index 21e1626..2d01c3d 100644
--- a/io/shutdown.c
+++ b/io/shutdown.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/sync.c b/io/sync.c
index 683899b..dd4e5dd 100644
--- a/io/sync.c
+++ b/io/sync.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include "init.h"
diff --git a/io/sync_file_range.c b/io/sync_file_range.c
index 35d8cc5..f4a7a57 100644
--- a/io/sync_file_range.c
+++ b/io/sync_file_range.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/io/truncate.c b/io/truncate.c
index 49ced6f..d63d6a1 100644
--- a/io/truncate.c
+++ b/io/truncate.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/libxcmd/command.c b/libxcmd/command.c
index ebf1413..708c3fc 100644
--- a/libxcmd/command.c
+++ b/libxcmd/command.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/libxcmd/help.c b/libxcmd/help.c
index 54d34d8..3761a56 100644
--- a/libxcmd/help.c
+++ b/libxcmd/help.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 
diff --git a/libxcmd/input.c b/libxcmd/input.c
index c06b5b8..d8f637f 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/input.h>
 #include <ctype.h>
diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index 443adbb..2ce07f5 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <paths.h>
 #include <errno.h>
 #include <stdio.h>
diff --git a/libxcmd/projects.c b/libxcmd/projects.c
index a0f5bc9..34125fd 100644
--- a/libxcmd/projects.c
+++ b/libxcmd/projects.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/libxcmd/quit.c b/libxcmd/quit.c
index faba4d1..6d9b5b7 100644
--- a/libxcmd/quit.c
+++ b/libxcmd/quit.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 72fc4b3..7483797 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -59,6 +59,7 @@
 
 #include "libxfs_api_defs.h"
 #include <xfs/platform_defs.h>
+#include <config.h>
 
 #include <xfs/list.h>
 #include <xfs/hlist.h>
diff --git a/libxfs/radix-tree.c b/libxfs/radix-tree.c
index c4b6971..8160f23 100644
--- a/libxfs/radix-tree.c
+++ b/libxfs/radix-tree.c
@@ -19,6 +19,7 @@
  */
 
 #include <xfs/platform_defs.h>
+#include <config.h>
 #include "radix-tree.h"
 
 #ifndef ARRAY_SIZE
diff --git a/libxlog/util.c b/libxlog/util.c
index 498c06c..01e97bb 100644
--- a/libxlog/util.c
+++ b/libxlog/util.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <xfs/libxlog.h>
 
diff --git a/logprint/log_copy.c b/logprint/log_copy.c
index 1517846..74063a8 100644
--- a/logprint/log_copy.c
+++ b/logprint/log_copy.c
@@ -15,6 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <xfs/libxlog.h>
 
diff --git a/logprint/log_dump.c b/logprint/log_dump.c
index dcecb44..4a50bae 100644
--- a/logprint/log_dump.c
+++ b/logprint/log_dump.c
@@ -15,6 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <xfs/libxlog.h>
 
diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 521ab66..7e49d50 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -15,6 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <xfs/libxlog.h>
 
diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index a02c71a..253017a 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -15,6 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <xfs/libxlog.h>
 
diff --git a/logprint/log_print_trans.c b/logprint/log_print_trans.c
index 0911b6f..22acc96 100644
--- a/logprint/log_print_trans.c
+++ b/logprint/log_print_trans.c
@@ -15,6 +15,7 @@
  * along with this program; if not, write the Free Software Foundation,
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <xfs/libxlog.h>
 
diff --git a/logprint/logprint.c b/logprint/logprint.c
index fdf106b..52a203c 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -18,6 +18,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <xfs/libxlog.h>
 
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 45565b7..11efb70 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <sys/stat.h>
 #include "xfs_mkfs.h"
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 83f7749..47c8d7b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <ctype.h>
 #ifdef ENABLE_BLKID
diff --git a/quota/darwin.c b/quota/darwin.c
index fb81f7f..7024eb8 100644
--- a/quota/darwin.c
+++ b/quota/darwin.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include "quota.h"
 #include <sys/quota.h>
 
diff --git a/quota/edit.c b/quota/edit.c
index cad3aee..57d517b 100644
--- a/quota/edit.c
+++ b/quota/edit.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <pwd.h>
 #include <grp.h>
 #include <ctype.h>
diff --git a/quota/free.c b/quota/free.c
index 79b52e9..e37e7c9 100644
--- a/quota/free.c
+++ b/quota/free.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/command.h>
 #include "init.h"
 #include "quota.h"
diff --git a/quota/freebsd.c b/quota/freebsd.c
index 7770b3c..0a19f39 100644
--- a/quota/freebsd.c
+++ b/quota/freebsd.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include "quota.h"
 
 int
diff --git a/quota/init.c b/quota/init.c
index 639e9e7..75840d5 100644
--- a/quota/init.c
+++ b/quota/init.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/path.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
diff --git a/quota/irix.c b/quota/irix.c
index bbbcd18..80381b4 100644
--- a/quota/irix.c
+++ b/quota/irix.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include "quota.h"
 #include <sys/quota.h>
 
diff --git a/quota/linux.c b/quota/linux.c
index 8a73922..86bbfa9 100644
--- a/quota/linux.c
+++ b/quota/linux.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include "quota.h"
 #include <sys/quota.h>
 
diff --git a/quota/path.c b/quota/path.c
index 0c204ed..2daf7cc 100644
--- a/quota/path.c
+++ b/quota/path.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
 #include "init.h"
diff --git a/quota/project.c b/quota/project.c
index a2c7046..eb88fb8 100644
--- a/quota/project.c
+++ b/quota/project.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
 #include "init.h"
diff --git a/quota/quot.c b/quota/quot.c
index 96d449e..a06d94a 100644
--- a/quota/quot.c
+++ b/quota/quot.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/command.h>
 #include <ctype.h>
 #include <pwd.h>
diff --git a/quota/quota.c b/quota/quota.c
index 367da8c..3c5f751 100644
--- a/quota/quota.c
+++ b/quota/quota.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/command.h>
 #include <ctype.h>
 #include <pwd.h>
diff --git a/quota/report.c b/quota/report.c
index 8e3316e..88df916 100644
--- a/quota/report.c
+++ b/quota/report.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/command.h>
 #include <sys/types.h>
 #include <pwd.h>
diff --git a/quota/state.c b/quota/state.c
index 42bffc0..be466b7 100644
--- a/quota/state.c
+++ b/quota/state.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/command.h>
 #include "init.h"
 #include "quota.h"
diff --git a/quota/util.c b/quota/util.c
index 179aafd..df3759d 100644
--- a/quota/util.c
+++ b/quota/util.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <sys/types.h>
 #include <pwd.h>
 #include <grp.h>
diff --git a/repair/agheader.c b/repair/agheader.c
index 9ae2deb..59cb630 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "globals.h"
 #include "agheader.h"
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index f3332b3..f2f3aca 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "globals.h"
 #include "err_protos.h"
diff --git a/repair/avl.c b/repair/avl.c
index eabecc3..0e8a2b1 100644
--- a/repair/avl.c
+++ b/repair/avl.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "avl.h"
 
diff --git a/repair/avl64.c b/repair/avl64.c
index c135da3..da87461 100644
--- a/repair/avl64.c
+++ b/repair/avl64.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <stdio.h>
 #include <libxfs.h>
 #include "avl64.h"
diff --git a/repair/bmap.c b/repair/bmap.c
index 71568f4..457c3bd 100644
--- a/repair/bmap.c
+++ b/repair/bmap.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "err_protos.h"
 #include "bmap.h"
diff --git a/repair/btree.c b/repair/btree.c
index 2beb75a..81d166b 100644
--- a/repair/btree.c
+++ b/repair/btree.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "btree.h"
 
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 9b7d017..3c3981b 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "avl.h"
 #include "globals.h"
diff --git a/repair/dinode.c b/repair/dinode.c
index 179203e..f1c070d 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "avl.h"
 #include "globals.h"
diff --git a/repair/dir2.c b/repair/dir2.c
index ceb8825..372e7a7 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "avl.h"
 #include "globals.h"
diff --git a/repair/globals.c b/repair/globals.c
index b588d03..b0747b6 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 
 #define EXTERN
diff --git a/repair/incore.c b/repair/incore.c
index cf1073f..7534701 100644
--- a/repair/incore.c
+++ b/repair/incore.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "avl.h"
 #include "btree.h"
diff --git a/repair/incore_bmc.c b/repair/incore_bmc.c
index 1bc5fd9..97c3484 100644
--- a/repair/incore_bmc.c
+++ b/repair/incore_bmc.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "avl.h"
 #include "globals.h"
diff --git a/repair/incore_ext.c b/repair/incore_ext.c
index 826bf44..fd1c515 100644
--- a/repair/incore_ext.c
+++ b/repair/incore_ext.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "avl.h"
 #include "btree.h"
diff --git a/repair/incore_ino.c b/repair/incore_ino.c
index cda6c2b..66e32a6 100644
--- a/repair/incore_ino.c
+++ b/repair/incore_ino.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "avl.h"
 #include "globals.h"
diff --git a/repair/init.c b/repair/init.c
index d0940aa..4470bd9 100644
--- a/repair/init.c
+++ b/repair/init.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "globals.h"
 #include "agheader.h"
diff --git a/repair/phase1.c b/repair/phase1.c
index ec75ada..162069a 100644
--- a/repair/phase1.c
+++ b/repair/phase1.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "globals.h"
 #include "agheader.h"
diff --git a/repair/phase2.c b/repair/phase2.c
index a23f472..940b3b4 100644
--- a/repair/phase2.c
+++ b/repair/phase2.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <xfs/libxlog.h>
 #include "avl.h"
diff --git a/repair/phase3.c b/repair/phase3.c
index 213d368..370dcb5 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "threads.h"
 #include "prefetch.h"
diff --git a/repair/phase4.c b/repair/phase4.c
index aa79ae0..5ead361 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "threads.h"
 #include "prefetch.h"
diff --git a/repair/phase5.c b/repair/phase5.c
index 0601810..7d61ee1 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "avl.h"
 #include "globals.h"
diff --git a/repair/phase6.c b/repair/phase6.c
index 130ed4f..a55f3dc 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "threads.h"
 #include "prefetch.h"
diff --git a/repair/phase7.c b/repair/phase7.c
index becacf8..49bf014 100644
--- a/repair/phase7.c
+++ b/repair/phase7.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "avl.h"
 #include "globals.h"
diff --git a/repair/prefetch.c b/repair/prefetch.c
index 1577971..4a0d4df 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -1,3 +1,4 @@
+#include <config.h>
 #include <libxfs.h>
 #include <pthread.h>
 #include "avl.h"
diff --git a/repair/progress.c b/repair/progress.c
index 45a412e..0125655 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -1,4 +1,5 @@
 
+#include <config.h>
 #include <libxfs.h>
 #include "globals.h"
 #include "progress.h"
diff --git a/repair/rt.c b/repair/rt.c
index 3a488c8..39e1b7b 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "avl.h"
 #include "globals.h"
diff --git a/repair/sb.c b/repair/sb.c
index a291b3e..047e385 100644
--- a/repair/sb.c
+++ b/repair/sb.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include <libxlog.h>
 #include "agheader.h"
diff --git a/repair/scan.c b/repair/scan.c
index e3895c2..5331f51 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 #include "avl.h"
 #include "globals.h"
diff --git a/repair/threads.c b/repair/threads.c
index d10b841..e5d534f 100644
--- a/repair/threads.c
+++ b/repair/threads.c
@@ -1,3 +1,4 @@
+#include <config.h>
 #include <libxfs.h>
 #include <pthread.h>
 #include <signal.h>
diff --git a/repair/versions.c b/repair/versions.c
index e176779..8f7e886 100644
--- a/repair/versions.c
+++ b/repair/versions.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 
 #define EXTERN
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 11a6069..10d7434 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <xfs/libxfs.h>
 #include <xfs/libxlog.h>
 #include <sys/resource.h>
diff --git a/rtcp/xfs_rtcp.c b/rtcp/xfs_rtcp.c
index 5f26a62..887e43f 100644
--- a/rtcp/xfs_rtcp.c
+++ b/rtcp/xfs_rtcp.c
@@ -16,6 +16,7 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <config.h>
 #include <libxfs.h>
 
 int rtcp(char *, char *, int);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
