Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3LK6Nrr172925 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 15:06:24 -0500
Received: from cf--amer001e--3.americas.sgi.com
	(cf--amer001e--3.americas.sgi.com [137.38.100.5])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4486EAC012
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 13:09:52 -0700 (PDT)
Subject: [Fwd: Re: [PATCH 4/4] xfs: reduce the number of pagb_lock
	roundtrips in xfs_alloc_clear_busy]
From: Alex Elder <aelder@sgi.com>
Date: Thu, 21 Apr 2011 15:09:19 -0500
Message-ID: <1303416559.2581.522.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: xfs@oss.sgi.com

Forgot to reply-all.  Sorry.	-Alex

-------- Forwarded Message --------
From: Alex Elder <aelder@sgi.com>
Reply-to: aelder@sgi.com
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: reduce the number of pagb_lock roundtrips
in xfs_alloc_clear_busy
Date: Thu, 21 Apr 2011 15:08:32 -0500

On Mon, 2011-04-18 at 02:59 -0400, Christoph Hellwig wrote:
> Instead of finding the per-ag and then taking and releasing the pagb_lock
> for every single busy extent completed sort the list of busy extents and
> only switch betweens AGs where nessecary.  This becomes especially important
> with the online discard support which will hit this lock more often.

Looks good.

My only comment was going to be:
    Is it better to sort before when committed, or sort at
    insertion time?
But I worked through it and concluded you are doing exactly
the right thing.

Reviewed-by: Alex Elder <aelder@sgi.com>



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
