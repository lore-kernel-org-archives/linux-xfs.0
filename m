Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F931C433E3
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 15:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D45E2075F
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 15:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgHYPJS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 11:09:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:55832 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgHYPJR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Aug 2020 11:09:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AD9ACAEAA;
        Tue, 25 Aug 2020 15:09:46 +0000 (UTC)
Date:   Tue, 25 Aug 2020 17:09:15 +0200
From:   Anthony Iliopoulos <ailiop@suse.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/6] xfsprogs: blockdev dax detection and warnings
Message-ID: <20200825150915.GD3357@technoir>
References: <20200824203724.13477-1-ailiop@suse.com>
 <20200824225533.GA12131@dread.disaster.area>
 <4aa834dd-5220-6312-e28f-1a94a56b1cc0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4aa834dd-5220-6312-e28f-1a94a56b1cc0@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 08:59:39AM -0500, Eric Sandeen wrote:
> On 8/24/20 5:55 PM, Dave Chinner wrote:
> > I agree that mkfs needs to be aware of DAX capability of the block
> > device, but that capability existing should not cause mkfs to fail.
> > If we want users to be able to direct mkfs to to create a DAX
> > capable filesystem then adding a -d dax option would be a better
> > idea. This would direct mkfs to align/size all the data options to
> > use a DAX compatible topology if blkid supports reporting the DAX
> > topology. It would also do things like turn off reflink (until that
> > is supported w/ DAX), etc.
> > 
> > i.e. if the user knows they are going to use DAX (and they will)
> > then they can tell mkfs to make a DAX compatible filesystem.
> 
> FWIW, Darrick /just/ added a -d daxinherit option, though all it does
> now is set the inheritable dax flag on the root dir, it doesn't enforce
> things like page vs block size, etc.

I am aware of that patch, but I considered the option to be somewhat
orthogonal, given that FS_XFLAG_DAX can be set (and inherited)
irrespective of dax support in the block device (and overridden via
mount opts if need be), so I didn't want to overload daxinherit.

> That change is currently staged in my local tree.
> 
> I suppose we could condition that on other requirements, although we've
> always had the ability to mkfs a filesystem that can't necessarily be
> used on the current machine - i.e. you can make a 64k block size filesystem
> on a 4k page machine, etc.  So I'm not sure we want to tie mkfs abilities
> to the current mkfs environment....

Agreed, so I suppose any dax option should be an opt-in, e.g. similar to
the -d dax=1 proposal. That won't prevent users from neglecting it and
creating a fs which will be later incompatible with -o dax, but that's a
different story I guess..

- Anthony
