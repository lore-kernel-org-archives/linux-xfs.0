Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793648195;
	b=ceLsUTbs0q44YComtS2uySMTmC8AxFeQk6fEFVDzjLe1C1WAXwpaeyT78elA3D4o456p
	 nsmVoBuEazPg096SV0WNmWc8+sedPwc1f+iuoYSmwueQX8k91vj9v4QnrHG0im4/W39Jj
	 XJoRZkjVlZDuxfh9f3VAmQmvR28GQY2kKexY0uvEDfaLk+E7fkfGg8p31Dcz2NwQ/lYMQ
	 8SlOHlcEbVhaDUKpAXrolQZf1goljrRQ8Z6ZL3hjK2eCAp8PyI49ZzhXczxTuV0cHvquz
	 ymcsHmdWRtqpj/jwztjoEpg5/ysXN+Ee5K9GP2L5pZ5XjVHhZVuVYim6LuelLIzPlsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793648195;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=LHO5wOnSm2HYmbFZRNJGwG5TsyiWk9ssZIFy4dlcutU=;
	b=crd1DBioX/BqevIi3svCkP+l9MHMm0/y1WG6+kw2gIVo1sXbmK8ZNgRuJDvLNr8sAKe+
	 I7ogReZ9488Xcu3TEHRmlop2Y6yf8dhW5bbXasi2POFFRPljvz6xn+G7fCi16PpJVqab3
	 79gTUElWYUPrb/hH4Xwu/N8WdCxsmzLB4A9RAkc8yssQvrQccfM4XXLtdyldw73lY4Yh/
	 dlAL73Y3gK3krLlVToorM5o7uut2knQS9/jYKolF3fXLVUpQ5bUXo7kFn3h6Gm+jI6HcY
	 bFgjMbLv3oKsr9tO5PfgVLyGxqut2z+xKjQwnESYOLSGe0yQiPqsoR4ssywC5NJ2dPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c3+MEL4t;
	arc=none smtp.remote-ip=209.85.208.174
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8CA606A326
	for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2026 19:36:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E8CA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c3+MEL4t
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3ab4891fc73so33805271fa.0
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2026 11:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793648193; x=1794252993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LHO5wOnSm2HYmbFZRNJGwG5TsyiWk9ssZIFy4dlcutU=;
        b=c3+MEL4t222p2owGgAbP6RpPSDoq160jtGP/jWpboKBbNRlYc0GNm3U/Ow9bLfn1Us
         /moaQMC97Po5Nhb04+PjkrWsjByhin8YlwoXLp7+pgtdOSbY/5W0fPZavJwy5W1R9ZHN
         ysuRyRr7gRSeoy8D1gLE6FKQF+38tZUK9ChWfo6GENsEtPF6KSI4JekRyouSkASi/74E
         y+Km4ZLoarviCCVBUuG7KOqhWOKgZSa1+aJyOjVsInxqM6bAwwG9qBUlEnfrJk+ddb8P
         joDDXBbzceB4e/dvQUpF9Acj8PY9L1A5RKRNIgwBqRd2Y+nhj16/oxpNcCoJQOrH/h79
         DT6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793648193; x=1794252993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LHO5wOnSm2HYmbFZRNJGwG5TsyiWk9ssZIFy4dlcutU=;
        b=fwiYGAQi7kE5PpgSTVRdVJ/QoLc9+ZPZmiMrVXZq85ZK9zw1xAM0XcLlsFDKuSR0mY
         NRcfeZLb+AjKG76tep9Q3CFXXUGDBWvQHju49rrIc9LAX183GFXZB1GrQVLGKUHgH7qu
         g95UL/HrzPDqEMNh9VESEWLb+kNzWjbNbwFdL9mJxRaCrSG2RjAqL4VQQKXfs3PVY2zo
         XfxEPrvjY/PlwX078X9rbkKkk4fZBmtEI1hKtIcF5Qb9eO5aTIJWhmj4S/OfrsFUKjrj
         VBHZ+Td3H/HE3lTbXlhPT6gFHvwp4xGIEPk8GslCiiY2YppxXO2QsLY17KJPrmEZI1eW
         bvkw==
X-Gm-Message-State: APuU4Z/PhDzh1XP5wwNf+7+9M9RMiabHTkr8t/8Qyh9GpVh1AGOhdrEk
	SL4HTXrCajr4jO3Kns0wbx833zhNPBTQ4H32ZfTT/cct2/YPx+I8TrDbjNY5xySGPJM=
X-Gm-Gg: AYBFou2EJGBBJA3icf07vhcTEh/A08N3LwjseLTTsTCpT2/LaGrqHAjIRgYn2JYEccS
	3bpEFGS8Qp7QylmA7zCO5gauOtjSq2DRHTQ7woibw7tBXz8eeCX5B1XYgA+x80FRBslIc/Bvhqp
	oOsCTZ7xMdf6JS0jR2kP7sdsghLDVEx2OxRiM21KdE9eSLMJtVA4gSAOLVwWTYB/o3OUdg6FJa6
	wJ79gkEnAD26Sq90Cl9HKy7VVJ7L7TQo9G1rF/VeSYlFkjadbpQC+H2uzk443uZyUVkNbxhidyB
	MnJlxam2224XRPTy531GiFipEIjy7Z3aE4CY3vpI4tuhbHlht27hWOAKtW3UvpdYJhFfQ15g/Yp
	mziXk/Zri//t+5rh3Yv3c4VA+nqNg9yG/juJqG8XURcWTek4UnArdg0vaCjvHYkOuAV6uqzFKmb
	QC0ImJieO5TvsisJOU8N7gaBnJsdE4ihsCtlHkIlEfbklk9CZJUBuMAzJvpB7PyyMJWAOgsvz2E
	aSnVj++sNTfDaCLv0ce6sH9T0p7CRpWAockfkb2qtbxS2lm5RBrCenuy9n29j/7NlCC47aco8jP
	UyduITSe0dJYsqml964eSEcMzxO2lM2mIYq5qRMmAfhGZzkaAinDD/3AJIibXLpeczAemaTJ07v
	0h2zxSLSgd4NqbAxjbRYUCfd3koXJtkTzuAJNSUZGYHk+daoE/MDrwmQuXqI=
X-Received: by 2002:a05:6512:1307:b0:5bf:cab4:e497 with SMTP id 2adb3069b0e04-5bfd95626acmr4072747e87.10.1793648193016;
        Mon, 02 Nov 2026 11:36:33 -0800 (PST)
Received: from Lauri-G-Pro-14-M4.intra.lakuz.com (n2vuxeh2n2qe1gcplsa-1.v6.elisa-laajakaista.fi. [2001:99a:2ab:bb00:cc57:81bf:b9a8:968a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe04edd72sm1794073e87.1.2026.11.02.11.36.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Nov 2026 11:36:32 -0800 (PST)
From: Lauri Gates <lauri.gates@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: Carlos Maiolino <cem@kernel.org>
Subject: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
Date: Mon,  2 Nov 2026 21:32:45 +0200
Message-ID: <20261102193533.93690-1-lauri.gates@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

FIEMAP on files with XFS_DIFLAG2_REFLINK set does not scale across
threads. For every written extent, xfs_read_iomap_begin() calls
xfs_reflink_trim_around_shared() (IOMAP_REPORT), which goes to
xfs_reflink_find_shared() and reads the AGF of the extent's AG with
xfs_alloc_read_agf(pag, NULL, 0, &agbp). Concurrent callers queue on
that buffer's b_sema. A parallel du-style scan of a reflinked tree
stops scaling at roughly the AG count, and threads working in the same
AG run slower than one thread alone.

My question, in more detail at the end: does reporting the shared flag
for FIEMAP need the AGF buffer locked?

I ran into this adding a shared-block mode to dust, a du clone, which
FIEMAPs every file and counts FIEMAP_EXTENT_SHARED extents once.
Inodes without the reflink flag return early and are unaffected.

Wait stack, kernel 7.0.0-1014-gcp: bpftrace counted the scanner's
sched:sched_switch events into TASK_UNINTERRUPTIBLE, keyed by kernel
stack, for about 6 seconds of repeated scans. 730,556 switches had this
stack; the next most common had 47:

  down+88
  xfs_buf_lock+50
  xfs_buf_find_lock+106
  xfs_buf_lookup.constprop.0+318
  xfs_buf_get_map+249
  xfs_buf_read_map+83
  xfs_trans_read_buf_map+313
  xfs_read_agf+183
  xfs_alloc_read_agf+91
  xfs_reflink_find_shared+154
  xfs_reflink_trim_around_shared+235
  xfs_read_iomap_begin+356
  iomap_iter+304
  iomap_fiemap+409
  xfs_vn_fiemap+92
  do_vfs_ioctl+758
  __x64_sys_ioctl+131

7.2 on arm64 shows the same chain. The functions involved are
unchanged in v7.4-rc1 and xfs for-next; since v7.3,
xfs_buf_read_map() calls xfs_buf_find_lock() directly, which takes the
same lock.

Reproducer
----------

fiemap-mt.c and run.sh are below. For each AG count, run.sh makes an
8 GiB loop image (mkfs.xfs -d agcount=N -m reflink=1) and writes
100,000 files of 4-32 KiB into each of plain/ and src/. It then makes
a reflink copy of src/ with cp -a --reflink=always. fiemap-mt lists
the files first, then times open + FS_IOC_FIEMAP + close of each one
from N threads; the figures are medians of 5 warm-cache runs. Order
"seq" hands concurrent threads neighbouring files in one directory, so
they share an AG; "shuffle" uses a fixed-seed random order, so they
mostly hit different AGs.

Wall time, with voluntary context switches in brackets, reflinked src/:

GCP n2-standard-8 (8 vCPUs, x86_64), Ubuntu 24.04, 7.0.0-1014-gcp:

  order    AGs  1 thread        4 threads           8 threads
  shuffle    4  313.6 ms (1)    153.6 ms (19,859)   209.5 ms (38,629)
  shuffle   32  308.7 ms (1)     96.8 ms (1,670)     78.7 ms (3,751)
  seq        4  272.7 ms (1)    587.5 ms (98,954)   922.1 ms (98,868)
  seq       32  268.8 ms (1)    621.4 ms (99,220)   892.3 ms (99,022)

On this machine, with threads spread over AGs, 8 threads take 2.7x as
long on 4 AGs as on 32. With threads in one AG, 8 threads take 3.3x
to 3.4x as long as one thread, whatever the AG count. bpftrace during
these runs shows the same frames and offsets as above, from down+88 to
xfs_read_iomap_begin+356, where its 20-frame capture ends.

Same run on an arm64 VM (7.2.12, 13 vCPUs):

  order    AGs  1 thread        4 threads           13 threads
  shuffle    4  190.8 ms (1)    184.6 ms (15,761)   237.1 ms (28,167)
  shuffle   32  194.7 ms (1)     69.7 ms (1,389)    120.9 ms (6,291)
  seq        4   95.0 ms (1)    745.0 ms (74,991)   144.4 ms (32,586)
  seq       32  100.9 ms (1)    859.2 ms (80,052)   160.7 ms (33,328)

Here seq is worst at 4 threads (7.8x one thread) and recovers somewhat
at 13. Times are not monotonic in thread count on either machine; I
have not looked into why.

On plain/ (never reflinked) no configuration on either machine
exceeds 10 voluntary context switches.

The original workload, for scale: dust scanning the Linux 6.12 source
tree (86,618 files) plus a reflink copy of it, on the same GCP machine
type, at dust's default thread count, mean of 10 runs:

  kernel  4 AGs     32 AGs    dust's normal mode, no FIEMAP (either)
  7.0     506.3 ms  274.8 ms  105-106 ms
  5.15    476.6 ms  277.7 ms  104-106 ms

On 7.0, voluntary context switches fell from 67,089 with 4 AGs to
4,230 with 32. With 4 AGs, dust -T 8 ran slower than -T 4 (513 vs
419 ms). On ext4 the FIEMAP pass added nothing measurable (59.5 vs
60.6 ms, tree without a copy); on btrfs it cost 3.3x but with 131-300
voluntary context switches, so no lock queueing.

Question
--------

Does reporting the shared flag for FIEMAP need the AGF buffer locked?
On this path the refcount btree lookup runs with tp == NULL, under the
inode lock from xfs_ilock_data_map_shared(), and the FIEMAP result is
a snapshot that can be stale by the time userspace reads it.

I am not suggesting dropping the flag. Commit 5f9268ca53ac ("xfs:
don't bother looking at the refcount tree for reads") kept
IOMAP_REPORT on the refcount lookup deliberately, and Dave described
the shared flag as a field diagnostic for reflinked files:
https://lore.kernel.org/all/20210124214346.GC4626@dread.disaster.area/

What I would like to know is whether an unlocked or cached lookup is
acceptable here, for example building on 2aedf844be1d ("xfs: move
buffer locking out of xfs_find_get_buf", in v7.3), which prepares
lookups that do not lock the buffer. If it is, I can test patches,
or try writing one with guidance.

Thanks,
Lauri Gates

---- fiemap-mt.c ----
// fiemap-mt: dust-free reproducer for XFS FIEMAP contention on reflinked files.
//
//   fiemap-mt populate DIR NFILES      create NFILES small files (4-32 KiB, deterministic
//                                      content) in subdirectories of 1000
//   fiemap-mt run DIR THREADS [ORDER]  list regular files under DIR, then open + FIEMAP
//                                      each one from THREADS threads; print wall time,
//                                      voluntary/involuntary context switches, and
//                                      extent counts
//
// ORDER is `seq` (default: directory order, so concurrent threads work on
// neighbouring files, which XFS keeps in the same AG) or `shuffle` (a fixed-seed
// random order, so concurrent threads usually hit different AGs, closer to a
// parallel tree walker like dust).
//
// The file list is built before timing starts, so the timed section is only
// open/FS_IOC_FIEMAP/close, the calls dust --shared-blocks makes per file.
#define _GNU_SOURCE
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/fiemap.h>
#include <linux/fs.h>
#include <pthread.h>
#include <stdatomic.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/resource.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

#define NEXT 64

static char **paths;
static size_t npaths, cap;
static atomic_size_t next_idx;
static atomic_long n_ext, n_shared_ext, n_shared_files, n_err;

static void die(const char *what) { perror(what); exit(1); }

static void add_path(const char *p) {
  if (npaths == cap) {
    cap = cap ? cap * 2 : 4096;
    paths = realloc(paths, cap * sizeof(*paths));
    if (!paths) die("realloc");
  }
  paths[npaths++] = strdup(p);
}

static void list_files(const char *dir) {
  DIR *d = opendir(dir);
  if (!d) die(dir);
  struct dirent *de;
  char p[4096];
  while ((de = readdir(d))) {
    if (!strcmp(de->d_name, ".") || !strcmp(de->d_name, "..")) continue;
    snprintf(p, sizeof(p), "%s/%s", dir, de->d_name);
    struct stat st;
    if (lstat(p, &st)) continue;
    if (S_ISDIR(st.st_mode)) list_files(p);
    else if (S_ISREG(st.st_mode) && st.st_blocks > 0) add_path(p);
  }
  closedir(d);
}

static void fiemap_file(const char *p) {
  int fd = open(p, O_RDONLY | O_NOFOLLOW | O_CLOEXEC | O_NOATIME);
  if (fd < 0) fd = open(p, O_RDONLY | O_NOFOLLOW | O_CLOEXEC);
  if (fd < 0) { atomic_fetch_add(&n_err, 1); return; }
  char buf[sizeof(struct fiemap) + NEXT * sizeof(struct fiemap_extent)];
  struct fiemap *fm = (struct fiemap *)buf;
  uint64_t start = 0;
  long ext = 0, shared = 0;
  for (;;) {
    memset(fm, 0, sizeof(*fm));
    fm->fm_start = start;
    fm->fm_length = FIEMAP_MAX_OFFSET - start;
    fm->fm_extent_count = NEXT;
    if (ioctl(fd, FS_IOC_FIEMAP, fm) < 0) { atomic_fetch_add(&n_err, 1); break; }
    if (fm->fm_mapped_extents == 0) break;
    int last = 0;
    for (unsigned i = 0; i < fm->fm_mapped_extents; i++) {
      struct fiemap_extent *e = &fm->fm_extents[i];
      ext++;
      if (e->fe_flags & FIEMAP_EXTENT_SHARED) shared++;
      if (e->fe_flags & FIEMAP_EXTENT_LAST) last = 1;
      start = e->fe_logical + e->fe_length;
    }
    if (last || fm->fm_mapped_extents < NEXT) break;
  }
  close(fd);
  atomic_fetch_add(&n_ext, ext);
  atomic_fetch_add(&n_shared_ext, shared);
  if (shared) atomic_fetch_add(&n_shared_files, 1);
}

static void *worker(void *arg) {
  (void)arg;
  for (;;) {
    size_t i = atomic_fetch_add(&next_idx, 1);
    if (i >= npaths) return NULL;
    fiemap_file(paths[i]);
  }
}

static double now_ms(void) {
  struct timespec t;
  clock_gettime(CLOCK_MONOTONIC, &t);
  return t.tv_sec * 1e3 + t.tv_nsec / 1e6;
}

static void shuffle_paths(void) {
  uint64_t x = 0x2545F4914F6CDD1Dull;
  for (size_t i = npaths; i > 1; i--) {
    x ^= x << 13; x ^= x >> 7; x ^= x << 17;
    size_t j = x % i;
    char *t = paths[i - 1]; paths[i - 1] = paths[j]; paths[j] = t;
  }
}

static int cmd_run(const char *dir, int threads, const char *order) {
  list_files(dir);
  if (!strcmp(order, "shuffle")) shuffle_paths();
  else if (strcmp(order, "seq")) { fprintf(stderr, "ORDER must be seq or shuffle\n"); return 2; }
  pthread_t *tids = calloc(threads, sizeof(*tids));
  struct rusage r0, r1;
  getrusage(RUSAGE_SELF, &r0);
  double t0 = now_ms();
  for (int i = 0; i < threads; i++)
    if (pthread_create(&tids[i], NULL, worker, NULL)) die("pthread_create");
  for (int i = 0; i < threads; i++) pthread_join(tids[i], NULL);
  double t1 = now_ms();
  getrusage(RUSAGE_SELF, &r1);
  double sys = (r1.ru_stime.tv_sec - r0.ru_stime.tv_sec) * 1e3 +
               (r1.ru_stime.tv_usec - r0.ru_stime.tv_usec) / 1e3;
  printf("order=%s threads=%d files=%zu extents=%ld shared_ext=%ld shared_files=%ld errors=%ld "
         "wall_ms=%.1f sys_ms=%.1f vcsw=%ld ivcsw=%ld\n",
         order, threads, npaths, atomic_load(&n_ext), atomic_load(&n_shared_ext),
         atomic_load(&n_shared_files), atomic_load(&n_err), t1 - t0, sys,
         r1.ru_nvcsw - r0.ru_nvcsw, r1.ru_nivcsw - r0.ru_nivcsw);
  return atomic_load(&n_err) ? 1 : 0;
}

static int cmd_populate(const char *dir, long n) {
  static unsigned char buf[32768];
  uint64_t x = 0x9E3779B97F4A7C15ull;
  char p[4096];
  for (long i = 0; i < n; i++) {
    if (i % 1000 == 0) {
      snprintf(p, sizeof(p), "%s/d%04ld", dir, i / 1000);
      if (mkdir(p, 0755) && errno != EEXIST) die(p);
    }
    x ^= x << 13; x ^= x >> 7; x ^= x << 17;
    size_t len = 4096 * (1 + x % 8);  // 4-32 KiB
    for (size_t j = 0; j < len; j += 8) {
      x ^= x << 13; x ^= x >> 7; x ^= x << 17;
      memcpy(buf + j, &x, 8);
    }
    snprintf(p, sizeof(p), "%s/d%04ld/f%07ld", dir, i / 1000, i);
    int fd = open(p, O_WRONLY | O_CREAT | O_TRUNC | O_CLOEXEC, 0644);
    if (fd < 0) die(p);
    if (write(fd, buf, len) != (ssize_t)len) die("write");
    close(fd);
  }
  return 0;
}

int main(int argc, char **argv) {
  if (argc == 4 && !strcmp(argv[1], "populate")) return cmd_populate(argv[2], atol(argv[3]));
  if ((argc == 4 || argc == 5) && !strcmp(argv[1], "run"))
    return cmd_run(argv[2], atoi(argv[3]), argc == 5 ? argv[4] : "seq");
  fprintf(stderr, "usage: %s populate DIR NFILES | run DIR THREADS [seq|shuffle]\n", argv[0]);
  return 2;
}

---- run.sh ----
#!/usr/bin/env bash
# Dust-free reproducer for XFS FIEMAP contention on reflinked files.
# Run as root on any Linux host with xfsprogs, gcc and loop-device support
# (OrbStack machine, GCP VM, bare metal). Builds an XFS image per AG count,
# fills it with a never-reflinked tree and a tree that has a reflink copy, and
# times multithreaded open+FIEMAP over each.
#
#   sudo repro/run.sh                      # defaults below
#   sudo NFILES=50000 RUNS=3 AGCOUNTS="4 32" THREADS="1 4 8" ORDERS=shuffle repro/run.sh
set -euo pipefail

NFILES=${NFILES:-100000}
RUNS=${RUNS:-5}
AGCOUNTS=${AGCOUNTS:-"4 32"}
THREADS=${THREADS:-$(printf '%s\n' 1 4 8 "$(nproc)" | sort -nu | tr '\n' ' ')}
ORDERS=${ORDERS:-"seq shuffle"}
WORK=${WORK:-/var/tmp/xfs-fiemap-repro}
HERE=$(cd "$(dirname "$0")" && pwd)

[ "$(id -u)" = 0 ] || { echo "run as root" >&2; exit 1; }
mkdir -p "$WORK/mnt"
gcc -O2 -pthread -o "$WORK/fiemap-mt" "$HERE/fiemap-mt.c"
BIN=$WORK/fiemap-mt

cleanup() { mountpoint -q "$WORK/mnt" && umount "$WORK/mnt"; rm -f "$WORK/xfs.img"; }
trap cleanup EXIT

echo "kernel=$(uname -r) arch=$(uname -m) nproc=$(nproc) $(mkfs.xfs -V) nfiles=$NFILES runs=$RUNS"

# Median of RUNS runs by wall_ms; prints the whole median line.
median_run() {
  local dir=$1 t=$2 order=$3
  for _ in $(seq "$RUNS"); do "$BIN" run "$dir" "$t" "$order"; done |
    awk '{for (i = 1; i <= NF; i++) if ($i ~ /^wall_ms=/) {split($i, a, "="); print a[2], $0}}' |
    sort -n | awk -v m=$(( (RUNS + 1) / 2 )) 'NR == m {$1 = ""; sub(/^ /, ""); print}'
}

for ag in $AGCOUNTS; do
  cleanup
  truncate -s 8G "$WORK/xfs.img"
  mkfs.xfs -q -f -d agcount="$ag" -m reflink=1 "$WORK/xfs.img"
  mount -o loop "$WORK/xfs.img" "$WORK/mnt"
  echo "=== $(xfs_info "$WORK/mnt" | grep -o 'agcount=[0-9]*'), $(xfs_info "$WORK/mnt" | grep -o 'reflink=[0-9]')"
  M=$WORK/mnt
  mkdir "$M/plain" "$M/src"
  "$BIN" populate "$M/plain" "$NFILES"
  "$BIN" populate "$M/src" "$NFILES"
  sync
  cp -a --reflink=always "$M/src" "$M/copy"
  sync
  for tree in plain src; do
    "$BIN" run "$M/$tree" "$(nproc)" >/dev/null   # warm the inode, extent and buffer caches
    for order in $ORDERS; do
      for t in $THREADS; do
        echo "ag=$ag tree=$tree $(median_run "$M/$tree" "$t" "$order")"
      done
    done
  done
done
