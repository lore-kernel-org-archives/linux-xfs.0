Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DC9C17CBF
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 05:07:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CB2368F80B6
	for <xfs@oss.sgi.com>; Fri, 24 May 2013 03:07:56 -0700 (PDT)
Date: Fri, 24 May 2013 06:07:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: kill suid/sgid through the truncate path.
Message-ID: <20130524100755.GA20767@infradead.org>
References: <1369312240-5925-1-git-send-email-david@fromorbit.com>
	<1369385888-17214-1-git-send-email-david@fromorbit.com>
	<1369385888-17214-3-git-send-email-david@fromorbit.com>
	<20130524100246.GA15373@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130524100246.GA15373@infradead.org>
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
Cc: bpm@sgi.com, xfs@oss.sgi.com

On Fri, May 24, 2013 at 06:02:46AM -0400, Christoph Hellwig wrote:
> On Fri, May 24, 2013 at 06:58:08PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > XFS has failed to kill suid/sgid bits correctly when truncating
> > files of non-zero size since commit c4ed4243 ("xfs: split
> > xfs_setattr") introduced in the 3.1 kernel. Fix it.
> 
> This should get a testcase in xfstests.

Ok, saw the testcase in the other thread.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
