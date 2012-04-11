Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3BK4e7a106131 for <xfs@oss.sgi.com>; Wed, 11 Apr 2012 15:04:40 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	GSxw1p7ZrNGcPhjv (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Apr 2012 13:04:39 -0700 (PDT)
Date: Wed, 11 Apr 2012 16:04:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] 273: don't delete everything if $SCRATCH_MNT isn't set
Message-ID: <20120411200433.GE28816@infradead.org>
References: <4F832C25.3080408@netapp.com>
 <20120409214445.GJ18323@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120409214445.GJ18323@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, Bryan Schumaker <bjschuma@netapp.com>

On Tue, Apr 10, 2012 at 07:44:45AM +1000, Dave Chinner wrote:
> On Mon, Apr 09, 2012 at 02:36:21PM -0400, Bryan Schumaker wrote:
> > The cleanup function is trapped before _require_scratch() is called, and
> > then expands "rm -rf $SCRATCH_MNT/*" to "rm -rf /*"
> 
> It doesn't need to clean up the scratch device - tests need to mkfs
> it first before using it, so just remove the $tmp* files. The sae
> fix is needed for tests 274 and 275.

Given his address I assume Bryan might test on NFS, which has funky
semantics for the scratch device.

Is that true Bryan?  I really need to dive back into how we handle NFS
in this respect to have a good judgement on this patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
