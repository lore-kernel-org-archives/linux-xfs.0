Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:42618 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751650AbdITOlb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Sep 2017 10:41:31 -0400
Date: Wed, 20 Sep 2017 16:41:30 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: rewrite getbmap using the xfs_iext_* helpers
Message-ID: <20170920144130.GA3610@lst.de>
References: <20170918152630.24592-1-hch@lst.de> <20170918152630.24592-2-hch@lst.de> <20170920132318.GB16481@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170920132318.GB16481@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Sep 20, 2017 at 09:23:18AM -0400, Brian Foster wrote:
> I couldn't quite tell from your previous response, so just to be sure...
> is the expectation to set BMV_OF_LAST on the last real extent of the
> file, even though we might report a hole entry just below the file ends
> with a hole? If so, this seems fine:

Yes.  That's what the old code does.  Note that there isn't anything
in xfsprogs or xfstests that ever looks at BMV_OF_LAST to start with.
