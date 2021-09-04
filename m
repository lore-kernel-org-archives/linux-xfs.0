Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57C8C433EF
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Sep 2021 01:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A216960EE6
	for <linux-xfs@archiver.kernel.org>; Sat,  4 Sep 2021 01:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244846AbhIDBa4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 3 Sep 2021 21:30:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236158AbhIDBas (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Sep 2021 21:30:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C63B60E76;
        Sat,  4 Sep 2021 01:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630718987;
        bh=XT5MqXrLe36wNEwISae6YZOlpRO4za3JIcotCx1Jlck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m8ePx9YgI+7lt5Zte/3JFpSO6GQmgj9s+7/0faOz8NYFS08s8MX0I7EShQX+mef/d
         i2DlERlpVLcdsGlLQC6a9c0W33Y156xXvFR0lcK4t4ZYiU5dFSBOVQ3juDckRIQ4yF
         kmbAYtqmgR4oIC7AGilu5wOf1Y9pQQwZu3Tqy3qRa2MAMz5eRLvnogHjT35DjcxyIP
         N44/U3/QiszHgEAtfE1rkBGxFqCKQr4vdfIiZh25oPSESXuNC5t7OpMP2NDQEbRtHi
         k+L52EPnu7zHYS+RJbALPM3634glDfV6egGUL1+NhsfOL9yqSQwcDHR5EFPRKZXIhT
         eX8XeXGA417ZQ==
Date:   Fri, 3 Sep 2021 18:29:46 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eryu Guan <guaneryu@gmail.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, Eryu Guan <guan@eryu.me>
Subject: Re: [PATCH 6/8] tools: make sure that test groups are described in
 the documentation
Message-ID: <20210904012946.GD9911@magnolia>
References: <163062674313.1579659.11141504872576317846.stgit@magnolia>
 <163062677608.1579659.1360826362143203767.stgit@magnolia>
 <CAOQ4uxit3G=0o3nXVFvW740v6Xi-pSn5uHsgKdOvH4ybc+3jKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxit3G=0o3nXVFvW740v6Xi-pSn5uHsgKdOvH4ybc+3jKw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 03, 2021 at 06:38:38AM +0300, Amir Goldstein wrote:
> > diff --git a/include/buildgrouplist b/include/buildgrouplist
> > index d898efa3..489de965 100644
> > --- a/include/buildgrouplist
> > +++ b/include/buildgrouplist
> > @@ -6,3 +6,4 @@
> >  group.list:
> >         @echo " [GROUP] $$PWD/$@"
> >         $(Q)$(TOPDIR)/tools/mkgroupfile $@
> > +       $(Q)$(TOPDIR)/tools/check-groups $(TOPDIR)/doc/group-names.txt $@
> 
> I would like to argue against checking groups post mkgroupfile
> and for checking groups during mkgroupfile

Done.

> > diff --git a/tools/check-groups b/tools/check-groups
> > new file mode 100755
> > index 00000000..0d193615
> > --- /dev/null
> > +++ b/tools/check-groups
> > @@ -0,0 +1,35 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> > +#
> > +# Make sure that all groups listed in a group.list file are mentioned in the
> > +# group description file.
> > +
> > +if [ -z "$1" ] || [ "$1" = "--help" ]; then
> > +       echo "Usage: $0 path_to_group_names [group.list files...]"
> > +       exit 1
> > +fi
> > +
> > +groups_doc_file="$1"
> > +shift
> > +
> > +get_group_list() {
> > +       for file in "$@"; do
> > +               while read testname groups; do
> > +                       test -z "${testname}" && continue
> > +                       test "${testname:0:1}" = "#" && continue
> > +
> > +                       echo "${groups}" | tr ' ' '\n'
> > +               done < "${file}"
> > +       done | sort | uniq
> > +}
> > +
> > +ret=0
> > +while read group; do
> > +       if ! grep -q "^${group}[[:space:]]" "${groups_doc_file}"; then
> > +               echo "${group}: group not mentioned in documentation." 1>&2
> 
> This message would have been more informative with the offending
> test file.

Hm.  This becomes much easier if I make the _begin_fstest helper do the
checking of the group names.

> Now after you crunched all the test files into group.list files and
> all the group.list files into a unique group set, this is too late.
> But this same check during generate_groupfile() would have
> been trivial and would allow reporting the offending test.
> 
> While we are on the subject of generate_groupfile(), can you please
> explain the rationale behind the method of extracting the test file
> groups by executing the test with GENERATE_GROUPS=yes?
> As opposed to just getting the list of groups on the stop from the file
> using grep?

Well... now that you point that out, it's so that we can put in custom
logic like checking group names. ;)

--D

> 
> Thanks,
> Amir.
