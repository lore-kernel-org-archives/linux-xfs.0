Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:38341 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728291AbeKTAoP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 19 Nov 2018 19:44:15 -0500
Date: Mon, 19 Nov 2018 15:20:28 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/5] generic: move prealloc-enabled fsx to separate
 tests
Message-ID: <20181119142028.GA16619@lst.de>
References: <20181110115145.30356-1-hch@lst.de> <20181110115145.30356-2-hch@lst.de> <20181118134456.GC3889@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181118134456.GC3889@desktop>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Sun, Nov 18, 2018 at 09:44:56PM +0800, Eryu Guan wrote:
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2000-2003 Silicon Graphics, Inc.  All Rights Reserved.
> 
> Hmm, I think it's better to write proper Copyright information for new
> tests,

I'm not the copyright holder, so I can't easily change this.  But
except for the odd All Rights reserved the above seems to be exactly
the style we use now.

> > +_cleanup()
> > +{
> > +    cd /
> > +    rm -rf $TEST_DIR/fsx.* $tmp.*
> > +}
> 
> Use tab as indention. Please ./new to generate new test template, so all
> has been taken care of.

I can replace spaces with tabs, but I don't want to regenerate the whole
tests.  In the it should stick to what we originally tested as much
as possible.

I'll look into the other changes.
