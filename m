Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 02:17:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l8O9HEQ3027682
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 02:17:17 -0700
Received: from cxfsmac10.melbourne.sgi.com (cxfsmac10.melbourne.sgi.com [134.14.55.100]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id TAA12623 for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 19:17:17 +1000
Message-ID: <46F7809D.1040900@sgi.com>
Date: Mon, 24 Sep 2007 19:17:17 +1000
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Review: Fix xfsidbg.c compiler warnings on x86_64
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Fix compile warnings for xfsidbg.c as seen on x86_64.

--- 2.6.x-xfs.orig/fs/xfs/xfsidbg.c
+++ 2.6.x-xfs/fs/xfs/xfsidbg.c
@@ -1798,10 +1798,10 @@ xfs_itrace_pr_entry(ktrace_entry_t *ktep
  	if ((__psint_t)ktep->val[0] == 0)
  		return 0;

-	if (kdbnearsym((unsigned int)ktep->val[8], &symtab)) {
+	if (kdbnearsym((unsigned long)ktep->val[8], &symtab)) {
  		unsigned long offval;

-		offval = (unsigned int)ktep->val[8] - symtab.sym_start;
+		offval = (unsigned long)ktep->val[8] - symtab.sym_start;

  		if (offval)
  			sprintf(funcname, "%s+0x%lx", symtab.sym_name, offval);
@@ -1871,13 +1871,13 @@ xfs_itrace_pr_entry(ktrace_entry_t *ktep

  	kdb_printf("\n");

-	kdb_printf("  cpu = %ld pid = %d ",
-			(long)ktep->val[6], (pid_t)ktep->val[7]);
+	kdb_printf("  cpu = %ld pid = %ld ",
+			(long)ktep->val[6], (long)ktep->val[7]);

-	if (kdbnearsym((unsigned int)ktep->val[4], &symtab)) {
+	if (kdbnearsym((unsigned long)ktep->val[4], &symtab)) {
  		unsigned long offval;

-		offval = (unsigned int)ktep->val[4] - symtab.sym_start;
+		offval = (unsigned long)ktep->val[4] - symtab.sym_start;

  		if (offval)
  			kdb_printf("  ra = %s+0x%lx", symtab.sym_name, offval);
