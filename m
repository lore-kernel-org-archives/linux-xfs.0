Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Aug 2008 04:52:05 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7LBq06H008208
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 04:52:01 -0700
Received: from mail.parisc-linux.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 164DC1A1F5C3
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 04:53:21 -0700 (PDT)
Received: from mail.parisc-linux.org (palinux.external.hp.com [192.25.206.14]) by cuda.sgi.com with ESMTP id pXIeVyabms5p6uo0 for <xfs@oss.sgi.com>; Thu, 21 Aug 2008 04:53:21 -0700 (PDT)
Date: Thu, 21 Aug 2008 05:53:10 -0600
From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
Message-ID: <20080821115310.GP8318@parisc-linux.org>
References: <20080820004326.519405a2.akpm@linux-foundation.org> <200808201613.AA00212@capsicum.lab.ntt.co.jp> <Pine.LNX.4.61.0808202352450.4532@dhcppc2> <20080820143916.1a7eddab.akpm@linux-foundation.org> <20080821021259.GA5706@disturbed> <Pine.LNX.4.62.0808210535450.25448@tamago.serverit.net> <20080821051508.GB5706@disturbed> <20080821060418.GC5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821060418.GC5706@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Szabolcs Szakacsits <szaka@ntfs-3g.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Aug 21, 2008 at 04:04:18PM +1000, Dave Chinner wrote:
> One thing I just found out - my old *laptop* is 4-5x faster than the
> 10krpm scsi disk behind an old cciss raid controller.  I'm wondering
> if the long delays in dispatch is caused by an interaction with CTQ
> but I can't change it on the cciss raid controllers. Are you using
> ctq/ncq on your machine?  If so, can you reduce the depth to
> something less than 4 and see what difference that makes?

I don't think that's going to make a difference when using CFQ.  I did
some tests that showed that CFQ would never issue more than one IO at a
time to a drive.  This was using sixteen userspace threads, each doing a
4k direct I/O to the same location.  When using noop, I would get 70k
IOPS and when using CFQ I'd get around 40k IOPS.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
