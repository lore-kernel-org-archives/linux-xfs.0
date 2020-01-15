Return-Path: <SRS0=S7Al=3E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D7AAC33CB2
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 20:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A9CB22522
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jan 2020 20:11:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=intel-com.20150623.gappssmtp.com header.i=@intel-com.20150623.gappssmtp.com header.b="Ft97un5Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgAOULE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 15:11:04 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43727 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729817AbgAOULC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 15:11:02 -0500
Received: by mail-oi1-f196.google.com with SMTP id p125so16667126oif.10
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jan 2020 12:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZNerA6RTqwQW5nW1+H5K5Uzw8BJvKQMgJNhaZlAlRYY=;
        b=Ft97un5QqUrNcT2a7r5rLK9Bcn1CGDH85x4lJi33iI5GvOUxp6vygNblPKWeya2a6T
         X0HIFeiVeuqE2D+saniOTNQWGbo8MKlSfUS0UMcJydL2FDE+2jKMsz4cG8rlk4viB2Af
         XNOMJ7xGAtdXm+eUDptNXQIDCN2NzQECzscSmosJ8UBLtvVbQyDAkNwphXsSrXWo+gHH
         0+cAUmAJVgbv/2p186TFDFyE8v6/+vZ52woVxENpm0uiusWM1856TiiKqNg9Y2DT7K4c
         IpkO011AaT1GzD9R+yLn0F0pLwaUYU35sLW3epoiCfwAhUYYzDgavjcxnV4iB8iiBj9o
         aAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZNerA6RTqwQW5nW1+H5K5Uzw8BJvKQMgJNhaZlAlRYY=;
        b=EeErw+DVKRyh35j3KgpxuckYL1oErGv/4Epk+K60HXpHxZR2ycfVK4R05Q/+NBQm0A
         JcoNsC/5BvXAMAFpOY5doPq1AOR0fHzJdfiom3cZ/lz9plVdoGXCopFKAojHCD9KFDP3
         xrpdSz4mH8+VA1cU8QVSdiIVhlgU/BVTitACM2kheYxyKpXLDt/skp9tBBr+J7jLvakK
         c5ZPvnNSlEJYeCmk1o0Yu6EkxJKKuz5hTtZ1vfuWrbLdR0Vrl6be4o+cGxWayrDZ19ob
         VBWfIsg84nvz7GS11ooh4iFGm1pQaRx7XLPZSZiUlE7RprkfSImR7Kcxx2yRkA8cDu69
         S7Aw==
X-Gm-Message-State: APjAAAVky9aQjdoQ+DPY0M6JNANOLsbmNLmHyycbHIfguCkqp3okHAs3
        Iq1PDCWRAQS+vL4itDr0kNq8GwpHBtzSM8dX6h9riw==
X-Google-Smtp-Source: APXvYqy4QzkLRwHtNjw7i40YuJZZHoFexa5gvsypx6CfMbxJrtBLTMJ4KWIy4ssx6HgqeUaer81G89JVSuVTbWsb3m4=
X-Received: by 2002:aca:3f54:: with SMTP id m81mr1208667oia.73.1579119061327;
 Wed, 15 Jan 2020 12:11:01 -0800 (PST)
MIME-Version: 1.0
References: <20200110192942.25021-1-ira.weiny@intel.com> <20200110192942.25021-2-ira.weiny@intel.com>
 <20200115113715.GB2595@quack2.suse.cz> <20200115173834.GD8247@magnolia> <20200115194512.GF23311@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20200115194512.GF23311@iweiny-DESK2.sc.intel.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 15 Jan 2020 12:10:50 -0800
Message-ID: <CAPcyv4hwefzruFj02YHYiy8nOpHJFGLKksjiXoRUGpT3C2rDag@mail.gmail.com>
Subject: Re: [RFC PATCH V2 01/12] fs/stat: Define DAX statx attribute
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@lst.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 15, 2020 at 11:45 AM Ira Weiny <ira.weiny@intel.com> wrote:
>
> On Wed, Jan 15, 2020 at 09:38:34AM -0800, Darrick J. Wong wrote:
> > On Wed, Jan 15, 2020 at 12:37:15PM +0100, Jan Kara wrote:
> > > On Fri 10-01-20 11:29:31, ira.weiny@intel.com wrote:
> > > > From: Ira Weiny <ira.weiny@intel.com>
> > > >
> > > > In order for users to determine if a file is currently operating in DAX
> > > > mode (effective DAX).  Define a statx attribute value and set that
> > > > attribute if the effective DAX flag is set.
> > > >
> > > > To go along with this we propose the following addition to the statx man
> > > > page:
> > > >
> > > > STATX_ATTR_DAX
> > > >
> > > >   DAX (cpu direct access) is a file mode that attempts to minimize
> >
> > "..is a file I/O mode"?
>
> or  "... is a file state ..."?
>
> > > >   software cache effects for both I/O and memory mappings of this
> > > >   file.  It requires a capable device, a compatible filesystem
> > > >   block size, and filesystem opt-in.
> >
> > "...a capable storage device..."
>
> Done
>
> >
> > What does "compatible fs block size" mean?  How does the user figure out
> > if their fs blocksize is compatible?  Do we tell users to refer their
> > filesystem's documentation here?
>
> Perhaps it is wrong for this to be in the man page at all?  Would it be better
> to assume the file system and block device are already configured properly by
> the admin?
>
> For which the blocksize restrictions are already well documented.  ie:
>
> https://www.kernel.org/doc/Documentation/filesystems/dax.txt
>
> ?
>
> How about changing the text to:
>
>         It requires a block device and file system which have been configured
>         to support DAX.
>
> ?

The goal was to document the gauntlet of checks that
__generic_fsdax_supported() performs so someone could debug "why am I
not able to get dax operation?"

>
> >
> > > > It generally assumes all
> > > >   accesses are via cpu load / store instructions which can
> > > >   minimize overhead for small accesses, but adversely affect cpu
> > > >   utilization for large transfers.
> >
> > Will this always be true for persistent memory?

For direct-mapped pmem there is no opportunity to do dma offload so it
will always be true that application dax access consumes cpu to do I/O
where something like NVMe does not. There has been unfruitful to date
experiments with the driver using an offload engine for kernel
internal I/O, but if you're use case is kernel internal I/O bound then
you don't need dax.

>
> I'm not clear.  Did you mean; "this" == adverse utilization for large transfers?
>
> >
> > I wasn't even aware that large transfers adversely affected CPU
> > utilization. ;)
>
> Sure vs using a DMA engine for example.

Right, this is purely a statement about cpu memcpy vs device-dma.

>
> >
> > > >  File I/O is done directly
> > > >   to/from user-space buffers. While the DAX property tends to
> > > >   result in data being transferred synchronously it does not give
> >
> > "...transferred synchronously, it does not..."
>
> done.
>
> >
> > > >   the guarantees of synchronous I/O that data and necessary
> >
> > "...it does not guarantee that I/O or file metadata have been flushed to
> > the storage device."
>
> The lack of guarantee here is mainly regarding metadata.
>
> How about:
>
>         While the DAX property tends to result in data being transferred
>         synchronously, it does not give the same guarantees of
>         synchronous I/O where data and the necessary metadata are
>         transferred together.
>
> >
> > > >   metadata are transferred. Memory mapped I/O may be performed
> > > >   with direct mappings that bypass system memory buffering.
> >
> > "...with direct memory mappings that bypass kernel page cache."
>
> Done.
>
> >
> > > > Again
> > > >   while memory-mapped I/O tends to result in data being
> >
> > I would move the sentence about "Memory mapped I/O..." to directly after
> > the sentence about file I/O being done directly to and from userspace so
> > that you don't need to repeat this statement.
>
> Done.
>
> >
> > > >   transferred synchronously it does not guarantee synchronous
> > > >   metadata updates. A dax file may optionally support being mapped
> > > >   with the MAP_SYNC flag which does allow cpu store operations to
> > > >   be considered synchronous modulo cpu cache effects.
> >
> > How does one detect or work around or deal with "cpu cache effects"?  I
> > assume some sort of CPU cache flush instruction is what is meant here,
> > but I think we could mention the basics of what has to be done here:
> >
> > "A DAX file may support being mapped with the MAP_SYNC flag, which
> > enables a program to use CPU cache flush operations to persist CPU store
> > operations without an explicit fsync(2).  See mmap(2) for more
> > information."?
>
> That sounds better.  I like the reference to mmap as well.
>
> Ok I changed a couple of things as well.  How does this sound?
>
>
> STATX_ATTR_DAX
>
>         DAX (cpu direct access) is a file mode that attempts to minimize

s/mode/state/?

>         software cache effects for both I/O and memory mappings of this
>         file.  It requires a block device and file system which have
>         been configured to support DAX.

It may not require a block device in the future.

>
>         DAX generally assumes all accesses are via cpu load / store
>         instructions which can minimize overhead for small accesses, but
>         may adversely affect cpu utilization for large transfers.
>
>         File I/O is done directly to/from user-space buffers and memory
>         mapped I/O may be performed with direct memory mappings that
>         bypass kernel page cache.
>
>         While the DAX property tends to result in data being transferred
>         synchronously, it does not give the same guarantees of
>         synchronous I/O where data and the necessary metadata are

Maybe use "O_SYNC I/O" explicitly to further differentiate the 2
meanings of "synchronous" in this sentence?

>         transferred together.
>
>         A DAX file may support being mapped with the MAP_SYNC flag,
>         which enables a program to use CPU cache flush operations to

s/operations/instructions/

>         persist CPU store operations without an explicit fsync(2).  See
>         mmap(2) for more information.

I think this also wants a reference to the Linux interpretation of
platform "persistence domains" we were discussing that here [1], but
maybe it should be part of a "pmem" manpage that can be referenced
from this man page.

[1]: http://lore.kernel.org/r/20200108064905.170394-1-aneesh.kumar@linux.ibm.com
