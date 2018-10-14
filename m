Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53134 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeJOBTZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 14 Oct 2018 21:19:25 -0400
Date: Sun, 14 Oct 2018 10:37:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/25] vfs: pass remap flags to
 generic_remap_file_range_prep
Message-ID: <20181014173738.GA6400@infradead.org>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938921860.8361.1983470639945895613.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153938921860.8361.1983470639945895613.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

> +	bool is_dedupe = (remap_flags & RFR_SAME_DATA);

Btw, I think the code would be cleaner if we dropped this variable.
