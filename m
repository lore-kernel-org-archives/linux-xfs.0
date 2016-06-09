Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BD80F7CA0
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 12:46:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 47D16AC002
	for <xfs@oss.sgi.com>; Thu,  9 Jun 2016 10:46:02 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id J4D8igDfQvuT0CWG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 09 Jun 2016 10:46:00 -0700 (PDT)
Date: Thu, 9 Jun 2016 10:45:51 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC] allow enabling reflinks at runtime
Message-ID: <20160609174551.GD10371@birch.djwong.org>
References: <1464877150-20457-1-git-send-email-hch@lst.de>
	<20160602225415.GP12670@dastard> <20160608071130.GB24663@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160608071130.GB24663@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jun 08, 2016 at 09:11:30AM +0200, Christoph Hellwig wrote:
> On Fri, Jun 03, 2016 at 08:54:15AM +1000, Dave Chinner wrote:
> > On Thu, Jun 02, 2016 at 04:19:07PM +0200, Christoph Hellwig wrote:
> > > I've had some vocal user requests to allow enabling reflinks at run time,
> > > which happens to be a mostly trivial feature.  The only caveat is that we
> > > need a large enough log size to support the reflink requirements, but for
> > > typical large file systems that's not an issue.
> > 
> > Hmmm - how does this interact with all the rmap code? I was not
> > planning on enabling reflink without rmap and vice versa simply
> > because it makes the validation and testing matrix vastly more
> > complex.
> 
> Uh.  So far I've only been testing pure reflink code, mostly because
> rmap really doesn't buy much for the use case I'm working on.

So far I've mostly been testing with mkfs.xfs -i sparse=1 -m rmapbt=1,reflink=1
on the assumption that sparse will get turned on soon and that it
might help a lot in the post-COW fragmentation world.

(Hoping that the cowextsize defaults avoid most of the horrifying
fragmentation that we see on the second- and last-letter filesystems.)

> Enabling rmap post-mkfs is defintively a different ballpark, and probably
> not worth it even if it would be doable.

Hughflgrgh.  I wasn't even going to consider /that/ possibility. :)

(I guess you could flip on the feature bit and run xfs_repair...)

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
