Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:58958 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932770AbeGIQZP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jul 2018 12:25:15 -0400
Date: Mon, 9 Jul 2018 09:24:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/2] generic: mread past eof shows nonzero contents
Message-ID: <20180709162458.GH5724@magnolia>
References: <153067982461.28315.11621030236927888645.stgit@magnolia>
 <153067983090.28315.5846228519830681377.stgit@magnolia>
 <20180708153814.GD14847@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180708153814.GD14847@infradead.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Sun, Jul 08, 2018 at 08:38:14AM -0700, Christoph Hellwig wrote:
> On Tue, Jul 03, 2018 at 09:50:30PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Certain sequences of generic/127 invocations complain about being able
> > to mread nonzero contents past eof.  Replicate that here as a regression
> > test.
> 
> This seesm to miss the update from Brian that actuallys makes
> it reproduce reliably for him and for me.

Oops, I lost track of that. :(

I'll post an update to g/499 to add it in.

--D
