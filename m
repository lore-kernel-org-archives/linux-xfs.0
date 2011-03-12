Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2C31DRB195805 for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 21:01:24 -0600
Received: from e31.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B58B61B09519
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 19:03:53 -0800 (PST)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id la01pQjpWOlSZgEK for
	<xfs@oss.sgi.com>; Fri, 11 Mar 2011 19:03:53 -0800 (PST)
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com
	[9.17.195.107])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2C2mjhD003958
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 19:48:45 -0700
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p2C33rft104130 for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 20:03:53 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p2C33r9M028039
	for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 20:03:53 -0700
Received: from [9.47.24.164] (chandra-lucid.beaverton.ibm.com [9.47.24.164])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p2C33qBl028015 for <xfs@oss.sgi.com>; Fri, 11 Mar 2011 20:03:52 -0700
Subject: testcase 011 trips and ASSERT in x86_64 too
From: Chandra Seetharaman <sekharan@us.ibm.com>
Content-Type: multipart/mixed; boundary="=-+dWvLbSMxQrWvDwVyQrJ"
Date: Fri, 11 Mar 2011 19:06:06 -0800
Message-ID: <1299899166.32230.629.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: XFS Mailing List <xfs@oss.sgi.com>


--=-+dWvLbSMxQrWvDwVyQrJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hello,

A while back I reported that the test case 011 trips an ASSERT on POWER
architecture, but not in x86_64.

I started comparing the code and quickly realized that the problem is
_not_ arch specific, but could make the test case 011 fail, with reduced
log on x86_64. But, I could make the POWER not fail by simply increasing
the file system size to 100G (from 20G).

After some debug I found that I get into this racy situation when the
free threshold drops and we flush the log buffer to the disk.
i.e in function xlog_grant_push_ail(), if we return at

       if (free_blocks >= free_threshold)
                return;
we do not get into the race that trips the ASSERT.

Then I started comparing the behavioral difference bet the two ARCHs,
and I found that in POWER I see more number of threads at a time (max of
4 threads) in the function xlog_grant_log_space(), whereas in x86_64 I
see max of only two and mostly it is only one.

I also noted that in POWER test case 011 takes about 8 seconds whereas
in x86_64, it takes about 165 seconds.

So, I ventured into the core of test case 011, dirstress, and found that
simply creating 1000s of files under a directory takes very long time in
x86_64 compare to POWER(1 min 15s Vs 2s)
Note: Attached is the source file (stripped version of dirstress.c) for
the program b.
------------------POWER----------------------------------
root@test135 chandra]# uname -a 
Linux test135.beaverton.ibm.com 2.6.38-rc7 #1 SMP Fri Mar 4 09:36:14 PST
2011 ppc64 ppc64 ppc64 GNU/Linux
[root@test135 chandra]# grep -e xfs -e home /proc/mounts
none /selinux selinuxfs rw,relatime 0 0
/dev/mapper/vg_test135-lv_home /home ext4
rw,seclabel,relatime,barrier=1,data=ordered 0 0
/dev/sda8 /mnt/xfsMntPt xfs rw,seclabel,relatime,attr2,noquota 0 0
[root@test135 chandra]# ###### Run test on XFS filesystem
[root@test135 chandra]# time ./b /mnt/xfsMntPt/dir 10000 1
i 0

real    0m2.055s
user    0m0.011s
sys     0m0.732s
[root@test135 chandra]# ###### Run test of ext4 filesystem
[root@test135 chandra]# time ./b /home/dir 10000 1
i 0

real    0m0.355s
user    0m0.009s
sys     0m0.304s
--------------------x86_64----------------------------------------
[root@test27 chandra]# uname -a
Linux test27 2.6.38-rc7 #4 SMP Wed Mar 9 08:37:32 PST 2011 x86_64 x86_64
x86_64 GNU/Linux
[root@test27 chandra]# grep -e xfs -e home /proc/mounts
none /selinux selinuxfs rw,relatime 0 0
/dev/sdc3 /home ext4 rw,seclabel,relatime,barrier=1,data=ordered 0 0
/dev/sdb1 /mnt/xfsMntPt xfs rw,seclabel,relatime,attr2,noquota 0 0
[root@test27 chandra]# ###### Run test on XFS filesystem
[root@test27 chandra]# time ./b /mnt/xfsMntPt/dir 10000 1
i 0

real    1m15.700s
user    0m0.030s
sys     0m1.679s
[root@test27 chandra]# ###### Run test of ext4 filesystem
[root@test27 chandra]# time ./b /home/dir 10000 1
i 0

real    0m0.317s
user    0m0.010s
sys     0m0.306s
-------------------------------------------------------------------

After quite an amount of debug I found that I can make it trip the
ASSERT in x86_64 also, if I start sufficient of threads accessing the
file system. Basically, "./b /mnt/xfsMntPt/dir 100 100" trips the
ASSERT.

I have two questions:

1. Does anybody have any explanation why x86_64 is so slow, compared
with POWER ?

2. Any suggestions on how to debug and fix the race condition ? 

Thanks & Regards,

chandra

--=-+dWvLbSMxQrWvDwVyQrJ
Content-Disposition: attachment; filename="b.c"
Content-Type: text/x-csrc; name="b.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#include <unistd.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define MKNOD_DEV 0

int
dirstress(char *dir, int num_files, int prefix)
{
	int i, err, fd;
	char buf[128];

	err = chdir(dir);
	if (err) {
		perror("cannot chdir to directory");
		return 1;
	}

	sprintf(buf, "dir%d", prefix);
	err = mkdir(buf, 0777);
	if (err) {
		perror("mkdir");
		return 1;
	}
	err = chdir(buf);
	if (err) {
		perror("cannot chdir to prefix");
		return 1;
	}

	for (i = 0; i < num_files; i++) {
		sprintf(buf, "XXXXXXXXXXXX.%d.%d", prefix, i);
		switch (i % 4) {
		case 0:
			/*
			 * Create a file
			 */
			fd = creat(buf, 0666);
			if (fd > 0) {
				close(fd);
			} else {
                                fprintf(stderr,"!! close %s failed\n", buf);
                                perror("close");
                        }
                        
			break;
		case 1:
			/*
			 * Make a directory.
			 */
			if (mkdir(buf, 0777)) {
                            fprintf(stderr,"!! mkdir %s 0777 failed\n", buf);
                            perror("mkdir");
                        }
                        
			break;
		case 2:
			/*
			 * Make a symlink
			 */
			if (symlink(buf, buf)) {
                            fprintf(stderr,"!! symlink %s %s failed\n", buf, buf);
                            perror("symlink");
                        }
                        
			break;
		case 3:
			/*
			 * Make a dev node
			 */
			if (mknod(buf, S_IFCHR | 0666, MKNOD_DEV)) {
                            fprintf(stderr,"!! mknod %s 0x%x failed\n", buf, MKNOD_DEV);
                            perror("mknod");
                        }
                        
			break;
		default:
			break;
		}
	}
	return 0;
}

main(int argc, char *argv[])
{
	pid_t pid;
	int i, count;

	if (argc != 4) {
		printf("Usage: %s directory num_files numprocs\n", argv[0]);
		exit(1);
	}
#if 0
	exit(dirstress(argv[1], atoi(argv[2])));
#else
	for (i = 0; i < atoi(argv[3]); i++) {
		printf("i %d\n", i);
		pid = fork();
		if (pid < 0) {
			perror("fork");
			goto done;
		}
		if (pid == 0) {
			exit(dirstress(argv[1], atoi(argv[2]), i));
		}
	}
done:
	while (wait(&count) != -1)
		;
	exit(0);
#endif
}

--=-+dWvLbSMxQrWvDwVyQrJ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--=-+dWvLbSMxQrWvDwVyQrJ--
