Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JBIIBU124660 for <xfs@oss.sgi.com>; Wed, 19 May 2010 06:18:18 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87A2A9E5E33
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 04:21:43 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id iPlDyZxCFjv7oCNY for <xfs@oss.sgi.com>;
	Wed, 19 May 2010 04:21:43 -0700 (PDT)
Date: Wed, 19 May 2010 07:20:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: rsync from xfs to nfs+xfs and ACL problems
Message-ID: <20100519112034.GA29064@infradead.org>
References: <201005181350.15308@zmi.at> <20100518123304.GH2150@dastard>
	<201005191304.42314@zmi.at>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201005191304.42314@zmi.at>
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

On Wed, May 19, 2010 at 01:04:37PM +0200, Michael Monnerie wrote:
> I changed again and defined an rsync module on the target, making a 
> direct rsync and no more shown errors. Still, what is causing the tons 
> of errors when rsyncing to nfs+xfs, no matter if nfs3 or nfs4? I looked 
> manually at some files and it seems everything was copied well, despite 
> the errors.

XFS stores ACLs different than other Linux filesystems because it's
on-disk compatible to IRIX.  While the other filesystems store the ACL
in the same format that is used for the user interface XFS stores it
in a separate trusted extended attribute.  rsync should and
traditionally has ignored those attributes, but it seems something in
rsync changed recently so that it tries to copy these attributes in
the trusted.* namespace, which fails on NFS.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
