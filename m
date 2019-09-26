Return-Path: <SRS0=9/io=XV=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C5E1C432C2
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 10:57:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24356207E0
	for <linux-xfs@archiver.kernel.org>; Thu, 26 Sep 2019 10:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbfIZK5x (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 26 Sep 2019 06:57:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57608 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfIZK5x (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Sep 2019 06:57:53 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 38EA218C4269;
        Thu, 26 Sep 2019 10:57:52 +0000 (UTC)
Received: from dresden.str.redhat.com (unknown [10.40.205.151])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FF3F60126;
        Thu, 26 Sep 2019 10:57:51 +0000 (UTC)
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
From:   Max Reitz <mreitz@redhat.com>
Subject: xfs_alloc_file_space() rounds len independently of offset
Autocrypt: addr=mreitz@redhat.com; prefer-encrypt=mutual; keydata=
 mQENBFXOJlcBCADEyyhOTsoa/2ujoTRAJj4MKA21dkxxELVj3cuILpLTmtachWj7QW+TVG8U
 /PsMCFbpwsQR7oEy8eHHZwuGQsNpEtNC2G/L8Yka0BIBzv7dEgrPzIu+W3anZXQW4702+uES
 U29G8TP/NGfXRRHGlbBIH9KNUnOSUD2vRtpOLXkWsV5CN6vQFYgQfFvmp5ZpPeUe6xNplu8V
 mcTw8OSEDW/ZnxJc8TekCKZSpdzYoxfzjm7xGmZqB18VFwgJZlIibt1HE0EB4w5GsD7x5ekh
 awIe3RwoZgZDLQMdOitJ1tUc8aqaxvgA4tz6J6st8D8pS//m1gAoYJWGwwIVj1DjTYLtABEB
 AAG0HU1heCBSZWl0eiA8bXJlaXR6QHJlZGhhdC5jb20+iQFTBBMBCAA9AhsDBQkSzAMABQsJ
 CAcCBhUICQoLAgQWAgMBAh4BAheABQJVzie5FRhoa3A6Ly9rZXlzLmdudXBnLm5ldAAKCRD0
 B9sAYdXPQDcIB/9uNkbYEex1rHKz3mr12uxYMwLOOFY9fstP5aoVJQ1nWQVB6m2cfKGdcRe1
 2/nFaHSNAzT0NnKz2MjhZVmcrpyd2Gp2QyISCfb1FbT82GMtXFj1wiHmPb3CixYmWGQUUh+I
 AvUqsevLA+WihgBUyaJq/vuDVM1/K9Un+w+Tz5vpeMidlIsTYhcsMhn0L9wlCjoucljvbDy/
 8C9L2DUdgi3XTa0ORKeflUhdL4gucWoAMrKX2nmPjBMKLgU7WLBc8AtV+84b9OWFML6NEyo4
 4cP7cM/07VlJK53pqNg5cHtnWwjHcbpGkQvx6RUx6F1My3y52vM24rNUA3+ligVEgPYBuQEN
 BFXOJlcBCADAmcVUNTWT6yLWQHvxZ0o47KCP8OcLqD+67T0RCe6d0LP8GsWtrJdeDIQk+T+F
 xO7DolQPS6iQ6Ak2/lJaPX8L0BkEAiMuLCKFU6Bn3lFOkrQeKp3u05wCSV1iKnhg0UPji9V2
 W5eNfy8F4ZQHpeGUGy+liGXlxqkeRVhLyevUqfU0WgNqAJpfhHSGpBgihUupmyUg7lfUPeRM
 DzAN1pIqoFuxnN+BRHdAecpsLcbR8sQddXmDg9BpSKozO/JyBmaS1RlquI8HERQoe6EynJhd
 64aICHDfj61rp+/0jTIcevxIIAzW70IadoS/y3DVIkuhncgDBvGbF3aBtjrJVP+5ABEBAAGJ
 ASUEGAEIAA8FAlXOJlcCGwwFCRLMAwAACgkQ9AfbAGHVz0CbFwf9F/PXxQR9i4N0iipISYjU
 sxVdjJOM2TMut+ZZcQ6NSMvhZ0ogQxJ+iEQ5OjnIputKvPVd5U7WRh+4lF1lB/NQGrGZQ1ic
 alkj6ocscQyFwfib+xIe9w8TG1CVGkII7+TbS5pXHRxZH1niaRpoi/hYtgzkuOPp35jJyqT/
 /ELbqQTDAWcqtJhzxKLE/ugcOMK520dJDeb6x2xVES+S5LXby0D4juZlvUj+1fwZu+7Io5+B
 bkhSVPb/QdOVTpnz7zWNyNw+OONo1aBUKkhq2UIByYXgORPFnbfMY7QWHcjpBVw9MgC4tGeF
 R4bv+1nAMMxKmb5VvQCExr0eFhJUAHAhVg==
Message-ID: <6d62fb2a-a4e6-3094-c1bf-0ca5569b244c@redhat.com>
Date:   Thu, 26 Sep 2019 12:57:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Thu, 26 Sep 2019 10:57:52 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I’ve noticed that fallocating some range on XFS sometimes does not
include the last block covered by the range, when the start offset is
unaligned.

(Tested on 5.3.0-gf41def397.)

This happens whenever ceil((offset + len) / block_size) - floor(offset /
block_size) > ceil(len / block_size), for example:

Let block_size be 4096.  Then (on XFS):

$ fallocate -o 2048 -l 4096 foo   # Range [2048, 6144)
$ xfs_bmap foo
foo:
        0: [0..7]: 80..87
        1: [8..15]: hole

There should not be a hole there.  Both of the first two blocks should
be allocated.  XFS will do that if I just let the range start one byte
sooner and increase the length by one byte:

$ rm -f foo
$ fallocate -o 2047 -l 4097 foo   # Range [2047, 6144)
$ xfs_bmap foo
foo:
        0: [0..15]: 88..103


(See [1] for a more extensive reasoning why this is a bug.)


The problem is (as far as I can see) that xfs_alloc_file_space() rounds
count (which equals len) independently of the offset.  So in the
examples above, 4096 is rounded to one block and 4097 is rounded to two;
even though the first example actually touches two blocks because of the
misaligned offset.

Therefore, this should fix the problem (and does fix it for me):

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0910cb75b..4f4437030 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -864,6 +864,7 @@ xfs_alloc_file_space(
 	xfs_filblks_t		allocatesize_fsb;
 	xfs_extlen_t		extsz, temp;
 	xfs_fileoff_t		startoffset_fsb;
+	xfs_fileoff_t		endoffset_fsb;
 	int			nimaps;
 	int			quota_flag;
 	int			rt;
@@ -891,7 +892,8 @@ xfs_alloc_file_space(
 	imapp = &imaps[0];
 	nimaps = 1;
 	startoffset_fsb	= XFS_B_TO_FSBT(mp, offset);
-	allocatesize_fsb = XFS_B_TO_FSB(mp, count);
+	endoffset_fsb = XFS_B_TO_FSB(mp, offset + count);
+	allocatesize_fsb = endoffset_fsb - startoffset_fsb;

 	/*
 	 * Allocate file space until done or until there is an error


Thanks and kind regards,

Max


[1] That this is a bug can be proven as follows:

1. The fallocate(2) man page states "subsequent writes into the range
specified by offset and len are guaranteed not to fail because of lack
of disk space."

2. Run this test (anywhere, e.g. tmpfs):

$ truncate -s $((4096 * 4096)) test_fs
$ mkfs.xfs -b size=4096 test_fs
[Success-indicating output, I hope]

$ mkdir mount_point
$ sudo mount -o loop test_fs mount_point
$ sudo chmod go+rwx mount_point
$ cd mount_point

$ free_blocks=$(df -B4k . | tail -n 1 \
      | awk '{ split($0, f); print f[4] }')

$ falloc_length=$((free_blocks * 4096))

$ while true; do \
     fallocate -o 2048 -l $falloc_length test_file && break; \
     falloc_length=$((falloc_length - 4096)); \
done
fallocate: fallocate failed: No space left on device
fallocate: fallocate failed: No space left on device
fallocate: fallocate failed: No space left on device
fallocate: fallocate failed: No space left on device

  # Now we have a test_file with an fallocated range of
  # [2048, 2048 + $falloc_length)
  # So we should be able to write anywhere in that area without
  # encountering ENOSPC; but that is what happens when we write
  # to the last block covered by the range:

$ dd if=/dev/zero of=test_file bs=1 conv=notrunc \
    seek=$falloc_length count=2048
dd: error writing 'test_file': No space left on device
1+0 records in
0+0 records out
0 bytes copied, 0.000164691 s, 0.0 kB/s


When I apply the diff shown above, I get one more “No space left on
device” line (indicating that fallocate consistently takes one
additional block), and then:

$ uname -sr
Linux 5.3.0-gf41def397-dirty

$ dd if=/dev/zero of=test_file bs=1 conv=notrunc \
    seek=$falloc_length count=2048
2048+0 records in
2048+0 records out
2048 bytes (2.0 kB, 2.0 KiB) copied, 0.0121903 s, 168 kB/s

(i.e., what I’d expect)
