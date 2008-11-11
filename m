Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Nov 2008 22:11:30 -0800 (PST)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAB6BLFC022826
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2008 22:11:21 -0800
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by netops-testserver-3.corp.sgi.com (Postfix) with SMTP id 6DB1A9088F
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2008 22:11:18 -0800 (PST)
Received: from boing.melbourne.sgi.com (boing.melbourne.sgi.com [134.14.55.141]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id RAA20421 for <xfs@oss.sgi.com>; Tue, 11 Nov 2008 17:11:16 +1100
Message-ID: <49192204.3040300@sgi.com>
Date: Tue, 11 Nov 2008 17:11:16 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: review: xfstests/192 atime test
Content-Type: multipart/mixed;
 boundary="------------000805090200060303090001"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------000805090200060303090001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Attached simple atime test.
192.out and group file would be added appropriately.
Thanks.
--Tim

--------------000805090200060303090001
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="192"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="192"

#! /bin/sh
# FS QA Test No. 192
#
# Simple test of atime - ensure it is persistent after unmount
#
#-----------------------------------------------------------------------
# Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
#-----------------------------------------------------------------------
#
# creator
owner=tes@emu.melbourne.sgi.com

seq=`basename $0`
echo "QA output created by $seq"

here=`pwd`
tmp=/tmp/$$
status=1	# failure is the default!
trap "exit \$status" 0 1 2 3 15

_access_time()
{
	stat --format=%X $1
}

# get standard environment, filters and checks
. ./common.rc
. ./common.filter

# real QA test starts here

_supported_fs xfs udf nfs
_supported_os Linux
delay=150

testfile=$TEST_DIR/testfile
rm -f $testfile
rm -f $seq.full

echo test >$testfile
time1=`_access_time $testfile | tee -a $seq.full` 

echo "sleep for $delay"
sleep $delay # sleep to allow time to move on for access
cat $testfile
time2=`_access_time $testfile | tee -a $seq.full` 

cd /
umount $TEST_DIR
mount $TEST_DIR
time3=`_access_time $testfile | tee -a $seq.full`

delta1=`expr $time2 - $time1`
delta2=`expr $time3 - $time1`

echo "delta1 - access time after sleep in-core: $delta1"
echo "delta2 - access time after sleep on-disk: $delta2"

# success, all done
status=0
exit

--------------000805090200060303090001--
