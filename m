Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41562 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727939AbeKJAMl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 9 Nov 2018 19:12:41 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88A7F7E43B
        for <linux-xfs@vger.kernel.org>; Fri,  9 Nov 2018 14:31:51 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 10/24] xfsdump: (style) insert a newline between type and fnt name in definitions
Date: Fri,  9 Nov 2018 15:29:50 +0100
Message-Id: <20181109143004.24963-11-jtulak@redhat.com>
In-Reply-To: <20181109143004.24963-1-jtulak@redhat.com>
References: <20181109143004.24963-1-jtulak@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

The xfs style we want to have after this patch is:

int

foo(...)

This patch only changes .c files. .h files use one-line style for
declarations, as is the custom in xfsprogs.

int foo(...)

Created by this script:

#!/usr/bin/env bash
# add a newline between type and function name on definitions
# (so skip .h files for this)

find . -name '*.c' ! -type d -exec bash -c '
sed -i \
    -e "s/^\([_a-zA-Z0-9][_a-zA-Z0-9 	]\+\) \([_a-zA-Z0-9]\+\)(\([^;]\+\)$/\1
\2(\3/" \
    $0
' {} \;

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 common/dlog.c           |  3 +-
 common/drive.c          |  3 +-
 common/drive_minrmt.c   | 12 +++++---
 common/drive_scsitape.c | 15 ++++++----
 common/getdents.c       |  3 +-
 common/stream.c         |  9 ++++--
 dump/content.c          | 60 ++++++++++++++++++++++++++-------------
 dump/inomap.c           | 18 ++++++++----
 inventory/testmain.c    |  3 +-
 librmt/rmtabort.c       |  3 +-
 librmt/rmtclose.c       |  3 +-
 librmt/rmtcommand.c     |  3 +-
 librmt/rmtlseek.c       |  3 +-
 librmt/rmtread.c        |  3 +-
 librmt/rmtstatus.c      |  3 +-
 librmt/rmtwrite.c       |  3 +-
 restore/content.c       | 63 +++++++++++++++++++++++++++--------------
 restore/tree.c          | 42 ++++++++++++++++++---------
 18 files changed, 168 insertions(+), 84 deletions(-)

diff --git a/common/dlog.c b/common/dlog.c
index d5b0443..acbf8bf 100644
--- a/common/dlog.c
+++ b/common/dlog.c
@@ -42,7 +42,8 @@ static char *promptstr = " -> ";
 
 static sigset_t dlog_registered_sigs;
 
-static bool_t promptinput(char *buf,
+static bool_t
+promptinput(char *buf,
 			   size_t bufsz,
 			   ix_t *exceptionixp,
 			   time32_t timeout,
diff --git a/common/drive.c b/common/drive.c
index 02a0f1f..e19390f 100644
--- a/common/drive.c
+++ b/common/drive.c
@@ -56,7 +56,8 @@ extern drive_strategy_t drive_strategy_rmt;
 /* forward declarations of locally defined static functions ******************/
 
 static drive_t *drive_alloc(char *, size_t);
-static void drive_allochdrs(drive_t *drivep,
+static void
+drive_allochdrs(drive_t *drivep,
 			     global_hdr_t *gwhdrtemplatep,
 			     ix_t driveix);
 
diff --git a/common/drive_minrmt.c b/common/drive_minrmt.c
index c5c9e56..89d3f5e 100644
--- a/common/drive_minrmt.c
+++ b/common/drive_minrmt.c
@@ -303,22 +303,26 @@ static bool_t get_tpcaps(drive_t *);
 static int prepare_drive(drive_t *drivep);
 static bool_t Open(drive_t *drivep);
 static void Close(drive_t *drivep);
-static int Read(drive_t *drivep,
+static int
+Read(drive_t *drivep,
 		      char *bufp,
 		      size_t cnt,
 		      int *errnop);
-static int Write(drive_t *drivep,
+static int
+Write(drive_t *drivep,
 		       char *bufp,
 		       size_t cnt,
 		       int *saved_errnop);
-static int record_hdr_validate(drive_t *drivep,
+static int
+record_hdr_validate(drive_t *drivep,
 				     char *bufp,
 				     bool_t chkoffpr);
 static int ring_read(void *clientctxp, char *bufp);
 static int ring_write(void *clientctxp, char *bufp);
 static double percent64(off64_t num, off64_t denom);
 static int getrec(drive_t *drivep);
-static int write_record(drive_t *drivep, char *bufp, bool_t chksumpr,
+static int
+write_record(drive_t *drivep, char *bufp, bool_t chksumpr,
                               bool_t xlatepr);
 static ring_msg_t * Ring_get(ring_t *ringp);
 static void Ring_reset(ring_t *ringp, ring_msg_t *msgp);
diff --git a/common/drive_scsitape.c b/common/drive_scsitape.c
index 54bbb9f..54a6797 100644
--- a/common/drive_scsitape.c
+++ b/common/drive_scsitape.c
@@ -350,25 +350,30 @@ static bool_t set_fixed_blksz(drive_t *, size_t);
 static int prepare_drive(drive_t *drivep);
 static bool_t Open(drive_t *drivep);
 static void Close(drive_t *drivep);
-static int Read(drive_t *drivep,
+static int
+Read(drive_t *drivep,
 		      char *bufp,
 		      size_t cnt,
 		      int *errnop);
-static int Write(drive_t *drivep,
+static int
+Write(drive_t *drivep,
 		       char *bufp,
 		       size_t cnt,
 		       int *saved_errnop);
-static int quick_backup(drive_t *drivep,
+static int
+quick_backup(drive_t *drivep,
 			      drive_context_t *contextp,
 			      ix_t skipcnt);
-static int record_hdr_validate(drive_t *drivep,
+static int
+record_hdr_validate(drive_t *drivep,
 				     char *bufp,
 				     bool_t chkoffpr);
 static int ring_read(void *clientctxp, char *bufp);
 static int ring_write(void *clientctxp, char *bufp);
 static double percent64(off64_t num, off64_t denom);
 static int getrec(drive_t *drivep);
-static int write_record(drive_t *drivep, char *bufp, bool_t chksumpr,
+static int
+write_record(drive_t *drivep, char *bufp, bool_t chksumpr,
                               bool_t xlatepr);
 static ring_msg_t * Ring_get(ring_t *ringp);
 static void Ring_reset(ring_t *ringp, ring_msg_t *msgp);
diff --git a/common/getdents.c b/common/getdents.c
index 7f79101..f3d967e 100644
--- a/common/getdents.c
+++ b/common/getdents.c
@@ -51,7 +51,8 @@ struct kernel_dirent64 {
    reasonable number of bytes to read.  If we should be wrong, we can
    reset the file descriptor.  In practice the kernel is limiting the
    amount of data returned much more then the reduced buffer size.  */
-int getdents_wrap(int fd, char *buf, size_t nbytes)
+int
+getdents_wrap(int fd, char *buf, size_t nbytes)
 {
 	struct dirent *dp;
 	struct kernel_dirent64 *kdp;
diff --git a/common/stream.c b/common/stream.c
index f7a0cce..0bc6a34 100644
--- a/common/stream.c
+++ b/common/stream.c
@@ -222,17 +222,20 @@ stream_getix(pthread_t tid)
 	if (p) p->s_exit_ ## field_name = (value);			\
 	unlock();
 
-void stream_set_code(pthread_t tid, int exit_code)
+void
+stream_set_code(pthread_t tid, int exit_code)
 {
 	stream_set(code, tid, exit_code);
 }
 
-void stream_set_return(pthread_t tid, rv_t rv)
+void
+stream_set_return(pthread_t tid, rv_t rv)
 {
 	stream_set(return, tid, rv);
 }
 
-void stream_set_hint(pthread_t tid, rv_t rv)
+void
+stream_set_hint(pthread_t tid, rv_t rv)
 {
 	stream_set(hint, tid, rv);
 }
diff --git a/dump/content.c b/dump/content.c
index 341a9ae..0f46563 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -261,51 +261,61 @@ extern size_t pgsz;
 
 /* file dumpers
  */
-static rv_t dump_dirs(ix_t strmix,
+static rv_t
+dump_dirs(ix_t strmix,
 		       xfs_bstat_t *bstatbufp,
 		       size_t bstatbuflen,
 		       void *inomap_contextp);
-static rv_t dump_dir(ix_t strmix,
+static rv_t
+dump_dir(ix_t strmix,
 		      jdm_fshandle_t *,
 		      int,
 		      xfs_bstat_t *);
-static rv_t dump_file(void *,
+static rv_t
+dump_file(void *,
 		       jdm_fshandle_t *,
 		       int,
 		       xfs_bstat_t *);
-static rv_t dump_file_reg(drive_t *drivep,
+static rv_t
+dump_file_reg(drive_t *drivep,
 			   context_t *contextp,
 			   content_inode_hdr_t *scwhdrp,
 			   jdm_fshandle_t *,
 			   xfs_bstat_t *,
 			   bool_t *);
-static rv_t dump_file_spec(drive_t *drivep,
+static rv_t
+dump_file_spec(drive_t *drivep,
 			    context_t *contextp,
 			    jdm_fshandle_t *,
 			    xfs_bstat_t *);
-static rv_t dump_filehdr(drive_t *drivep,
+static rv_t
+dump_filehdr(drive_t *drivep,
 			  context_t *contextp,
 			  xfs_bstat_t *,
 			  off64_t,
 			  int);
-static rv_t dump_extenthdr(drive_t *drivep,
+static rv_t
+dump_extenthdr(drive_t *drivep,
 			    context_t *contextp,
 			    int32_t,
 			    int32_t,
 			    off64_t,
 			    off64_t);
-static rv_t dump_dirent(drive_t *drivep,
+static rv_t
+dump_dirent(drive_t *drivep,
 			 context_t *contextp,
 			 xfs_bstat_t *,
 			 xfs_ino_t,
 			 gen_t,
 			 char *,
 			 size_t);
-static rv_t init_extent_group_context(jdm_fshandle_t *,
+static rv_t
+init_extent_group_context(jdm_fshandle_t *,
 				       xfs_bstat_t *,
 				       extent_group_context_t *);
 static void cleanup_extent_group_context(extent_group_context_t *);
-static rv_t dump_extent_group(drive_t *drivep,
+static rv_t
+dump_extent_group(drive_t *drivep,
 			       context_t *contextp,
 			       xfs_bstat_t *,
 			       extent_group_context_t *,
@@ -315,7 +325,8 @@ static rv_t dump_extent_group(drive_t *drivep,
 			       off64_t *,
 			       off64_t *,
 			       bool_t *);
-static bool_t dump_session_inv(drive_t *drivep,
+static bool_t
+dump_session_inv(drive_t *drivep,
 			        context_t *contextp,
 			        media_hdr_t *mwhdrp,
 			        content_inode_hdr_t *scwhdrp);
@@ -324,36 +335,43 @@ static rv_t write_pad(drive_t *drivep, size_t);
 static void mark_callback(void *, drive_markrec_t *, bool_t);
 
 static void inv_cleanup(void);
-static void dump_terminator(drive_t *drivep,
+static void
+dump_terminator(drive_t *drivep,
 			     context_t *contextp,
 			     media_hdr_t *mwhdrp);
-static rv_t Media_mfile_begin(drive_t *drivep,
+static rv_t
+Media_mfile_begin(drive_t *drivep,
 			       context_t *contextp,
 			       bool_t intr_allowed);
-static rv_t Media_mfile_end(drive_t *drivep,
+static rv_t
+Media_mfile_end(drive_t *drivep,
 			     context_t *contextp,
 			     media_hdr_t *mwhdrp,
 			     off64_t *ncommittedp,
 			     bool_t hit_eom);
 static bool_t Media_prompt_overwrite(drive_t *drivep);
-static rv_t Media_erasechk(drive_t *drivep,
+static rv_t
+Media_erasechk(drive_t *drivep,
 			    int dcaps,
 			    bool_t intr_allowed,
 			    bool_t prevmediapresentpr);
 static bool_t Media_prompt_erase(drive_t *drivep);
 static char *Media_prompt_label(drive_t *drivep, char *bufp, size_t bufsz);
-static void update_cc_Media_useterminatorpr(drive_t *drivep,
+static void
+update_cc_Media_useterminatorpr(drive_t *drivep,
 					     context_t *contextp);
 static void set_mcflag(ix_t thrdix);
 static void clr_mcflag(ix_t thrdix);
 
 static bool_t check_complete_flags(void);
 
-static rv_t dump_extattrs(drive_t *drivep,
+static rv_t
+dump_extattrs(drive_t *drivep,
 			   context_t *contextp,
 	       		   jdm_fshandle_t *fshandlep,
 			   xfs_bstat_t *statp);
-static rv_t dump_extattr_list(drive_t *drivep,
+static rv_t
+dump_extattr_list(drive_t *drivep,
 			       context_t *contextp,
 	       		       jdm_fshandle_t *fshandlep,
 			       xfs_bstat_t *statp,
@@ -367,7 +385,8 @@ static char *dump_extattr_buildrecord(xfs_bstat_t *statp,
 				       uint32_t valuesz,
 				       int flag,
 				       char **valuepp);
-static rv_t dump_extattrhdr(drive_t *drivep,
+static rv_t
+dump_extattrhdr(drive_t *drivep,
 			     context_t *contextp,
 			     xfs_bstat_t *statp,
 			     size_t recsz,
@@ -375,7 +394,8 @@ static rv_t dump_extattrhdr(drive_t *drivep,
 			     ix_t flags,
 			     uint32_t valsz);
 
-static bool_t save_quotas(char *mntpnt,
+static bool_t
+save_quotas(char *mntpnt,
 			   quota_info_t *quotainfo);
 static int getxfsqstat(char *fsdev);
 
diff --git a/dump/inomap.c b/dump/inomap.c
index 182d99e..b6acd3c 100644
--- a/dump/inomap.c
+++ b/dump/inomap.c
@@ -67,7 +67,8 @@ extern bool_t allowexcludefiles_pr;
 
 /* inomap construction callbacks
  */
-static int cb_context(bool_t last,
+static int
+cb_context(bool_t last,
 			    time32_t,
 			    bool_t,
 			    time32_t,
@@ -86,11 +87,13 @@ static bool_t cb_inoinresumerange(xfs_ino_t);
 static bool_t cb_inoresumed(xfs_ino_t);
 static void cb_accuminit_sz(void);
 static void cb_spinit(void);
-static int cb_startpt(void *,
+static int
+cb_startpt(void *,
 			    jdm_fshandle_t *,
 			    int,
 			    xfs_bstat_t *);
-static int supprt_prune(void *,
+static int
+supprt_prune(void *,
 			      jdm_fshandle_t *,
 			      int,
 			      xfs_bstat_t *,
@@ -107,17 +110,20 @@ static void inomap_set_gen(void *, xfs_ino_t, gen_t);
 
 /* subtree abstraction
  */
-static int subtree_descend_cb(void *,
+static int
+subtree_descend_cb(void *,
 				    jdm_fshandle_t *,
 				    int fsfd,
 				    xfs_bstat_t *,
 				    char *);
-static int subtreelist_parse_cb(void *,
+static int
+subtreelist_parse_cb(void *,
 				      jdm_fshandle_t *,
 				      int fsfd,
 				      xfs_bstat_t *,
 				      char *);
-static int subtreelist_parse(jdm_fshandle_t *,
+static int
+subtreelist_parse(jdm_fshandle_t *,
 				   int,
 				   xfs_bstat_t *,
 				   char *[],
diff --git a/inventory/testmain.c b/inventory/testmain.c
index 07f4ae3..09b9bd6 100644
--- a/inventory/testmain.c
+++ b/inventory/testmain.c
@@ -359,7 +359,8 @@ write_test(int nsess, int nstreams, int nmedia, int dumplevel)
 }
 
 
-void usage(void)
+void
+usage(void)
 {
 	printf("(%s ./inv w|r|q -v <verbosity> -s <nsess>"
 	       "-t <strms> -m <nmediafiles> \n", optarg);
diff --git a/librmt/rmtabort.c b/librmt/rmtabort.c
index a7db4b1..bd61b25 100644
--- a/librmt/rmtabort.c
+++ b/librmt/rmtabort.c
@@ -28,7 +28,8 @@
  *	abort --- close off a remote tape connection
  */
 
-void _rmt_abort(int fildes)
+void
+_rmt_abort(int fildes)
 {
 	close(READ(fildes));
 	close(WRITE(fildes));
diff --git a/librmt/rmtclose.c b/librmt/rmtclose.c
index 97f53c7..b15a459 100644
--- a/librmt/rmtclose.c
+++ b/librmt/rmtclose.c
@@ -49,7 +49,8 @@ int fildes;
  *	_rmt_close --- close a remote magtape unit and shut down
  */
 
-static int _rmt_close(int fildes)
+static int
+_rmt_close(int fildes)
 {
 	int rc;
 
diff --git a/librmt/rmtcommand.c b/librmt/rmtcommand.c
index b5726d9..5811d50 100644
--- a/librmt/rmtcommand.c
+++ b/librmt/rmtcommand.c
@@ -32,7 +32,8 @@
  *	_rmt_command --- attempt to perform a remote tape command
  */
 
-int _rmt_command(fildes, buf)
+int
+_rmt_command(fildes, buf)
 int fildes;
 char *buf;
 {
diff --git a/librmt/rmtlseek.c b/librmt/rmtlseek.c
index bf8c0fa..7278921 100644
--- a/librmt/rmtlseek.c
+++ b/librmt/rmtlseek.c
@@ -52,7 +52,8 @@ int whence;
  *	_rmt_lseek --- perform an imitation lseek operation remotely
  */
 
-static off_t _rmt_lseek(int fildes, off_t offset, int whence)
+static off_t
+_rmt_lseek(int fildes, off_t offset, int whence)
 {
 	char buffer[BUFMAGIC];
 
diff --git a/librmt/rmtread.c b/librmt/rmtread.c
index 3456901..7531b69 100644
--- a/librmt/rmtread.c
+++ b/librmt/rmtread.c
@@ -53,7 +53,8 @@ unsigned int nbyte;
  *	_rmt_read --- read a buffer from a remote tape
  */
 
-static int _rmt_read(int fildes, char *buf, unsigned int nbyte)
+static int
+_rmt_read(int fildes, char *buf, unsigned int nbyte)
 {
 	int rc, i;
 	char buffer[BUFMAGIC];
diff --git a/librmt/rmtstatus.c b/librmt/rmtstatus.c
index f141395..91ad308 100644
--- a/librmt/rmtstatus.c
+++ b/librmt/rmtstatus.c
@@ -31,7 +31,8 @@
  *	_rmt_status --- retrieve the status from the pipe
  */
 
-int _rmt_status(fildes)
+int
+_rmt_status(fildes)
 int fildes;
 {
 	int i;
diff --git a/librmt/rmtwrite.c b/librmt/rmtwrite.c
index 9b4cc50..c53aeea 100644
--- a/librmt/rmtwrite.c
+++ b/librmt/rmtwrite.c
@@ -53,7 +53,8 @@ unsigned int nbyte;
  *	_rmt_write --- write a buffer to the remote tape
  */
 
-static int _rmt_write(int fildes, char *buf, unsigned int nbyte)
+static int
+_rmt_write(int fildes, char *buf, unsigned int nbyte)
 {
 	char buffer[BUFMAGIC];
 
diff --git a/restore/content.c b/restore/content.c
index e3217e7..5b45906 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -695,7 +695,8 @@ static Media_t *Media_create(ix_t thrdix);
 static void Media_indir(Media_t *Mediap);
 static void Media_indir(Media_t *Mediap);
 static void Media_atnondir(Media_t *Mediap);
-static rv_t Media_mfile_next(Media_t *Mediap,
+static rv_t
+Media_mfile_next(Media_t *Mediap,
 			      purp_t purp,
 			      sync_t *donesyncp,
 			      dh_t  *filehp,
@@ -707,29 +708,34 @@ static rv_t Media_mfile_next(Media_t *Mediap,
 			      drive_t **drivepp,
 			      filehdr_t *fhdr);
 static void Media_end(Media_t *Mediap);
-static bool_t Media_prompt_change(drive_t *drivep,
+static bool_t
+Media_prompt_change(drive_t *drivep,
 				   purp_t purp,
 				   bag_t *bagp,
 				   bool_t knownholespr,
 				   bool_t maybeholespr);
 
 static bool_t Inv_validate_cmdline(void);
-static bool_t dumpcompat(bool_t resumepr,
+static bool_t
+dumpcompat(bool_t resumepr,
 			  ix_t level,
 			  uuid_t baseid,
 			  bool_t logpr);
-static bool_t promptdumpmatch(ix_t thrdix,
+static bool_t
+promptdumpmatch(ix_t thrdix,
 			       global_hdr_t *grhdrp,
 			       media_hdr_t *mrhdrp,
 			       content_hdr_t *crhdrp,
 			       content_inode_hdr_t *scrhdrp);
 
-static void pi_checkpoint(dh_t fileh,
+static void
+pi_checkpoint(dh_t fileh,
 			   drive_mark_t *drivemarkp,
 			   xfs_ino_t ino,
 			   off64_t off);
 static bool_t pi_transcribe(inv_session_t *sessp);
-static dh_t pi_addfile(Media_t *Mediap,
+static dh_t
+pi_addfile(Media_t *Mediap,
 			global_hdr_t *grhdrp,
 			drive_hdr_t *drhdrp,
 			media_hdr_t *mrhdrp,
@@ -746,7 +752,8 @@ static bag_t * pi_neededobjs_nondir_alloc(bool_t *knownholesprp,
 					   bool_t showobjindrivepr,
 					   bool_t markskippr);
 static void pi_neededobjs_free(bag_t *bagp);
-static void pi_bracketneededegrps(dh_t thisfileh,
+static void
+pi_bracketneededegrps(dh_t thisfileh,
 				   egrp_t *first_egrp,
 				   egrp_t *next_egrp);
 static void pi_update_stats(off64_t sz);
@@ -754,7 +761,8 @@ static void pi_hiteod(ix_t strmix, ix_t objix);
 static void pi_hiteom(ix_t strmix, ix_t objix);
 static void pi_hitnextdump(ix_t strmix, ix_t objix, ix_t lastfileix);
 static bool_t pi_know_no_more_on_object(purp_t purp, ix_t strmix, ix_t objix);
-static bool_t pi_know_no_more_beyond_on_object(purp_t purp,
+static bool_t
+pi_know_no_more_beyond_on_object(purp_t purp,
 					        ix_t strmix,
 					        ix_t objix,
 					        ix_t fileix);
@@ -765,12 +773,14 @@ static void pi_note_underhead(dh_t thisobjh, dh_t thisfileh);
 static void pi_lock(void);
 static void pi_unlock(void);
 
-static rv_t applydirdump(drive_t *drivep,
+static rv_t
+applydirdump(drive_t *drivep,
 			  dh_t fileh,
 			  content_inode_hdr_t *scrhdrp,
 			  filehdr_t *fhdrp);
 static rv_t treepost(char *path1, char *path2);
-static rv_t applynondirdump(drive_t *drivep,
+static rv_t
+applynondirdump(drive_t *drivep,
 			     dh_t fileh,
 			     content_inode_hdr_t *scrhdrp,
 			     char *path1,
@@ -780,17 +790,20 @@ static rv_t finalize(char *path1, char *path2);
 static void wipepersstate(void);
 
 static rv_t read_filehdr(drive_t *drivep, filehdr_t *fhdrp, bool_t fhcs);
-static rv_t restore_file(drive_t *drivep,
+static rv_t
+restore_file(drive_t *drivep,
 			  filehdr_t *fhdrp,
 			  bool_t ehcs,
 			  bool_t ahcs,
 			  char *path1,
 			  char *path2);
-static bool_t restore_reg(drive_t *drivep,
+static bool_t
+restore_reg(drive_t *drivep,
 			   filehdr_t *fhdrp,
 			   rv_t *rvp,
 			   char *path);
-static bool_t restore_extent_group(drive_t *drivep,
+static bool_t
+restore_extent_group(drive_t *drivep,
 				    filehdr_t *fhdrp,
 				    char *path,
 				    int fd,
@@ -798,26 +811,30 @@ static bool_t restore_extent_group(drive_t *drivep,
 				    rv_t *rvp);
 static bool_t restore_complete_reg(stream_context_t*);
 static bool_t restore_spec(filehdr_t *fhdrp, rv_t *rvp, char *path);
-static bool_t restore_symlink(drive_t *drivep,
+static bool_t
+restore_symlink(drive_t *drivep,
 			       filehdr_t *fhdrp,
 			       rv_t *rvp,
 			       char *path,
 			       char *scratchpath,
 			       bool_t ehcs);
 static rv_t read_extenthdr(drive_t *drivep, extenthdr_t *ehdrp, bool_t ehcs);
-static rv_t read_dirent(drive_t *drivep,
+static rv_t
+read_dirent(drive_t *drivep,
 			 direnthdr_t *dhdrp,
 			 size_t direntbufsz,
 			 bool_t dhcs);
 static rv_t discard_padding(size_t sz, drive_t *drivep);
-static rv_t restore_extent(filehdr_t *fhdrp,
+static rv_t
+restore_extent(filehdr_t *fhdrp,
 			    extenthdr_t *ehdrp,
 			    int fd,
 			    char *path,
 			    drive_t *drivep,
 			    off64_t *bytesreadp);
 static bool_t askinvforbaseof(uuid_t baseid, inv_session_t *sessp);
-static void addobj(bag_t *bagp,
+static void
+addobj(bag_t *bagp,
 		    uuid_t *objidp,
 		    label_t objlabel,
 		    bool_t indrivepr,
@@ -826,14 +843,16 @@ static size_t cntobj(bag_t *bagp);
 static bool_t gapneeded(egrp_t *firstegrpp, egrp_t *lastegrpp);
 static char * ehdr_typestr(int32_t type);
 static int egrpcmp(egrp_t *egrpap, egrp_t *egrpbp);
-static void display_dump_label(bool_t lockpr,
+static void
+display_dump_label(bool_t lockpr,
 				int mllevel,
 				char *introstr,
 				global_hdr_t *grhdrp,
 				media_hdr_t *mrhdrp,
 				content_hdr_t *crhdrp,
 				content_inode_hdr_t *scrhdrp);
-static void display_needed_objects(purp_t purp,
+static void
+display_needed_objects(purp_t purp,
 				    bag_t *bagp,
 				    bool_t knownholespr,
 				    bool_t maybeholespr);
@@ -844,7 +863,8 @@ static void pi_show_nomloglock(void);
 
 static bool_t extattr_init(size_t drivecnt);
 static char * get_extattrbuf(ix_t which);
-static rv_t restore_extattr(drive_t *drivep,
+static rv_t
+restore_extattr(drive_t *drivep,
 			     filehdr_t *fhdrp,
 			     char *path,
 			     bool_t ahcs,
@@ -854,7 +874,8 @@ static rv_t restore_extattr(drive_t *drivep,
 static bool_t restore_dir_extattr_cb(char *path, dah_t dah);
 static bool_t restore_dir_extattr_cb_cb(extattrhdr_t *ahdrp, void *ctxp);
 static void setextattr(char *path, extattrhdr_t *ahdrp);
-static void partial_reg(ix_t d_index, xfs_ino_t ino, off64_t fsize,
+static void
+partial_reg(ix_t d_index, xfs_ino_t ino, off64_t fsize,
                         off64_t offset, off64_t sz);
 static bool_t partial_check (xfs_ino_t ino, off64_t fsize);
 static bool_t partial_check2 (partial_rest_t *isptr, off64_t fsize);
diff --git a/restore/tree.c b/restore/tree.c
index 7612634..87e6be3 100644
--- a/restore/tree.c
+++ b/restore/tree.c
@@ -268,7 +268,8 @@ extern bool_t restore_rootdir_permissions;
 
 /* forward declarations of locally defined static functions ******************/
 
-static nh_t Node_alloc(xfs_ino_t ino,
+static nh_t
+Node_alloc(xfs_ino_t ino,
 			gen_t gen,
 			nrh_t nrh,
 			dah_t dah,
@@ -276,7 +277,8 @@ static nh_t Node_alloc(xfs_ino_t ino,
 static void Node_free(nh_t *nhp);
 static node_t * Node_map(nh_t nh);
 static void Node_unmap(nh_t nh, node_t **npp);
-static int Node2path_recurse(nh_t nh, char *buf,
+static int
+Node2path_recurse(nh_t nh, char *buf,
 				   int bufsz, int level);
 static void adopt(nh_t parh, nh_t cldh, nrh_t nrh);
 static nrh_t disown(nh_t cldh);
@@ -287,13 +289,16 @@ static nh_t link_nexth(nh_t nh);
 static nh_t link_matchh(nh_t hardh, nh_t parh, char *name);
 static void link_in(nh_t nh);
 static void link_out(nh_t nh);
-static void link_headiter(bool_t (*cbfp)(void *contextp, nh_t hardh),
+static void
+link_headiter(bool_t (*cbfp)(void *contextp, nh_t hardh),
 			   void *contextp);
-static void link_iter_init(link_iter_context_t *link_iter_contextp,
+static void
+link_iter_init(link_iter_context_t *link_iter_contextp,
 			    nh_t hardheadh);
 static nh_t link_iter_next(link_iter_context_t *link_iter_contextp);
 void link_iter_unlink(link_iter_context_t *link_iter_contextp, nh_t nh);
-static bool_t hash_init(size64_t vmsz,
+static bool_t
+hash_init(size64_t vmsz,
 			 size64_t dircnt,
 			 size64_t nondircnt,
 			 char *perspath);
@@ -302,16 +307,19 @@ static inline size_t hash_val(xfs_ino_t ino, size_t hashmask);
 static void hash_in(nh_t nh);
 static void hash_out(nh_t nh);
 static nh_t hash_find(xfs_ino_t ino, gen_t gen);
-static void hash_iter(bool_t (*cbfp)(void *contextp, nh_t hashh),
+static void
+hash_iter(bool_t (*cbfp)(void *contextp, nh_t hashh),
 		       void *contextp);
 static void setdirattr(dah_t dah, char *path);
-static bool_t tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
+static bool_t
+tsi_walkpath(char *arg, nh_t rooth, nh_t cwdh,
 			    dlog_pcbp_t pcb, void *pctxp,
 			    nh_t *namedhp, nh_t *parhp, nh_t *cldhp,
 			    xfs_ino_t *inop, bool_t *isdirprp, bool_t *isselpr);
 static bool_t Node2path(nh_t nh, char *path, char *errmsg);
 static bool_t tree_setattr_recurse(nh_t parh, char *path);
-static void tsi_cmd_pwd_recurse(void *ctxp,
+static void
+tsi_cmd_pwd_recurse(void *ctxp,
 				 dlog_pcbp_t pcb,
 				 void *pctxp,
 				 nh_t nh);
@@ -1173,21 +1181,25 @@ tree_subtree_parse(bool_t sensepr, char *path)
  * somewhere else in the tree. next, make new directories. then rename
  * directories. finally, create hardlinks from orphanage.
  */
-static bool_t noref_elim_recurse(nh_t parh,
+static bool_t
+noref_elim_recurse(nh_t parh,
 				  nh_t cldh,
 				  bool_t parrefpr,
 				  char *path1,
 				  char *path2);
 
-static bool_t mkdirs_recurse(nh_t parh,
+static bool_t
+mkdirs_recurse(nh_t parh,
 			      nh_t cldh,
 			      char *path);
 
-static bool_t rename_dirs(nh_t cldh,
+static bool_t
+rename_dirs(nh_t cldh,
 			   char *path1,
 			   char *path2);
 
-static bool_t proc_hardlinks(char *path1,
+static bool_t
+proc_hardlinks(char *path1,
 			      char *path2);
 
 bool_t
@@ -1991,7 +2003,8 @@ tree_cb_links(xfs_ino_t ino,
  * clear the REFED flags.
  */
 
-static void tree_adjref_recurse(nh_t cldh,
+static void
+tree_adjref_recurse(nh_t cldh,
 				 bool_t pardumpedpr,
 				 bool_t parrefedpr);
 
@@ -2033,7 +2046,8 @@ tree_adjref_recurse(nh_t cldh,
 	}
 }
 
-static bool_t tree_extattr_recurse(nh_t parh,
+static bool_t
+tree_extattr_recurse(nh_t parh,
 				    nh_t cldh,
 				    bool_t (*cbfunc)(char *path,
 							 dah_t dah),
-- 
2.19.1
