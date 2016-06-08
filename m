Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1FB3D7CA0
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 02:11:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8B115AC001
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 00:11:33 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id r6WKqZjgar15zAPH (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 08 Jun 2016 00:11:31 -0700 (PDT)
Date: Wed, 8 Jun 2016 09:11:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] allow enabling reflinks at runtime
Message-ID: <20160608071130.GB24663@lst.de>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
	<20160602225415.GP12670@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160602225415.GP12670@dastard>
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
Cc: xfs@oss.sgi.com, darrick.wong@oracle.com

On Fri, Jun 03, 2016 at 08:54:15AM +1000, Dave Chinner wrote:
> On Thu, Jun 02, 2016 at 04:19:07PM +0200, Christoph Hellwig wrote:
> > I've had some vocal user requests to allow enabling reflinks at run time,
> > which happens to be a mostly trivial feature.  The only caveat is that we
> > need a large enough log size to support the reflink requirements, but for
> > typical large file systems that's not an issue.
> 
> Hmmm - how does this interact with all the rmap code? I was not
> planning on enabling reflink without rmap and vice versa simply
> because it makes the validation and testing matrix vastly more
> complex.

Uh.  So far I've only been testing pure reflink code, mostly because
rmap really doesn't buy much for the use case I'm working on.
Enabling rmap post-mkfs is defintively a different ballpark, and probably
not worth it even if it would be doable.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
