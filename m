Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49874 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751332AbdH3Nqa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 30 Aug 2017 09:46:30 -0400
Date: Wed, 30 Aug 2017 15:46:29 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: fix incorrect log_flushed on fsync
Message-ID: <20170830134629.GA32355@lst.de>
References: <1504100302-3297-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1504100302-3297-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Josef Bacik <jbacik@fb.com>, stable@vger.kernel.org

Oops.

Yes, except for the case of calling xlog_state_release_iclog
ourselves we can't claim that the cache has been flushed.  In
fact I'm not even sure that is save, if ic_refcnt makes
xlog_state_release_iclog exit early, so we might have to
pass additional information around there.
