Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E5F257F37
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 17:11:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8236FAC001
	for <xfs@oss.sgi.com>; Wed, 22 Apr 2015 15:11:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hyA54w3DSAQeqzON (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Apr 2015 15:11:12 -0700 (PDT)
Date: Wed, 22 Apr 2015 18:10:47 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: don't trigger fsync log force based on inode pin
	count
Message-ID: <20150422221047.GB48944@bfoster.bfoster>
References: <1429713466-22137-1-git-send-email-bfoster@redhat.com>
	<20150422161509.GA27237@infradead.org>
	<20150422171322.GB6688@bfoster.bfoster>
	<20150422211845.GP21261@dastard>
	<20150422220244.GA48944@bfoster.bfoster>
	<20150422220611.GA8881@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150422220611.GA8881@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Apr 22, 2015 at 03:06:11PM -0700, Christoph Hellwig wrote:
> On Wed, Apr 22, 2015 at 06:02:44PM -0400, Brian Foster wrote:
> > That was what I thought at first but I bumped the extent count a couple
> > times and still couldn't reproduce. I was curious enough to track it
> > down and it is actually the time update again. For whatever reason, I
> > think the crc mechanism is throwing the timing off and just hiding the
> > problem again. E.g., no-op xfs_vn_time_update() and the problem
> > reproduces on v5 as well.
> 
> Actually, its the changecount again.  If MS_I_VERSION is set
> the VFS will always call into ->xfs_vn_time_update.

Ah, I see. Yeah, that explains the time update then...

Brian

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
