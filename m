Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D4BC6FD18
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Mar 2023 23:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjC1Xzq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC1Xzp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2023 19:55:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C97F3A96
        for <linux-xfs@vger.kernel.org>; Tue, 28 Mar 2023 16:55:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FB02B81F66
        for <linux-xfs@vger.kernel.org>; Tue, 28 Mar 2023 23:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB67BC433D2;
        Tue, 28 Mar 2023 23:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680047690;
        bh=QQ7Le7cclE6LfxukK0VHuYhUHz8al+qYN7zAQf045rM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i5mVg/5W1msRP3yk0Kjp/xjp3X0Pb1YSGrk4+4+T/JgwIAZJOeGeHtu0VMt39f8ea
         g16ryvtIx9ULDAQnEdDO4+cyn9sAsZhKExvSDzlaug7Lz+ZAORkvALHIG79BB8Hx+0
         tqxH+r8mboSZXx2KhiiF+fILMAG5UBsyem3GIMPkqAugjC+cHCNmwOxN18mS2hpYGY
         uXKQe7bgVng8fXZvEYk1i64wJvbT9xQNvONSzlxflwsYgtKaJMAqXjGfSXln9hdQdH
         mJCYf7uujG3tHfHUCSG0PZWgkW4XWtVN4cT8glWIGdycQF+Hz+N+5Z42SbuppEJTCn
         OBMfC7eQHQPJw==
Date:   Tue, 28 Mar 2023 16:54:49 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCHSET v10r1d2 00/17] xfs: encode parent pointer name in
 xattr key
Message-ID: <20230328235449.GB991605@frogsfrogsfrogs>
References: <20230316185414.GH11394@frogsfrogsfrogs>
 <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
 <6e6f7948dfdeac87accb8cd437f0c22d21a2e8e0.camel@oracle.com>
 <CAOQ4uxhVgPt93Wi3Z577gncWSxOE8S0fq5aasLJbffk8Rkg-GQ@mail.gmail.com>
 <20230325170106.GA16180@frogsfrogsfrogs>
 <CAOQ4uxj4ZwdCps2qFZCn9hTWcEaq1xUSJs=f1N5B4H4stayDPQ@mail.gmail.com>
 <20230328012932.GE16180@frogsfrogsfrogs>
 <20230328222959.GD3223426@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230328222959.GD3223426@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 29, 2023 at 09:29:59AM +1100, Dave Chinner wrote:
> On Mon, Mar 27, 2023 at 06:29:32PM -0700, Darrick J. Wong wrote:
> > On Sun, Mar 26, 2023 at 06:21:17AM +0300, Amir Goldstein wrote:
> > > On Sat, Mar 25, 2023 at 8:01 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > > On Sat, Mar 25, 2023 at 10:59:16AM +0300, Amir Goldstein wrote:
> > > > > On Fri, Mar 24, 2023 at 8:19 PM Allison Henderson
> > > > > <allison.henderson@oracle.com> wrote:
> > > Right.
> > > So how about
> > > (parent_ino, parent_gen, dirent_hash) -> (dirent_name)
> > > 
> > > This is not a breaking change and you won't need to do another
> > > breaking change later.
> > > 
> > > This could also be internal to VLOOKUP: appended vhash to
> > > attr name and limit VLOOKUP name size to  255 - vhashsize.
> > 
> > The original "put the hash in the xattr name" patches did that, but I
> > discarded that approach because it increases the size of each parent
> > pointer by 4 bytes, and was really easy to make a verrrry slow
> > filesystem:
> 
> Right, that's because hash collision resolution is very dumb. It's
> just a linear walk from start to end comparing the names of each
> coliding entry.
> 
> > I wrote an xfs_io command to compute lists of names with the same
> > dirhash value.  If I created a giant directory with the same file
> > hardlinked millions of times where all those dirent names all hash to
> > the same value, lookups in the directory gets really slow because the
> > dabtree code has to walk (on average) half a million dirents to find the
> > matching one.
> 
> That's worst case behaviour, not real-world production behaviour.
> It's also a dabtree optimisation problem, not a parent pointer
> problem. i.e. if this is a real world issue, we need to fix the
> dabtree indexing, not work around it in the parent pointer format.
> 
> IOWs, optimising the parent pointer structure for the *rare* corner
> case of an intentionally crafted dahash btree collision farm is, to
> me, the wrong way to design a structure.
> 
> Optimising it for the common fast path (single parent xattrs,
> followed by small numbers of parents) is what we should be doing,
> because that situation will occur an uncountable number of times
> more frequently than this theorectical worst case behaviour. i.e.
> the worst case will, in all likelihood, never happen in production
> environments - behaviour in this circumstance is only a
> consideration for mitigating malicious attacks.
> 
> And, quite frankly, nobody is going to bother attacking a filesystem
> this way - there is literally nothing that can be gained from
> slowing down access to a single directory in this manner. It's a DOS
> at best, but there are *much* easier ways of doing that and it
> doesn't require parent pointers or dahash collisions at all.
> 
> 
> > 
> > There were also millions of parent pointer xattrs, all with the same
> > attr name and hence the same hash value here too.  Doing that made the
> > performance totally awful.  Changing the hash to crc32c and then sha512
> > made it much harder to induce collision slowdowns on both ends like
> > that, though sha512 added a noticeable performance hit for what it was
> > preventing.
> 
> So why not change the dahash for parent pointer enabled filesystems
> to use crc32c everywhere?

That's not difficult to do, but it'll break name obscuring in metadump
unless you know of a quick way to derive B from A and maintain crc32c(A)
== crc32c(B).

Granted I had mostly written off name obscuring in metadump on parent
pointer filesystems anyway.

> I'd much prefer we have a parent pointer index key that is fixed
> length, has constant hash time and a dabtree hash that is far more
> resilient to collision farming than to have to perform
> encoding/decoding of varaible length values into the key to work
> around a collision-rich hashing algorithm.

Wellllll I was 10 minutes away from sending v11 with all of my changes
integrated, but I guess now I'll go rework the dabtree to use crc32c,
encode the crc32c in the parent pointer attr name, and get rid of all
the variable length value decoding.  Now that I just got rid of all the
intermediate patches with hash-in-attr-name.

Let's see if I can hammer that out in the next 15 minutes.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
