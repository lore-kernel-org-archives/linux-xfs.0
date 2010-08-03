Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o73MUNTs259244 for <xfs@oss.sgi.com>; Tue, 3 Aug 2010 17:30:23 -0500
Received: from mail-vw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91D0511C8C68
	for <xfs@oss.sgi.com>; Tue,  3 Aug 2010 15:38:37 -0700 (PDT)
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id joksoM09ZZvtUTQW
	for <xfs@oss.sgi.com>; Tue, 03 Aug 2010 15:38:37 -0700 (PDT)
Received: by vws15 with SMTP id 15so3511359vws.26
	for <xfs@oss.sgi.com>; Tue, 03 Aug 2010 15:30:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100718235036.GC32635@dastard>
References: <AANLkTilX3l8TbUztLStj_u9OqOZnBrsNQxmeV4DuBmYJ@mail.gmail.com>
	<20100718012033.GA18888@dastard>
	<AANLkTikEv75KRyRTs4awmG894NSKMnBkJNJPYsypMdWf@mail.gmail.com>
	<20100718235036.GC32635@dastard>
Date: Tue, 3 Aug 2010 18:30:36 -0400
Message-ID: <AANLkTi=EzePfBRdEFQo2BRtKy=464Ci6zPG=UyYJiwNp@mail.gmail.com>
Subject: Re: XFS hung on 2.6.33.3 kernel
From: Ilia Mirkin <imirkin@alum.mit.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Jul 18, 2010 at 7:50 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sat, Jul 17, 2010 at 09:35:33PM -0400, Ilia Mirkin wrote:
>> On Sat, Jul 17, 2010 at 9:20 PM, Dave Chinner <david@fromorbit.com> wrot=
e:
>> > On Sat, Jul 17, 2010 at 12:01:11AM -0400, Ilia Mirkin wrote:
>> > I can't find a thread that holds the XFS inode lock that everything
>> > is waiting on. I think it is the ILOCK, but none of the threads in
>> > this trace should be holding it where they are blocked. IOWs, the
>> > output does not give me enough information to get to the root cause.
>>
>> In case this happens again, was there something more useful I could
>> have collected? Should I have grabbed all task states?
>
> All the task states, including the running tasks, is probably a good
> start. Also, if the kernel you are running has tracing events
> enabled and has the necessary XFS tracepoints (I can't remember off
> the top of my head whether they are in 2.6.33), you might want to
> enable tracing of:
>
> =A0 =A0 =A0 =A0xfs_ilock
> =A0 =A0 =A0 =A0xfs_ilock_nowait
> =A0 =A0 =A0 =A0xfs_ilock_demote
> =A0 =A0 =A0 =A0xfs_iunlock
>
> via:
>
> # echo 1 > /sys/kernel/debug/tracing/events/xfs/<trace_point>/enable
>
> and when the problem is hit dumping the trace via:
>
> # cat /sys/kernel/debug/tracing/trace > trace.log
>
> You may also want to bump up the trace buffer size to capture more
> events:
>
> # echo 32768 > /sys/kernel/debug/tracing/buffer_size_kb

Sad. Nothing in /sys/kernel/debug, I tried turning on some config
options at random before doing this run (including lockdep), but I
still don't have these. Guess it's time to read some docs :)

>
> Though I suspect the only way to get to the bottom of it will
> be to work out a reproducable test case....

I felt a little bothered by this issue, so I dug in a little further.
I basically created a sample mysql, tar, and it seemed that having
memory pressure helped, so I created an allocator as well.

The "mysql" program basically just has 10 threads, each with their own
O_DIRECT-opened fd, reading/writing to random locations in a large
file.

The "tar" program opens the file, reads it in sequentially with plain read(=
).

The "malloc" program allocates a configured amount of memory in the
system and then exits. Ideally this should be the amount of RAM in the
system.

I ran all this in a VM (kvm) with 4 VCPUs (the machine itself is 4S,
8C/S), 512M ram, 512M swap, and a dedicated lvm-backed volume for the
test XFS partition (3G). The warnings were no problem to trigger,
coming off at around one per second on average, the hang took about
4-5h to appear [although in the previous 8+ hour run, nothing
happened, and then I added lockdep].

Basically I was running in three separate shells:

./test-mysqld /mnt/tmp/test
./test-tar /mnt/tmp/test
while true; do ./test-malloc; done

(oh, and /mnt/tmp/test is a 3G file on a newish XFS; the fs was
created/used in prior boots as well, so not completely brand new)

test-tar ended up eventually stuck in a D state, as well as one of the
mysql threads. I could still create/delete files on the filesystem
(although I didn't try writing anything substantial).

The system is still up and running in this state, let me know if you'd
like me to try doing something in particular to it.

Below I have the program source code, as well as output from echo t >
/proc/sysrq-trigger.

The programs [this is not the cleanest code I've written, but it
apparently does the trick... probably left over unnecessary stuff from
earlier debugging in there]:

test-malloc.c
-------------
// gcc -Wall -o test-malloc -pthread test-malloc.c

#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define BLKSIZE 4096

int main(int argc, char *argv[]) {
    int i;
    for (i =3D 0; i < 512 * 1024 * 1024 / BLKSIZE; i++) {
        void *x =3D malloc(BLKSIZE);
        memset(x, 0, BLKSIZE);
        usleep(1);
    }
    return 0;
}

-------------
test-mysqld.c
-------------
// gcc -Wall -o test-mysqld -pthread test-mysqld.c

#define _GNU_SOURCE

#include <pthread.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>

#define THREADS 10
#define BLKSIZE 4096

void *thread(void *arg) {
    struct stat s;
    int fd =3D *(int *)arg;
    fstat(fd, &s);

    struct random_data rnd;
    char state[128];
    initstate_r(fd, state, 128, &rnd);

    char *buf =3D mmap(NULL, BLKSIZE, PROT_READ | PROT_WRITE, MAP_SHARED
| MAP_ANONYMOUS, -1, 0);

    int t;

    while (1) {
        random_r(&rnd, &t);
        off_t block =3D (t % s.st_size) / BLKSIZE;
        lseek(fd, block * BLKSIZE, SEEK_SET);
        random_r(&rnd, &t);
        int r =3D t % 2;
        if (r) {
            read(fd, buf, BLKSIZE);
        } else {
            int i;
            for (i =3D 0; i < BLKSIZE; i++) {
                random_r(&rnd, &t);
                buf[i] =3D (char)t;
            }
            write(fd, buf, BLKSIZE);
        }
    }

    close(fd);
    return NULL;
}

void *datasync(void *arg) {
    int *iarg =3D arg;
    int i;
    while (1) {
        for (i =3D 0; i < THREADS; i++) {
            fsync(iarg[i]);
        }
        sleep(1);
    }
}

int main(int argc, char *argv[]) {
    pthread_t threads[THREADS];
    int fds[THREADS];
    int i;
    for (i =3D 0; i < THREADS; i++) {
        fds[i] =3D open(argv[1], O_RDWR | O_DIRECT);
        pthread_create(&threads[i], NULL, thread, &fds[i]);
    }

    pthread_t sync_thread;
    pthread_create(&sync_thread, NULL, datasync, fds);

    for (i =3D 0; i < THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    return 0;
}


-------------
test-tar.c
-------------
// gcc -Wall -o test-tar -pthread test-tar.c

#define _GNU_SOURCE

#include <pthread.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <errno.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
    while (1) {
        int fd =3D open(argv[1], O_RDWR);
        char buf[4096];

        lseek(fd, 0, SEEK_SET);
        while (read(fd, buf, 4096) !=3D 0);

        close(fd);
    }
}

-------------------

The output of echo t > /proc/sysrq-trigger [apologies for line-wrapping]

[16087.359042] SysRq : Show State
[16087.359872]   task                        PC stack   pid father
[16087.359872] init          S 0000000000000000  3296     1      0 0x000000=
00
[16087.359872]  ffff88001f8ff908 0000000000000046 ffff88001f8ff868
0000000000000286
[16087.359872]  0000000000000040 000000000000def8 ffff88001f8fffd8
0000000000014180
[16087.359872]  ffff88001f8fffd8 0000000000014180 ffff88001f910000
ffff88001fa542c0
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff8148f948>] schedule_hrtimeout_range+0xc2/0xf7
[16087.359872]  [<ffffffff8105a9e0>] ? hrtimer_wakeup+0x0/0x21
[16087.359872]  [<ffffffff8105b4eb>] ? hrtimer_start_range_ns+0xf/0x11
[16087.359872]  [<ffffffff810f8b92>] poll_schedule_timeout+0x46/0x69
[16087.359872]  [<ffffffff810f985a>] do_select+0x5c1/0x605
[16087.359872]  [<ffffffff810f9299>] ? do_select+0x0/0x605
[16087.359872]  [<ffffffff81066948>] ? register_lock_class+0x20/0x327
[16087.359872]  [<ffffffff810f9d51>] ? __pollwait+0x0/0xcf
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff810698a9>] ? lock_release_non_nested+0x97/0x20d
[16087.359872]  [<ffffffff810c885b>] ? might_fault+0x57/0xa4
[16087.359872]  [<ffffffff810c885b>] ? might_fault+0x57/0xa4
[16087.359872]  [<ffffffff810c88a4>] ? might_fault+0xa0/0xa4
[16087.359872]  [<ffffffff810c885b>] ? might_fault+0x57/0xa4
[16087.359872]  [<ffffffff810f9a57>] core_sys_select+0x1b9/0x255
[16087.359872]  [<ffffffff810f98df>] ? core_sys_select+0x41/0x255
[16087.359872]  [<ffffffff810698a9>] ? lock_release_non_nested+0x97/0x20d
[16087.359872]  [<ffffffff810c88a4>] ? might_fault+0xa0/0xa4
[16087.359872]  [<ffffffff810c885b>] ? might_fault+0x57/0xa4
[16087.359872]  [<ffffffff810c885b>] ? might_fault+0x57/0xa4
[16087.359872]  [<ffffffff81060016>] ? ktime_get_ts+0xb1/0xbe
[16087.359872]  [<ffffffff810f9d29>] sys_select+0x94/0xbc
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] kthreadd      S 0000000000000000  4096     2      0 0x000000=
00
[16087.359872]  ffff88001f91df00 0000000000000046 0000000000000000
ffff88001f91decc
[16087.359872]  0000000000000000 000000000000def8 ffff88001f91dfd8
0000000000014180
[16087.359872]  ffff88001f91dfd8 0000000000014180 ffff88001f9110b0
ffff88001f152160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff810578cd>] kthreadd+0x83/0x109
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff8105784a>] ? kthreadd+0x0/0x109
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] migration/0   S 0000000000000000  6496     3      2 0x000000=
00
[16087.359872]  ffff88001f91fe50 0000000000000046 0000000000000000
ffffffff81039a5e
[16087.359872]  ffff880000000000 000000000000def8 ffff88001f91ffd8
0000000000014180
[16087.359872]  ffff88001f91ffd8 0000000000014180 ffff88001f912160
ffff88001f0b5370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81039a5e>] ? migration_thread+0x76/0x297
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff81039b84>] migration_thread+0x19c/0x297
[16087.359872]  [<ffffffff810399e8>] ? migration_thread+0x0/0x297
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] ksoftirqd/0   S 0000000000000000  6600     4      2 0x000000=
00
[16087.359872]  ffff88001f931e80 0000000000000046 ffffffff8104ad59
0000000000000000
[16087.359872]  ffff88001f930000 000000000000def8 ffff88001f931fd8
0000000000014180
[16087.359872]  ffff88001f931fd8 0000000000014180 ffff88001f913210
ffff88001e622160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff8104ad59>] ? run_timer_softirq+0x28a/0x2d3
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff810430b4>] run_ksoftirqd+0x52/0x121
[16087.359872]  [<ffffffff81043062>] ? run_ksoftirqd+0x0/0x121
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] migration/1   S 0000000000000001  6552     5      2 0x000000=
00
[16087.359872]  ffff88001f933e50 0000000000000046 0000000000000000
ffffffff81039a5e
[16087.359872]  ffff880000000000 000000000000def8 ffff88001f933fd8
0000000000014180
[16087.359872]  ffff88001f933fd8 0000000000014180 ffff88001f9142c0
ffff88001f980000
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81039a5e>] ? migration_thread+0x76/0x297
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff81039b84>] migration_thread+0x19c/0x297
[16087.359872]  [<ffffffff810399e8>] ? migration_thread+0x0/0x297
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] ksoftirqd/1   S 0000000000000000  6600     6      2 0x000000=
00
[16087.359872]  ffff88001f939e80 0000000000000046 0000000000000000
0000000000000000
[16087.359872]  ffff88001f938000 000000000000def8 ffff88001f939fd8
0000000000014180
[16087.359872]  ffff88001f939fd8 0000000000014180 ffff88001f915370
ffff88001dcb5370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff810430b4>] run_ksoftirqd+0x52/0x121
[16087.359872]  [<ffffffff81043062>] ? run_ksoftirqd+0x0/0x121
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] migration/2   S 0000000000000002  6552     7      2 0x000000=
00
[16087.359872]  ffff88001f95be50 0000000000000046 0000000000000000
ffffffff81039a5e
[16087.359872]  ffff880000000000 000000000000def8 ffff88001f95bfd8
0000000000014180
[16087.359872]  ffff88001f95bfd8 0000000000014180 ffff88001f960000
ffff88001f152160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81039a5e>] ? migration_thread+0x76/0x297
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff81039b84>] migration_thread+0x19c/0x297
[16087.359872]  [<ffffffff810399e8>] ? migration_thread+0x0/0x297
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] ksoftirqd/2   S 0000000000000000  6600     8      2 0x000000=
00
[16087.359872]  ffff88001f969e80 0000000000000046 ffffffff814903d9
ffff88001e7f9ea8
[16087.359872]  ffff880002714b40 000000000000def8 ffff88001f969fd8
0000000000014180
[16087.359872]  ffff88001f969fd8 0000000000014180 ffff88001f9610b0
ffff88001fa542c0
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff814903d9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff810430b4>] run_ksoftirqd+0x52/0x121
[16087.359872]  [<ffffffff81043062>] ? run_ksoftirqd+0x0/0x121
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] migration/3   S 0000000000000003  6552     9      2 0x000000=
00
[16087.359872]  ffff88001f96de50 0000000000000046 0000000000000000
0000000000000046
[16087.359872]  0000000000000000 000000000000def8 ffff88001f96dfd8
0000000000014180
[16087.359872]  ffff88001f96dfd8 0000000000014180 ffff88001f963210
ffff88001f965370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff81039b84>] migration_thread+0x19c/0x297
[16087.359872]  [<ffffffff810399e8>] ? migration_thread+0x0/0x297
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] ksoftirqd/3   S 0000000000000000  6600    10      2 0x000000=
00
[16087.359872]  ffff88001f96fe80 0000000000000046 0000000000000000
0000000000000000
[16087.359872]  ffff88001f96e000 000000000000def8 ffff88001f96ffd8
0000000000014180
[16087.359872]  ffff88001f96ffd8 0000000000014180 ffff88001f9642c0
ffff88001e622160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff810430b4>] run_ksoftirqd+0x52/0x121
[16087.359872]  [<ffffffff81043062>] ? run_ksoftirqd+0x0/0x121
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] events/0      S ffff88001f966420  6152    11      2 0x000000=
00
[16087.359872]  ffff88001f977dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f966420 000000000000def8 ffff88001f977fd8
0000000000014180
[16087.359872]  ffff88001f977fd8 0000000000014180 ffff88001f966420
ffff88001f0b5370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff810c6802>] ? vmstat_update+0x0/0x3a
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] events/1      S ffff88001f980000  5776    12      2 0x000000=
00
[16087.359872]  ffff88001f989dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f980000 000000000000def8 ffff88001f989fd8
0000000000014180
[16087.359872]  ffff88001f989fd8 0000000000014180 ffff88001f980000
ffff88001dcb5370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff810c6802>] ? vmstat_update+0x0/0x3a
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] events/2      S ffff88001f9810b0  5704    13      2 0x000000=
00
[16087.359872]  ffff88001f98bdc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f9810b0 000000000000def8 ffff88001f98bfd8
0000000000014180
[16087.359872]  ffff88001f98bfd8 0000000000014180 ffff88001f9810b0
ffff88001f152160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff812acbd4>] ? flush_to_ldisc+0x0/0x1a0
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] events/3      S ffff88001f982160  5328    14      2 0x000000=
00
[16087.359872]  ffff88001f98ddc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f982160 000000000000def8 ffff88001f98dfd8
0000000000014180
[16087.359872]  ffff88001f98dfd8 0000000000014180 ffff88001f982160
ffff88001f965370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff813ab4ea>] ? neigh_periodic_work+0x0/0x185
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] cpuset        S 0000000000000000  6712    15      2 0x000000=
00
[16087.359872]  ffff88001f98fdc0 0000000000000046 ffff88001f98fd90
ffff88001f98fd8c
[16087.359872]  ffff88001f983210 000000000000def8 ffff88001f98ffd8
0000000000014180
[16087.359872]  ffff88001f98ffd8 0000000000014180 ffff88001f983210
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] khelper       S ffff88001f9842c0  5232    16      2 0x000000=
00
[16087.359872]  ffff88001f999dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f9842c0 000000000000def8 ffff88001f999fd8
0000000000014180
[16087.359872]  ffff88001f999fd8 0000000000014180 ffff88001f9842c0
ffff88001f962160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff81052790>] ? __call_usermodehelper+0x0/0x6c
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] netns         S 0000000000000000  6816    19      2 0x000000=
00
[16087.359872]  ffff88001fa35dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f985370 000000000000def8 ffff88001fa35fd8
0000000000014180
[16087.359872]  ffff88001fa35fd8 0000000000014180 ffff88001f985370
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] async/mgr     S 0000000000000000  6152    22      2 0x000000=
00
[16087.359872]  ffff88001fa3de60 0000000000000046 ffff880002714180
0000000000000001
[16087.359872]  ffff88001fa3ddd0 000000000000def8 ffff88001fa3dfd8
0000000000014180
[16087.359872]  ffff88001fa3dfd8 0000000000014180 ffff88001f986420
ffff88001f9842c0
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81039436>] ? try_to_wake_up+0x2d5/0x2e7
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff8105d934>] ? async_manager_thread+0x0/0xe8
[16087.359872]  [<ffffffff8105d9f2>] async_manager_thread+0xbe/0xe8
[16087.359872]  [<ffffffff81039448>] ? default_wake_function+0x0/0xf
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] sync_supers   S 0000000000000000  6616   155      2 0x000000=
00
[16087.359872]  ffff88001fa41e90 0000000000000046 ffff88001fa50000
0000000000000000
[16087.359872]  0000000000000002 000000000000def8 ffff88001fa41fd8
0000000000014180
[16087.359872]  ffff88001fa41fd8 0000000000014180 ffff88001fa50000
ffff88001f966420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff810c6c16>] ? bdi_sync_supers+0x0/0x51
[16087.359872]  [<ffffffff81490bdd>] ? _raw_spin_unlock+0x26/0x2b
[16087.359872]  [<ffffffff810ecf84>] ? sync_supers+0x13/0xa5
[16087.359872]  [<ffffffff810c6c16>] ? bdi_sync_supers+0x0/0x51
[16087.359872]  [<ffffffff810c6c50>] bdi_sync_supers+0x3a/0x51
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] bdi-default   S ffff88001f9abe40  5816   157      2 0x000000=
00
[16087.359872]  ffff88001f9abd80 0000000000000046 ffff88001fa510b0
ffffffff81490baf
[16087.359872]  ffffffff81b71f00 000000000000def8 ffff88001f9abfd8
0000000000014180
[16087.359872]  ffff88001f9abfd8 0000000000014180 ffff88001fa510b0
ffff88001f0b5370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81490baf>] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[16087.359872]  [<ffffffff8104b617>] ? __mod_timer+0x141/0x153
[16087.359872]  [<ffffffff8104b45f>] ? init_timer_key+0x8d/0x99
[16087.359872]  [<ffffffff8148efbb>] schedule_timeout+0xa2/0xc9
[16087.359872]  [<ffffffff8104b095>] ? process_timeout+0x0/0xb
[16087.359872]  [<ffffffff81490b3b>] ? _raw_spin_unlock_bh+0x2f/0x33
[16087.359872]  [<ffffffff810c776a>] bdi_forker_task+0x1a8/0x2da
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff810c75c2>] ? bdi_forker_task+0x0/0x2da
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kblockd/0     S ffff88001fa52160  5856   159      2 0x000000=
00
[16087.359872]  ffff88001fa37dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fa52160 000000000000def8 ffff88001fa37fd8
0000000000014180
[16087.359872]  ffff88001fa37fd8 0000000000014180 ffff88001fa52160
ffff88001f0b5370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff81269971>] ? blk_unplug_work+0x0/0x4d
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kblockd/1     S ffff88001fa53210  5624   160      2 0x000000=
00
[16087.359872]  ffff88001fa3fdc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fa53210 000000000000def8 ffff88001fa3ffd8
0000000000014180
[16087.359872]  ffff88001fa3ffd8 0000000000014180 ffff88001fa53210
ffff88001dcb5370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff8127a542>] ? cfq_kick_queue+0x0/0x3c
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kblockd/2     S ffff88001fa542c0  5856   161      2 0x000000=
00
[16087.359872]  ffff88001fa3bdc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fa542c0 000000000000def8 ffff88001fa3bfd8
0000000000014180
[16087.359872]  ffff88001fa3bfd8 0000000000014180 ffff88001fa542c0
ffff88001f152160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff8127a542>] ? cfq_kick_queue+0x0/0x3c
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kblockd/3     S ffff88001fa55370  5576   162      2 0x000000=
00
[16087.359872]  ffff88001fa47dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fa55370 000000000000def8 ffff88001fa47fd8
0000000000014180
[16087.359872]  ffff88001fa47fd8 0000000000014180 ffff88001fa55370
ffff88001f155370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff8127a542>] ? cfq_kick_queue+0x0/0x3c
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kacpid        S ffff88001fa56420  6232   165      2 0x000000=
00
[16087.359872]  ffff88001f9afdc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fa56420 000000000000def8 ffff88001f9affd8
0000000000014180
[16087.359872]  ffff88001f9affd8 0000000000014180 ffff88001fa56420
ffff88001f910000
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff812d5785>] ? bind_to_cpu0+0x0/0x2f
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kacpi_notify  S ffff88001fa65370  6232   166      2 0x000000=
00
[16087.359872]  ffff88001fa69dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fa65370 000000000000def8 ffff88001fa69fd8
0000000000014180
[16087.359872]  ffff88001fa69fd8 0000000000014180 ffff88001fa65370
ffff88001fa642c0
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff812d5785>] ? bind_to_cpu0+0x0/0x2f
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kacpi_hotplug S ffff88001fa642c0  6232   167      2 0x000000=
00
[16087.359872]  ffff88001fa6bdc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fa642c0 000000000000def8 ffff88001fa6bfd8
0000000000014180
[16087.359872]  ffff88001fa6bfd8 0000000000014180 ffff88001fa642c0
ffff88001f910000
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff812d5785>] ? bind_to_cpu0+0x0/0x2f
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kseriod       S ffff88001fa87e78  5352   239      2 0x000000=
00
[16087.359872]  ffff88001fa87e40 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fa63210 000000000000def8 ffff88001fa87fd8
0000000000014180
[16087.359872]  ffff88001fa87fd8 0000000000014180 ffff88001fa63210
ffff88001f910000
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff8136408e>] serio_thread+0x2cd/0x30a
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81363dc1>] ? serio_thread+0x0/0x30a
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] rpciod/0      S 0000000000000000  6664   269      2 0x000000=
00
[16087.359872]  ffff88001f08ddc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fa62160 000000000000def8 ffff88001f08dfd8
0000000000014180
[16087.359872]  ffff88001f08dfd8 0000000000014180 ffff88001fa62160
ffffffff81a0e020
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] rpciod/1      S 0000000000000000  6664   270      2 0x000000=
00
[16087.359872]  ffff88001f08fdc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fa60000 000000000000def8 ffff88001f08ffd8
0000000000014180
[16087.359872]  ffff88001f08ffd8 0000000000014180 ffff88001fa60000
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] rpciod/2      S 0000000000000000  6664   271      2 0x000000=
00
[16087.359872]  ffff88001fa7fdc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fa610b0 000000000000def8 ffff88001fa7ffd8
0000000000014180
[16087.359872]  ffff88001fa7ffd8 0000000000014180 ffff88001fa610b0
ffff88001f962160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] rpciod/3      S 0000000000000000  6664   272      2 0x000000=
00
[16087.359872]  ffff88001f091dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fa66420 000000000000def8 ffff88001f091fd8
0000000000014180
[16087.359872]  ffff88001f091fd8 0000000000014180 ffff88001fa66420
ffff88001f910000
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kswapd0       S 00000000ffffffff  4352   319      2 0x000000=
00
[16087.359872]  ffff88001f0bdd60 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fb58000 000000000000def8 ffff88001f0bdfd8
0000000000014180
[16087.359872]  ffff88001f0bdfd8 0000000000014180 ffff88001fb58000
ffff88001f152160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff810bf06c>] kswapd+0x853/0x867
[16087.359872]  [<ffffffff810bc216>] ? isolate_pages_global+0x0/0x1f2
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff810be819>] ? kswapd+0x0/0x867
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] aio/0         S 0000000000000000  6664   375      2 0x000000=
00
[16087.359872]  ffff88001f0bfdc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fb590b0 000000000000def8 ffff88001f0bffd8
0000000000014180
[16087.359872]  ffff88001f0bffd8 0000000000014180 ffff88001fb590b0
ffffffff81a0e020
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] aio/1         S 0000000000000000  6664   376      2 0x000000=
00
[16087.359872]  ffff88001f107dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fb5a160 000000000000def8 ffff88001f107fd8
0000000000014180
[16087.359872]  ffff88001f107fd8 0000000000014180 ffff88001fb5a160
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] aio/2         S 0000000000000000  6664   377      2 0x000000=
00
[16087.359872]  ffff88001f143dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fb5b210 000000000000def8 ffff88001f143fd8
0000000000014180
[16087.359872]  ffff88001f143fd8 0000000000014180 ffff88001fb5b210
ffff88001f962160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] aio/3         S 0000000000000000  6664   378      2 0x000000=
00
[16087.359872]  ffff88001f105dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fb5c2c0 000000000000def8 ffff88001f105fd8
0000000000014180
[16087.359872]  ffff88001f105fd8 0000000000014180 ffff88001fb5c2c0
ffff88001f965370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] nfsiod        S 0000000000000000  6664   390      2 0x000000=
00
[16087.359872]  ffff88001f0ffdc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001fb5d370 000000000000def8 ffff88001f0fffd8
0000000000014180
[16087.359872]  ffff88001f0fffd8 0000000000014180 ffff88001fb5d370
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kslowd000     S ffff88001fb5e420  6768   399      2 0x000000=
00
[16087.359872]  ffff88001f0fbe40 0000000000000046 0000000000000000
ffffffff81057e21
[16087.359872]  ffff88001fb5e420 000000000000def8 ffff88001f0fbfd8
0000000000014180
[16087.359872]  ffff88001f0fbfd8 0000000000014180 ffff88001fb5e420
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e21>] ? prepare_to_wait_exclusive+0x1e/0x7a
[16087.359872]  [<ffffffff81057e72>] ? prepare_to_wait_exclusive+0x6f/0x7a
[16087.359872]  [<ffffffff810aaced>] slow_work_thread+0x140/0x2da
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff810aabad>] ? slow_work_thread+0x0/0x2da
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kslowd001     S ffff88001f0b42c0  6792   400      2 0x000000=
00
[16087.359872]  ffff88001f16fe40 0000000000000046 0000000000000000
ffffffff81057e21
[16087.359872]  ffff88001f0b42c0 000000000000def8 ffff88001f16ffd8
0000000000014180
[16087.359872]  ffff88001f16ffd8 0000000000014180 ffff88001f0b42c0
ffff88001f962160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e21>] ? prepare_to_wait_exclusive+0x1e/0x7a
[16087.359872]  [<ffffffff81057e72>] ? prepare_to_wait_exclusive+0x6f/0x7a
[16087.359872]  [<ffffffff810aaced>] slow_work_thread+0x140/0x2da
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff810aabad>] ? slow_work_thread+0x0/0x2da
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfs_mru_cache S 0000000000000000  6664   409      2 0x000000=
00
[16087.359872]  ffff88001f195dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f0b3210 000000000000def8 ffff88001f195fd8
0000000000014180
[16087.359872]  ffff88001f195fd8 0000000000014180 ffff88001f0b3210
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfslogd/0     S 0000000000000000  6664   410      2 0x000000=
00
[16087.359872]  ffff88001f197dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f0b2160 000000000000def8 ffff88001f197fd8
0000000000014180
[16087.359872]  ffff88001f197fd8 0000000000014180 ffff88001f0b2160
ffffffff81a0e020
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfslogd/1     S ffff88001f0b10b0  6376   411      2 0x000000=
00
[16087.359872]  ffff88001f1a1dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f0b10b0 000000000000def8 ffff88001f1a1fd8
0000000000014180
[16087.359872]  ffff88001f1a1fd8 0000000000014180 ffff88001f0b10b0
ffff88001fa53210
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff8123f271>] ? xfs_buf_iodone_work+0x0/0xa1
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfslogd/2     S ffff88001f0b0000  5952   412      2 0x000000=
00
[16087.359872]  ffff88001f1a3dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f0b0000 000000000000def8 ffff88001f1a3fd8
0000000000014180
[16087.359872]  ffff88001f1a3fd8 0000000000014180 ffff88001f0b0000
ffff88001fa542c0
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff8123f271>] ? xfs_buf_iodone_work+0x0/0xa1
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfslogd/3     S ffff88001f0b6420  6256   413      2 0x000000=
00
[16087.359872]  ffff88001f1a5dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f0b6420 000000000000def8 ffff88001f1a5fd8
0000000000014180
[16087.359872]  ffff88001f1a5fd8 0000000000014180 ffff88001f0b6420
ffff88001fa55370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff8123f271>] ? xfs_buf_iodone_work+0x0/0xa1
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfsdatad/0    D ffff88001f0b5370  6216   414      2 0x000000=
00
[16087.359872]  ffff88001f1a7d00 0000000000000046 0000000000000000
ffffffff81490baf
[16087.359872]  ffffffff81b71f00 000000000000def8 ffff88001f1a7fd8
0000000000014180
[16087.359872]  ffff88001f1a7fd8 0000000000014180 ffff88001f0b5370
ffffffff81a0e020
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81490baf>] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[16087.359872]  [<ffffffff8104b617>] ? __mod_timer+0x141/0x153
[16087.359872]  [<ffffffff8104b45f>] ? init_timer_key+0x8d/0x99
[16087.359872]  [<ffffffff8148efbb>] schedule_timeout+0xa2/0xc9
[16087.359872]  [<ffffffff8104b095>] ? process_timeout+0x0/0xb
[16087.359872]  [<ffffffff81054688>] ? queue_work+0x1a/0x1c
[16087.359872]  [<ffffffff8148effb>] schedule_timeout_uninterruptible+0x19/=
0x1b
[16087.359872]  [<ffffffff8123bc95>] xfs_end_io+0x7d/0x8c
[16087.359872]  [<ffffffff81053dfb>] worker_thread+0x22c/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff8123bc18>] ? xfs_end_io+0x0/0x8c
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfsdatad/1    S ffff88001f153210  6216   415      2 0x000000=
00
[16087.359872]  ffff88001f1b1dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f153210 000000000000def8 ffff88001f1b1fd8
0000000000014180
[16087.359872]  ffff88001f1b1fd8 0000000000014180 ffff88001f153210
ffff88001e5e42c0
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff8123bc18>] ? xfs_end_io+0x0/0x8c
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfsdatad/2    D ffff88001f152160  6112   416      2 0x000000=
00
[16087.359872]  ffff88001f1b3d00 0000000000000046 0000000000000000
ffffffff81490baf
[16087.359872]  ffff88001f95c000 000000000000def8 ffff88001f1b3fd8
0000000000014180
[16087.359872]  ffff88001f1b3fd8 0000000000014180 ffff88001f152160
ffff88001f962160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81490baf>] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[16087.359872]  [<ffffffff8104b617>] ? __mod_timer+0x141/0x153
[16087.359872]  [<ffffffff8104b45f>] ? init_timer_key+0x8d/0x99
[16087.359872]  [<ffffffff8148efbb>] schedule_timeout+0xa2/0xc9
[16087.359872]  [<ffffffff8104b095>] ? process_timeout+0x0/0xb
[16087.359872]  [<ffffffff81054688>] ? queue_work+0x1a/0x1c
[16087.359872]  [<ffffffff8148effb>] schedule_timeout_uninterruptible+0x19/=
0x1b
[16087.359872]  [<ffffffff8123bc95>] xfs_end_io+0x7d/0x8c
[16087.359872]  [<ffffffff81053dfb>] worker_thread+0x22c/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff8123bc18>] ? xfs_end_io+0x0/0x8c
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfsdatad/3    S ffff88001f1510b0  6176   417      2 0x000000=
00
[16087.359872]  ffff88001f1b5dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f1510b0 000000000000def8 ffff88001f1b5fd8
0000000000014180
[16087.359872]  ffff88001f1b5fd8 0000000000014180 ffff88001f1510b0
ffff88001fb58000
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81053da4>] ? worker_thread+0x1d5/0x332
[16087.359872]  [<ffffffff8123bc18>] ? xfs_end_io+0x0/0x8c
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfsconvertd/0 S 0000000000000000  6664   418      2 0x000000=
00
[16087.359872]  ffff88001f1b7dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f1b8000 000000000000def8 ffff88001f1b7fd8
0000000000014180
[16087.359872]  ffff88001f1b7fd8 0000000000014180 ffff88001f1b8000
ffffffff81a0e020
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfsconvertd/1 S 0000000000000000  6664   419      2 0x000000=
00
[16087.359872]  ffff88001f1c1dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f1b90b0 000000000000def8 ffff88001f1c1fd8
0000000000014180
[16087.359872]  ffff88001f1c1fd8 0000000000014180 ffff88001f1b90b0
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfsconvertd/2 S 0000000000000000  6664   420      2 0x000000=
00
[16087.359872]  ffff88001f1c3dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f1ba160 000000000000def8 ffff88001f1c3fd8
0000000000014180
[16087.359872]  ffff88001f1c3fd8 0000000000014180 ffff88001f1ba160
ffff88001f962160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfsconvertd/3 S 0000000000000000  6664   421      2 0x000000=
00
[16087.359872]  ffff88001f1c5dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f1bb210 000000000000def8 ffff88001f1c5fd8
0000000000014180
[16087.359872]  ffff88001f1c5fd8 0000000000014180 ffff88001f1bb210
ffff88001f965370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] crypto/0      S 0000000000000000  6664   423      2 0x000000=
00
[16087.359872]  ffff88001f135dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f1bc2c0 000000000000def8 ffff88001f135fd8
0000000000014180
[16087.359872]  ffff88001f135fd8 0000000000014180 ffff88001f1bc2c0
ffffffff81a0e020
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] crypto/1      S 0000000000000000  6664   424      2 0x000000=
00
[16087.359872]  ffff88001fa07dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f1bd370 000000000000def8 ffff88001fa07fd8
0000000000014180
[16087.359872]  ffff88001fa07fd8 0000000000014180 ffff88001f1bd370
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] crypto/2      S 0000000000000000  6664   425      2 0x000000=
00
[16087.359872]  ffff88001f191dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f1be420 000000000000def8 ffff88001f191fd8
0000000000014180
[16087.359872]  ffff88001f191fd8 0000000000014180 ffff88001f1be420
ffff88001f962160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] crypto/3      S 0000000000000000  6664   426      2 0x000000=
00
[16087.359872]  ffff88001f1c7dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f150000 000000000000def8 ffff88001f1c7fd8
0000000000014180
[16087.359872]  ffff88001f1c7fd8 0000000000014180 ffff88001f150000
ffff88001f965370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kpsmoused     S 0000000000000000  6664   575      2 0x000000=
00
[16087.359872]  ffff88001f22ddc0 0000000000000046 ffff88001f22dd90
ffff88001f22dd8c
[16087.359872]  ffff88001f1e6420 000000000000def8 ffff88001f22dfd8
0000000000014180
[16087.359872]  ffff88001f22dfd8 0000000000014180 ffff88001f1e6420
ffff88001f962160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] edac-poller   S 0000000000000000  6664   583      2 0x000000=
00
[16087.359872]  ffff88001f283dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f1e5370 000000000000def8 ffff88001f283fd8
0000000000014180
[16087.359872]  ffff88001f283fd8 0000000000014180 ffff88001f1e5370
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kondemand/0   S 0000000000000000  6664   586      2 0x000000=
00
[16087.359872]  ffff88001f289dc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f1e3210 000000000000def8 ffff88001f289fd8
0000000000014180
[16087.359872]  ffff88001f289fd8 0000000000014180 ffff88001f1e3210
ffffffff81a0e020
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kondemand/1   S 0000000000000000  6664   587      2 0x000000=
00
[16087.359872]  ffff88001f28bdc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f1e2160 000000000000def8 ffff88001f28bfd8
0000000000014180
[16087.359872]  ffff88001f28bfd8 0000000000014180 ffff88001f1e2160
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kondemand/2   S 0000000000000000  6664   588      2 0x000000=
00
[16087.359872]  ffff88001f28ddc0 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001f1e10b0 000000000000def8 ffff88001f28dfd8
0000000000014180
[16087.359872]  ffff88001f28dfd8 0000000000014180 ffff88001f1e10b0
ffff88001f962160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kondemand/3   S 0000000000000000  6664   589      2 0x000000=
00
[16087.359872]  ffff88001f28fdc0 0000000000000046 ffff88001f28fd90
ffff88001f28fd8c
[16087.359872]  ffff88001f1e0000 000000000000def8 ffff88001f28ffd8
0000000000014180
[16087.359872]  ffff88001f28ffd8 0000000000014180 ffff88001f1e0000
ffff88001f965370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81053ccc>] worker_thread+0xfd/0x332
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81053bcf>] ? worker_thread+0x0/0x332
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] vballoon      S ffff88001ec37e60  6736   605      2 0x000000=
00
[16087.359872]  ffff88001ec37e20 0000000000000046 0000000000000000
ffffffff81057e9b
[16087.359872]  ffff88001ec38000 000000000000def8 ffff88001ec37fd8
0000000000014180
[16087.359872]  ffff88001ec37fd8 0000000000014180 ffff88001ec38000
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81057e9b>] ? prepare_to_wait+0x1e/0x7b
[16087.359872]  [<ffffffff8138e267>] ? vp_get+0x48/0x5d
[16087.359872]  [<ffffffff8138f1b7>] balloon+0x143/0x2c0
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff8138f074>] ? balloon+0x0/0x2c0
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] kjournald     S ffff88001f09e970  3984   620      2 0x000000=
00
[16087.359872]  ffff88001ec4de20 0000000000000046 ffff88001ec4dd90
ffffffff81067901
[16087.359872]  ffff88001ec390b0 000000000000def8 ffff88001ec4dfd8
0000000000014180
[16087.359872]  ffff88001ec4dfd8 0000000000014180 ffff88001ec390b0
ffff88001f0b5370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81067901>] ? mark_held_locks+0x4d/0x6b
[16087.359872]  [<ffffffff811602bb>] kjournald+0x1cf/0x25a
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff811600ec>] ? kjournald+0x0/0x25a
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] udevd         S 0000000000000000  5616   711      1 0x000000=
00
[16087.359872]  ffff88001ed73a58 0000000000000046 0000000000000000
000000000000004c
[16087.359872]  ffff88001ed73a88 000000000000def8 ffff88001ed73fd8
0000000000014180
[16087.359872]  ffff88001ed73fd8 0000000000014180 ffff88001edb2160
ffffffff81a0e020
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff8148f8c5>] schedule_hrtimeout_range+0x3f/0xf7
[16087.359872]  [<ffffffff81490bdd>] ? _raw_spin_unlock+0x26/0x2b
[16087.359872]  [<ffffffff81423dca>] ? unix_peer_get+0x19/0x3d
[16087.359872]  [<ffffffff81423de6>] ? unix_peer_get+0x35/0x3d
[16087.359872]  [<ffffffff810f8b92>] poll_schedule_timeout+0x46/0x69
[16087.359872]  [<ffffffff810f8fac>] do_sys_poll+0x36a/0x40b
[16087.359872]  [<ffffffff810f9d51>] ? __pollwait+0x0/0xcf
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810b7d5a>] ? __pagevec_free+0x70/0x85
[16087.359872]  [<ffffffff810bb1b8>] ? release_pages+0x1aa/0x1bc
[16087.359872]  [<ffffffff810d32b2>] ? anon_vma_unlink+0x1b/0x71
[16087.359872]  [<ffffffff81067901>] ? mark_held_locks+0x4d/0x6b
[16087.359872]  [<ffffffff810e4920>] ? kmem_cache_free+0x99/0xd3
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff810ce526>] ? remove_vma+0x7f/0x87
[16087.359872]  [<ffffffff810ce526>] ? remove_vma+0x7f/0x87
[16087.359872]  [<ffffffff81002a9c>] ? sysret_check+0x27/0x62
[16087.359872]  [<ffffffff810f91e2>] sys_poll+0x50/0xba
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] dhcpcd        S 0000000000000000  3536  2636      1 0x000000=
00
[16087.359872]  ffff88001e785a58 0000000000000046 0000000000000000
0000000000000282
[16087.359872]  0000000000000040 000000000000def8 ffff88001e785fd8
0000000000014180
[16087.359872]  ffff88001e785fd8 0000000000014180 ffff88001ec3c2c0
ffff88001f965370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff8148f948>] schedule_hrtimeout_range+0xc2/0xf7
[16087.359872]  [<ffffffff8105a9e0>] ? hrtimer_wakeup+0x0/0x21
[16087.359872]  [<ffffffff8105b4eb>] ? hrtimer_start_range_ns+0xf/0x11
[16087.359872]  [<ffffffff810f9e17>] ? __pollwait+0xc6/0xcf
[16087.359872]  [<ffffffff810f8b92>] poll_schedule_timeout+0x46/0x69
[16087.359872]  [<ffffffff810f8fac>] do_sys_poll+0x36a/0x40b
[16087.359872]  [<ffffffff810f9d51>] ? __pollwait+0x0/0xcf
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff811154ca>] ? fsnotify_clear_marks_by_inode+0x2b/0=
xe0
[16087.359872]  [<ffffffff810e4920>] ? kmem_cache_free+0x99/0xd3
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff810e4920>] ? kmem_cache_free+0x99/0xd3
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff810fa2a0>] ? __d_free+0x51/0x55
[16087.359872]  [<ffffffff810fa2d6>] ? d_free+0x32/0x4b
[16087.359872]  [<ffffffff81101451>] ? mntput_no_expire+0x24/0xf8
[16087.359872]  [<ffffffff81060016>] ? ktime_get_ts+0xb1/0xbe
[16087.359872]  [<ffffffff810f8b31>] ? poll_select_set_timeout+0x5c/0x77
[16087.359872]  [<ffffffff810f91e2>] sys_poll+0x50/0xba
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] login         S ffff88001edb42c0  4896  2847      1 0x000000=
00
[16087.359872]  ffff88001dc61e58 0000000000000046 0000000000000000
0000000000000000
[16087.359872]  ffff88001dc61e08 000000000000def8 ffff88001dc61fd8
0000000000014180
[16087.359872]  ffff88001dc61fd8 0000000000014180 ffff88001edb42c0
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81040671>] do_wait+0x1bd/0x22b
[16087.359872]  [<ffffffff81040785>] sys_wait4+0xa6/0xc3
[16087.359872]  [<ffffffff8103ee89>] ? child_wait_callback+0x0/0x53
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] agetty        S ffff88001f9ec290  5784  2848      1 0x000000=
00
[16087.359872]  ffff88001dcddd08 0000000000000046 0000000000000000
0000000000000000
[16087.359872]  ffff88001edb6420 000000000000def8 ffff88001dcddfd8
0000000000014180
[16087.359872]  ffff88001dcddfd8 0000000000014180 ffff88001edb6420
ffff88001f962160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff8105497d>] ? flush_work+0x2b/0xf2
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff8148ef3b>] schedule_timeout+0x22/0xc9
[16087.359872]  [<ffffffff8104b009>] ? del_timer_sync+0x73/0x84
[16087.359872]  [<ffffffff8104af96>] ? del_timer_sync+0x0/0x84
[16087.359872]  [<ffffffff81054c01>] ? flush_delayed_work+0x50/0x55
[16087.359872]  [<ffffffff812a97d8>] n_tty_read+0x517/0x7f3
[16087.359872]  [<ffffffff81039448>] ? default_wake_function+0x0/0xf
[16087.359872]  [<ffffffff812a4e53>] tty_read+0x7d/0xba
[16087.359872]  [<ffffffff810eb75e>] vfs_read+0xa8/0x102
[16087.359872]  [<ffffffff810eb87c>] sys_read+0x47/0x70
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] agetty        S ffff88001f9bd350  5320  2849      1 0x000000=
00
[16087.359872]  ffff88001f231d08 0000000000000046 0000000000000000
0000000000000000
[16087.359872]  ffff88001edb3210 000000000000def8 ffff88001f231fd8
0000000000014180
[16087.359872]  ffff88001f231fd8 0000000000014180 ffff88001edb3210
ffff88001f962160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff8105497d>] ? flush_work+0x2b/0xf2
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff8148ef3b>] schedule_timeout+0x22/0xc9
[16087.359872]  [<ffffffff8104b009>] ? del_timer_sync+0x73/0x84
[16087.359872]  [<ffffffff8104af96>] ? del_timer_sync+0x0/0x84
[16087.359872]  [<ffffffff81054c01>] ? flush_delayed_work+0x50/0x55
[16087.359872]  [<ffffffff812a97d8>] n_tty_read+0x517/0x7f3
[16087.359872]  [<ffffffff81039448>] ? default_wake_function+0x0/0xf
[16087.359872]  [<ffffffff812a4e53>] tty_read+0x7d/0xba
[16087.359872]  [<ffffffff810eb75e>] vfs_read+0xa8/0x102
[16087.359872]  [<ffffffff810eb87c>] sys_read+0x47/0x70
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] agetty        S ffff88001f9bd360  5224  2850      1 0x000000=
00
[16087.359872]  ffff88001ed71d08 0000000000000046 0000000000000000
0000000000000000
[16087.359872]  ffff88001edb0000 000000000000def8 ffff88001ed71fd8
0000000000014180
[16087.359872]  ffff88001ed71fd8 0000000000014180 ffff88001edb0000
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff8148ef3b>] schedule_timeout+0x22/0xc9
[16087.359872]  [<ffffffff8104b009>] ? del_timer_sync+0x73/0x84
[16087.359872]  [<ffffffff8104af96>] ? del_timer_sync+0x0/0x84
[16087.359872]  [<ffffffff81054c01>] ? flush_delayed_work+0x50/0x55
[16087.359872]  [<ffffffff812a97d8>] n_tty_read+0x517/0x7f3
[16087.359872]  [<ffffffff81039448>] ? default_wake_function+0x0/0xf
[16087.359872]  [<ffffffff812a4e53>] tty_read+0x7d/0xba
[16087.359872]  [<ffffffff810eb75e>] vfs_read+0xa8/0x102
[16087.359872]  [<ffffffff810eb87c>] sys_read+0x47/0x70
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] agetty        S ffff88001f21c5e0  5224  2851      1 0x000000=
00
[16087.359872]  ffff88001e425d08 0000000000000046 0000000000000000
0000000000000000
[16087.359872]  ffff88001edb10b0 000000000000def8 ffff88001e425fd8
0000000000014180
[16087.359872]  ffff88001e425fd8 0000000000014180 ffff88001edb10b0
ffff88001f965370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff8105497d>] ? flush_work+0x2b/0xf2
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff8148ef3b>] schedule_timeout+0x22/0xc9
[16087.359872]  [<ffffffff8104b009>] ? del_timer_sync+0x73/0x84
[16087.359872]  [<ffffffff8104af96>] ? del_timer_sync+0x0/0x84
[16087.359872]  [<ffffffff81054c01>] ? flush_delayed_work+0x50/0x55
[16087.359872]  [<ffffffff812a97d8>] n_tty_read+0x517/0x7f3
[16087.359872]  [<ffffffff81039448>] ? default_wake_function+0x0/0xf
[16087.359872]  [<ffffffff812a4e53>] tty_read+0x7d/0xba
[16087.359872]  [<ffffffff810eb75e>] vfs_read+0xa8/0x102
[16087.359872]  [<ffffffff810eb87c>] sys_read+0x47/0x70
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] agetty        S ffff88001fa78a80  5784  2852      1 0x000000=
00
[16087.359872]  ffff88001dd1bd08 0000000000000046 0000000000000000
0000000000000000
[16087.359872]  ffff88001edb5370 000000000000def8 ffff88001dd1bfd8
0000000000014180
[16087.359872]  ffff88001dd1bfd8 0000000000014180 ffff88001edb5370
ffffffff81a0e020
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff8148ef3b>] schedule_timeout+0x22/0xc9
[16087.359872]  [<ffffffff8104b009>] ? del_timer_sync+0x73/0x84
[16087.359872]  [<ffffffff8104af96>] ? del_timer_sync+0x0/0x84
[16087.359872]  [<ffffffff81054c01>] ? flush_delayed_work+0x50/0x55
[16087.359872]  [<ffffffff812a97d8>] n_tty_read+0x517/0x7f3
[16087.359872]  [<ffffffff81039448>] ? default_wake_function+0x0/0xf
[16087.359872]  [<ffffffff812a4e53>] tty_read+0x7d/0xba
[16087.359872]  [<ffffffff810eb75e>] vfs_read+0xa8/0x102
[16087.359872]  [<ffffffff810eb87c>] sys_read+0x47/0x70
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] bash          R  running task     3968  2853   2847 0x000000=
00
[16087.359872]  332e37383036315b ffffffff8148e017 0000003000000010
ffff88001eda3d98
[16087.359872]  ffff88001eda3cd8 0000000137383935 ffff88001eda2000
ffff88001eda2000
[16087.359872]  ffff880002780000 0000000000000000 0000000000000082
0000000000000004
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff810057a3>] ? dump_trace+0x2fe/0x30f
[16087.359872]  [<ffffffff8100618f>] show_trace_log_lvl+0x4c/0x58
[16087.359872]  [<ffffffff8100528f>] show_stack_log_lvl+0xff/0x10e
[16087.359872]  [<ffffffff81006141>] show_stack+0x17/0x19
[16087.359872]  [<ffffffff81036d04>] sched_show_task+0xc0/0xc5
[16087.359872]  [<ffffffff81036d59>] show_state_filter+0x50/0x9b
[16087.359872]  [<ffffffff812ba8d3>] sysrq_handle_showstate+0xb/0xd
[16087.359872]  [<ffffffff812bac43>] __handle_sysrq+0xbb/0x158
[16087.359872]  [<ffffffff812bace0>] ? write_sysrq_trigger+0x0/0x44
[16087.359872]  [<ffffffff812bad19>] write_sysrq_trigger+0x39/0x44
[16087.359872]  [<ffffffff8113397a>] proc_reg_write+0x84/0xa1
[16087.359872]  [<ffffffff810eb56f>] vfs_write+0xab/0x105
[16087.359872]  [<ffffffff810eb68d>] sys_write+0x47/0x70
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] xfsbufd       S ffff88001eecde80  6208  2861      2 0x000000=
00
[16087.359872]  ffff88001eecddd0 0000000000000046 0000000000000000
ffffffff81490baf
[16087.359872]  ffff88001f970000 000000000000def8 ffff88001eecdfd8
0000000000014180
[16087.359872]  ffff88001eecdfd8 0000000000014180 ffff88001e5890b0
ffff88001f965370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81490baf>] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[16087.359872]  [<ffffffff8104b617>] ? __mod_timer+0x141/0x153
[16087.359872]  [<ffffffff8104b45f>] ? init_timer_key+0x8d/0x99
[16087.359872]  [<ffffffff8148efbb>] schedule_timeout+0xa2/0xc9
[16087.359872]  [<ffffffff8104b095>] ? process_timeout+0x0/0xb
[16087.359872]  [<ffffffff8148f031>] schedule_timeout_interruptible+0x19/0x=
1b
[16087.359872]  [<ffffffff8123f1d7>] xfsbufd+0x73/0x10d
[16087.359872]  [<ffffffff8123f164>] ? xfsbufd+0x0/0x10d
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfsaild       S 0000000000000000  6440  2862      2 0x000000=
00
[16087.359872]  ffff88001dc81de0 0000000000000046 ffff88001e58c2c0
ffffffff81490baf
[16087.359872]  ffffffff81b71f00 000000000000def8 ffff88001dc81fd8
0000000000014180
[16087.359872]  ffff88001dc81fd8 0000000000014180 ffff88001e58c2c0
ffff88001f0b5370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81490baf>] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[16087.359872]  [<ffffffff8104b617>] ? __mod_timer+0x141/0x153
[16087.359872]  [<ffffffff8104b45f>] ? init_timer_key+0x8d/0x99
[16087.359872]  [<ffffffff8148efbb>] schedule_timeout+0xa2/0xc9
[16087.359872]  [<ffffffff8104b095>] ? process_timeout+0x0/0xb
[16087.359872]  [<ffffffff8148f031>] schedule_timeout_interruptible+0x19/0x=
1b
[16087.359872]  [<ffffffff81245c5c>] xfsaild+0x3f/0x84
[16087.359872]  [<ffffffff81245c1d>] ? xfsaild+0x0/0x84
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] xfssyncd      S 0000000000007530  5664  2863      2 0x000000=
00
[16087.359872]  ffff88001ef3dda0 0000000000000046 0000000000000000
ffffffff81490baf
[16087.359872]  ffff88001f934000 000000000000def8 ffff88001ef3dfd8
0000000000014180
[16087.359872]  ffff88001ef3dfd8 0000000000014180 ffff88001e58e420
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81490baf>] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[16087.359872]  [<ffffffff8104b617>] ? __mod_timer+0x141/0x153
[16087.359872]  [<ffffffff8104b45f>] ? init_timer_key+0x8d/0x99
[16087.359872]  [<ffffffff8148efbb>] schedule_timeout+0xa2/0xc9
[16087.359872]  [<ffffffff8104b095>] ? process_timeout+0x0/0xb
[16087.359872]  [<ffffffff8148f031>] schedule_timeout_interruptible+0x19/0x=
1b
[16087.359872]  [<ffffffff81245fb3>] xfssyncd+0x80/0x1bd
[16087.359872]  [<ffffffff81245f33>] ? xfssyncd+0x0/0x1bd
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] screen        S 0000000000000000  5008  2876      1 0x000000=
00
[16087.359872]  ffff88001f2d1908 0000000000000046 0000000000000000
ffffffff81067b93
[16087.359872]  ffff88001f2d1878 000000000000def8 ffff88001f2d1fd8
0000000000014180
[16087.359872]  ffff88001f2d1fd8 0000000000014180 ffff88001e58d370
ffff88001f965370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff8104af88>] ? try_to_del_timer_sync+0x66/0x74
[16087.359872]  [<ffffffff8148f8c5>] schedule_hrtimeout_range+0x3f/0xf7
[16087.359872]  [<ffffffff812ac13e>] ? put_ldisc+0x91/0x98
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff810f8b92>] poll_schedule_timeout+0x46/0x69
[16087.359872]  [<ffffffff810f985a>] do_select+0x5c1/0x605
[16087.359872]  [<ffffffff810f9299>] ? do_select+0x0/0x605
[16087.359872]  [<ffffffff810f9d51>] ? __pollwait+0x0/0xcf
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9a57>] core_sys_select+0x1b9/0x255
[16087.359872]  [<ffffffff810f98df>] ? core_sys_select+0x41/0x255
[16087.359872]  [<ffffffff810698a9>] ? lock_release_non_nested+0x97/0x20d
[16087.359872]  [<ffffffff810698a9>] ? lock_release_non_nested+0x97/0x20d
[16087.359872]  [<ffffffff81490b6a>] ? _raw_spin_unlock_irq+0x2b/0x31
[16087.359872]  [<ffffffff810c885b>] ? might_fault+0x57/0xa4
[16087.359872]  [<ffffffff810c885b>] ? might_fault+0x57/0xa4
[16087.359872]  [<ffffffff810f9d29>] sys_select+0x94/0xbc
[16087.359872]  [<ffffffff814903d9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] bash          S ffff88001f1542c0  5384  2877   2876 0x000000=
00
[16087.359872]  ffff88001dc17e58 0000000000000046 0000000000000000
0000000000000000
[16087.359872]  ffff88001dc17e08 000000000000def8 ffff88001dc17fd8
0000000000014180
[16087.359872]  ffff88001dc17fd8 0000000000014180 ffff88001f1542c0
ffff88001f965370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81040671>] do_wait+0x1bd/0x22b
[16087.359872]  [<ffffffff810c885b>] ? might_fault+0x57/0xa4
[16087.359872]  [<ffffffff81040785>] sys_wait4+0xa6/0xc3
[16087.359872]  [<ffffffff8103ee89>] ? child_wait_callback+0x0/0x53
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] test-mysqld   S 0000000000000000  5096  2881   2877 0x000000=
00
[16087.359872]  ffff88001ee51bf8 0000000000000046 0000000000000000
ffffffff8106a8a6
[16087.359872]  0000000100000000 000000000000def8 ffff88001ee51fd8
0000000000014180
[16087.359872]  ffff88001ee51fd8 0000000000014180 ffff88001dcb42c0
ffff88001f962160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff8106a8a6>] ? queue_lock+0x57/0x5f
[16087.359872]  [<ffffffff81490bdd>] ? _raw_spin_unlock+0x26/0x2b
[16087.359872]  [<ffffffff8106ab41>] futex_wait_queue_me+0x82/0x9a
[16087.359872]  [<ffffffff8106ac9c>] futex_wait+0x143/0x2b1
[16087.359872]  [<ffffffff810325c3>] ? select_task_rq_fair+0x7a7/0x81e
[16087.359872]  [<ffffffff8106c958>] do_futex+0x98/0x9a2
[16087.359872]  [<ffffffff81066f14>] ? trace_hardirqs_off+0xd/0xf
[16087.359872]  [<ffffffff81490baf>] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff8103a8da>] ? wake_up_new_task+0xd4/0xe2
[16087.359872]  [<ffffffff8103cbf3>] ? do_fork+0x279/0x33e
[16087.359872]  [<ffffffff812873d8>] ? call_rwsem_wake+0x18/0x30
[16087.359872]  [<ffffffff8106d375>] sys_futex+0x113/0x131
[16087.359872]  [<ffffffff814903d9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] test-mysqld   D 0000000000000002  3440  2882   2877 0x000000=
00
[16087.359872]  ffff88001edfba88 0000000000000046 ffff88001edfba08
ffffffff810676b1
[16087.359872]  ffff88001ec1e420 000000000000def8 ffff88001edfbfd8
0000000000014180
[16087.359872]  ffff88001edfbfd8 0000000000014180 ffff88001ec1e420
ffff88001f152160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff81060016>] ? ktime_get_ts+0xb1/0xbe
[16087.359872]  [<ffffffff8148ec26>] io_schedule+0x7b/0xc2
[16087.359872]  [<ffffffff810b2a58>] sync_page+0x44/0x48
[16087.359872]  [<ffffffff8148f078>] __wait_on_bit_lock+0x45/0x8c
[16087.359872]  [<ffffffff810b2a14>] ? sync_page+0x0/0x48
[16087.359872]  [<ffffffff810b29c4>] __lock_page+0x63/0x6a
[16087.359872]  [<ffffffff81057cec>] ? wake_bit_function+0x0/0x2a
[16087.359872]  [<ffffffff810bb7bc>] lock_page+0x37/0x3b
[16087.359872]  [<ffffffff810bb842>] invalidate_inode_pages2_range+0x82/0x2=
cb
[16087.359872]  [<ffffffff8123bbed>] ? xfs_vm_direct_IO+0x90/0xbb
[16087.359872]  [<ffffffff8123be2b>] ? xfs_get_blocks_direct+0x0/0x17
[16087.359872]  [<ffffffff8123ba4b>] ? xfs_end_io_direct+0x0/0x4e
[16087.359872]  [<ffffffff810b370a>] generic_file_direct_write+0x102/0x158
[16087.359872]  [<ffffffff81243606>] xfs_write+0x4a5/0x793
[16087.359872]  [<ffffffff810309a6>] ? cpuacct_charge+0x8e/0x97
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff8123ffa5>] xfs_file_aio_write+0x5a/0x5c
[16087.359872]  [<ffffffff810eabe6>] do_sync_write+0xc0/0x106
[16087.359872]  [<ffffffff810ebd8c>] ? fget_light+0x4f/0xfb
[16087.359872]  [<ffffffff81256e08>] ? security_file_permission+0x11/0x13
[16087.359872]  [<ffffffff810eb56f>] vfs_write+0xab/0x105
[16087.359872]  [<ffffffff810eb68d>] sys_write+0x47/0x70
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] test-mysqld   D ffff88001ec190b0  3152  2883   2877 0x000000=
00
[16087.359872]  ffff88001e4bde28 0000000000000046 ffff88001e4bdda8
ffffffff810676b1
[16087.359872]  ffff88001ec190b0 000000000000def8 ffff88001e4bdfd8
0000000000014180
[16087.359872]  ffff88001e4bdfd8 0000000000014180 ffff88001ec190b0
ffff88001ec3b210
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff81067901>] ? mark_held_locks+0x4d/0x6b
[16087.359872]  [<ffffffff8148f6b8>] ? __mutex_lock_common+0x216/0x330
[16087.359872]  [<ffffffff8148f6c0>] __mutex_lock_common+0x21e/0x330
[16087.359872]  [<ffffffff810eba12>] ? generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810eba12>] ? generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810ebd8c>] ? fget_light+0x4f/0xfb
[16087.359872]  [<ffffffff8148f881>] mutex_lock_nested+0x37/0x3c
[16087.359872]  [<ffffffff810eba12>] generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810ea6b4>] vfs_llseek+0x35/0x37
[16087.359872]  [<ffffffff810ea7cf>] sys_lseek+0x48/0x67
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] test-mysqld   D 0000000000000000  3360  2884   2877 0x000000=
00
[16087.359872]  ffff88001ece7e28 0000000000000046 ffff88001ece7df8
ffff88001ece7df4
[16087.359872]  ffff88001e9e0000 000000000000def8 ffff88001ece7fd8
0000000000014180
[16087.359872]  ffff88001ece7fd8 0000000000014180 ffff88001ec1a160
ffffffff81a0e020
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff8148f6b8>] ? __mutex_lock_common+0x216/0x330
[16087.359872]  [<ffffffff8148f6c0>] __mutex_lock_common+0x21e/0x330
[16087.359872]  [<ffffffff810eba12>] ? generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810eba12>] ? generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810ebd8c>] ? fget_light+0x4f/0xfb
[16087.359872]  [<ffffffff8148f881>] mutex_lock_nested+0x37/0x3c
[16087.359872]  [<ffffffff810eba12>] generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810ea6b4>] vfs_llseek+0x35/0x37
[16087.359872]  [<ffffffff810ea7cf>] sys_lseek+0x48/0x67
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] test-mysqld   D 0000000000000000  2664  2885   2877 0x000000=
00
[16087.359872]  ffff88001ecc9bb8 0000000000000046 ffff88001ecc9b38
ffffffff810676b1
[16087.359872]  ffff880002614180 000000000000def8 ffff88001ecc9fd8
0000000000014180
[16087.359872]  ffff88001ecc9fd8 0000000000014180 ffff88001ec1c2c0
ffff88001ec3b210
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff8149022b>] rwsem_down_failed_common+0x9a/0xcc
[16087.359872]  [<ffffffff8149027d>] rwsem_down_write_failed+0x20/0x2a
[16087.359872]  [<ffffffff812873b3>] call_rwsem_down_write_failed+0x13/0x20
[16087.359872]  [<ffffffff8105b78b>] ? down_write_nested+0x66/0x6d
[16087.359872]  [<ffffffff81221001>] ? xfs_ilock+0x2c/0xb2
[16087.359872]  [<ffffffff81221001>] xfs_ilock+0x2c/0xb2
[16087.359872]  [<ffffffff8124342d>] xfs_write+0x2cc/0x793
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff8123ffa5>] xfs_file_aio_write+0x5a/0x5c
[16087.359872]  [<ffffffff810eabe6>] do_sync_write+0xc0/0x106
[16087.359872]  [<ffffffff810ebd8c>] ? fget_light+0x4f/0xfb
[16087.359872]  [<ffffffff81256e08>] ? security_file_permission+0x11/0x13
[16087.359872]  [<ffffffff810eb56f>] vfs_write+0xab/0x105
[16087.359872]  [<ffffffff810eb68d>] sys_write+0x47/0x70
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] test-mysqld   D ffff88001ec1d370  2664  2886   2877 0x000000=
00
[16087.359872]  ffff88001eea1e28 0000000000000046 ffff88001eea1da8
ffffffff810676b1
[16087.359872]  000000000000000d 000000000000def8 ffff88001eea1fd8
0000000000014180
[16087.359872]  ffff88001eea1fd8 0000000000014180 ffff88001ec1d370
ffff88001fa53210
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff81067901>] ? mark_held_locks+0x4d/0x6b
[16087.359872]  [<ffffffff8148f6b8>] ? __mutex_lock_common+0x216/0x330
[16087.359872]  [<ffffffff8148f6c0>] __mutex_lock_common+0x21e/0x330
[16087.359872]  [<ffffffff810eba12>] ? generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810eba12>] ? generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810ebd8c>] ? fget_light+0x4f/0xfb
[16087.359872]  [<ffffffff8148f881>] mutex_lock_nested+0x37/0x3c
[16087.359872]  [<ffffffff810eba12>] generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810ea6b4>] vfs_llseek+0x35/0x37
[16087.359872]  [<ffffffff810ea7cf>] sys_lseek+0x48/0x67
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] test-mysqld   D 0000000000000002  3440  2887   2877 0x000000=
00
[16087.359872]  ffff88001ee87a88 0000000000000046 0000000000000000
ffff88000240a980
[16087.359872]  0000000046e48524 000000000000def8 ffff88001ee87fd8
0000000000014180
[16087.359872]  ffff88001ee87fd8 0000000000014180 ffff88001ec1b210
ffffffff81a0e020
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81060016>] ? ktime_get_ts+0xb1/0xbe
[16087.359872]  [<ffffffff8148ec26>] io_schedule+0x7b/0xc2
[16087.359872]  [<ffffffff810b2a58>] sync_page+0x44/0x48
[16087.359872]  [<ffffffff8148f078>] __wait_on_bit_lock+0x45/0x8c
[16087.359872]  [<ffffffff810b2a14>] ? sync_page+0x0/0x48
[16087.359872]  [<ffffffff810b29c4>] __lock_page+0x63/0x6a
[16087.359872]  [<ffffffff81057cec>] ? wake_bit_function+0x0/0x2a
[16087.359872]  [<ffffffff810bb7bc>] lock_page+0x37/0x3b
[16087.359872]  [<ffffffff810bb842>] invalidate_inode_pages2_range+0x82/0x2=
cb
[16087.359872]  [<ffffffff8123bbed>] ? xfs_vm_direct_IO+0x90/0xbb
[16087.359872]  [<ffffffff8123be2b>] ? xfs_get_blocks_direct+0x0/0x17
[16087.359872]  [<ffffffff8123ba4b>] ? xfs_end_io_direct+0x0/0x4e
[16087.359872]  [<ffffffff810b370a>] generic_file_direct_write+0x102/0x158
[16087.359872]  [<ffffffff81243606>] xfs_write+0x4a5/0x793
[16087.359872]  [<ffffffff810309a6>] ? cpuacct_charge+0x8e/0x97
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff8123ffa5>] xfs_file_aio_write+0x5a/0x5c
[16087.359872]  [<ffffffff810eabe6>] do_sync_write+0xc0/0x106
[16087.359872]  [<ffffffff810ebd8c>] ? fget_light+0x4f/0xfb
[16087.359872]  [<ffffffff81256e08>] ? security_file_permission+0x11/0x13
[16087.359872]  [<ffffffff810eb56f>] vfs_write+0xab/0x105
[16087.359872]  [<ffffffff810eb68d>] sys_write+0x47/0x70
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] test-mysqld   D ffff88001f1e42c0  2664  2888   2877 0x000000=
00
[16087.359872]  ffff88001dcc5e28 0000000000000046 0000000000000000
ffffffff810676b1
[16087.359872]  ffff88001e9e0000 000000000000def8 ffff88001dcc5fd8
0000000000014180
[16087.359872]  ffff88001dcc5fd8 0000000000014180 ffff88001f1e42c0
ffff88001f962160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff8148f6b8>] ? __mutex_lock_common+0x216/0x330
[16087.359872]  [<ffffffff8148f6c0>] __mutex_lock_common+0x21e/0x330
[16087.359872]  [<ffffffff810eba12>] ? generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810eba12>] ? generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810ebd8c>] ? fget_light+0x4f/0xfb
[16087.359872]  [<ffffffff8148f881>] mutex_lock_nested+0x37/0x3c
[16087.359872]  [<ffffffff810eba12>] generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810ea6b4>] vfs_llseek+0x35/0x37
[16087.359872]  [<ffffffff810ea7cf>] sys_lseek+0x48/0x67
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] test-mysqld   D ffff88001ec3d370  2664  2889   2877 0x000000=
00
[16087.359872]  ffff88001ede5e28 0000000000000046 ffff88001ede5da8
ffffffff810676b1
[16087.359872]  ffff88001ec3d370 000000000000def8 ffff88001ede5fd8
0000000000014180
[16087.359872]  ffff88001ede5fd8 0000000000014180 ffff88001ec3d370
ffff88001f0b5370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff81067901>] ? mark_held_locks+0x4d/0x6b
[16087.359872]  [<ffffffff8148f6b8>] ? __mutex_lock_common+0x216/0x330
[16087.359872]  [<ffffffff8148f6c0>] __mutex_lock_common+0x21e/0x330
[16087.359872]  [<ffffffff810eba12>] ? generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810eba12>] ? generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810ebd8c>] ? fget_light+0x4f/0xfb
[16087.359872]  [<ffffffff8148f881>] mutex_lock_nested+0x37/0x3c
[16087.359872]  [<ffffffff810eba12>] generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810ea6b4>] vfs_llseek+0x35/0x37
[16087.359872]  [<ffffffff810ea7cf>] sys_lseek+0x48/0x67
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] test-mysqld   D 0000000000000000  3152  2890   2877 0x000000=
00
[16087.359872]  ffff88001e6fbc08 0000000000000046 ffff88001e6fbbd8
ffff88001e6fbbd4
[16087.359872]  ffff88001ec3b210 000000000000def8 ffff88001e6fbfd8
0000000000014180
[16087.359872]  ffff88001e6fbfd8 0000000000014180 ffff88001ec3b210
ffff88001ec1a160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff8148f6b8>] ? __mutex_lock_common+0x216/0x330
[16087.359872]  [<ffffffff8148f6c0>] __mutex_lock_common+0x21e/0x330
[16087.359872]  [<ffffffff81243420>] ? xfs_write+0x2bf/0x793
[16087.359872]  [<ffffffff81243420>] ? xfs_write+0x2bf/0x793
[16087.359872]  [<ffffffff8148f881>] mutex_lock_nested+0x37/0x3c
[16087.359872]  [<ffffffff81243420>] xfs_write+0x2bf/0x793
[16087.359872]  [<ffffffff810309a6>] ? cpuacct_charge+0x8e/0x97
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff8123ffa5>] xfs_file_aio_write+0x5a/0x5c
[16087.359872]  [<ffffffff810eabe6>] do_sync_write+0xc0/0x106
[16087.359872]  [<ffffffff810ebd8c>] ? fget_light+0x4f/0xfb
[16087.359872]  [<ffffffff81256e08>] ? security_file_permission+0x11/0x13
[16087.359872]  [<ffffffff810eb56f>] vfs_write+0xab/0x105
[16087.359872]  [<ffffffff810eb68d>] sys_write+0x47/0x70
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] test-mysqld   D ffff88001ec3e420  3232  2891   2877 0x000000=
00
[16087.359872]  ffff88001ee91e28 0000000000000046 ffff88001ee91da8
ffffffff810676b1
[16087.359872]  ffff88001ec3e420 000000000000def8 ffff88001ee91fd8
0000000000014180
[16087.359872]  ffff88001ee91fd8 0000000000014180 ffff88001ec3e420
ffff88001f152160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff81067901>] ? mark_held_locks+0x4d/0x6b
[16087.359872]  [<ffffffff8148f6b8>] ? __mutex_lock_common+0x216/0x330
[16087.359872]  [<ffffffff8148f6c0>] __mutex_lock_common+0x21e/0x330
[16087.359872]  [<ffffffff810eba12>] ? generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810eba12>] ? generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810ebd8c>] ? fget_light+0x4f/0xfb
[16087.359872]  [<ffffffff8148f881>] mutex_lock_nested+0x37/0x3c
[16087.359872]  [<ffffffff810eba12>] generic_file_llseek+0x2c/0x5e
[16087.359872]  [<ffffffff810ea6b4>] vfs_llseek+0x35/0x37
[16087.359872]  [<ffffffff810ea7cf>] sys_lseek+0x48/0x67
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] test-mysqld   D ffff88001ec3a160  4136  2892   2877 0x000000=
00
[16087.359872]  ffff88001e6d7e18 0000000000000046 ffffffff810b242d
ffffffff8105b193
[16087.359872]  000000010000000e 000000000000def8 ffff88001e6d7fd8
0000000000014180
[16087.359872]  ffff88001e6d7fd8 0000000000014180 ffff88001ec3a160
ffff88001e5e42c0
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff810b242d>] ? find_get_pages_tag+0x0/0x12a
[16087.359872]  [<ffffffff8105b193>] ? lock_hrtimer_base+0x25/0x4a
[16087.359872]  [<ffffffff81067901>] ? mark_held_locks+0x4d/0x6b
[16087.359872]  [<ffffffff8148f6b8>] ? __mutex_lock_common+0x216/0x330
[16087.359872]  [<ffffffff8148f6c0>] __mutex_lock_common+0x21e/0x330
[16087.359872]  [<ffffffff8110a3af>] ? vfs_fsync_range+0x6e/0xa6
[16087.359872]  [<ffffffff8110a3af>] ? vfs_fsync_range+0x6e/0xa6
[16087.359872]  [<ffffffff8148f881>] mutex_lock_nested+0x37/0x3c
[16087.359872]  [<ffffffff8110a3af>] vfs_fsync_range+0x6e/0xa6
[16087.359872]  [<ffffffff8110a454>] vfs_fsync+0x18/0x1a
[16087.359872]  [<ffffffff8110a488>] do_fsync+0x32/0x48
[16087.359872]  [<ffffffff8110a4bb>] sys_fsync+0xb/0xf
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] bash          S ffff88001e5e0000  5776  2893   2876 0x000000=
00
[16087.359872]  ffff88001ee57e58 0000000000000046 0000000000000000
0000000000000000
[16087.359872]  ffff88001ee57e08 000000000000def8 ffff88001ee57fd8
0000000000014180
[16087.359872]  ffff88001ee57fd8 0000000000014180 ffff88001e5e0000
ffffffff81a0e020
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81040671>] do_wait+0x1bd/0x22b
[16087.359872]  [<ffffffff810c885b>] ? might_fault+0x57/0xa4
[16087.359872]  [<ffffffff81040785>] sys_wait4+0xa6/0xc3
[16087.359872]  [<ffffffff8103ee89>] ? child_wait_callback+0x0/0x53
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] test-tar      D 0000000000000000  3320  2897   2893 0x000000=
00
[16087.359872]  ffff88001e6eb700 0000000000000046 ffff88001e6eb680
ffffffff810676b1
[16087.359872]  0000000000000000 000000000000def8 ffff88001e6ebfd8
0000000000014180
[16087.359872]  ffff88001e6ebfd8 0000000000014180 ffff88001e58a160
ffff88001ec1c2c0
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff8149022b>] rwsem_down_failed_common+0x9a/0xcc
[16087.359872]  [<ffffffff8127b18e>] ? cfq_close_cooperator+0xd9/0x184
[16087.359872]  [<ffffffff814902ad>] rwsem_down_read_failed+0x26/0x30
[16087.359872]  [<ffffffff81287384>] call_rwsem_down_read_failed+0x14/0x30
[16087.359872]  [<ffffffff8105b7ed>] ? down_read_nested+0x5b/0x62
[16087.359872]  [<ffffffff81221050>] ? xfs_ilock+0x7b/0xb2
[16087.359872]  [<ffffffff81221050>] xfs_ilock+0x7b/0xb2
[16087.359872]  [<ffffffff812210b0>] xfs_ilock_map_shared+0x29/0x2f
[16087.359872]  [<ffffffff8122762b>] xfs_iomap+0x9f/0x39c
[16087.359872]  [<ffffffff81066948>] ? register_lock_class+0x20/0x327
[16087.359872]  [<ffffffff8123bd40>] __xfs_get_blocks+0x71/0x15c
[16087.359872]  [<ffffffff8123be54>] xfs_get_blocks+0x12/0x14
[16087.359872]  [<ffffffff811137a1>] do_mpage_readpage+0x173/0x467
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff810b2d46>] ? add_to_page_cache_locked+0xa4/0xcd
[16087.359872]  [<ffffffff81113bc8>] mpage_readpages+0xd6/0x11a
[16087.359872]  [<ffffffff8123be42>] ? xfs_get_blocks+0x0/0x14
[16087.359872]  [<ffffffff8123be42>] ? xfs_get_blocks+0x0/0x14
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff8123cee4>] xfs_vm_readpages+0x1a/0x1c
[16087.359872]  [<ffffffff810ba6a2>] __do_page_cache_readahead+0x163/0x1fc
[16087.359872]  [<ffffffff810ba5ba>] ? __do_page_cache_readahead+0x7b/0x1fc
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff810ba757>] ra_submit+0x1c/0x20
[16087.359872]  [<ffffffff810baa7b>] ondemand_readahead+0x243/0x256
[16087.359872]  [<ffffffff810bab6e>] page_cache_sync_readahead+0x38/0x3a
[16087.359872]  [<ffffffff810b3cd7>] generic_file_aio_read+0x242/0x5a7
[16087.359872]  [<ffffffff81243d6d>] xfs_read+0x1a8/0x1ff
[16087.359872]  [<ffffffff8123ffff>] xfs_file_aio_read+0x58/0x5d
[16087.359872]  [<ffffffff810eacec>] do_sync_read+0xc0/0x106
[16087.359872]  [<ffffffff810372ec>] ? finish_task_switch+0x6f/0xad
[16087.359872]  [<ffffffff8103727d>] ? finish_task_switch+0x0/0xad
[16087.359872]  [<ffffffff8148eb33>] ? schedule+0x845/0x8bd
[16087.359872]  [<ffffffff81256e08>] ? security_file_permission+0x11/0x13
[16087.359872]  [<ffffffff810eb75e>] vfs_read+0xa8/0x102
[16087.359872]  [<ffffffff810eb87c>] sys_read+0x47/0x70
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] bash          S ffff88001e6e0000  4880  2898   2876 0x000000=
00
[16087.359872]  ffff88001f3dfe58 0000000000000046 0000000000000000
0000000000000000
[16087.359872]  ffff88001f3dfe08 000000000000def8 ffff88001f3dffd8
0000000000014180
[16087.359872]  ffff88001f3dffd8 0000000000014180 ffff88001e6e0000
ffff88001f965370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81040671>] do_wait+0x1bd/0x22b
[16087.359872]  [<ffffffff810c885b>] ? might_fault+0x57/0xa4
[16087.359872]  [<ffffffff81040785>] sys_wait4+0xa6/0xc3
[16087.359872]  [<ffffffff8103ee89>] ? child_wait_callback+0x0/0x53
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] syslog-ng     S ffff88001e6e10b0  6248  3348      1 0x000000=
00
[16087.359872]  ffff88001f373e58 0000000000000046 0000000000000002
0000000000000000
[16087.359872]  ffff88001f373e08 000000000000def8 ffff88001f373fd8
0000000000014180
[16087.359872]  ffff88001f373fd8 0000000000014180 ffff88001e6e10b0
ffff88001e5e6420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81040671>] do_wait+0x1bd/0x22b
[16087.359872]  [<ffffffff81040785>] sys_wait4+0xa6/0xc3
[16087.359872]  [<ffffffff8103ee89>] ? child_wait_callback+0x0/0x53
[16087.359872]  [<ffffffff810e9148>] ? sys_close+0x2d/0xe4
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] syslog-ng     S 0000000000000000  3832  3349   3348 0x000000=
00
[16087.359872]  ffff88001f3e9a58 0000000000000046 0000000000000000
0000000000000282
[16087.359872]  0000000000000040 000000000000def8 ffff88001f3e9fd8
0000000000014180
[16087.359872]  ffff88001f3e9fd8 0000000000014180 ffff88001e5e6420
ffff88001f965370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff8148f948>] schedule_hrtimeout_range+0xc2/0xf7
[16087.359872]  [<ffffffff8105a9e0>] ? hrtimer_wakeup+0x0/0x21
[16087.359872]  [<ffffffff8105b4eb>] ? hrtimer_start_range_ns+0xf/0x11
[16087.359872]  [<ffffffff810f8b92>] poll_schedule_timeout+0x46/0x69
[16087.359872]  [<ffffffff810f8fac>] do_sys_poll+0x36a/0x40b
[16087.359872]  [<ffffffff810f9d51>] ? __pollwait+0x0/0xcf
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810f9e20>] ? pollwake+0x0/0x5c
[16087.359872]  [<ffffffff810676b1>] ? mark_lock+0x22/0x225
[16087.359872]  [<ffffffff81067901>] ? mark_held_locks+0x4d/0x6b
[16087.359872]  [<ffffffff8103077e>] ? __wake_up+0x22/0x50
[16087.359872]  [<ffffffff81490baf>] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff81067b62>] ? trace_hardirqs_on_caller+0x10b/0x12f
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff81060016>] ? ktime_get_ts+0xb1/0xbe
[16087.359872]  [<ffffffff810f8b31>] ? poll_select_set_timeout+0x5c/0x77
[16087.359872]  [<ffffffff810f91e2>] sys_poll+0x50/0xba
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] flush-254:0   S 00000000000493e0  5216  4467      2 0x000000=
00
[16087.359872]  ffff88001e783db0 0000000000000046 ffff88001e623210
ffffffff81490baf
[16087.359872]  ffff88001f95c000 000000000000def8 ffff88001e783fd8
0000000000014180
[16087.359872]  ffff88001e783fd8 0000000000014180 ffff88001e623210
ffff88001f152160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81490baf>] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[16087.359872]  [<ffffffff8104b617>] ? __mod_timer+0x141/0x153
[16087.359872]  [<ffffffff8104b45f>] ? init_timer_key+0x8d/0x99
[16087.359872]  [<ffffffff8148efbb>] schedule_timeout+0xa2/0xc9
[16087.359872]  [<ffffffff8104b095>] ? process_timeout+0x0/0xb
[16087.359872]  [<ffffffff8148f031>] schedule_timeout_interruptible+0x19/0x=
1b
[16087.359872]  [<ffffffff811075a4>] bdi_writeback_task+0x82/0xa9
[16087.359872]  [<ffffffff810c789c>] ? bdi_start_fn+0x0/0xd4
[16087.359872]  [<ffffffff810c790d>] bdi_start_fn+0x71/0xd4
[16087.359872]  [<ffffffff810c789c>] ? bdi_start_fn+0x0/0xd4
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] flush-254:16  S 00000000000493e0  6208  4702      2 0x000000=
00
[16087.359872]  ffff88001e6cddb0 0000000000000046 0000000000000000
ffffffff81490baf
[16087.359872]  ffff88001f970000 000000000000def8 ffff88001e6cdfd8
0000000000014180
[16087.359872]  ffff88001e6cdfd8 0000000000014180 ffff88001e5e5370
ffff88001f965370
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81490baf>] ? _raw_spin_unlock_irqrestore+0x3f/0x47
[16087.359872]  [<ffffffff8104b617>] ? __mod_timer+0x141/0x153
[16087.359872]  [<ffffffff8104b45f>] ? init_timer_key+0x8d/0x99
[16087.359872]  [<ffffffff8148efbb>] schedule_timeout+0xa2/0xc9
[16087.359872]  [<ffffffff8104b095>] ? process_timeout+0x0/0xb
[16087.359872]  [<ffffffff8148f031>] schedule_timeout_interruptible+0x19/0x=
1b
[16087.359872]  [<ffffffff811075a4>] bdi_writeback_task+0x82/0xa9
[16087.359872]  [<ffffffff810c789c>] ? bdi_start_fn+0x0/0xd4
[16087.359872]  [<ffffffff810c790d>] bdi_start_fn+0x71/0xd4
[16087.359872]  [<ffffffff810c789c>] ? bdi_start_fn+0x0/0xd4
[16087.359872]  [<ffffffff81057842>] kthread+0x7d/0x85
[16087.359872]  [<ffffffff81003894>] kernel_thread_helper+0x4/0x10
[16087.359872]  [<ffffffff81490f3c>] ? restore_args+0x0/0x30
[16087.359872]  [<ffffffff810577c5>] ? kthread+0x0/0x85
[16087.359872]  [<ffffffff81003890>] ? kernel_thread_helper+0x0/0x10
[16087.359872] bash          S ffff88001dcb10b0  4616  4754   2876 0x000000=
00
[16087.359872]  ffff88001f371e58 0000000000000046 0000000000000002
0000000000000000
[16087.359872]  ffff88001f371e08 000000000000def8 ffff88001f371fd8
0000000000014180
[16087.359872]  ffff88001f371fd8 0000000000014180 ffff88001dcb10b0
ffff88001f152160
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81040671>] do_wait+0x1bd/0x22b
[16087.359872]  [<ffffffff810c885b>] ? might_fault+0x57/0xa4
[16087.359872]  [<ffffffff81040785>] sys_wait4+0xa6/0xc3
[16087.359872]  [<ffffffff8103ee89>] ? child_wait_callback+0x0/0x53
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] sync          D 0000000000000000  4896  4761   4754 0x000000=
00
[16087.359872]  ffff88001edafcd8 0000000000000046 0000000000000000
ffffffff81067901
[16087.359872]  ffff88001e5e42c0 000000000000def8 ffff88001edaffd8
0000000000014180
[16087.359872]  ffff88001edaffd8 0000000000014180 ffff88001e5e42c0
ffff88001f916420
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81067901>] ? mark_held_locks+0x4d/0x6b
[16087.359872]  [<ffffffff81057eed>] ? prepare_to_wait+0x70/0x7b
[16087.359872]  [<ffffffff8123d0e0>] xfs_ioend_wait+0x83/0x9b
[16087.359872]  [<ffffffff81057cb4>] ? autoremove_wake_function+0x0/0x38
[16087.359872]  [<ffffffff810b90a6>] ? mapping_tagged+0x60/0x69
[16087.359872]  [<ffffffff810b9046>] ? mapping_tagged+0x0/0x69
[16087.359872]  [<ffffffff81246621>] xfs_sync_inode_data+0x98/0xbf
[16087.359872]  [<ffffffff81246773>] xfs_inode_ag_walk+0x9d/0xdc
[16087.359872]  [<ffffffff81246589>] ? xfs_sync_inode_data+0x0/0xbf
[16087.359872]  [<ffffffff81246808>] xfs_inode_ag_iterator+0x56/0x84
[16087.359872]  [<ffffffff81246589>] ? xfs_sync_inode_data+0x0/0xbf
[16087.359872]  [<ffffffff812469d0>] xfs_sync_data+0x26/0x4e
[16087.359872]  [<ffffffff81246a47>] xfs_quiesce_data+0x1e/0x57
[16087.359872]  [<ffffffff81244359>] xfs_fs_sync_fs+0x26/0xd7
[16087.359872]  [<ffffffff8112fa4e>] ? vfs_quota_sync+0x1b7/0x1c8
[16087.359872]  [<ffffffff81131394>] sync_quota_sb+0x4e/0x103
[16087.359872]  [<ffffffff8110a5ff>] __sync_filesystem+0x41/0x72
[16087.359872]  [<ffffffff8110a6da>] sync_filesystems+0xaa/0x100
[16087.359872]  [<ffffffff8110a781>] sys_sync+0x1c/0x2e
[16087.359872]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[16087.359872] test-malloc   R  running task     4616  4765   2898 0x000000=
00
[16087.359872]  ffff88001f3abdb8 0000000000000040 0000000000000001
ffff88001f3abea8
[16087.359872]  ffff88000268e720 ffffffff81063fa4 ffff88001f3abe48
ffffffff8105b465
[16087.359872]  ffff88001dcb5370 000000000000e6b0 0000000100000001
000000000000c350
[16087.359872] Call Trace:
[16087.359872]  [<ffffffff81067b93>] ? trace_hardirqs_on+0xd/0xf
[16087.359872]  [<ffffffff8148f9ff>] ? do_nanosleep+0x73/0xb3
[16087.359872]  [<ffffffff8105b578>] ? hrtimer_nanosleep+0x8b/0xf9
[16087.359872]  [<ffffffff8105a9e0>] ? hrtimer_wakeup+0x0/0x21
[16087.359872]  [<ffffffff8105b4eb>] ? hrtimer_start_range_ns+0xf/0x11
[16087.359872]  [<ffffffff8105b644>] ? sys_nanosleep+0x5e/0x78
[16087.359872]  [<ffffffff81002a6b>] ? system_call_fastpath+0x16/0x1b
[16087.359872]
[16087.359872] Showing all locks held in the system:
[16087.359872] 2 locks held by xfsdatad/0/414:
[16087.359872]  #0:  (xfsdatad){+.+...}, at: [<ffffffff81053da4>]
worker_thread+0x1d5/0x332
[16087.359872]  #1:  ((&ioend->io_work)){+.+...}, at:
[<ffffffff81053da4>] worker_thread+0x1d5/0x332
[16087.359872] 2 locks held by xfsdatad/2/416:
[16087.359872]  #0:  (xfsdatad){+.+...}, at: [<ffffffff81053da4>]
worker_thread+0x1d5/0x332
[16087.359872]  #1:  ((&ioend->io_work)){+.+...}, at:
[<ffffffff81053da4>] worker_thread+0x1d5/0x332
[16087.359872] 1 lock held by agetty/2848:
[16087.359872]  #0:  (&tty->atomic_read_lock){+.+.+.}, at:
[<ffffffff812a9599>] n_tty_read+0x2d8/0x7f3
[16087.359872] 1 lock held by agetty/2849:
[16087.359872]  #0:  (&tty->atomic_read_lock){+.+.+.}, at:
[<ffffffff812a9599>] n_tty_read+0x2d8/0x7f3
[16087.359872] 1 lock held by agetty/2850:
[16087.359872]  #0:  (&tty->atomic_read_lock){+.+.+.}, at:
[<ffffffff812a9599>] n_tty_read+0x2d8/0x7f3
[16087.359872] 1 lock held by agetty/2851:
[16087.359872]  #0:  (&tty->atomic_read_lock){+.+.+.}, at:
[<ffffffff812a9599>] n_tty_read+0x2d8/0x7f3
[16087.359872] 1 lock held by agetty/2852:
[16087.359872]  #0:  (&tty->atomic_read_lock){+.+.+.}, at:
[<ffffffff812a9599>] n_tty_read+0x2d8/0x7f3
[16087.359872] 2 locks held by bash/2853:
[16087.359872]  #0:  (sysrq_key_table_lock){......}, at:
[<ffffffff812babae>] __handle_sysrq+0x26/0x158
[16087.359872]  #1:  (tasklist_lock){.+.+..}, at: [<ffffffff8106733d>]
debug_show_all_locks+0x53/0x188
[16087.359872] 1 lock held by test-mysqld/2882:
[16087.359872]  #0:  (&(&ip->i_iolock)->mr_lock){++++++}, at:
[<ffffffff8122101e>] xfs_ilock+0x49/0xb2
[16087.359872] 1 lock held by test-mysqld/2883:
[16087.359872]  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at:
[<ffffffff810eba12>] generic_file_llseek+0x2c/0x5e
[16087.359872] 1 lock held by test-mysqld/2884:
[16087.359872]  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at:
[<ffffffff810eba12>] generic_file_llseek+0x2c/0x5e
[16087.359872] 2 locks held by test-mysqld/2885:
[16087.359872]  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at:
[<ffffffff81243420>] xfs_write+0x2bf/0x793
[16087.359872]  #1:  (&(&ip->i_iolock)->mr_lock){++++++}, at:
[<ffffffff81221001>] xfs_ilock+0x2c/0xb2
[16087.359872] 1 lock held by test-mysqld/2886:
[16087.359872]  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at:
[<ffffffff810eba12>] generic_file_llseek+0x2c/0x5e
[16087.359872] 1 lock held by test-mysqld/2887:
[16087.359872]  #0:  (&(&ip->i_iolock)->mr_lock){++++++}, at:
[<ffffffff8122101e>] xfs_ilock+0x49/0xb2
[16087.359872] 1 lock held by test-mysqld/2888:
[16087.359872]  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at:
[<ffffffff810eba12>] generic_file_llseek+0x2c/0x5e
[16087.359872] 1 lock held by test-mysqld/2889:
[16087.359872]  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at:
[<ffffffff810eba12>] generic_file_llseek+0x2c/0x5e
[16087.359872] 1 lock held by test-mysqld/2890:
[16087.359872]  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at:
[<ffffffff81243420>] xfs_write+0x2bf/0x793
[16087.359872] 1 lock held by test-mysqld/2891:
[16087.359872]  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at:
[<ffffffff810eba12>] generic_file_llseek+0x2c/0x5e
[16087.359872] 1 lock held by test-mysqld/2892:
[16087.359872]  #0:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at:
[<ffffffff8110a3af>] vfs_fsync_range+0x6e/0xa6
[16087.359872] 2 locks held by test-tar/2897:
[16087.359872]  #0:  (&(&ip->i_iolock)->mr_lock){++++++}, at:
[<ffffffff8122101e>] xfs_ilock+0x49/0xb2
[16087.359872]  #1:  (&(&ip->i_lock)->mr_lock){++++..}, at:
[<ffffffff81221050>] xfs_ilock+0x7b/0xb2
[16087.359872] 2 locks held by sync/4761:
[16087.359872]  #0:  (mutex){+.+...}, at: [<ffffffff8110a64e>]
sync_filesystems+0x1e/0x100
[16087.359872]  #1:  (&type->s_umount_key#24){.+.+..}, at:
[<ffffffff8110a6b8>] sync_filesystems+0x88/0x100
[16087.359872]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
