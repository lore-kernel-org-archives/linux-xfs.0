Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 360D27CBF
	for <linux-xfs@oss.sgi.com>; Tue, 26 Feb 2013 14:31:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3FD5AC001
	for <linux-xfs@oss.sgi.com>; Tue, 26 Feb 2013 12:31:42 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	27ToZyHFWnTtN1Tt for <linux-xfs@oss.sgi.com>;
	Tue, 26 Feb 2013 12:31:37 -0800 (PST)
Date: Wed, 27 Feb 2013 07:31:35 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hung in D state during fclose
Message-ID: <20130226203135.GS5551@dastard>
References: <20130212065545.GC10731@dastard>
	<3542214BE3A3EF419F236DFE0F878BC90512DC@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<20130212102014.GA26694@dastard>
	<3542214BE3A3EF419F236DFE0F878BC90517D2@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<20130212202246.GB26694@dastard>
	<3542214BE3A3EF419F236DFE0F878BC905190D@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<3542214BE3A3EF419F236DFE0F878BC9051A09@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<20130213051552.GF26694@dastard>
	<3542214BE3A3EF419F236DFE0F878BC9052F35@BL2PRD0310MB374.namprd03.prod.outlook.com>
	<3542214BE3A3EF419F236DFE0F878BC9055A4A@BL2PRD0310MB374.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3542214BE3A3EF419F236DFE0F878BC9055A4A@BL2PRD0310MB374.namprd03.prod.outlook.com>
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
To: "Cheung, Norman" <Norman.Cheung@kla-tencor.com>
Cc: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

On Tue, Feb 26, 2013 at 07:41:42PM +0000, Cheung, Norman wrote:
> I'd been checking all the XFS patches if any might relate to my situation and came across this 
> http://article.gmane.org/gmane.comp.file-systems.xfs.general/40349/
> 
> From: Christoph Hellwig <hch <at> infradead.org>
> Subject: [PATCH, RFC] writeback: avoid redirtying when ->write_inode failed to clear I_DIRTY
> Newsgroups: gmane.comp.file-systems.xfs.general
> Date: 2011-08-27 06:14:09 GMT (1 year, 26 weeks, 1 day, 13 hours and 17 minutes ago)
> Right now ->write_inode has no way to safely return a EAGAIN without explicitly
> redirtying the inode, as we would lose the dirty state otherwise.  Most
> filesystems get this wrong, but XFS makes heavy use of it to avoid blocking
> the flusher thread when ->write_inode hits contentended inode locks.  A
> contended ilock is something XFS can hit very easibly when extending files, as
> the data I/O completion handler takes the lock to update the size, and the
> ->write_inode call can race with it fairly easily if writing enough data
> in one go so that the completion for the first write come in just before
> we call ->write_inode.
> 
> Change the handling of this case to use requeue_io for a quick retry instead
> of redirty_tail, which keeps moving out the dirtied_when data and thus keeps
> delaying the writeout more and more with every failed attempt to get the lock.
> 
> I wonder if this would have caused my application waiting for xfs_ilock.  I checked 
> that  this patch is not in my kernel source (SUSE 11 SP2, Rel 3.0.13-0.27)

I have no idea whether it will help or not, because SuSE (like Red
Hat) ship a heavily patched kernel and so it's rather hard for
anyone here to triage and diagnose problems like this. Further, even
if we can find a potential cause, we still can't fix it for you.
Hence perhaps you are best advised to talk to your SuSE support
contact at this point?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
