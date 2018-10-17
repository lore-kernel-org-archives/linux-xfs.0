Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48674 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbeJQQe7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Oct 2018 12:34:59 -0400
Date: Wed, 17 Oct 2018 01:40:20 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 26/26] xfs: remove redundant remap partial EOF block
 checks
Message-ID: <20181017084020.GJ16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153966006214.3607.15131077363912605792.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153966006214.3607.15131077363912605792.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Mon, Oct 15, 2018 at 08:21:02PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Now that we've moved the partial EOF block checks to the VFS helpers, we
> can remove the redundant functionality from XFS.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
