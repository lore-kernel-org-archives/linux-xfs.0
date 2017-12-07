Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33659 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751718AbdLGADA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Dec 2017 19:03:00 -0500
Date: Thu, 7 Dec 2017 01:02:59 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: remove "no-allocation" reservations for file
        creations
Message-ID: <20171207000259.GA18701@lst.de>
References: <20170821082404.3387-1-hch@lst.de> <20170823202213.GA4796@magnolia> <20170824004755.GC21024@dastard> <20170829180445.GU4757@magnolia> <20170903072513.GA14807@lst.de> <20170903153150.GE4073@magnolia> <20171205013422.GC19219@magnolia> <20171205185936.GE19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171205185936.GE19219@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Tue, Dec 05, 2017 at 10:59:36AM -0800, Darrick J. Wong wrote:
> I fixed most of the auto group regressions with small fixes to xfstests,
> but xfs/013 is a problem because once we run out of space to create new
> dirX we simply get nothing.  Will have to study the behavior of that
> test in more depth...

With what kind of config do you see xfs/013 failures?
