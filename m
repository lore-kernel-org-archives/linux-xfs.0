Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D5FC47FFE
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 10:08:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 73C19AC003
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2015 08:08:50 -0800 (PST)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id ZgSplsYgYFxg56KD for <xfs@oss.sgi.com>;
	Tue, 03 Feb 2015 08:08:46 -0800 (PST)
Date: Tue, 3 Feb 2015 11:08:45 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 10/20] nfsd: implement pNFS operations
Message-ID: <20150203160845.GO22301@fieldses.org>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-11-git-send-email-hch@lst.de>
	<20150129203346.GA11064@fieldses.org>
	<20150202124349.GA15598@lst.de>
	<20150202142832.GC22301@fieldses.org>
	<20150202145619.GA18387@lst.de>
	<20150202150032.GD22301@fieldses.org>
	<20150202185638.GB23319@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150202185638.GB23319@lst.de>
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
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Mon, Feb 02, 2015 at 07:56:38PM +0100, Christoph Hellwig wrote:
> On Mon, Feb 02, 2015 at 10:00:32AM -0500, J. Bruce Fields wrote:
> > I'm planning to pull Jeff's tree and then apply these on top.  (Even if
> > the conflict's fairly trivial I'm just happier being able to test the
> > combination exactly as they're commited.)
> > 
> > I'll do that now, should be pushed out in an hour or two.
> 
> I've pushed out a pnfsd-for-3.20-3 branch to
> git://git.infradead.org/users/hch/pnfs.git
> 
> Or do you want me to resend the whole thing?

No, looks fine to me as is.  Thanks!  I'll play around with it a little
more and then push it out.

GETLAYOUT is going to be annoying if we need big layouts.  We'll have to
figure out what to do with that reply size estimation, and clients will
have to figure out how to get the maxresponsesized_cached right, I
guess?  Oh well.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
