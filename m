Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n09JilXw017679 for <xfs@oss.sgi.com>; Fri, 9 Jan 2009 13:44:47 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C846417C86E4
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2009 11:44:46 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rCVyZHEHqZuxdifx for
	<xfs@oss.sgi.com>; Fri, 09 Jan 2009 11:44:46 -0800 (PST)
Date: Fri, 9 Jan 2009 14:44:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090109194445.GA28759@infradead.org>
References: <20090107180246.GA15218@infradead.org>
	<20090107182415.GA12039@dth.net>
	<20090107183115.GA6261@infradead.org>
	<20090107184420.GA15653@dth.net>
	<20090107185628.GA19255@infradead.org>
	<20090108215602.GA24479@dth.net> <20090109004609.GM9448@disturbed>
	<20090109012610.GA23075@dth.net> <20090109020800.GO9448@disturbed>
	<20090109061043.GA31450@dth.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090109061043.GA31450@dth.net>
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

On Fri, Jan 09, 2009 at 07:10:44AM +0100, Danny ter Haar wrote:
> # git bisect bad v2.6.28-git3
> # git bisect good v2.6.28-git2
> 
> and take it from there.

Yes.  Then it gives you a revision to test and you can use

	git bisect next

to try the next one, or

	git bisect skip

if the current version is bad due to some other reason (doesn't boot /
compile)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
