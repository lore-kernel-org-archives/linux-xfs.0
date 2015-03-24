Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 85B957F59
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 16:17:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1A6E3AC002
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 14:17:45 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	HLaPET4n9vwyCOM8 for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 14:17:43 -0700 (PDT)
Date: Wed, 25 Mar 2015 08:17:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/8] xfs: add DAX file operations support
Message-ID: <20150324211740.GT28621@dastard>
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
	<1427194266-2885-6-git-send-email-david@fromorbit.com>
	<551153C4.6000808@plexistor.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <551153C4.6000808@plexistor.com>
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
To: Boaz Harrosh <boaz@plexistor.com>
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Tue, Mar 24, 2015 at 02:08:36PM +0200, Boaz Harrosh wrote:
> On 03/24/2015 12:51 PM, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add the initial support for DAX file operations to XFS. This
> > includes the necessary block allocation and mmap page fault hooks
> > for DAX to function.
> > 
> > Note: we specifically have to disable splice_read/write from
> 
> It looks from below code that splice_read is perfectly supportable
> through the call to default_file_splice_read() so you might
> want to change the comment here.

Ah, I forgot to update the description.

> Regarding splice_write:
> It looks to me like you left the vector at iter_file_splice_write().
> If I understand correctly I think you need to call default_file_splice_write()
> that uses memcpy, just as it was at the previous patches when you left
> the vector NULL. So I think you need the same switch for write
> as you do below for read.

iter_file_splice_write() uses vfs_iter_write, which goes through
->write_iter, which we punt to the direct IO path for DAX.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
