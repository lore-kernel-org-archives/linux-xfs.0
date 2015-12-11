Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6EA5E7F3F
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 22:26:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 508088F8033
	for <xfs@oss.sgi.com>; Thu, 10 Dec 2015 20:26:12 -0800 (PST)
Received: from mga11.intel.com ([192.55.52.93]) by cuda.sgi.com with ESMTP id
	9hFoCPDQpMlwpRVv for <xfs@oss.sgi.com>;
	Thu, 10 Dec 2015 20:26:10 -0800 (PST)
Date: Thu, 10 Dec 2015 21:26:09 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: xfstests failures with xfs, dax and v4.4-rc3
Message-ID: <20151211042609.GA5360@linux.intel.com>
References: <20151202183438.GA1319@linux.intel.com>
	<20151202202910.GH19199@dastard> <20151202204502.GI19199@dastard>
	<20151202213932.GA7652@linux.intel.com>
	<20151210165458.GA13603@linux.intel.com>
	<20151210223333.GH26718@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151210223333.GH26718@dastard>
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
Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>

On Fri, Dec 11, 2015 at 09:33:33AM +1100, Dave Chinner wrote:
> On Thu, Dec 10, 2015 at 09:54:58AM -0700, Ross Zwisler wrote:
> > On Wed, Dec 02, 2015 at 02:39:32PM -0700, Ross Zwisler wrote:
> > > I've verified that this fixes all three failing xfstests reported in this mail.
> > > Thanks!
> > 
> > Hey Dave,
> > 
> > Are you planning on pushing this fix for v4.4?
> 
> No plans to right now - ENOSPC is a corner case that most users
> won't be anywhere near, especially for experimental functionality on
> hardware nobody actually has....

Really?  I realize that it may be a case that most users won't actually hit,
but it is a 5 line change that fixes four xfstests regressions between v4.3 and
v4.4 for my DAX testing...

Is there a strong reason *not* to push it in the v4.4 cycle?  I'm trying to
clear up all xfstests differences between DAX and non-DAX, and this would help
quite a bit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
