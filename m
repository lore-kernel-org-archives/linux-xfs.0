Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:50535 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031649AbeBNPxo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Feb 2018 10:53:44 -0500
Date: Wed, 14 Feb 2018 16:53:43 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: rewrite the fdatasync optimization
Message-ID: <20180214155343.GA4472@lst.de>
References: <20180205073933.17065-1-hch@lst.de> <20180205221726.c2hdvaairki27gxf@destitution> <20180206072356.GB1649@lst.de> <20180208231725.GH20266@dastard> <20180213150402.GA15030@lst.de> <20180213232640.GG6778@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180213232640.GG6778@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Jeff Layton <jlayton@redhat.com>

Ok, for the case where the same file also accessed throught NFS is
locally written and fdatasync we'll run into an issue.

But we already have the exact same issue on NFSv3 which always uses
ctime and never looks at iversion.
