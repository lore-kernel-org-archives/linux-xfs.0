Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1GIZ14j172951 for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 12:35:02 -0600
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 353291D5E00
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2010 10:36:19 -0800 (PST)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id hwyZmGMmptt124sc for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2010 10:36:19 -0800 (PST)
Date: Tue, 16 Feb 2010 19:36:28 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 00/10] quotactl fixed and cleanups
Message-ID: <20100216183627.GC3153@quack.suse.cz>
References: <20100216084446.377980079@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100216084446.377980079@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, jack@suse.cz, swhiteho@redhat.com, xfs@oss.sgi.com

On Tue 16-02-10 03:44:46, Christoph Hellwig wrote:
> This is a first large batch of refactoring the generic quotactl code.
> I started looking at this for merging the FS interfaces for "VFS" and "XFS"
> style quotas now that we grow more filesystems wanting to support quota
> in a more advanced way than the generic implementation can, e.g. GFS2
> and cifs.  There will be another couple of patches do do the actual
> work which are not quite ready, but this is a large and useful enough batch
> to get review and possibly included first.
  Thanks for the cleanups. Upto a few fixed typos and whitespace errors
I've merged your patchset into my tree.
  As a side note, OCFS2 implements XFS-style clustered quotas using current
VFS quota subsystem (and quota file format) so my naive feeling is that at
least GFS2 should fit in there as well. But maybe I'm wrong.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
