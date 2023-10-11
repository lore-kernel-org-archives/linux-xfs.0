Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B12CDB482
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 22:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbjJKWV5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 18:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235183AbjJKWV4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 18:21:56 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF995A9
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 15:21:54 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-27d1b48e20dso217957a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 15:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1697062914; x=1697667714; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ub4KO+rWQSrkpj0BKjW8xOTGMdk7AajjEHqtUx4WR6E=;
        b=zcM1lUO4/hBNiBALL5gU239jyoXH8BH8W35dUdIwBo8TfGnFjkVoe6UhhfJyGYBn+y
         2LGTNF6dTvkKK++2mp0tXcGozl+JlbeQ7GHAre689bUfRlLxvU2+Sg0qgRofeiyTQBUa
         8FnZ28AaxGWucFSb5qitlH/rYx6Y1m0aU+zD1U/dOpoWPycOlIvVCA9/5YI/mVs85pjQ
         ls6s00/vY8e7Bqd7xczbYMI4cHMxUVUwGQ+OFokx/8VBdwXB6sl+ylSLj2k25pPp8qzl
         HqCDWIzloCIqGSQM8BlslCYnMmmTLkWyfVWeAbyEvWNh1BdPylU38Dh0hh08N7Xk81aj
         5vHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697062914; x=1697667714;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ub4KO+rWQSrkpj0BKjW8xOTGMdk7AajjEHqtUx4WR6E=;
        b=ed+Q1g0fUivj2t5a2pxHfn1Py2R8CnB+6nO54xaMrrUKpMCkfI3Dak9OfLi16RNJp5
         cYlqrmc1Xip7P38wsE3csjrO9soAJR1G+oGHjr7GNYDAEDxUoudOJVPfJQPW2i/xe2NQ
         1DyTKPnzyA3v1z5ZZ3kMeTAfYVjmm1/6z1h5kSgqSuxL5cePW/2xHwqXoukY1mahlr9/
         IT5OAHPihUYmcbmD70X1QJCAKwyuhyZOXIlwyo39ptPMI/zmDnglKR55Hd+oiebvZJbW
         tYaMJkfE+sPUFbm3L3kTv6E/hvmtxkHF2s3njphjBDWvhFDDjgf1QZ0vmKQaxW/z5SPV
         OnDA==
X-Gm-Message-State: AOJu0Yzz2+Z5RML8W9hFxttnq/X/3jUD8Y/Lrrkhzc+z1JNG2HCAsf7/
        91iH0HCc3PHn8vztMidPhsG0zIYb6nf9RjCG3nM=
X-Google-Smtp-Source: AGHT+IFMdBNS4/z5pMtE2hR195I63bRr+qbivczO00fkaX6NatRxZMtAObHowUzA5XUd6QOsrqVsFw==
X-Received: by 2002:a17:90b:38c9:b0:268:b0b:a084 with SMTP id nn9-20020a17090b38c900b002680b0ba084mr20138979pjb.46.1697062914162;
        Wed, 11 Oct 2023 15:21:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id x1-20020a17090aca0100b0027b436159afsm401669pjt.40.2023.10.11.15.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 15:21:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qqhaR-00CaDt-0t;
        Thu, 12 Oct 2023 09:21:51 +1100
Date:   Thu, 12 Oct 2023 09:21:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, cheng.lin130@zte.com.cn,
        linux-xfs@vger.kernel.org, jiang.yong5@zte.com.cn,
        wang.liang82@zte.com.cn, liu.dong3@zte.com.cn
Subject: Re: [PATCH] xfs: pin inodes that would otherwise overflow link count
Message-ID: <ZScf/3nlAPu9c4T2@dread.disaster.area>
References: <20231011203350.GY21298@frogsfrogsfrogs>
 <ZScOxEP5V/fQNDW8@dread.disaster.area>
 <20231011214105.GA21298@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011214105.GA21298@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 02:41:05PM -0700, Darrick J. Wong wrote:
> On Thu, Oct 12, 2023 at 08:08:20AM +1100, Dave Chinner wrote:
> > On Wed, Oct 11, 2023 at 01:33:50PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > The VFS inc_nlink function does not explicitly check for integer
> > > overflows in the i_nlink field.  Instead, it checks the link count
> > > against s_max_links in the vfs_{link,create,rename} functions.  XFS
> > > sets the maximum link count to 2.1 billion, so integer overflows should
> > > not be a problem.
> > > 
> > > However.  It's possible that online repair could find that a file has
> > > more than four billion links, particularly if the link count got
> > 
> > I don't think we should be attempting to fix that online - if we've
> > really found an inode with 4 billion links then something else has
> > gone wrong during repair because we shouldn't get there in the first
> > place.
> 
> I don't agree -- if online repair really does find 3 billion dirents
> pointing to a (very) hardlinked file, then it should set the link count
> to 3 billion.  The VFS will not let userspace add more hardlinks, but it
> will let userspace remove hardlinks.

Yet that leaves the inode with a corruption link count according to
the on disk format definition. We know stuff is going to go wrong
when the user starts trying to remove hardlinks, which will result
in having repair run again to (eventually) remove the PINNED value.

The situation is no different to having 5 billion hard links -
that's as invalid as having 3 billion hard links - but we are using
language lawyering to split the fine hair that is "corrupt but
technically still usable" and "corrupt and unrecoverable".

Both situations are less than ideal, and if we solve the 5 billion
hardlink case, there is no reason at all for letting this whacky
"treat unlinked as negative until it pins" overflow case exist at
all.

> > Regardless, I don't think fixing nlink overflow cases should be done
> > online. A couple of billion links to a single inode takes a
> > *long* time to create and even longer to validate (and take a -lot-
> > of memory).
> 
> xfs_repair will burn a lot of memory and time doing that; xfs_scrub will
> take just as much time but only O(icount) memory.

Yup, I've seen repair take *3 weeks* and 250GB of RAM to validate
production filesystems with a couple of billion hard links and
individual inode link counts in the ~100million range. We're talking
about an order of magnitude higher link counts here - the validation
runtime alone is massively problematic, let alone deciding what
should be done with overflows. Fixing this requires human
intervention to decide what to do...

> > Hence I think we should just punt "more than 2.1
> > billion links" to the offline repair, because online repair can't do
> > anything to actually find whatever caused the overflow in the
> > first place, nor can it actually fix it - it should never have
> > happened in the first place....
> 
> I don't think deleting dirents to reduce link count is a good idea,
> since the repair tool will have no idea which directory links are more
> deletable than others.

I never said we should delete directory links. I said we should punt
it to an admin to decide how to fix (i.e. to an offline repair
context).

> If repair finds XFS_MAXLINKS < nr_dirents < -1U, then I think we should
> reset the link count and let userspace decide if they're going to unlink
> the file to reduce the link count.  That's already what xfs_repair does,
> and xfs_scrub follows that behavior.
> 
> For nr_dirents > -1U, online repair just skips the file and reports that
> repairs didn't succeed.  xfs_repair overflows the u32 and won't notice
> that it's now set the link count to something suspiciously low.

Fixing this requires human intervention to decide what to do. If
it's a hardlink backup farm (the cases I've seen with this scale of
link counts) then the trivial solution is to duplicate the inode
everything is linked to and then move all the overflows to the
duplicate(s).

repair *could* do this automatically by duplicating the source inode
into lost+found and redirecting overflowed dirents to them. It
doesn't matter where the duplicated inodes live - there will be
directories pointing to them from all over the place. Doing this
will not result in any loss of data or directory entries - it just
means that the "shared" inode is not a single unique inode anymore.

If we solve the larger overflow problem this way, then the
XFS_MAXLINKS < nr_dirents < -1U case can also use this solution and
we no longer need to support a whacky "corrupt but technically still
usable" corner case....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
