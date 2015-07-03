Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7163F7F6F
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 18:45:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4268B8F8052
	for <xfs@oss.sgi.com>; Fri,  3 Jul 2015 16:45:22 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	ilhZcVadraE6OrKm for <xfs@oss.sgi.com>;
	Fri, 03 Jul 2015 16:45:20 -0700 (PDT)
Date: Sat, 4 Jul 2015 09:45:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfsprogs: blkid is now mandatory
Message-ID: <20150703234518.GP7943@dastard>
References: <1629704668.22787354.1435832837879.JavaMail.zimbra@redhat.com>
	<1435833796-24004-1-git-send-email-jtulak@redhat.com>
	<20150703151904.GA13839@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150703151904.GA13839@infradead.org>
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
Cc: sandeen@redhat.com, xfs@oss.sgi.com, Jan Tulak <jtulak@redhat.com>

On Fri, Jul 03, 2015 at 08:19:04AM -0700, Christoph Hellwig wrote:
> Thanks Jan!
> 
> On Thu, Jul 02, 2015 at 12:43:16PM +0200, Jan Tulak wrote:
> > Because blkid is here for a long time, I hereby propose a patch for removing support
> > for NOT having blkid. The current support through set of #ifdef is prone to errors like
> > making a patch just in one of the branches, and according to a recent talk between
> > Christoph and Eric, it is not necessary to keep it supported.
> > 
> > Remove code for checking ENABLE_BLKID, and the code when ENABLE_BLKID is not defined.
> > The only use of libdisk was in the removed code, so remove libdisk too.
> > It makes blkid required for compilation.
> 
> Can you wrap your commit description lines after ~ 75 characters,
> please?

ObBikeShed: I find 68 characters for commit messages is more
friendly, especially with the way git show pads the commit messages
and people cut/paste it into email...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
