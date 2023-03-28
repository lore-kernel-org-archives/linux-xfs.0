Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C8F0C76196
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Mar 2023 22:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjC1WaH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Mar 2023 18:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjC1WaF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2023 18:30:05 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BDA135
        for <linux-xfs@vger.kernel.org>; Tue, 28 Mar 2023 15:30:04 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o6-20020a17090a9f8600b0023f32869993so16647706pjp.1
        for <linux-xfs@vger.kernel.org>; Tue, 28 Mar 2023 15:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1680042603;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8dDRy80lz5DHmECbtxUU7qvuojmYfsBwS3nNUaIqDYA=;
        b=jgUZgD1urOS/exGEtxb8cODCPe0SbbBUB+dElLQRQrxep7YCKjomZegCOOM5gvMv8s
         rrahpQfXsHVRhXTljzA826bZOjjljKu/CXvNWF+ly20APV0F+5Nqo6bpWG3IELTz6a6+
         8nXEoOLT8q1yA3SqQsRY0jAVG2Th6SMNFGWl6a5vCBzFZwYXDEZzPmcvnia6ICiqINNC
         iAiokZSlG7JLAuD3h+u03kzPdurpDBnEE9jxMxc7kdv/J+uSQ4UW8ARl2IhEstJpo6W1
         OqSCDlT+/9CaxLzMD+YnS/4XDneAEBlidCj5GApofljcZpyAzyzjDbFZey62l0k1P9Kw
         S4AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680042603;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8dDRy80lz5DHmECbtxUU7qvuojmYfsBwS3nNUaIqDYA=;
        b=xjfIjM+eMbrIjxo8i4fd+voXHa5dDvZ2uYksT8a4SzZ8tHLNG363qBZyuajmrUrTnv
         iBUTiXfatrTPEVVUL9ZZhBvIlfHPIJhyLkwU2+XW7z6yJ6gIVSo3U3XfuhPkzIl48+Lg
         RGTNBF4LYqBpgA+J8HV9mi+k+jjzyUdYmzyNANn1KNouO9lBxRAHolczN0eXUanxu8WT
         zEl7rcpnXn+g5SL3powrJ8MOtTHBuZmBLEKMbGPWonJIY2D1IgEPznT4chl/+l+6XcD+
         noCFnmWvyEp8ZfF9rQR7swxdVLg9DfHuruXWOPWeO3/AoNBj02Q6bXqCG4aXilIYlQ8G
         fIgQ==
X-Gm-Message-State: AAQBX9c5s9nUiYZdDNGEbrb4ytStr/L6YtJ38oYZ3oWxBamrrlk9YTgA
        Xm6f+/F5a8WtGSQCgOMaKVqhvw==
X-Google-Smtp-Source: AKy350apTRIYaGAODrF3+uZMekYkNnzSFxw7+ICIyoxar96Y2kPC9BDZC9KQT6ToECLe9EuLYqNk9g==
X-Received: by 2002:a17:902:ec8c:b0:19e:8566:ea86 with SMTP id x12-20020a170902ec8c00b0019e8566ea86mr19742336plg.62.1680042603693;
        Tue, 28 Mar 2023 15:30:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-91-157.pa.nsw.optusnet.com.au. [49.181.91.157])
        by smtp.gmail.com with ESMTPSA id c10-20020a170902c1ca00b001a24bf87e20sm4380613plc.37.2023.03.28.15.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 15:30:03 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1phHpI-00EKvw-0A; Wed, 29 Mar 2023 09:30:00 +1100
Date:   Wed, 29 Mar 2023 09:29:59 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCHSET v10r1d2 00/17] xfs: encode parent pointer name in
 xattr key
Message-ID: <20230328222959.GD3223426@dread.disaster.area>
References: <20230316185414.GH11394@frogsfrogsfrogs>
 <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
 <6e6f7948dfdeac87accb8cd437f0c22d21a2e8e0.camel@oracle.com>
 <CAOQ4uxhVgPt93Wi3Z577gncWSxOE8S0fq5aasLJbffk8Rkg-GQ@mail.gmail.com>
 <20230325170106.GA16180@frogsfrogsfrogs>
 <CAOQ4uxj4ZwdCps2qFZCn9hTWcEaq1xUSJs=f1N5B4H4stayDPQ@mail.gmail.com>
 <20230328012932.GE16180@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230328012932.GE16180@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 27, 2023 at 06:29:32PM -0700, Darrick J. Wong wrote:
> On Sun, Mar 26, 2023 at 06:21:17AM +0300, Amir Goldstein wrote:
> > On Sat, Mar 25, 2023 at 8:01 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > On Sat, Mar 25, 2023 at 10:59:16AM +0300, Amir Goldstein wrote:
> > > > On Fri, Mar 24, 2023 at 8:19 PM Allison Henderson
> > > > <allison.henderson@oracle.com> wrote:
> > Right.
> > So how about
> > (parent_ino, parent_gen, dirent_hash) -> (dirent_name)
> > 
> > This is not a breaking change and you won't need to do another
> > breaking change later.
> > 
> > This could also be internal to VLOOKUP: appended vhash to
> > attr name and limit VLOOKUP name size to  255 - vhashsize.
> 
> The original "put the hash in the xattr name" patches did that, but I
> discarded that approach because it increases the size of each parent
> pointer by 4 bytes, and was really easy to make a verrrry slow
> filesystem:

Right, that's because hash collision resolution is very dumb. It's
just a linear walk from start to end comparing the names of each
coliding entry.

> I wrote an xfs_io command to compute lists of names with the same
> dirhash value.  If I created a giant directory with the same file
> hardlinked millions of times where all those dirent names all hash to
> the same value, lookups in the directory gets really slow because the
> dabtree code has to walk (on average) half a million dirents to find the
> matching one.

That's worst case behaviour, not real-world production behaviour.
It's also a dabtree optimisation problem, not a parent pointer
problem. i.e. if this is a real world issue, we need to fix the
dabtree indexing, not work around it in the parent pointer format.

IOWs, optimising the parent pointer structure for the *rare* corner
case of an intentionally crafted dahash btree collision farm is, to
me, the wrong way to design a structure.

Optimising it for the common fast path (single parent xattrs,
followed by small numbers of parents) is what we should be doing,
because that situation will occur an uncountable number of times
more frequently than this theorectical worst case behaviour. i.e.
the worst case will, in all likelihood, never happen in production
environments - behaviour in this circumstance is only a
consideration for mitigating malicious attacks.

And, quite frankly, nobody is going to bother attacking a filesystem
this way - there is literally nothing that can be gained from
slowing down access to a single directory in this manner. It's a DOS
at best, but there are *much* easier ways of doing that and it
doesn't require parent pointers or dahash collisions at all.


> 
> There were also millions of parent pointer xattrs, all with the same
> attr name and hence the same hash value here too.  Doing that made the
> performance totally awful.  Changing the hash to crc32c and then sha512
> made it much harder to induce collision slowdowns on both ends like
> that, though sha512 added a noticeable performance hit for what it was
> preventing.

So why not change the dahash for parent pointer enabled filesystems
to use crc32c everywhere?

I'd much prefer we have a parent pointer index key that is fixed
length, has constant hash time and a dabtree hash that is far more
resilient to collision farming than to have to perform
encoding/decoding of varaible length values into the key to work
around a collision-rich hashing algorithm.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
