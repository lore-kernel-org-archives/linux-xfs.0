Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6FEBC6FD1C
	for <linux-xfs@archiver.kernel.org>; Sat, 25 Mar 2023 17:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjCYRCh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 25 Mar 2023 13:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYRCg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Mar 2023 13:02:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CDE19A5;
        Sat, 25 Mar 2023 10:02:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D77E260C75;
        Sat, 25 Mar 2023 17:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E0AC433D2;
        Sat, 25 Mar 2023 17:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679763754;
        bh=eBy46bhrjOeNX4xGn+9pvlmGMlNVPN1ZAxKppcS9p1M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=blIJUVozSyxNtxaaQlfJBWeeAfoR7ylHsll0qUsX3x7u+h34nyqbraBe88J/KJ8dG
         8xL+kMen1ncz1mYnE+WUIJIAqPOEVJ3fJnTn5JpJeKYE4V+HrAV7jchMnoWX3Olovn
         8BA4J7IWZqI1gGpr9T9e3iXy8LtBHQr1f4Lea5YZwDRL+YSuTY+KIqnPqsdcVpKtdH
         7bNlQqda7pPKSJARX6kVUuvHhLxK68yzNC+e1DInYInqDmgd+WIJ+Y1L8VJ1rZtKdi
         +89xXEU9IJ/Cx0EAJtg9ozdrgN05861t8rsHVJsF3NCfXKwL17725aCPOWJsyhwIdp
         EP0+QGCFWfHJg==
Date:   Sat, 25 Mar 2023 10:02:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC DELUGE v10r1d2] xfs: Parent Pointers
Message-ID: <20230325170233.GB16180@frogsfrogsfrogs>
References: <20230316185414.GH11394@frogsfrogsfrogs>
 <776987d7caf645996bea6cdb43ac1530f76c91d1.camel@oracle.com>
 <20230317234533.GR11376@frogsfrogsfrogs>
 <f571048601445a05043a79ac502261618945376b.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f571048601445a05043a79ac502261618945376b.camel@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 21, 2023 at 09:14:39PM +0000, Allison Henderson wrote:
> On Fri, 2023-03-17 at 16:45 -0700, Darrick J. Wong wrote:
> > On Fri, Mar 17, 2023 at 07:06:07PM +0000, Allison Henderson wrote:
> > > On Thu, 2023-03-16 at 11:54 -0700, Darrick J. Wong wrote:
> > > > Hi everyone,
> > > > 
> > > > This deluge contains all of the additions to the parent pointers
> > > > patchset that I've been working since last month's deluge.  The
> > > > kernel
> > > > and xfsprogs patchsets are based on Allison's v10 tag from last
> > > > week;
> > > > the fstests patches are merely a part of my development tree.  To
> > > > recap
> > > > Allison's cover letter:
> > > > 
> > > > "The goal of this patch set is to add a parent pointer attribute
> > > > to
> > > > each
> > > > inode.  The attribute name containing the parent inode,
> > > > generation,
> > > > and
> > > > directory offset, while the  attribute value contains the file
> > > > name.
> > > > This feature will enable future optimizations for online scrub,
> > > > shrink,
> > > > nfs handles, verity, or any other feature that could make use of
> > > > quickly
> > > > deriving an inodes path from the mount point."
> > > > 
> > > > v10r1d2 rebases everything against 6.3-rc2.  I still want to
> > > > remove
> > > > the
> > > > diroffset from the ondisk parent pointer, but for v10 I've
> > > > replaced
> > > > the
> > > > sha512 hashing code with modifications to the xattr code to
> > > > support
> > > > lookups based on name *and* value.  With that working, we can
> > > > encode
> > > > parent pointers like this:
> > > > 
> > > >         (parent_ino, parent_gen, name[])
> > > > 
> > > > xattr lookups still work correctly, and repair doesn't have to
> > > > deal
> > > > with
> > > > keeping the diroffsets in sync if the directory gets rebuilt. 
> > > > With
> > > > this
> > > > change applied, I'm ready to weave my new changes into Allison's
> > > > v10
> > > > and
> > > > call parent pointers done. :)
> > > > 
> > > > The online directory and parent pointer code are exactly the same
> > > > as
> > > > the
> > > > v9r2d1 release, so I'm eliding that and everything that was in
> > > > Allison's
> > > > recent v10 patchset.  IOWs, this deluge includes only the bug
> > > > fixes
> > > > I've
> > > > made to parent pointers, the updates I've made to the ondisk
> > > > format,
> > > > and
> > > > the necessary changes to fstests to get everything to pass.
> > > > 
> > > > If you want to pull the whole thing, use these links:
> > > > https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-drop-unnecessary__;!!ACWV5N9M2RV99hQ!MnkBbyDKEdgQiXLfmXZ87uT_j_TAtQHHA1UraPf01op6wNpRZkk2tg5CXru4eL6-pzJyUl-uJAZlSrGWwDFp$
> > > >  
> > > > https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-drop-unnecessary__;!!ACWV5N9M2RV99hQ!MnkBbyDKEdgQiXLfmXZ87uT_j_TAtQHHA1UraPf01op6wNpRZkk2tg5CXru4eL6-pzJyUl-uJAZlSmjOh6X7$
> > > >  
> > > > https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs-name-in-attr-key__;!!ACWV5N9M2RV99hQ!MnkBbyDKEdgQiXLfmXZ87uT_j_TAtQHHA1UraPf01op6wNpRZkk2tg5CXru4eL6-pzJyUl-uJAZlSlulOhuJ$
> > > >  
> > > > 
> > > > Allison: Could you please resync libxfs in the following patches
> > > > under
> > > > https://urldefense.com/v3/__https://github.com/allisonhenderson/xfsprogs/commits/xfsprogs_new_pptrs_v10__;!!ACWV5N9M2RV99hQ!MnkBbyDKEdgQiXLfmXZ87uT_j_TAtQHHA1UraPf01op6wNpRZkk2tg5CXru4eL6-pzJyUl-uJAZlSqiXa3xN$
> > > >  
> > > > please?
> > > > 
> > > > xfsprogs: add parent pointer support to attribute code
> > > > xfsprogs: extend transaction reservations for parent attributes
> > > > xfsprogs: parent pointer attribute creation
> > > > xfsprogs: remove parent pointers in unlink
> > > > xfsprogs: Add parent pointers to rename
> > > > xfsprogs: move/add parent pointer validators to xfs_parent
> > > > 
> > > > There are discrepancies between the two, which makes
> > > > ./tools/libxfs-
> > > > diff
> > > > unhappy.  Or, if you want me to merge my ondisk format changes
> > > > into
> > > > my
> > > > branches, I'll put out v11 with everything taken care of.
> > > Sure, will resync, as I recall some of them had to deviate a little
> > > bit
> > > because the corresponding code appears in different places, or
> > > needed
> > > special handling.
> > 
> > Ok, thank you.  It's easier to develop xfsprogs code when libxfs can
> > be
> > kept in sync easily.
> 
> Here is a resync, some of them still needed hand porting, but it looks
> like it sync'd up a lot of white space so let me know if this clears up
> things for you
> https://github.com/allisonhenderson/xfsprogs/tree/xfsprogs_new_pptrs_v10r1

Yep, thanks.  I'll incorporate that into v11. :)

--D

> Allison
> 
> > 
> > > Originally my intent was just to get the kernel side of things
> > > settled
> > > and landed first, and then grind through the other spaces since
> > > user
> > > space is mostly a port.  I was trying to avoid sending out giant
> > > deluges since people seemed to get hung up enough in just kernel
> > > space
> > > reviews.
> > 
> > Yeah, 'tis true that sending xfsprogs libxfs patches prematurely is
> > just
> > noise on the list. :/
> > 
> > That said, the closer a patchset gets to final review, the tidier the
> > xfsprogs part ought to be.  I've added support in repair and the
> > debugger, which means this is /very/ close to its final review.
> > 
> > --D
> > 
> > > Thanks for all the help tho.
> > > 
> > > Allison
> > > 
> > > > 
> > > > --D
> > > 
> 
