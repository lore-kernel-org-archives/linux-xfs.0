Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o873UswU216741 for <xfs@oss.sgi.com>; Mon, 6 Sep 2010 22:30:55 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0207517B5A81
	for <xfs@oss.sgi.com>; Mon,  6 Sep 2010 20:31:36 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	Uk6MSoBXNFCIqvcu for <xfs@oss.sgi.com>;
	Mon, 06 Sep 2010 20:31:36 -0700 (PDT)
Date: Tue, 7 Sep 2010 13:31:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: LWN.net article: creating 1 billion files -> XFS looses
Message-ID: <20100907033134.GF7362@dastard>
References: <201008191312.49346@zmi.at>
	<20100906154254.5542426c@harpe.intellique.com>
	<20100906220410.GD7362@dastard> <201009070058.40849@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201009070058.40849@zmi.at>
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
To: Michael Monnerie <michael.monnerie@is.it-management.at>
Cc: xfs@oss.sgi.com

On Tue, Sep 07, 2010 at 12:58:40AM +0200, Michael Monnerie wrote:
> On Dienstag, 7. September 2010 Dave Chinner wrote:
> > # mkfs.xfs -d size=64k
> > 
> > Will speed up large directory operations by at least an order of
> > magnitude.
>  
> I've read the man page for mkfs.xfs, but I couldn't find out if using 
> mkfs -d su=64k,sw=2

Sorry, I screwed that up, it should have read:

# mkfs.xfs -n size=64k

(-n = naming = directories. -d = data != directories)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
