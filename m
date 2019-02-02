Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34676 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbfBBQOG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Feb 2019 11:14:06 -0500
Date: Sat, 2 Feb 2019 08:14:04 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/8] xfs: track unlinked inode counts in per-ag data
Message-ID: <20190202161404.GA19609@infradead.org>
References: <154897667054.26065.13164381203002725289.stgit@magnolia>
 <154897668290.26065.2216454639188570690.stgit@magnolia>
 <20190201185924.GA31203@bfoster>
 <20190201193348.GL5761@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190201193348.GL5761@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Fri, Feb 01, 2019 at 11:33:48AM -0800, Darrick J. Wong wrote:
> Maybe we can just drop this patch entirely?  If we leak any unlinked
> inodes they'll get cleaned up at next mount... wait, we never did merge
> Eric's patch to reap unlinked inodes at mount time, did we?

Which patch?  We must recovery unlinked inodes during each mount that
requires log recovery and have done that since the very beginning.

I don't see how we could ever see unlinked inodes during a clean
mount.
