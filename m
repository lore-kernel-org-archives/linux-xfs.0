Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 May 2008 22:11:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4J5BUbQ016778
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 22:11:32 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51A29B876C0
	for <xfs@oss.sgi.com>; Sun, 18 May 2008 22:12:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id UnUP1zqWG4THzqMG for <xfs@oss.sgi.com>; Sun, 18 May 2008 22:12:13 -0700 (PDT)
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 5BB15A9C509
	for <xfs@oss.sgi.com>; Mon, 19 May 2008 00:12:10 -0500 (CDT)
Message-ID: <48310C29.2040500@sandeen.net>
Date: Mon, 19 May 2008 00:12:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: QA test for mounting with external log
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

This could probably use some cleanup but something like this
would have caught that recent regression.

Thanks,
-Eric

#! /bin/sh
# FS QA Test No. 188
#
# Test mounting with a device-sized external log
#
#-----------------------------------------------------------------------
# Copyright (c) 2000-2005 Silicon Graphics, Inc.  All Rights Reserved.
#-----------------------------------------------------------------------
#
# creator
owner=sandeen-xfs@sandeen.net

seq=`basename $0`
echo "QA output created by $seq"

here=`pwd`
tmp=/tmp/$$
status=1	# failure is the default!
trap "_cleanup; exit \$status" 0 1 2 3 15

_cleanup()
{
    cd /
    rm -f $tmp.*
    losetup -d /dev/loop2
}

# get standard environment, filters and checks
. ./common.rc
. ./common.filter
rm -f $seq.full

# real QA test starts here

# Modify as appropriate.
_require_scratch
_supported_fs xfs
_supported_os Linux # (for losetup)

export MKFS_OPTIONS=""
export MOUNT_OPTIONS=""

dd if=/dev/zero bs=1M count=16 of=$tmp.logfile >/dev/null
losetup /dev/loop2 $tmp.logfile
_scratch_mkfs -llogdev=/dev/loop2 >/dev/null 2>&1
_scratch_mount -o logdev=/dev/loop2
umount $SCRATCH_DEV

# success, all done
status=0
exit
