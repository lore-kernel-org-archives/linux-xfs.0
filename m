Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6UH8PN6149222 for <xfs@oss.sgi.com>; Sat, 30 Jul 2011 12:08:25 -0500
Received: from merit-proxy01.merit.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 74EF31EF130F
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2011 10:08:24 -0700 (PDT)
Received: from merit-proxy01.merit.edu (merit-proxy01.merit.edu
	[207.75.116.193]) by cuda.sgi.com with ESMTP id
	ht4UIgqLZeGav7BB for <xfs@oss.sgi.com>;
	Sat, 30 Jul 2011 10:08:24 -0700 (PDT)
Date: Sat, 30 Jul 2011 13:08:22 -0400
From: Jim Rees <rees@umich.edu>
Subject: Re: xfstests fails on nfs4 file system
Message-ID: <20110730170822.GA27493@merit.edu>
References: <20110730151604.GA26285@merit.edu>
	<20110730163326.GA19290@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110730163326.GA19290@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

  On Sat, Jul 30, 2011 at 11:16:04AM -0400, Jim Rees wrote:
  > xfstests fails on nfs4 file system:
  > 
  > rhcl1# mount -t nfs -o nfsvers=4,minorversion=1 emc-1:/pnfs2 /mnt/emc-1
  > rhcl1# cd /home/rees/xfstests
  > rhcl1# setenv TEST_DEV emc-1:/pnfs2
  > rhcl1# setenv TEST_DIR /mnt/emc-1/rees/xfstests
  > rhcl1# ./check -nfs
  > common.rc: Error: $TEST_DEV (emc-1:/pnfs2) is not a MOUNTED nfs filesystem
  > /bin/df: `emc-1:/pnfs2': No such file or directory
  > /bin/df: no file systems processed
  > 
  > Originally nfs4 was a separate file system type, and it still shows up that
  > way in mtab:
  > emc-1:/pnfs2/ on /mnt/emc-1 type nfs4 (rw,relatime,vers=4,...
  > 
  > I fixed this by commenting out the type check at the end of common.rc.  I
  > don't know enough about the innards of xfstests to know what the proper fix
  > is.  Maybe a substring match, or explicit check for nfs4?
  
  What about the following patch?  I makes sure the nfs4 output gets
  normalized to nfs as early as possible.

Makes sense, and it works.

Tested-by: Jim Rees <rees@umich.edu>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
