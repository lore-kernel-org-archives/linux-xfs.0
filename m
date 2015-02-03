Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2C1EB7F6F
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 12:35:46 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id ADE7AAC002
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 10:35:42 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id PxisHKIr3tZxdVmt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Feb 2015 10:35:36 -0800 (PST)
Date: Tue, 3 Feb 2015 19:35:33 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 16/20] xfs: pass a 64-bit count argument to
	xfs_iomap_write_unwritten
Message-ID: <20150203183533.GA16929@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-17-git-send-email-hch@lst.de>
	<20150129205232.GB11064@fieldses.org>
	<20150202073024.GA9399@lst.de> <20150202192404.GI6282@dastard>
	<20150202194300.GN6282@dastard>
	<20150202194826.GG22301@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150202194826.GG22301@fieldses.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, Jeff Layton <jlayton@primarydata.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Mon, Feb 02, 2015 at 02:48:26PM -0500, J. Bruce Fields wrote:
> Previously: http://lkml.kernel.org/r/20150106175611.GA16413@lst.de
> 
> 	>       - any advice on testing?  Is there was some simple
> 	>       virtual setup that would allow any loser with no special
> 	>       hardware (e.g., me) to check whether they've broken the
> 	>       block server?
> 
> 	Run two kvm VMs that share the same disk.  Create an XFS
> 	filesystem on the MDS, and export it.  If the client has blkmapd
> 	running (on Debian it needs to be started manually) it will use
> 	pNFS for accessing the filesystem.  Verify that using the
> 	per-operation counters in /proc/self/mounstats.  Repeat with
> 	additional clients as nessecary.
> 
> 	Alternatively set up a simple iSCSI target using tgt or lio and
> 	connect to it from multiple clients.
> 
> Which sounds reasonable to me, but I haven't tried to incorporate this
> into my regression testing yet.

Additionally I can offer the following script to generate recalls,
which don't really happen during normal operation.  I don't
really know how to write a proper testcase that coordinates access
to the exported filesystem and nfs unless it runs locally on the same node,
though.  It would need some higher level, network aware test harness:

----- snip -----
#!/bin/sh

set +x

# wait for grace period
touch /mnt/nfs1/foo

dd if=/dev/zero of=/mnt/nfs1/foo bs=128M count=32 conv=fdatasync oflag=direct &

sleep 2

echo "" > /mnt/test/foo && echo "recall done"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
