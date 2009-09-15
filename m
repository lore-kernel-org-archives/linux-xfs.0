Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8FCltdG162242 for <xfs@oss.sgi.com>; Tue, 15 Sep 2009 07:48:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53DB51658D2A
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2009 05:49:09 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id EISk4anjjdC0ZoiH for
	<xfs@oss.sgi.com>; Tue, 15 Sep 2009 05:49:09 -0700 (PDT)
Date: Tue, 15 Sep 2009 08:49:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [xfstests]: add-reiserfs-specific-_check_reiserfs_filesystem patch
Message-ID: <20090915124908.GA4070@infradead.org>
References: <200909140846.52217.jbarton@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200909140846.52217.jbarton@redhat.com>
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
To: Jaroslav Barton <jbarton@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 14, 2009 at 08:46:52AM +0200, Jaroslav Barton wrote:
> Hi,
> 
> I was on vacation last week.
> 
> I am using xfstests in my project and testing reiserfs filesystem. Reiserfsck 
> waits for confirmation before fsck is runned. This patch runs reiserfsck with 
> --yes parameter and confirmation is not needed.

I'd be much more happy if you would add a way to pass options to
_check_generic_filesystem, e.g. by introducing a _fsck_opts machinery
mirroring _mkfs_opts and _mount_opts.  That would also clean up what
Ted did in 8b61ae6352b1f92cc004a7349b90f39609c77a8f.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
