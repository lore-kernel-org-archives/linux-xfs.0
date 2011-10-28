Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9S9bsGI144417 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 04:37:54 -0500
Date: Fri, 28 Oct 2011 05:37:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: incremental dump directory selection
Message-ID: <20111028093752.GB23069@infradead.org>
References: <1319214933-16276-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1319214933-16276-1-git-send-email-wkendall@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 21, 2011 at 11:35:33AM -0500, Bill Kendall wrote:
> When doing incremental backups, xfsdump does a recursive scan through
> the filesystems to determine the proper set of unchanged directories
> to include in the dump in order to make the dump self-contained
> (allowing files to be restored from this dump without applying the
> base dumps first).
> 
> For high-inode count filesystems, the recursive scan may consume a
> significant portion of the backup time. This patch adds a -D option
> which causes xfsdump to skip the recursive scan. Unchanged directories
> will not be dumped, so the base dump(s) will have to be loaded prior
> to restoring files from the dump. When restoring files from such a
> dump, a message is issued to alert the user that files may end up in
> the orphanage if the base dump(s) has not been applied.

Any chance you could submit some xfstests coverage for this feature?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
