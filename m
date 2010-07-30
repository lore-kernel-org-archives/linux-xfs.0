Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o59EDSiN068302 for <xfs@oss.sgi.com>; Wed, 9 Jun 2010 09:13:28 -0500
Received: from stout.americas.sgi.com (stout.americas.sgi.com [128.162.232.50])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2EBC28F8049
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 14:51:23 -0700 (PDT)
Received: from stout.americas.sgi.com (localhost6.localdomain6 [127.0.0.1])
	by stout.americas.sgi.com (8.14.3/8.14.2) with ESMTP id o6ULpNUF008603
	for <xfs@oss.sgi.com>; Fri, 30 Jul 2010 16:51:23 -0500
Received: (from aelder@localhost)
	by stout.americas.sgi.com (8.14.3/8.14.3/Submit) id o6ULpNLX008602
	for xfs@oss.sgi.com; Fri, 30 Jul 2010 16:51:23 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201007302151.o6ULpNLX008602@stout.americas.sgi.com>
Date: Fri, 30 Jul 2010 16:51:23 -0500
Subject: dmapi: fix depend targets
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

There's no need to re-make the dependency files all the time.  Make
it so the "depend" target rebuilds the ".dep" file only if necessary.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 include/buildrules |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: b/include/buildrules
===================================================================
--- a/include/buildrules
+++ b/include/buildrules
@@ -8,7 +8,7 @@ include $(TOPDIR)/include/builddefs
 
 clean clobber : $(addsuffix -clean,$(SUBDIRS))
 	rm -f $(DIRT)
-	@rm -fr .libs
+	@rm -fr .libs .dep
 
 %-clean:
 	$(MAKE) -C $* clean
@@ -72,9 +72,10 @@ ifdef LTLIBRARY
 DEPENDSCRIPT := $(DEPENDSCRIPT) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,'
 endif
 
-depend : $(CFILES) $(HFILES) $(addsuffix -depend,$(SUBDIRS))
+depend : .dep $(addsuffix -depend,$(SUBDIRS))
+
+.dep : $(CFILES) $(HFILES)
 	$(DEPENDSCRIPT) > .dep
-	test -s .dep || rm -f .dep
 
 %-depend:
 	$(MAKE) -C $* depend

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
