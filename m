Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54937 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932076AbeDWRbe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 13:31:34 -0400
Date: Mon, 23 Apr 2018 19:32:57 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/13] xfs: remove xfs_qm_dqread flags argument
Message-ID: <20180423173257.GI834@lst.de>
References: <152440954198.29601.14390250048915099607.stgit@magnolia> <152440961880.29601.15798100669042989214.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440961880.29601.15798100669042989214.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

On Sun, Apr 22, 2018 at 08:06:58AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the _qm_dqread functionality to _qm_dqensure, then remove the flags
> argument from xfs_qm_dqread since the only DQALLOC users were internal
> to xfs_dquot.c anyway.

Unless this makes something much easier later in the series I'd rather
not change the names and calling conventions here.  dqensure just sounds
very weird, and having dqread is a trivial wrapper for it also doesn't
seem to be very intuitive.
