Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:37248 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932985AbdBVTkD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 22 Feb 2017 14:40:03 -0500
Date: Wed, 22 Feb 2017 12:39:59 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: XFS kernel BUG during generic/270 with v4.10
Message-ID: <20170222193959.GB29474@linux.intel.com>
References: <20170222191300.GA29474@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170222191300.GA29474@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org

On Wed, Feb 22, 2017 at 12:13:00PM -0700, Ross Zwisler wrote:
> By running generic/270 in a loop on an XFS filesystem mounted with DAX I'm
> able to reliably generate the following kernel bug after a few (~10)
> iterations (output passed through kasan_symbolize.py):

A few other notes which I should have included in the original report:

1) I initially found this while testing Brian's fix for the WARN_ON I reported
with this same test [1].

2) After the initial failure I was able to reproduce the issue reliably on
v4.10.  Based on 1) and 2) my guess is that this failure is independent of the
other issue that I reported and that Brian was trying to fix.  They just
happen to show up with the same xfstest.

[1] https://www.spinics.net/lists/linux-xfs/msg04300.html

Thanks,
- Ross
