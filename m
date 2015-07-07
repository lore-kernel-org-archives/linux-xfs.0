Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F19C07F50
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 19:29:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D12AE304053
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 17:29:53 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	NjrHlKkdkvUMBpbl for <xfs@oss.sgi.com>;
	Mon, 06 Jul 2015 17:29:51 -0700 (PDT)
Date: Tue, 7 Jul 2015 10:24:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: regarding journaling mode
Message-ID: <20150707002430.GV7943@dastard>
References: <CAMcfJ7vDCNo138qnUJ8O0ZDYxgh9k8rgFUoTN3mKcY-SiMWrzA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMcfJ7vDCNo138qnUJ8O0ZDYxgh9k8rgFUoTN3mKcY-SiMWrzA@mail.gmail.com>
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
To: Rakesh Patel <patelrakeshcomp@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 06, 2015 at 11:38:32AM +0530, Rakesh Patel wrote:
> Hi,
> 
> I come to know XFS is using writeback journaling mode.

Can you explain how you came to that conclusion?

> As per the
> journaling guide, writeback is unsafe which does not preserve data and
> metadata write synchronization.

What journalling guide would that be? Please quote your sources when
asking questions.

> I really want to know reason behind to choose writeback mode for journaling
> in XFS.

Metadata updates after data IO completion are used instead of
ordering data writeback operations through the journal.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
