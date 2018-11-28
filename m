Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729093AbeK2D7X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Nov 2018 22:59:23 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C38693138B9B
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 16:57:05 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 2/4] xfsdump: do not split function call with ifdef
Date: Wed, 28 Nov 2018 17:56:47 +0100
Message-Id: <20181128165649.56853-3-jtulak@redhat.com>
In-Reply-To: <20181128165649.56853-1-jtulak@redhat.com>
References: <20181128165649.56853-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@redhat.com, Jan Tulak <jtulak@redhat.com>

In two files in xfsdump, a function call is split in half by an ifdef
macro to conditionally pick an argument at compile time. This causes the
code to be a bit less obvious and some analysis tools have trouble with
understanding it.

So, instead of splitting the function in half, move the whole function
call into each of the ifdef macros.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 common/drive_minrmt.c | 3 ++-
 common/main.c         | 8 ++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index 59a40a7..04fed3e 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -2585,11 +2585,12 @@ read_label( drive_t *drivep )
 	if (( nread == 0 )  /* takes care of sun */
 	      ||            /* now handle SGI */
 	      (nread < 0 && saved_errno == ENOSPC )) {
-		mlog( MLOG_NORMAL | MLOG_DRIVE,
 #ifdef DUMP
+		mlog( MLOG_NORMAL | MLOG_DRIVE,
 		      _("encountered EOD : assuming blank media\n") );
 #endif
 #ifdef RESTORE
+		mlog( MLOG_NORMAL | MLOG_DRIVE,
 		      _("encountered EOD : end of data\n") );
 #endif
 		( void )rewind_and_verify( drivep );
diff --git a/common/main.c b/common/main.c
index b3605d1..0c23eb4 100644
--- a/common/main.c
+++ b/common/main.c
@@ -581,12 +581,14 @@ main( int argc, char *argv[] )
 		sigaction( SIGTERM, &sa, NULL );
 		sigaction( SIGQUIT, &sa, NULL );
 
+#ifdef DUMP
 		ok = drive_init2( argc,
 				  argv,
-#ifdef DUMP
 				  gwhdrtemplatep );
 #endif /* DUMP */
 #ifdef RESTORE
+		ok = drive_init2( argc,
+				  argv,
 				  ( global_hdr_t * )0 );
 #endif /* RESTORE */
 		if ( ! ok ) {
@@ -629,12 +631,14 @@ main( int argc, char *argv[] )
 	 * time-consuming chore. drive_init3 will synchronize with each slave.
 	 */
 	if ( ! init_error ) {
+#ifdef DUMP
 		ok = drive_init2( argc,
 				  argv,
-#ifdef DUMP
 				  gwhdrtemplatep );
 #endif /* DUMP */
 #ifdef RESTORE
+		ok = drive_init2( argc,
+				  argv,
 				  ( global_hdr_t * )0 );
 #endif /* RESTORE */
 		if ( ! ok ) {
-- 
2.19.1
