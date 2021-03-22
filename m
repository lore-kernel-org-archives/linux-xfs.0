Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CED7C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 03:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F063B61939
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Mar 2021 03:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhCVDd2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 21 Mar 2021 23:33:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229728AbhCVDdT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 21 Mar 2021 23:33:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E622D6192C;
        Mon, 22 Mar 2021 03:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616383999;
        bh=8efzq305bKAuepxX8cRM4PLqKaZpRvdF6+L7IL/UlqQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cg+4efioNY9XeGAvmccgKBMO48+7ZOVQWwJHzKjXnYbTyEuALI7xRYdh1eou6S7ff
         DTS3Q0FZazND11CHsGSTdMBLXJ2sS2YWFQn2s+b6NJAX++W2KxwL4mJhP/K2AFEiSX
         NOVxBo0DckjMSXqu/hXjuBs7MG1PBWLBAn/hYL3uGa5Sx7lhv7XJqLhEdaDZUpy2dn
         EUx9VKeYwaLRcBThxOwk/dOrAu48l7cm3FpuF9UdswZevCuOxZMMlY1hwNfwdxHtt8
         4cFvX7pxTPgYwF7u48zOnoi/yCJtulpf8dZWzwh5c7Nhbs9hYW8wdu3IMq3bSJmaer
         7MiUgqN7FUnHA==
Date:   Sun, 21 Mar 2021 20:33:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: Rudimentary spelling fix
Message-ID: <20210322033316.GB22100@magnolia>
References: <20210322024619.714927-1-unixbhaskar@gmail.com>
 <6d410ec3-438d-9510-d599-bb8b825a6d3e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d410ec3-438d-9510-d599-bb8b825a6d3e@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 21, 2021 at 07:52:41PM -0700, Randy Dunlap wrote:
> On 3/21/21 7:46 PM, Bhaskar Chowdhury wrote:
> > 
> > s/sytemcall/systemcall/
> > 
> > 
> > Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> > ---
> >  fs/xfs/xfs_inode.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index f93370bd7b1e..b5eef9f09c00 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -2870,7 +2870,7 @@ xfs_finish_rename(
> >  /*
> >   * xfs_cross_rename()
> >   *
> > - * responsible for handling RENAME_EXCHANGE flag in renameat2() sytemcall
> > + * responsible for handling RENAME_EXCHANGE flag in renameat2() systemcall
> >   */
> >  STATIC int
> >  xfs_cross_rename(
> > --
> 
> I'll leave it up to Darrick or someone else.
> 
> To me it's "syscall" or "system call".

Agreed; could you change it to one of Randy's suggestions, please?

--D

> -- 
> ~Randy
> 
