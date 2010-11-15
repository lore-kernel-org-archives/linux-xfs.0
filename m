Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAF108n0001234 for <xfs@oss.sgi.com>; Sun, 14 Nov 2010 19:00:08 -0600
Received: from mx4-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B669A13B5D83
	for <xfs@oss.sgi.com>; Sun, 14 Nov 2010 17:01:39 -0800 (PST)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id AgwGK5JEPECZBB6Z for
	<xfs@oss.sgi.com>; Sun, 14 Nov 2010 17:01:39 -0800 (PST)
Date: Sun, 14 Nov 2010 20:01:39 -0500 (EST)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <1825553240.2178961289782899012.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4CDDC193.9030208@redhat.com>
Subject: Re: [PATCH] xfstests 246: Test for race between direct I/O and mmap
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

----- "Eric Sandeen" <sandeen@redhat.com> wrote:

> From: Lachlan McIlroy <lmcilory@redhat.com>
lmcilroy - although I was briefly known as lmcilory due a HR error.

Eric, the test looks good to me, thanks for fixing the errors in it.

> 
> A customer reported a problem:
> 
> If a process is using mmap to write to a file on an 
> ext4 filesystem while another process is using direct 
> I/O to write to the same file the first thread may 
> receive a SIGBUS during a page fault.
> 
> A SIGBUS occurs if the page fault tries to access a 
> page that is entirely beyond the end of the file but 
> in this test case that should not be happening.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> #! /bin/bash
> # FS QA Test No. 246
> #
> # Test for race between direct I/O and mmap
> #
> #-----------------------------------------------------------------------
> # Copyright (c) 2010 Red Hat, Inc.  All Rights Reserved.
> #
> # This program is free software; you can redistribute it and/or
> # modify it under the terms of the GNU General Public License as
> # published by the Free Software Foundation.
> #
> # This program is distributed in the hope that it would be useful,
> # but WITHOUT ANY WARRANTY; without even the implied warranty of
> # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> # GNU General Public License for more details.
> #
> # You should have received a copy of the GNU General Public License
> # along with this program; if not, write the Free Software
> Foundation,
> # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> #-----------------------------------------------------------------------
> #
> # creator
> owner=lmcilroy@redhat.com
> 
> seq=`basename $0`
> echo "QA output created by $seq"
> 
> here=`pwd`
> tmp=/tmp/$$
> status=1	# failure is the default!
> trap "_cleanup; exit \$status" 0 1 2 3 7 15
> 
> _cleanup()
> {
>     cd /
>     rm -f $tmp.* $testfile
>     wait
> }
> 
> # get standard environment, filters and checks
> . ./common.rc
> . ./common.filter
> 
> # real QA test starts here
> 
> # Modify as appropriate.
> _supported_fs generic
> _supported_os Linux
> 
> testfile=$TEST_DIR/$seq.$$
> 
> loops=500
> iosize=1048576
> 
> # Initialise file
> dd if=/dev/zero of=$testfile bs=$iosize count=$loops &> /dev/null
> [ $? -ne 0 ] && exit
> sync
> 	
> # Direct I/O overwriter
> dd if=/dev/zero of=$testfile oflag=direct bs=$iosize count=$loops
> conv=notrunc &> /dev/null &
> [ $? -ne 0 ] && exit
> 
> # Mmap writer
> start=`expr $loops - 1`
> for i in `seq $start -1 0`
> do
> 	offset=`expr $i \* $iosize`
> 	$XFS_IO_PROG -F -f -c "mmap -w $offset $iosize" -c "mwrite $offset
> $iosize" $testfile
> 	[ $? -ne 0 ] && exit
> done
> 
> wait
> 
> echo "Silence is golden."
> 
> # success, all done
> status=0
> exit

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
