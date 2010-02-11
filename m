Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1BJgBs2173646 for <xfs@oss.sgi.com>; Thu, 11 Feb 2010 13:42:12 -0600
Subject: Re: [PATCH 0/2] commit_metadata export operation v3
From: Trond Myklebust <trond.myklebust@fys.uio.no>
In-Reply-To: <20100211192611.12949.65493.stgit@case>
References: <20100211192611.12949.65493.stgit@case>
Date: Thu, 11 Feb 2010 14:43:19 -0500
Message-ID: <1265917399.478.37.camel@localhost>
Mime-Version: 1.0
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
To: Ben Myers <bpm@sgi.com>
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, 2010-02-11 at 13:26 -0600, Ben Myers wrote: 
> Here is the latest version of the knfsd sync changes.  I have addressed the
> suggestions provided by Christoph, Trond, and Dave.
> 
> Thanks,
> 	Ben

Hi Ben,

This looks good to me, but before you send it on to Bruce, you might
want to try rebasing this against his for-2.6.34 branch. That branch
contains the stuff that is queued up for the next merge window, and
includes Christoph's vfs_fsync() changes and my vfs_fsync_range() change
to nfsd_commit().

See
http://git.linux-nfs.org/?p=bfields/linux.git;a=shortlog;h=refs/heads/for-2.6.34

Cheers
  Trond

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
