Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JBk9c1126179 for <xfs@oss.sgi.com>; Wed, 19 May 2010 06:46:09 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 603E41DF3242
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 04:48:28 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id L6iccW2gaSGNOPPL for
	<xfs@oss.sgi.com>; Wed, 19 May 2010 04:48:28 -0700 (PDT)
Date: Wed, 19 May 2010 07:48:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS on 2.6.26: reading the first 4K of a large file takes ages
Message-ID: <20100519114826.GA18224@infradead.org>
References: <8239xojfco.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <8239xojfco.fsf@mid.bfk.de>
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
To: Florian Weimer <fweimer@bfk.de>
Cc: xfs@oss.sgi.com

On Wed, May 19, 2010 at 11:33:27AM +0000, Florian Weimer wrote:
> We've got a couple of rather large files, and with a cold cache,
> reading the first 4K bytes of the file (e.g., just running
> "head --bytes 4096" on it) takes ages, up to several minutes,
> sometimes triggering the hang check timer.
> 
> I wonder if XFS reads the whole extent information into RAM when the
> file is opened.  Is this the case, at least on 2.6.26?  Has this
> changed in later versions, perhaps?

Yes, XFS always reads in the extent map, and no this hasn't changed
recently.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
