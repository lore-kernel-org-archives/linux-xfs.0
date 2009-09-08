Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n88IeBsR088610 for <xfs@oss.sgi.com>; Tue, 8 Sep 2009 13:40:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 83F1F435960
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2009 11:40:51 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id G5cm4kOHzz7yL1o2 for
	<xfs@oss.sgi.com>; Tue, 08 Sep 2009 11:40:51 -0700 (PDT)
Date: Tue, 8 Sep 2009 14:40:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fsetxattr() fails on a writable descriptor?
Message-ID: <20090908184049.GA22050@infradead.org>
References: <1251987642.3855.36.camel@dhcp-lab-219.englab.brq.redhat.com>
	<4AA1A3E6.2020606@draigBrady.com> <87k50den1e.fsf@meyering.net>
	<1252309787.3852.8.camel@dhcp-lab-219.englab.brq.redhat.com>
	<4AA4C950.3080303@draigBrady.com>
	<1252318482.3852.18.camel@dhcp-lab-219.englab.brq.redhat.com>
	<4AA6402D.8040209@draigBrady.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4AA6402D.8040209@draigBrady.com>
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
To: P??draig Brady <P@draigBrady.com>
Cc: linux-fsdevel@vger.kernel.org, CoreutilsBugs <bug-coreutils@gnu.org>, xfs@oss.sgi.com

On Tue, Sep 08, 2009 at 12:29:49PM +0100, P??draig Brady wrote:
> fsetxattr() is failing for me when the permissions are readonly
> but the descriptor is writable as demonstrated by the program below.
> I've tried this on ext3 and ext4 with libattr-2.4.43-3.fc11.i586
> and linux-2.6.30.5-43.fc11.i586

That's not XFS specifci behaviour.  For all xattr operations, fd-based
or not we always do the full permission checks, and have done so since
day one.  Check the routined xattr_permission in fs/xattr.c of the
kernel tree.  It seems a bit unusual, but I'm not sure changing it now
is a good idea - the xattr support has been around for a long time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
