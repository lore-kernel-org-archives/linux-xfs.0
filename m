Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54953 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932158AbeDWReZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Apr 2018 13:34:25 -0400
Date: Mon, 23 Apr 2018 19:35:48 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 12/13] xfs: rename on-disk dquot counter zap functions
Message-ID: <20180423173548.GL834@lst.de>
References: <152440954198.29601.14390250048915099607.stgit@magnolia> <152440963795.29601.14844972913332721242.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152440963795.29601.14844972913332721242.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de

I agree with getting rid of the old names, but what about

xfs_qm_reset_dqcounts_buf and xfs_qm_reset_dqcounts_all to fit with
the naming for the existing xfs_qm_reset_dqcounts low-level function?
