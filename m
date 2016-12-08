Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54945 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbcLHOal (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 8 Dec 2016 09:30:41 -0500
Date: Thu, 8 Dec 2016 06:30:39 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] xfs/109 crashed 2k block size reflink enabled XFS
Message-ID: <20161208143039.GA32751@infradead.org>
References: <20161205092112.GS29149@eguan.usersys.redhat.com>
 <20161205143906.GA16352@infradead.org>
 <20161205153625.GA20032@infradead.org>
 <20161205182802.GB8436@birch.djwong.org>
 <20161206144559.GA14623@infradead.org>
 <20161207034903.GX16813@birch.djwong.org>
 <20161207071857.GA23809@infradead.org>
 <20161207174032.GA1072@infradead.org>
 <20161208063503.GJ8436@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161208063503.GJ8436@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eryu Guan <eguan@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Dec 07, 2016 at 10:35:03PM -0800, Darrick J. Wong wrote:
> I bet that assert is a result of the btree insert failing to find a new
> block to expand into.  I've felt for a while that we ought to yell ENOSPC
> louder when this happens, since I've hit it numerous times and grumbled
> about it not being obvious that we ran out of space.

Heh.  Took me a while to figure out what caused it last night as well.

> Anyway, XFS_AG_RESV_AGFL only gets a reservation if rmapbt=1 (or if you
> added an additional reservation after dinner), so if you're running
> reflink only then it's not surprising that it still runs out of space,
> since reflink=1 only reserves RESV_METADATA space.

I'm not running reflink only - this is the testcase from Eryu with
reflink and rmpbt for now.

But at that point I didn't add RESV_METADATA to xfs_bmbt_alloc_block.
With that one liner added xfs/109 seems to be doing fine so far, and
I've had it running for a few hours already today.  Note that this
is still without actually reserving additional block in
xfs_ag_resv_init, which is probably needed.
