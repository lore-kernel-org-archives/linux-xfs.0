Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Oct 2007 06:43:18 -0700 (PDT)
Received: from smtp.aaisp.net.uk (smtp.aaisp.net.uk [81.187.81.52])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9DDh7cu024734
	for <xfs@oss.sgi.com>; Sat, 13 Oct 2007 06:43:08 -0700
Received: from zeus.pccl.info ([81.2.82.67])
	by smtp.aaisp.net.uk with esmtp (Exim 4.62)
	(envelope-from <andrew@digital-domain.net>)
	id 1IfH8O-0007qv-Sx
	for xfs@oss.sgi.com; Tue, 09 Oct 2007 16:36:38 +0100
Date: Tue, 9 Oct 2007 16:36:35 +0100
From: Andrew Clayton <andrew@digital-domain.net>
Subject: Latencies in XFS.
Message-ID: <20071009163635.413dec0c@zeus.pccl.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I'll try not to flood with information on the first post.

In trying to track down this issue here:
http://www.spinics.net/lists/raid/msg17195.html

I think I have narrowed it down to XFS.

The basic problem I am seeing is that applications on client
workstations whose home directories are NFS mounted are stalling in
filesystem calls such as open, close, unlink.

I have eventually come up with a simple test case which shows the
problem (well the seeming filesystem stalls anyway). I did this on my
machine at home, Athlon XP 768MB RAM, XFS is on a Seagate IDE. Kernel is
2.8.23-rc9-current git 

(Oh yeah, no networking/NFS is involved here)

If I run the following program

/* fslattest.c */

#define _GNU_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <string.h>


int main(int argc, char *argv[])
{
        char file[255];

        if (argc < 2) {
                printf("Usage: fslattest file\n");
                exit(1);
        }

        strncpy(file, argv[1], 254);
        printf("Opening %s\n", file);

        while (1) {
                int testfd = open(file, 
                        O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600);
                close(testfd);
                unlink(file);
                sleep(1);
        }

        exit(0);
}


e.g $ strace -T -e open fslattest test

And then after a few seconds run

$ dd if=/dev/zero of=bigfile bs=1M count=500

I see the following

Before dd kicks in

open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.005043>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000212>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.016844>

while dd is running

open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <2.000348>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <1.594441>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <2.224636>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <1.074615>

dd stopped

open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.013224>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.007109>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.007108>


Doing the same thing with ext3 shows no such stalls. e.g before, during
and after the above dd

open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.015423>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000092>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000093>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000088>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000103>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000096>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000094>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000114>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000091>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000274>
open("test", O_WRONLY|O_CREAT|O_EXCL|O_TRUNC|O_LARGEFILE, 0600) = 3 <0.000107>


I Just tried the above on a machine here in the office. It seems to
have a much faster disk than mine, and the latencies aren't quite a
dramatic upto about 1.0 seconds. Mounting with nobarrier reduces that
to generally < 0.5 seconds. 

Just ask if you'd like more info.


Cheers,

Andrew
