Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B48237FCB
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 15:33:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 329C48F8068
	for <xfs@oss.sgi.com>; Wed, 16 Jul 2014 13:33:06 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Go6QhZiuTK9EM5X2 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Jul 2014 13:33:04 -0700 (PDT)
Date: Wed, 16 Jul 2014 22:33:01 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] logprint: Fix printing of AGF buffers
Message-ID: <20140716203301.GB21559@quack.suse.cz>
References: <1405349100-19734-1-git-send-email-jack@suse.cz>
	<20140715101931.GC30363@infradead.org>
	<20140715140938.GA1733@quack.suse.cz>
	<20140715153922.GB5369@infradead.org>
	<20140716003851.GO22339@dastard>
	<20140716081105.GB29924@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140716081105.GB29924@infradead.org>
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
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Wed 16-07-14 01:11:05, Christoph Hellwig wrote:
> On Wed, Jul 16, 2014 at 10:38:51AM +1000, Dave Chinner wrote:
> > I added this:
> > 
> > 	/*
> > 	 * The addition of spare space and the non-logged CRC format
> > 	 * fields to the AGF mean that the size that is logged is almost
> > 	 * always going to be smaller than the structure itself. Hence
> > 	 * we need to make sure that the buffer contains all the data we
> > 	 * want to print rather than just check against the structure
> > 	 * size.
> > 	 */
> > 
> > Cheers,
> 
> I'd prefer to mention v4 filesystems as well:
> 
> 	/*
> 	 * v4 filesystems only contain the fields before the uuid, and
> 	 * even v5 filesystems don't usually log any field beneath it.
> 	 */
> 
> note that the AGI case also needs the same treatment.
  Yep, I'll send an updated patch in a moment.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
