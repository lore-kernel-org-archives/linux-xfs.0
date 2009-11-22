Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAMCUbiU140842 for <xfs@oss.sgi.com>; Sun, 22 Nov 2009 06:30:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9755D18C3010
	for <xfs@oss.sgi.com>; Sun, 22 Nov 2009 04:31:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id UC6lloaSA4WlM7r0 for
	<xfs@oss.sgi.com>; Sun, 22 Nov 2009 04:31:02 -0800 (PST)
Date: Sun, 22 Nov 2009 07:31:01 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS, NFS and inode64 on 2.6.27
Message-ID: <20091122123101.GA30986@infradead.org>
References: <200911201152.43809@zmi.at> <20091121131657.GA2095@infradead.org>
	<200911212217.57407@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200911212217.57407@zmi.at>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Sat, Nov 21, 2009 at 10:17:57PM +0100, Michael Monnerie wrote:
> >  filehandles which have to encode the inode number of the export
> >  root.  Your best option is to simplify switch to exporting a whole
> >  filesystem, 
> 
> That's how it worked until NFSv3. I tried that also, didn't work either.
> The whole thing worked before I reinstalled it (this server now runs 
> virtualized within XENserver), and maybe that made some subdirs have 
> inodes > 32bit.
> 
> >  alternatively you can try making sure NFSD uses the
> >  16byte wide UUID style export.  
> 
> How'd I do that?

I'm not sure, haven't deal with nfs utils a lot recently.  I'd suggest
you brings this up on linux-nfs@vger.kernel.org.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
