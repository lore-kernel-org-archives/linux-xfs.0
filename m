Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAFM7YOS031794 for <xfs@oss.sgi.com>; Thu, 15 Nov 2012 16:07:34 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	qM2BnrnxD0zsH919 for <xfs@oss.sgi.com>;
	Thu, 15 Nov 2012 14:09:38 -0800 (PST)
Date: Fri, 16 Nov 2012 09:09:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 17/32 V2] xfs: verify dquot blocks as they are read from
	disk
Message-ID: <20121115220936.GK14281@dastard>
References: <1352721264-3700-1-git-send-email-david@fromorbit.com>
	<1352721264-3700-18-git-send-email-david@fromorbit.com>
	<20121114065013.GE1710@dastard> <50A52CA3.3060604@sgi.com>
	<20121115204830.GG14281@dastard> <50A5583D.5070101@sgi.com>
	<20121115211608.GI14281@dastard> <50A55FEC.30106@sgi.com>
	<20121115220117.GJ14281@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121115220117.GJ14281@dastard>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Nov 16, 2012 at 09:01:17AM +1100, Dave Chinner wrote:
> On Thu, Nov 15, 2012 at 03:34:36PM -0600, Mark Tinguely wrote:
> > On 11/15/12 15:16, Dave Chinner wrote:
> > >On Thu, Nov 15, 2012 at 03:01:49PM -0600, Mark Tinguely wrote:
> > >>On 11/15/12 14:48, Dave Chinner wrote:
> > >>>On Thu, Nov 15, 2012 at 11:55:47AM -0600, Mark Tinguely wrote:
> > >>>>The xfs_quota program does not generate output with V2 which causes
> > >>>>xfstest 050 to fails.
> > >>>
> > >>>I don't think that has anything to do with this patch orthechange
> > >>>for V2 - V2 only changes quotacheck behaviour, and that doesn't
> > >>>impact xfs_quota behaviour. The test passes just fine here:
> > >>>
> > >>>$ sudo ./check 050
> > >>>FSTYP         -- xfs (debug)
> > >>>PLATFORM      -- Linux/x86_64 test-2 3.7.0-rc5-dgc+
> > >>>MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdb
> > >>>MOUNT_OPTIONS -- /dev/vdb /mnt/scratch
> > >>>
> > >>>050 14s ... 15s
> > >>>Ran: 050
> > >>>Passed all 1 tests
> > >>>
> > >>>So perhaps there's something else going wrong on your machine?
> > >
> > >Curious. There aren't any errors in the syslog/dmesg saying that
> > >buffers failed verification during the quota check runs, are there?
> > >Also, what platform are you testing on?
> > 
> > No error message in dmesg nor /var/log/messages
> > 
> > This is a x86_64.
> > 
> > It is running OSS with most recent commit:
> > 
> >  commit 579b62faa5fb16ffeeb88cda5e2c4e95730881af
> > 
> > Your two series:
> > 	xfs: fixes for 3.7-rc6
> > 	xfs: current queue for 3.8
> > 
> > I added the XFS_SB_VERSION2_CRCBIT attribute to xfsprogs and enabled
> > it in mkfs.xfs and remade the test/scratch filesystems.
> 
> That's likely your problem. Why are you testing with this bit set -
> that's to indicate that there are on disk format changes, and none
> of them occur in this patch set. Hence the kernel should be refusing
> to mount any filesystem with that bit set. As such, I'm using a
> standard userspace for all this regression testing, because
> filesystems with the CRC bit should be failed during mount on 3.8.
> 
> /me goes looking....
> 
> Ok, the kernel isn't refusing to mount when that bit is set. That's
> a bug in the patch that introduces the CRC bit that I borked when
> splitting it out of a larger patch. I'll send an updated patch (it's
> the xfs: add CRC infrastructure patch).

FWIW, if I intended this patch set to be tested with a feature bit
set or modified userspace, I would have posted patches that modify
the userspace tools appropriately. If you see something that
requires userspace tool modification to make use of, then you should
be asking questions about that during review rather than quietly
modifying userspace tools yourself to test said changes.

In most cases, enabling kernel feature bits (i.e. presence in the
GOOD flags) without corresponding changes to userspace is a bug, as
demonstrated here...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
