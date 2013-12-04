Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5DE3B7F4E
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 07:08:54 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2C17AC008
	for <xfs@oss.sgi.com>; Wed,  4 Dec 2013 05:08:50 -0800 (PST)
Date: Wed, 4 Dec 2013 05:08:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: reinstate the iolock in xfs_readdir
Message-ID: <20131204130848.GA22926@infradead.org>
References: <20131203212951.GP1935@sgi.com> <20131203225520.GZ10988@dastard>
	<20131203231415.GS1935@sgi.com> <20131204001030.GD10988@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131204001030.GD10988@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com

On Wed, Dec 04, 2013 at 11:10:30AM +1100, Dave Chinner wrote:
> The simple fact is that if we ever want to do concurrent directory
> read operations, we have to take the ilock in readdir() to ensure we
> can serialise correctly against modifications because the i_mutex
> can't be used to do that. So, really, I'm not against the fix you
> proposed - I'm just trying to understand why it is necessary right
> now....

Some comments from the person who authered that old comment that removed
the ilock:

 - as far as I can tell that was not intentional.  I'm usually pretty
   good at recording such things in the changelog if I do it
   intentionally.
 - relying on the open function to read in the extent list seems
   potentially dangerous.  We generally try to make sure all the
   functions using it read it in if needed including the proper
   locking.  If we want to avoid that for some reason like in the
   writeback path we at least comment it and put asserts in.
 - like Dave pointed out I think things should just work for mainline
   modulo maybe the attr by handle ioctl, but it seems by accident.
   Figuring out what issues Ben sees would be useful.
 - instead of putting the ilock back at the highest level we might want
   to push it down to the dir2 data code and only cover the actual
   critical region where we need it.
 - xfs_iread_extents really needs an assert to make sure the ilock
   is held.
 - xfs_bmapi_read probably should have an assert as well to make
   sure the ilock is held in some way

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
