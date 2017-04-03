Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:48355 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752237AbdDCSyx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 3 Apr 2017 14:54:53 -0400
Date: Mon, 3 Apr 2017 20:54:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] xfs: Honor FALLOC_FL_KEEP_SIZE when punching ends
        of files
Message-ID: <20170403185441.GA30537@lst.de>
References: <22a11e65fd5037498a78de61f3ed4dae466ad854.1489791330.git.calvinowens@fb.com> <19504ff40a16efff2e51d85388fce5be578edbc3.1489985397.git.calvinowens@fb.com> <20170321113932.GA58653@bfoster.bfoster> <ab15bba5-601a-3297-959c-ddb04b42d082@fb.com> <20170331041800.ugi4wgmbqx44mbwa@Haydn> <20170403171531.GJ4864@birch.djwong.org> <20170403171812.GK4864@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170403171812.GK4864@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Calvin Owens <calvinowens@fb.com>, Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, kernel-team@fb.com, stable@vger.kernel.org

On Mon, Apr 03, 2017 at 10:18:12AM -0700, Darrick J. Wong wrote:
> I'll pick this up for 4.12, unless anyone wants me to push this for -rc6?

Yes, please do.  This is a regression that corrupts user visible data.
