Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54734 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbeGYGIR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 02:08:17 -0400
Date: Tue, 24 Jul 2018 21:58:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: clean up IRELE/iput callsites
Message-ID: <20180725045823.GB31006@infradead.org>
References: <153248128617.28208.11803349732053454018.stgit@magnolia>
 <153248129832.28208.4218463670080722161.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153248129832.28208.4218463670080722161.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 24, 2018 at 06:14:58PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Replace the IRELE macro with a proper function so that we can do proper
> typechecking and so that we can stop open-coding iput in scrub, which
> means that we'll be able to ftrace inode lifetimes going through scrub
> correctly.

Why do we need a function to be able to use IRELE in scrub?
