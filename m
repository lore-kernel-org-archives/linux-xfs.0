Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2277B7CA1
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 07:22:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E63A8304032
	for <xfs@oss.sgi.com>; Mon, 20 Jun 2016 05:22:48 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id qerADLWi8AFZH5rx (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 20 Jun 2016 05:22:45 -0700 (PDT)
Date: Mon, 20 Jun 2016 14:22:43 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/14] fs: introduce iomap infrastructure
Message-ID: <20160620122243.GB29059@lst.de>
References: <1464792297-13185-1-git-send-email-hch@lst.de>
	<1464792297-13185-3-git-send-email-hch@lst.de>
	<20160616161242.GB2106@quack2.suse.cz>
	<20160617120144.GA333@lst.de> <20160620022952.GJ26977@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160620022952.GJ26977@dastard>
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
Cc: rpeterso@redhat.com, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, Jun 20, 2016 at 12:29:52PM +1000, Dave Chinner wrote:
> On Fri, Jun 17, 2016 at 02:01:44PM +0200, Christoph Hellwig wrote:
> > On Thu, Jun 16, 2016 at 06:12:42PM +0200, Jan Kara wrote:
> > > This is actually in 512-byte units, not in fs blocks as the comment
> > > suggests, right?
> > 
> > Indeed, thanks for spotting this!
> 
> I'll update the patches I've already tested, Christoph, so you don't
> have to post an update just for this.

Ok, thanks.  Can't wait for the code to finally go in..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
