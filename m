Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:56701 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752096AbdHKLWF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 07:22:05 -0400
Date: Fri, 11 Aug 2017 04:22:03 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] xfs: evict all inodes involved with log redo item
 recovery
Message-ID: <20170811112203.GC27964@infradead.org>
References: <150234262066.13754.6534116056866237943.stgit@magnolia>
 <150234263191.13754.5037661818451431724.stgit@magnolia>
 <20170810145126.GC3777@bfoster.bfoster>
 <20170810171851.GW24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170810171851.GW24087@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Thu, Aug 10, 2017 at 10:18:51AM -0700, Darrick J. Wong wrote:
> I felt there's less messing around with vfs internals by sticking to
> igrab and iput (and letting them deal with the internal inode state)
> since that's what xfs uses elsewhere to manage inode life cycles.

I'd feel much safer calling evict_inodes rather than reimplementing
it poorly.  In fact we might want to just call it in the VFS after
a failed mount?

Either way please also add Al to the Cc for the next version.
