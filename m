Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0AK9Quj036366 for <xfs@oss.sgi.com>; Mon, 10 Jan 2011 14:09:28 -0600
Date: Mon, 10 Jan 2011 15:11:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/12] xfsprogs: some things aren't all that special
Message-ID: <20110110201137.GA27277@infradead.org>
References: <1293741599.2294.342.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1293741599.2294.342.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 30, 2010 at 02:39:59PM -0600, Alex Elder wrote:
> Move the check for short file names out of is_special_dirent() and
> into generate_obfuscated_name().  That way the check is more
> directly associated with the algorithm that requires it.
> 
> Similarly, move the check for inode == 0, since that case has to do
> with storing extended attributes (not files) in the name table.
> 
> As a result, is_special_dirent() is really only focused on whether a
> given file is in the lost+found directory.
> 
> Rename is_special_dirent() to reflect its more specific purpose.
> 
> And use a cast to elminate a compile warning in calls to
> libxfs_da_hashname().

I think Dave's resync of libxfs takes care of that bit.  Either way it
really should be a separate patch.

Also you've stopped overwriting orphanage_ino if it already exists.
I don't think this really matters as we won't have two inodes with the
same name below the root inode.  Either way it should be documented in
the changelog.

Otherwise the change looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
