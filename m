Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56214 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753872AbeGHPiQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jul 2018 11:38:16 -0400
Date: Sun, 8 Jul 2018 08:38:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] generic: mread past eof shows nonzero contents
Message-ID: <20180708153814.GD14847@infradead.org>
References: <153067982461.28315.11621030236927888645.stgit@magnolia>
 <153067983090.28315.5846228519830681377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153067983090.28315.5846228519830681377.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: guaneryu@gmail.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jul 03, 2018 at 09:50:30PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Certain sequences of generic/127 invocations complain about being able
> to mread nonzero contents past eof.  Replicate that here as a regression
> test.

This seesm to miss the update from Brian that actuallys makes
it reproduce reliably for him and for me.
