Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n09M2Evl026708 for <xfs@oss.sgi.com>; Fri, 9 Jan 2009 16:02:16 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 75F3876744
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2009 14:02:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Qmnc1tA1b6hjBSFw for
	<xfs@oss.sgi.com>; Fri, 09 Jan 2009 14:02:10 -0800 (PST)
Date: Fri, 9 Jan 2009 17:01:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090109220138.GA5282@infradead.org>
References: <20090107185628.GA19255@infradead.org>
	<20090108215602.GA24479@dth.net> <20090109004609.GM9448@disturbed>
	<20090109012610.GA23075@dth.net> <20090109020800.GO9448@disturbed>
	<20090109061043.GA31450@dth.net>
	<20090109194445.GA28759@infradead.org>
	<20090109195144.GA19857@dth.net>
	<20090109195852.GA6362@infradead.org>
	<20090109214206.GA2901@dth.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090109214206.GA2901@dth.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Danny ter Haar <dth@dth.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jan 09, 2009 at 10:42:06PM +0100, Danny ter Haar wrote:
> Quoting Christoph Hellwig (hch@infradead.org):
> > There is no specific 2.6.28-git respository, just a main linux 2.6 one:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> > The git bisect command make sure you will get the right revisions
> > checked out to bisect.
> 
> still not making myself clear i guess..

Or me beeing stupid, sorry :)  The -gitN thingies aren't
official tags, but unofficial snapshots done by Dave Woodhouse.

He has a mapping on
http://www.kernel.org/pub/linux/kernel/people/dwmw2/snapshot-tags/ from
these names to actual tags.  So 2.6.28-git2 would be

	3c92ec8ae91ecf59d88c798301833d7cf83f2179

and 2.6.28-git3

	6a94cb73064c952255336cc57731904174b2c58f

so use

git bisect good 3c92ec8ae91ecf59d88c798301833d7cf83f2179
git bisect bad 6a94cb73064c952255336cc57731904174b2c58f


Sorry for the confusion..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
