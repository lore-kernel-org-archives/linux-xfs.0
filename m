Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96DF1C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 21:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EBF961206
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 21:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbhIPVqS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 17:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236462AbhIPVqR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 17:46:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A764A61206;
        Thu, 16 Sep 2021 21:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631828696;
        bh=aLEsIV45ZbEt9Q+0oxwp7pyFA8XgYM2WfTV0+s9OIZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GlNvUsYreygKl0Ueffv3PpKMWyTIyfcT9gZ2npIhbBGdxiIkJMCSIhAI/wMtHEokE
         HOtOLFNBfSqBWnSRuTKrMY1bjIfJwOyEH0KyrE6RdjMl4iCk84XuxxCV13IJmiFhs9
         eyVFgXqlRU/Cjw8e5T0tNYn1jgFu77cU9nhrT5z1XJtQIm/U9JHPXCHozK+5A5v1wn
         pozVxx+kqlT/Q+RszsK64oRMzOZr55+9s5yN1MwTU/LbkoNd1Z8YKBUWD+Z1LEUJ7w
         N5LpCVhpdD6R/aQUQ6cQI/s7L9mLA7j+H5cqJshAKRfTsSJ/eDbTTRHiBbsFvzEf0n
         GYmFaULxqNH1w==
Date:   Thu, 16 Sep 2021 14:44:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH 7/9] tools: add missing license tags to my scripts
Message-ID: <20210916214456.GA34846@magnolia>
References: <163174935747.380880.7635671692624086987.stgit@magnolia>
 <163174939566.380880.290670167130749389.stgit@magnolia>
 <CAOQ4uxh-_qHNRJF1Jn8A=NpFw4+8tneOMPTFE6B-Rj4ryWFeqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxh-_qHNRJF1Jn8A=NpFw4+8tneOMPTFE6B-Rj4ryWFeqw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 09:06:38AM +0300, Amir Goldstein wrote:
> On Thu, Sep 16, 2021 at 2:43 AM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > From: Darrick J. Wong <djwong@kernel.org>
> >
> > I forgot to add spdx license tags and copyright statements to some of
> > the tools that I've contributed to fstests.  Fix this to be explicit.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> Is someone having an identity crisis? :-P

No, just an IT crisis.  @oracle.com is now exchange cloud, hence me
moving to kernel.org mail forwarding.  For licensing things I want to
make it clear that someone from oracle is adding an oracle copyright
statement.

--D

> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> 
> > ---
> >  common/preamble     |   21 ++++++++
> >  doc/group-names.txt |  135 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tools/mkgroupfile   |   33 +++++++++---
> >  3 files changed, 181 insertions(+), 8 deletions(-)
> >  create mode 100644 doc/group-names.txt
> >
> >
> > diff
> > ---
> >  tools/mkgroupfile |    4 +++-
> >  tools/mvtest      |    5 ++++-
> >  tools/nextid      |    4 +++-
> >  3 files changed, 10 insertions(+), 3 deletions(-)
> >
> >
> > diff --git a/tools/mkgroupfile b/tools/mkgroupfile
> > index e4244507..634ec92c 100755
> > --- a/tools/mkgroupfile
> > +++ b/tools/mkgroupfile
> > @@ -1,5 +1,7 @@
> >  #!/bin/bash
> > -
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> >  # Generate a group file from the _begin_fstest call in each test.
> >
> >  if [ "$1" = "--help" ]; then
> > diff --git a/tools/mvtest b/tools/mvtest
> > index 5088b45f..99b15414 100755
> > --- a/tools/mvtest
> > +++ b/tools/mvtest
> > @@ -1,6 +1,9 @@
> >  #!/bin/sh
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2015 Oracle.  All Rights Reserved.
> > +#
> 
> [...]
> 
> > diff --git a/tools/nextid b/tools/nextid
> > index 9507de29..9e31718c 100755
> > --- a/tools/nextid
> > +++ b/tools/nextid
> > @@ -1,5 +1,7 @@
> >  #!/bin/bash
> > -
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2015 Oracle.  All Rights Reserved.
> > +#
> 
> I suppose 2015 is intentional?
> Should it be 2015-2021? I have no idea what the legal implications
> are, but anyway, very low probability that those scripts would end up
> in litigation :)
> 
> Thanks,
> Amir.
