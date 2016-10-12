Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753583AbcJLQWc (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 Oct 2016 12:22:32 -0400
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 012D415568
        for <linux-xfs@vger.kernel.org>; Wed, 12 Oct 2016 16:15:20 +0000 (UTC)
Received: from [10.10.60.218] (vpn-60-218.rdu2.redhat.com [10.10.60.218])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u9CGFIhv016298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA256 bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Oct 2016 12:15:19 -0400
From: "Benjamin Coddington" <bcodding@redhat.com>
Subject: SEEK_HOLE second hole problem
Date: Wed, 12 Oct 2016 12:15:18 -0400
Message-ID: <2303295B-3B56-404D-BAE3-A644D67EEC49@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

While investigating generic/285 failure on NFS on an XFS export I think 
I
found a seek hole bug.

For a file with a hole/data pattern of hole, data, hole, data; it 
appears
that SEEK_HOLE for pattern chunks larger than 65536 will be incorrect 
for
seeking the start of the next hole after the first hole.

Here's my little test program:

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

#define SEEK_HOLE      4
//#define CHUNK 65536
#define CHUNK 69632

int main(int argc, char **argv)
{
         int fd;
         off_t pos;
         char *buf = NULL;

         buf = malloc(4096);
         memset(buf, 'a', 4096);

         fd = open(argv[1], O_RDWR|O_CREAT|O_TRUNC, 0644);

         for (pos = CHUNK; pos < CHUNK*2; pos += 4096)
             pwrite(fd, buf, 4096, pos);

         for (pos = CHUNK*3; pos < CHUNK*4; pos += 4096)
             pwrite(fd, buf, 4096, pos);

         pos = lseek(fd, CHUNK, SEEK_HOLE);
         printf("SEEK_HOLE found second hole at %llu, expecting %llu\n", 
pos, CHUNK*2);

         close(fd);
}

[root@fedora ~]# ./test /exports/scratch/foo
SEEK_HOLE found second hole at 196608, expecting 139264

This is on 4.8, I did a bit of digging through XFS to see if I could 
find
the problem, and it looks like XFS is interesting enough that I could 
spend
all my time reading it... but I couldn't make serious progress and I 
have to
go back to my actual job.

Let me know how I can help, or if I am just doing something exceedingly
stupid..

Ben
