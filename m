Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8420C48BE8
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Jun 2021 00:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A314D613E9
	for <linux-xfs@archiver.kernel.org>; Sat, 12 Jun 2021 00:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFLAgZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 20:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229584AbhFLAgY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Jun 2021 20:36:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6007613CA;
        Sat, 12 Jun 2021 00:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623458065;
        bh=kJIg00BPuJ/o7nEOJpZlQbnWjfkygII478F9miPHWhM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qofhMN5cAIafq4qlN/BQt9xDXDWjbeLPRSWRs125ataRziRWskQH3mQthVJJiQ1w1
         UTzHzhe/uydrqSiBchaoD+Pa6Wui68Qqpob4eG6GEo24DTgrle74r1fBMq2sByVmgl
         zCOqqXH9MpM+3mNZPpxaLEpGMu2HqXUXd96lm/6vN6PMnPkWdKsYO4/VGsvoofyumw
         odobJItmC1GtQ9JkFtQyGgiBygA8XQIa471W5/Mj9DO9u+N/6CAKQFI/AB+L+S73gB
         /+NDIt+rsNmIyfmL3fKD2FVOg7lGm7j1ghluJcnk5LDokKH3oaMohV36CLV+3LWWzN
         0btyReSmEabBg==
Date:   Fri, 11 Jun 2021 17:34:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com
Subject: Re: [PATCH 03/13] fstests: refactor test boilerplate code
Message-ID: <20210612003425.GG2945738@locust>
References: <162317276202.653489.13006238543620278716.stgit@locust>
 <162317277866.653489.1612159248973350500.stgit@locust>
 <YMP65LkTANPpJ2Bg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMP65LkTANPpJ2Bg@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 11, 2021 at 05:08:04PM -0700, Eric Biggers wrote:
> On Tue, Jun 08, 2021 at 10:19:38AM -0700, Darrick J. Wong wrote:
> > diff --git a/common/preamble b/common/preamble
> > new file mode 100644
> > index 00000000..63f66957
> > --- /dev/null
> > +++ b/common/preamble
> > @@ -0,0 +1,49 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +
> > +# Boilerplate fstests functionality
> > +
> > +# Standard cleanup function.  Individual tests should override this.
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> 
> This probably should use "rm -rf" so that tests don't need to override this just
> because they created directories rather than files.

Hm.  I've been told (many years) in the past that I shouldn't really be
using recursive rm unless I /know/ that I've created a $tmp.dir
directory.  OTOH that gets rid of a few thousand more lines of cruft...

<shrug> I'll change it to rm -r -f and see what kind of reaction I get.

--D

> 
> - Eric
