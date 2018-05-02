Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:39948 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750936AbeEBQb4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 May 2018 12:31:56 -0400
Date: Wed, 2 May 2018 18:34:31 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/13] xfs: remove xfs_qm_dqread flags argument
Message-ID: <20180502163431.GB27020@lst.de>
References: <152506698177.21553.13500862866416804148.stgit@magnolia> <152506705098.21553.6894396720813018127.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152506705098.21553.6894396720813018127.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@lst.de

On Sun, Apr 29, 2018 at 10:44:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Move the _qm_dqread functionality to _qm_dqensure, then remove the flags
> argument from xfs_qm_dqread since the only DQALLOC users were internal
> to xfs_dquot.c anyway.

I really see no point in doing the wrapper.  I'd much rather keep
xfs_qm_dqread with a the additional argument, be that a flags value
or a bool.  For example the same patch with the new xfs_dquot_setup
kept as xfs_qm_dqread and everyone calling it with an additional
false argument would seem much nicer to me.
