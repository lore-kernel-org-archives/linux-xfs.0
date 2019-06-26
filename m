Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:40299 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbfFZF6E (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Jun 2019 01:58:04 -0400
Date: Wed, 26 Jun 2019 07:57:32 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfs cgroup writeback support
Message-ID: <20190626055732.GA23631@lst.de>
References: <20190624134315.21307-1-hch@lst.de> <20190625032527.GF1611011@magnolia> <20190625100532.GE1462@lst.de> <20190626055701.GA5171@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626055701.GA5171@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>

On Tue, Jun 25, 2019 at 10:57:01PM -0700, Darrick J. Wong wrote:
> That may be, but I don't want to merge this patchset only to find out
> I've unleashed Pandora's box of untested cgroupwb hell... I /think/ they
> fixed all those problems, but it didn't take all that long tracing the
> blkg/blkcg object relationships for my brain to fall out. :/

c'mon.  We are adding handful of line patch to finally bring XFS in
line with everyone else.  That doesn't mean we want to take over
cgroup maintenance.
