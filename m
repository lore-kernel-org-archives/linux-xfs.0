Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3B47F7CA1
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 09:48:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CC325AC005
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 07:48:20 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 8DqS46Qqn64DuaeC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2016 07:48:17 -0800 (PST)
Date: Wed, 3 Feb 2016 16:48:16 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] direct-io: always call ->end_io if non-NULL
Message-ID: <20160203154816.GA2698@lst.de>
References: <1454444257-9086-1-git-send-email-hch@lst.de>
	<1454444257-9086-2-git-send-email-hch@lst.de>
	<20160203000510.GB5854@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160203000510.GB5854@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

> > -	if (dio->end_io && dio->result)
> > -		dio->end_io(dio->iocb, offset, transferred, dio->private);
> > +	if (dio->end_io)
> > +		dio->end_io(dio->iocb, offset, ret, dio->private);
> 
> Could we make end_io return an int so that errors during completion can be
> stuffed into ret to be picked up by whatever's calling directio?  Something
> like this:
> 
> if (dio->end_io) {
> 	int ret2;
> 
> 	ret2 = dio->end_io(dio->iocb, offset, ret, dio->private);
> 	if (ret2 && !ret)
> 		ret = ret2;
> }
> 
> That way I can capture IO errors during the CoW remapping step and pass them to
> userland either via dio_complete()'s return value or through ki_complete.
> 
> (If ret itself is an error code then obviously we don't bother with the
> post-CoW remap.)

Should be doable, I'll respin it with that change.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
