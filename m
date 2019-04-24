Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44893 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726935AbfDXQqj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Apr 2019 12:46:39 -0400
Date: Wed, 24 Apr 2019 18:46:34 +0200
From: Greg KH <greg@kroah.com>
Subject: Re: [STABLE PATCH 0/2] Fix in-memory metadata corruption at
 xfs_attr3_leaf_write_verify()
Message-ID: <20190424164634.GC21916@kroah.com>
References: <1554042273-3307-1-git-send-email-alex@zadara.com>
 <20190403140822.GH8633@kroah.com>
 <CAOcd+r23YiLOZWoWVkuF3U4EJGiEOFM-1MgZiBgMJA4apavH8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOcd+r23YiLOZWoWVkuF3U4EJGiEOFM-1MgZiBgMJA4apavH8w@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadara.com>
Cc: linux-xfs@vger.kernel.org, stable@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, hch@lst.de, Shyam Kaushik <shyam@zadara.com>

On Sat, Apr 06, 2019 at 04:11:53PM +0300, Alex Lyakas wrote:
> Hi Greg,
> 
> The relevant commits in the Linus's tree are:
> 
> b7b2846fe26f2c0d7f317c874a13d3ecf22670ff
> xfs: add the ability to join a held buffer to a defer_ops
> 
> 6e643cd094de3bd0f97edcc1db0089afa24d909f
> xfs: hold xfs_buf locked between shortform->leaf conversion and the
> addition of an attribute
> 
> They were pulled by Linus in commit:
> 
> fca0e39b2bd2fcfea2027845df28757943d9f561
> Merge tag 'xfs-4.15-fixes-8' of git://git.kernel.org/pub/scm/fs/xfs/xfs-linux

Thanks, both now queued up.

greg k-h
