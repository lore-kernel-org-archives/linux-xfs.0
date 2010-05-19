Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JBnXvx126332 for <xfs@oss.sgi.com>; Wed, 19 May 2010 06:49:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 25DBA1DF327F
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 04:51:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YYbX1PGdmRJCtDdN for
	<xfs@oss.sgi.com>; Wed, 19 May 2010 04:51:52 -0700 (PDT)
Date: Wed, 19 May 2010 07:51:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: rsync from xfs to nfs+xfs and ACL problems
Message-ID: <20100519115151.GA19104@infradead.org>
References: <201005181350.15308@zmi.at> <201005191304.42314@zmi.at>
	<20100519112034.GA29064@infradead.org> <201005191346.38699@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201005191346.38699@zmi.at>
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

On Wed, May 19, 2010 at 01:46:38PM +0200, Michael Monnerie wrote:
> On Mittwoch, 19. Mai 2010 Christoph Hellwig wrote:
> > XFS stores ACLs different than other Linux filesystems because it's
> > on-disk compatible to IRIX.  While the other filesystems store the
> >  ACL in the same format that is used for the user interface XFS
> >  stores it in a separate trusted extended attribute.  rsync should
> >  and
> > traditionally has ignored those attributes, but it seems something in
> > rsync changed recently so that it tries to copy these attributes in
> > the trusted.* namespace, which fails on NFS.
>  
> Thank you. Does that mean I can simply ignore that errors, and that 
> everything is OK even over NFS?

Thinks should be okay - rsync probably has copied the ACLs via the
normal system namespace.  You can verify this by doing a getfacl
on a nfs file that should havfe ACLs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
