Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60178 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfBBT2P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Feb 2019 14:28:15 -0500
Date: Sat, 2 Feb 2019 11:28:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/8] xfs: track unlinked inode counts in per-ag data
Message-ID: <20190202192805.GP5761@magnolia>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897668290.26065.2216454639188570690.stgit@magnolia>
 <20190201185924.GA31203@bfoster>
 <20190201193348.GL5761@magnolia>
 <20190202161404.GA19609@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190202161404.GA19609@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Sat, Feb 02, 2019 at 08:14:04AM -0800, Christoph Hellwig wrote:
> On Fri, Feb 01, 2019 at 11:33:48AM -0800, Darrick J. Wong wrote:
> > Maybe we can just drop this patch entirely?  If we leak any unlinked
> > inodes they'll get cleaned up at next mount... wait, we never did merge
> > Eric's patch to reap unlinked inodes at mount time, did we?
> 
> Which patch?  We must recovery unlinked inodes during each mount that
> requires log recovery and have done that since the very beginning.

I /think/ the patch was "xfs: don't require a dirty log on snapshots".

> I don't see how we could ever see unlinked inodes during a clean
> mount.

/me had thought it was related to something about root filesystems that
are mounted ro and then remounted rw, but <shrug> I can't recall ATM.

Anyway, I'm still not sure we need all this mutex+counter infrastructure
for a debugging assert...

--D
