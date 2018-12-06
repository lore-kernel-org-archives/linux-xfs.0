Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:54464 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbeLFEQH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Dec 2018 23:16:07 -0500
Date: Thu, 6 Dec 2018 05:16:06 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: COW improvements and always_cow support V3
Message-ID: <20181206041606.GA12563@lst.de>
References: <20181203222503.30649-1-hch@lst.de> <20181206010550.GN24487@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181206010550.GN24487@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

On Wed, Dec 05, 2018 at 05:05:50PM -0800, Darrick J. Wong wrote:
> Hmm, so I tried running xfstests with quota enabled and -g all and
> always_cow=1, and saw a bunch of test failures.  Are these expected?
> A always_cow=0 run seems to have run fine.
> 
> (generic/050 might just be broken so don't spend too much energy on
> that one)

What xfstests options are you using for this "quota enabled" run?
