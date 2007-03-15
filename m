Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 15 Mar 2007 12:58:08 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2FJvx6p013950
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2007 12:57:59 -0700
Date: Thu, 15 Mar 2007 20:57:57 +0100
From: Nick Piggin <npiggin@suse.de>
Subject: Re: Announce: new-aops-1 for 2.6.21-rc3
Message-ID: <20070315195757.GB19625@wotan.suse.de>
References: <20070315161704.GH8321@wotan.suse.de> <20070315195351.GE21942@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315195351.GE21942@ca-server1.us.oracle.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>, reiserfs-list@namesys.com, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, nfs@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net

On Thu, Mar 15, 2007 at 12:53:51PM -0700, Mark Fasheh wrote:
> On Thu, Mar 15, 2007 at 05:17:04PM +0100, Nick Piggin wrote:
> > OK, I've gone through and fixed several bugs until the thing actually
> > survives fsx-linux for both ext2 and ext3 ordered and writeback (both
> > when using the new aops, and the legacy prepare_write path). Actually
> > ext3 sometimes breaks, but it does in unpatched kernels anyway.
> > 
> > At 15 patches (including the initial buffered write deadlock fixes),
> > it is too much to keep posting -- not much has fundamentally changed,
> > so I'll just post occasionally if we make big changes. The quilt
> > format is probably easier for someone wishing to work on it anyway.
> 
> Hmm, we still left out some exports...

Thanks, applied.
