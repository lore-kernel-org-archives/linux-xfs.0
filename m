Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 112AAC3A59E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 05:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0A7E20870
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 05:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbfIDFkQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 01:40:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbfIDFkQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Sep 2019 01:40:16 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EB67DC056808;
        Wed,  4 Sep 2019 05:40:15 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6504D5C220;
        Wed,  4 Sep 2019 05:40:15 +0000 (UTC)
Date:   Wed, 4 Sep 2019 13:47:16 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs_io: support splice data between two files
Message-ID: <20190904054715.GX7239@dhcp-12-102.nay.redhat.com>
References: <20190519150026.24626-1-zlang@redhat.com>
 <CAOQ4uxiHZzF5VdC-v3jzorc26RSUdou0v=Vx-XwYT3BAzSwyZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiHZzF5VdC-v3jzorc26RSUdou0v=Vx-XwYT3BAzSwyZA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 04 Sep 2019 05:40:15 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 04, 2019 at 08:20:34AM +0300, Amir Goldstein wrote:
> On Sun, May 19, 2019 at 8:31 PM Zorro Lang <zlang@redhat.com> wrote:
> >
> > Add splice command into xfs_io, by calling splice(2) system call.
> >
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >
> > Hi,
> >
> > Thanks the reviewing from Eric.
> >
> > If 'length' or 'soffset' or 'length + soffset' out of source file
> > range, splice hanging there. V2 fix this issue.
> >
> > Thanks,
> > Zorro
> >
> >  io/Makefile       |   2 +-
> >  io/init.c         |   1 +
> >  io/io.h           |   1 +
> >  io/splice.c       | 194 ++++++++++++++++++++++++++++++++++++++++++++++
> >  man/man8/xfs_io.8 |  26 +++++++
> >  5 files changed, 223 insertions(+), 1 deletion(-)
> >  create mode 100644 io/splice.c
> >
> ...
> > +static void
> > +splice_help(void)
> > +{
> > +       printf(_(
> > +"\n"
> > +" Splice a range of bytes from the given offset between files through pipe\n"
> > +"\n"
> > +" Example:\n"
> > +" 'splice filename 0 4096 32768' - splice 32768 bytes from filename at offset\n"
> > +"                                  0 into the open file at position 4096\n"
> > +" 'splice filename' - splice all bytes from filename into the open file at\n"
> > +" '                   position 0\n"
> > +"\n"
> > +" Copies data between one file and another.  Because this copying is done\n"
> > +" within the kernel, sendfile does not need to transfer data to and from user\n"
> > +" space.\n"
> > +" -m -- SPLICE_F_MOVE flag, attempt to move pages instead of copying.\n"
> > +" Offset and length in the source/destination file can be optionally specified.\n"
> > +"\n"));
> > +}
> > +
> 
> splice belongs to a family of syscalls that can be used to transfer
> data between files.
> 
> xfs_io already has several different sets of arguments for commands
> from that family, providing different subset of control to user:
> 
> copy_range [-s src_off] [-d dst_off] [-l len] src_file | -f N -- Copy
> a range of data between two files
> dedupe infile src_off dst_off len -- dedupes a number of bytes at a
> specified offset
> reflink infile [src_off dst_off len] -- reflinks an entire file, or a
> number of bytes at a specified offset
> sendfile -i infile | -f N [off len] -- Transfer data directly between
> file descriptors
> 
> I recently added '-f N' option to copy_range that was needed by a test.
> Since you are adding a new command I must ask if it would not be
> appropriate to add this capability in the first place.
> Even if not added now, we should think about how the command options
> would look like if we do want to add it later.
> I would really hate to see a forth mutation of argument list...
> 
> An extreme solution would be to use the super set of all explicit options:
> 
> splice [-m] <-i infile | -f N> [-s src_off] [-d dst_off] [-l len]
> 
> We could later add optional support for -s -d -l -i flags to all of the
> commands above and then we will have a unified format.

I'd like to see an uniform option format too. When I write this patch,
I don't know which 'format' is *official*, so I have to choose one I prefer
personally. How to decide which one is better?

Another problem is, if we're going to make all these commands' format
to unify, it'll cause incompatible issue, for example xfstests has lots
of cases use xfs_io commands.

Thanks,
Zorro

> 
> Personally, I have no objection that splice could also use the
> "simple" arguments list as you implemented it, since reflink is
> going to have to continue to support this usage anyway.
> 
> Thanks,
> Amir.
