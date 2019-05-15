Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:59032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbfEOGwk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 02:52:40 -0400
Date: Tue, 14 May 2019 23:52:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/11] libxfs: create new file trans_buf.c
Message-ID: <20190515065238.GF29211@infradead.org>
References: <1557519510-10602-1-git-send-email-sandeen@redhat.com>
 <1557519510-10602-7-git-send-email-sandeen@redhat.com>
 <20190515060750.GY29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515060750.GY29573@dread.disaster.area>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org

On Wed, May 15, 2019 at 04:07:50PM +1000, Dave Chinner wrote:
> On Fri, May 10, 2019 at 03:18:25PM -0500, Eric Sandeen wrote:
> > Pull functions out of libxfs/*.c into trans_buf.c, if they roughly match
> > the kernel's xfs_trans_buf.c file.
> > 
> > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> So I have no problems with this, but I'm not sure what the eventual
> goal is? Just sharing code, or is there some functionality that
> requires a more complete transaction subsystem in userspace?
> 
> I'm asking because if the goal is eventual unification with the
> kernel code, then we probably should name the files the same as the
> kernel code so we don't have to rename them again when we do the
> unification. That will make history searching a bit easier - less
> file names to follow across and git blame works a whole lot better...

Even if we don't want to directly share code having the same file
name would still be nice..
