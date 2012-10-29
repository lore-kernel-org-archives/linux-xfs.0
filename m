Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9TE8vS8170922 for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 09:08:58 -0500
Message-ID: <508E8ECA.2080204@sgi.com>
Date: Mon, 29 Oct 2012 09:12:26 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: xfstests: test ext4 statfs
References: <5089749C.4050003@redhat.com> <508AD066.4090102@sgi.com>
	<508AD8E8.1040301@redhat.com> <508E8480.5020507@sgi.com>
In-Reply-To: <508E8480.5020507@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com, Eric Sandeen <sandeen@redhat.com>, ext4 development <linux-ext4@vger.kernel.org>

   xfstests: test ext4 statfs

     Calculating free blocks in ext[234] is surprisingly hard, since
     by default we report "bsd" style df which doesn't count filesystem
     "overhead" blocks as used.

     With a lot of code dedicated to sorting out what to report as
     free, things tend to go wrong surprisingly often.

     Here's a test to actually try to stop the next regression.  ;)

     NB: For bsddf, the kernel currently does not count journal blocks
     as overhead; it probably should.  But the test below looks to have
     the result within 1% of perfection, so it still passes even if
     the kernel doesn't count the journal against free blocks.

Eric,

This patch has been committed to git://oss.sgi.com/xfs/cmds/xfstests, 
master branch, commit 0b2ab695.

Thanks
--Rich



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
