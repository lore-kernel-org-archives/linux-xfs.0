Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36401 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdH2NAr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2017 09:00:47 -0400
Date: Tue, 29 Aug 2017 06:00:46 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS reflinks
Message-ID: <20170829130046.GA28896@infradead.org>
References: <04eacb90-aac9-7c47-f074-fa91eb253822@bytemark.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04eacb90-aac9-7c47-f074-fa91eb253822@bytemark.co.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Cottam <chris.cottam@bytemark.co.uk>
Cc: linux-xfs@vger.kernel.org

On Tue, Aug 29, 2017 at 12:23:13PM +0100, Chris Cottam wrote:
> I've got a project where being able to take COW copies of a VMs disc
> would be really useful (disc snapshots to be then archived off elsewhere)
> 
> How stable is the the experimental reflinks feature and do you have any
> idea when it might be declared stable?

I've got a customer that heavily uses (and tests) reflinks.  They
initially found a few issues, but these days the QA teams finds
bugs in decade old XFS code but not related to reflinks..

You're mileage my vary, but I think we should be able to drop the
experimental tag now.
