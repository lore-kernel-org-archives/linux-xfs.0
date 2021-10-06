Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC1C1C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Oct 2021 18:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A44626103E
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Oct 2021 18:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbhJFSLz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Oct 2021 14:11:55 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57986 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhJFSLz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Oct 2021 14:11:55 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3C5EC22589;
        Wed,  6 Oct 2021 18:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1633543802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6ylpJsAAmJfBL2teO8PmC7DD+y+Rcc17U9eU6uVcmOw=;
        b=eFtRp4TnNV/vCYVBGH+utpc4sEWlMYOUKoTJGrOuHVyqiT/HAVKOZtT3y8BaEMHahZw0Si
        XMxfIpJsMi2KigSqPIcza8wF+H7PK25VH2v2AfACcJyk2bZbWVLtMSH/nTsxeDjpFgpFEW
        H1gVl63lbCrv3TTtafdayZd1I85ARcI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1633543802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6ylpJsAAmJfBL2teO8PmC7DD+y+Rcc17U9eU6uVcmOw=;
        b=NaG6wJpRH5CKHM1WZ49raGJWPeXIUpF0sCiFD07FxXeK/I+kMTYvFlQW1C7n8Y81Lvl7KP
        Wemqsh5oxeBwWeCw==
Received: from quack2.suse.cz (unknown [10.163.28.18])
        by relay2.suse.de (Postfix) with ESMTP id 0E82FA3B84;
        Wed,  6 Oct 2021 18:10:02 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 581231F2C8F; Wed,  6 Oct 2021 20:10:01 +0200 (CEST)
Date:   Wed, 6 Oct 2021 20:10:01 +0200
From:   Jan Kara <jack@suse.cz>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Jan Kara <jack@suse.cz>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: Performance regression with async inode inactivation
Message-ID: <20211006181001.GA4182@quack2.suse.cz>
References: <20211004100653.GD2255@quack2.suse.cz>
 <20211004211508.GB54211@dread.disaster.area>
 <20211005081157.GA24625@quack2.suse.cz>
 <20211005212608.GC54211@dread.disaster.area>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20211005212608.GC54211@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 06-10-21 08:26:08, Dave Chinner wrote:
> On Tue, Oct 05, 2021 at 10:11:57AM +0200, Jan Kara wrote:
> > On Tue 05-10-21 08:15:08, Dave Chinner wrote:
> > > On Mon, Oct 04, 2021 at 12:06:53PM +0200, Jan Kara wrote:
> > > > Hello,
> > > > 
> > > > our performance testing grid has detected a performance regression caused
> > > > by commit ab23a77687 ("xfs: per-cpu deferred inode inactivation queues")
> > > > with reaim benchmark running 'disk' and 'disk-large' workloads. The
> > > > regression has been so far detected on two machines - marvin7 (48 cpus, 64
> > > > GB ram, SATA SSD), dobby (64 cpus, 192 GB ram, rotating disk behind
> > > > megaraid_sas controller).
> > > 
> > > Yup, large cpu count, single slow disk, and the cause will likely be
> > > exclusive rwsem lock contention on a directory inode that concurrent
> > > openat and unlink are occuring in.
> > > 
> > > Basically, that commit removed a bunch of userspace overhead in
> > > unlinks, when mean they run as fast as the unlink() call can remove
> > > the directory entry. There is effectively nothing throttling
> > > unlink() in XFS now except for available log space and it mostly
> > > runs to completion without blocking. Hence the front end unlink
> > > performance can run in much faster bursts before delayed
> > > inactivation needs to run.
> > > 
> > > Given most of the added CPU overhead is in the rwsem spin_on_owner
> > > path, it implies that the write lock holder is, indeed, not sleeping
> > > with the lock held. Hence reaim is hitting a borderline contended
> > > rwsem much harder and with different behaviour, resulting in
> > > catastrophic breakdown of lock performance and hence unlink
> > > performance goes backwards.
> > > 
> > > I can't see any other new sleeping lock contention in the workload
> > > profiles - the context switch rate goes down substantially (by 35%!)
> > > with commit ab23a77687, which also implies that the lock contention
> > > is resulting in much longer spin and/or sleep times on the lock.
> > > 
> > > I'm not sure we can do anything about this in the filesystem. The
> > > contended lock is a core, high level VFS lock which is the first
> > > point of unlinkat() syscall serialisation. This is the lock that is
> > > directly exposed to userspace concurrency, so the scalability of
> > > this lock determines concurrency performance of the userspace
> > > application.....
> > 
> > Thanks for explanation! It makes sense, except one difference I can see in
> > vmstat on both marvin7 and dobby which I don't understand:
> > 
> > Dobby:
> > Ops Sector Reads                     1009081.00     1009081.00
> > Ops Sector Writes                   11550795.00    18753764.00
> > 
> > Marvin7:
> > Ops Sector Reads                      887951.00      887951.00
> > Ops Sector Writes                    8248822.00    11135086.00
> > 
> > So after the change reaim ends up doing noticeably more writes. I had a
> > look at iostat comparison as well but there wasn't anything particular
> > standing out besides higher amount of writes on the test disk. I guess,
> > I'll limit the number of clients to a single number showing the regression,
> > enable some more detailed monitoring and see whether something interesting
> > pops up.
> 
> Interesting.
> 
> There weren't iostats in the original intel profiles given. I
> can see a couple of vmstats that give some indications -
> vmstat.io.bo went up from ~2500 to ~6000, and proc-vmstat.pgpgout
> went up from ~90k to 250k.
> 
> Looking at another more recent profile, there are more IO related
> stats in the output vmstat.nr_written went up by 2.5x and
> vmstat.pgpgout went up by a factor of 6 (50k -> 300k) but otherwise
> everything else was fairly constant in the VM. The resident size of
> the file cache is small, and vmstat.nr_dirtied went up by a small
> ammount by it's 4 orders of magnitude larger than nr_written.
> 
> Hmmm. That implies a *lot* of overwrite of cached files.
> 
> I wonder if we've just changed the memory pressure enough to trigger
> more frequent writeback? We're delaying the inactivation (and hence
> page cache invalidation) of up to 256 inodes per CPU, and the number
> of cached+dirty inodes appears to have increased a small amount
> (from ~3000 to ~4000). With slow disks, a small change in writeback
> behaviour could cause seek-bound related performance regressions.
> 
> Also worth noting is that there's been some recent variance in reaim
> numbers recently because of the journal FUA/flush optimisations
> we've made.  Some machines report +20% from that change, some report
> -20%, and there's no pattern to it. It's just another indication
> that the reaim scalability and perf on these large CPU count, single
> spinning disk setups is highly dependent on disk performance and
> seek optimisation...
> 
> Have you run any tests on a system that isn't stupidly overpowered
> for it's disk subsystem? e.g. has an SSD rather than spinning rust?

So marvin7 actually has SSD. I was experimenting some more. Attached is a
simple reproducer that demonstrates the issue for me - it just creates 16k
file, fsync it, delete it in a loop from given number processes (I run with
48). The reproducer runs ~25% slower after the commit ab23a77687. Note that
the reproducer makes each process use a different directory so i_rwsem
contention is out of question.

From blktrace I can see that indeed after the commit we do ~25% more
writes.  Each stress-unlink process does the same amount of IO, the extra
IO comes solely from the worker threads. Also I'd note that before the
commit we were reusing blocks much more (likely inode blocks getting
reused) - before the commit we write to ~88 MB worth of distinct disk
blocks, after the commit we write to ~296 MB worth of distinct disk blocks.
That's understandable given the delayed inode freeing but it's one thing
that could possibly have effect.  That's how far I've come today, I'll dig
more tomorrow.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--XsQoSWH+UP9D9v3l
Content-Type: text/x-c; charset=us-ascii
Content-Disposition: attachment; filename="stress-unlink.c"

#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/time.h>

#define COUNT 100
#define SIZE 16384
#define MAX_PROCS 1024

char shm_name[64];
char wbuf[SIZE];

void prepare(char *base, int num)
{
	char dir[128];

	sprintf(dir, "%s/dir-%d", base, num);
	if (mkdir(dir, 0700) < 0 && errno != EEXIST) {
		perror("mkdir");
		exit(1);
	}
}

void teardown(char *base, int num)
{
	char dir[128];

	sprintf(dir, "%s/dir-%d", base, num);
	rmdir(dir);
}

void run_test(char *base, int num)
{
	char name[128];
	int shmfd;
	int i;
	int *shm;
	int fd;

	sprintf(name, "%s/dir-%d/file", base, num);
	shmfd = shm_open(shm_name, O_RDWR, 0);
	if (shmfd < 0) {
		perror("shm_open");
		exit(1);
	}
	shm = mmap(NULL, sizeof(int) * MAX_PROCS, PROT_READ | PROT_WRITE,
		   MAP_SHARED, shmfd, 0);
	if (shm == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}
	shm[num + 1] = 1;
	while (shm[0] == 0)
		usleep(1);

	for (i = 0; i < COUNT; i++) {
		fd = open(name, O_CREAT | O_WRONLY, 0644);
		if (fd < 0) {
			perror("open");
			exit(1);
		}
		if (write(fd, wbuf, SIZE) != SIZE) {
			perror("pwrite");
			exit(1);
		}
		fsync(fd);
		close(fd);
		unlink(name);
	}
}

int main(int argc, char **argv)
{
	int procs, i, j;
	pid_t pids[MAX_PROCS];
	int shmfd;
	int *shm;
	struct timeval start, end;
	long long ms;

	if (argc != 3) {
		fprintf(stderr, "Usage: stress-unlink <processes> <dir>\n");
		return 1;
	}
	procs = strtol(argv[1], NULL, 10);
	if (procs > MAX_PROCS) {
		fprintf(stderr, "Too many processes!\n");
		return 1;
	}

	memset(wbuf, 0xcc, SIZE);
	sprintf(shm_name, "/stress-unlink-%u", getpid());
	shmfd = shm_open(shm_name, O_CREAT | O_RDWR, 0600);
	if (shmfd < 0) {
		perror("shm_open");
		return 1;
	}
	if (ftruncate(shmfd, sizeof(int) * MAX_PROCS) < 0) {
		perror("ftruncate shm");
		return 1;
	}
	shm = mmap(NULL, sizeof(int) * MAX_PROCS, PROT_READ | PROT_WRITE,
		   MAP_SHARED, shmfd, 0);
	if (shm == MAP_FAILED) {
		perror("mmap");
		return 1;
	}
	
	shm[0] = 0;
	for (i = 0; i < procs; i++) {
		shm[i+1] = 0;
		prepare(argv[2], i);
	}

	for (i = 0; i < procs; i++) {
		pids[i] = fork();
		if (pids[i] < 0) {
			perror("fork");
			for (j = 0; j < i; j++)
				kill(pids[j], SIGKILL);
			return 1;
		}
		if (pids[i] == 0) {
			run_test(argv[2], i);
			exit(0);
		}
	}

	do {
		for (i = 0; i < procs && shm[i + 1]; i++);
	} while (i != procs);
	gettimeofday(&start, NULL);
	shm[0] = 1;
	fprintf(stderr, "Processes started.\n");

	for (i = 0; i < procs; i++)
		waitpid(pids[i], NULL, 0);
	gettimeofday(&end, NULL);
	for (i = 0; i < procs; i++)
		teardown(argv[2], i);
	shm_unlink(shm_name);
	ms = (((long long)(end.tv_sec - start.tv_sec) * 1000000) +
		(end.tv_usec - start.tv_usec)) / 1000;
	printf("%lld.%03lld\n", ms/1000, ms%1000);
	
	return 0;
}

--XsQoSWH+UP9D9v3l--
