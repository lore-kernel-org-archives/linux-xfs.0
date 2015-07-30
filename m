Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5F4187F6D
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 12:21:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3B73C304032
	for <xfs@oss.sgi.com>; Thu, 30 Jul 2015 10:21:04 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 8kmTTa4fFJVfMA9y (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 30 Jul 2015 10:21:02 -0700 (PDT)
Date: Thu, 30 Jul 2015 10:21:01 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 1/2] xfs: return committed status from xfs_trans_roll()
Message-ID: <20150730172101.GA31255@infradead.org>
References: <1437682410-51778-3-git-send-email-bfoster@redhat.com>
	<1437682410-51778-2-git-send-email-bfoster@redhat.com>
	<20150728004009.GB24249@dastard>
	<20150728134006.GD38784@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150728134006.GD38784@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Tue, Jul 28, 2015 at 09:40:06AM -0400, Brian Foster wrote:
> > Hmmm - something I just noticed: if we only have one EFD per EFI,
> > why do we do we have that layer of extent counting before dropping
> > real references?
> > 
> 
> I wondered this myself, but hadn't made it deep enough to see if we used
> the reference count elsewhere.

Because the elders (no pun on Alex, sorry :)) didn't realize we

 a) don't even ever look at at the logged extents in EFD
 b) have a 1:1 relationship between EFIs and EFDs

I tried to sort some of that out about a year ago, but I didn't manage
to get far.
have just one.  Note that not having to log these

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
