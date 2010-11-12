Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oACMZdQt167764 for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 16:35:39 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 716F91751FA
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 14:37:09 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ryrDM06cAAJddLSl for
	<xfs@oss.sgi.com>; Fri, 12 Nov 2010 14:37:09 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oACMb8rO031681
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 12 Nov 2010 17:37:08 -0500
Message-ID: <4CDDC193.9030208@redhat.com>
Date: Fri, 12 Nov 2010 16:37:07 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 246: Test for race between direct I/O and mmap
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>
Cc: Lachlan McIlroy <lmcilroy@redhat.com>



From: Lachlan McIlroy <lmcilory@redhat.com>

A customer reported a problem:

If a process is using mmap to write to a file on an 
ext4 filesystem while another process is using direct 
I/O to write to the same file the first thread may 
receive a SIGBUS during a page fault.

A SIGBUS occurs if the page fault tries to access a 
page that is entirely beyond the end of the file but 
in this test case that should not be happening.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

#! /bin/bash
# FS QA Test No. 246
#
# Test for race between direct I/O and mmap
#
#-----------------------------------------------------------------------
# Copyright (c) 2010 Red Hat, Inc.  All Rights Reserved.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it would be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write the Free Software Foundation,
# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#-----------------------------------------------------------------------
#
# creator
owner=lmcilroy@redhat.com

seq=`basename $0`
echo "QA output created by $seq"

here=`pwd`
tmp=/tmp/$$
status=1	# failure is the default!
trap "_cleanup; exit \$status" 0 1 2 3 7 15

_cleanup()
{
    cd /
    rm -f $tmp.* $testfile
    wait
}

# get standard environment, filters and checks
. ./common.rc
. ./common.filter

# real QA test starts here

# Modify as appropriate.
_supported_fs generic
_supported_os Linux

testfile=$TEST_DIR/$seq.$$

loops=500
iosize=1048576

# Initialise file
dd if=/dev/zero of=$testfile bs=$iosize count=$loops &> /dev/null
[ $? -ne 0 ] && exit
sync
	
# Direct I/O overwriter
dd if=/dev/zero of=$testfile oflag=direct bs=$iosize count=$loops conv=notrunc &> /dev/null &
[ $? -ne 0 ] && exit

# Mmap writer
start=`expr $loops - 1`
for i in `seq $start -1 0`
do
	offset=`expr $i \* $iosize`
	$XFS_IO_PROG -F -f -c "mmap -w $offset $iosize" -c "mwrite $offset $iosize" $testfile
	[ $? -ne 0 ] && exit
done

wait

echo "Silence is golden."

# success, all done
status=0
exit


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
