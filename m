Return-Path: <SRS0=XxdV=7D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEEF9C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 09:05:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABC7E2070A
	for <linux-xfs@archiver.kernel.org>; Thu, 21 May 2020 09:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbgEUJFQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 05:05:16 -0400
Received: from verein.lst.de ([213.95.11.211]:53758 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728558AbgEUJFQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 21 May 2020 05:05:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E057B68BEB; Thu, 21 May 2020 11:05:13 +0200 (CEST)
Date:   Thu, 21 May 2020 11:05:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/11] xfs: hide most of the incore inode walk interface
Message-ID: <20200521090513.GB8252@lst.de>
References: <158993911808.976105.13679179790848338795.stgit@magnolia> <158993918698.976105.6231244252663510379.stgit@magnolia> <20200520064643.GK2742@lst.de> <20200520185422.GY17627@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520185422.GY17627@magnolia>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 20, 2020 at 11:54:22AM -0700, Darrick J. Wong wrote:
> On Wed, May 20, 2020 at 08:46:43AM +0200, Christoph Hellwig wrote:
> > On Tue, May 19, 2020 at 06:46:27PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Hide the incore inode walk interface because callers outside of the
> > > icache code don't need to know about iter_flags and radix tags and other
> > > implementation details of the incore inode cache.
> > 
> > I don't really see the point here.  It isn't hiding much, and only from
> > a single caller.  I have to say I also prefer the old naming over _ici_
> > and find the _all postfix not exactly descriptive.
> 
> This last patch is more of a prep patch for the patchsets that come
> after it: cleaning up the block gc stuff and deferred inode
> inactivation.  It's getting kinda late so I didn't want to send 11 more
> patches, but perhaps that would make it clearer where this is all
> heading?

I'd say drop it from this series and resend it with that series if
you are going to send it out.

> The quota dqrele_all code does not care about inode radix tree tags nor

It only started to care about them because you merged the functions
and now exposed them to the dqrele code at the beginning of this series.
But with just a single user not caring and too aring I'm perfectly fine
with exposing the tags in the interface.

> does it need the ability to grab inodes /while/ they're in INEW state,
> so there's no reason to pass those arguments around.
> 
> OTOH I guess I could have hid XFS_AGITER_INEW_WAIT in xfs_icache.c and
> left the function names unchanged.

Maybe just flip the default for the flag if that makes your series
easier?
