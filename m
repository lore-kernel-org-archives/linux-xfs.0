Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:51905 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751435AbdCAPJd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Mar 2017 10:09:33 -0500
Date: Wed, 1 Mar 2017 16:09:30 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] failure atomic writes for file systems and block devices
Message-ID: <20170301150930.GF12248@lst.de>
References: <20170228145737.19016-1-hch@lst.de> <20170228232204.GB5269@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170228232204.GB5269@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

On Tue, Feb 28, 2017 at 03:22:04PM -0800, Darrick J. Wong wrote:
> (Assuming there's no syncv involved here...?)

No.  While I think we could implement it for XFS similar how we roll
transactions over multiple inodes for a few transactions, the use case
is much more limited, and the potential pitfalls are much bigger.

> > have to check the F_IOINFO fcntl before, which is a bit of a killer.
> > Because of that I've also not implemented any other validity checks
> > yet, as they might make thing even worse when an open on a not supported
> > file system or device fails, but not on an old kernel.  Maybe we need
> > a new open version that checks arguments properly first?
> 
> Does fcntl(F_SETFL...) suffer from this?

Yes.
