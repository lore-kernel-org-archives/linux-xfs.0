Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33934 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbeJOX2S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Oct 2018 19:28:18 -0400
Date: Mon, 15 Oct 2018 08:42:08 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 11/25] vfs: pass remap flags to
 generic_remap_file_range_prep
Message-ID: <20181015154208.GH28243@magnolia>
References: <153938912912.8361.13446310416406388958.stgit@magnolia>
 <153938921860.8361.1983470639945895613.stgit@magnolia>
 <20181014173738.GA6400@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181014173738.GA6400@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Sun, Oct 14, 2018 at 10:37:38AM -0700, Christoph Hellwig wrote:
> > +	bool is_dedupe = (remap_flags & RFR_SAME_DATA);
> 
> Btw, I think the code would be cleaner if we dropped this variable.

Ok to both.  I'll move up the patch to replace is_dedupe with
remap_flags to avoid churning the _touch function too, btw.

--D
