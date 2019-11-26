Return-Path: <SRS0=SRpQ=ZS=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89511C432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 08:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D44020722
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Nov 2019 08:50:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zadara-com.20150623.gappssmtp.com header.i=@zadara-com.20150623.gappssmtp.com header.b="mBeuwaDr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfKZIuc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Nov 2019 03:50:32 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:34207 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfKZIuc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Nov 2019 03:50:32 -0500
Received: by mail-il1-f193.google.com with SMTP id p6so16942135ilp.1
        for <linux-xfs@vger.kernel.org>; Tue, 26 Nov 2019 00:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zadara-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1w3U1XXG2p0rGFUUPBS9srOeCf2FjzmkoyYTuaUmY5k=;
        b=mBeuwaDrliDGRcV38uyFnxDuZTy1r8LB3yuQsvm4VZch7u0uhnhPUXFojDIUps0ek3
         zRBzjEUQKA2c1eGuz5Fr0pE6hzkrKZ7yQXMe3gY74ZbxFfGupeib8FH394Mmx4Vd9YYt
         vU7IrLXPMPiAwDYyNl/daAZX60Y8DDjNcMYqjtAMWjvoGuC8S+vAAYCSNrexdd7RV1f7
         ksckaFUIdmDoXJ3B+MyhvktQeID5sTxEEQxOywSYox0E0xjYXioN3sbD4RLrAHPUwD34
         4DNPE/ek7hS88G+O21usivkoXkGwbQIdtqi0S8saFl2g9PbYs2bNXT9mSBWnC1ybfoRj
         NPMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1w3U1XXG2p0rGFUUPBS9srOeCf2FjzmkoyYTuaUmY5k=;
        b=qvOJ/tLepuZSL1a+RDg/lPpntBFsri3Ws+6VybpKaUk31biNzBXb+PF5+2lergQLJ9
         gf8kuInE0oNfaJxvJCmHfmMeReuz1FCSQluMCOLTPXRzEXd9sQq19yPKUPf+ocZhH44u
         nG6xAMSChFwxnkvzgESD4k81A9nbim7a/kCL5eAICK7nKu3p8iLFHAfcJFiT8ZeGBGyj
         s2X0+Ip2jsH4ccYWErMlrkBUPdIwZ5o5i2W2sSp5VBUvxUZwJX2yDrCZKr4jn60N27Sc
         X/F840hZD+9AQKYcbRXMKwpe6u89W+F0Fx95YOFJ+fIvtFMPq+HIrcTXUotO9cC7PjI0
         U5YQ==
X-Gm-Message-State: APjAAAWxsPPk1xWBDQJtJKSfPbvb0YXHNpruJHriQS061ebHduXSQlvU
        MPEJeNf+c+Nbsm7aZ5do6kBitTyoEc34wHy9gcZ3mA==
X-Google-Smtp-Source: APXvYqxza5SjUtk5ykJVNpTrYSGcS6eeNj5AeDGkU0uGyxjCYVTZi0dNDZOf00TlxftOqI7MIOBCgYGxFw+kfq5uClc=
X-Received: by 2002:a92:5b86:: with SMTP id c6mr36338199ilg.135.1574758231676;
 Tue, 26 Nov 2019 00:50:31 -0800 (PST)
MIME-Version: 1.0
References: <1574359699-10191-1-git-send-email-alex@zadara.com>
 <20191122154314.GA31076@bfoster> <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
 <20191124164012.GL6219@magnolia> <c807e9fb-3ad9-7110-fd5d-29b07a3d1c66@sandeen.net>
 <20191125130752.GB44777@bfoster>
In-Reply-To: <20191125130752.GB44777@bfoster>
From:   Alex Lyakas <alex@zadara.com>
Date:   Tue, 26 Nov 2019 10:50:20 +0200
Message-ID: <CAOcd+r34Y5ysbPdBpzT--iPRjCAHE4TXPCP7B+yQFET7cuW-8g@mail.gmail.com>
Subject: Re: [RFC-PATCH] xfs: do not update sunit/swidth in the superblock to
 match those provided during mount
To:     Brian Foster <bfoster@redhat.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 25, 2019 at 3:07 PM Brian Foster <bfoster@redhat.com> wrote:
>
> On Sun, Nov 24, 2019 at 11:38:53AM -0600, Eric Sandeen wrote:
> > On 11/24/19 10:40 AM, Darrick J. Wong wrote:
> > > On Sun, Nov 24, 2019 at 11:13:09AM +0200, Alex Lyakas wrote:
> >
> > ...
> >
> > >>>> With the suggested patch, xfs repair is working properly also when mount-provided sunit/swidth are different.
> > >>>>
> > >>>> However, I am not sure whether this is the proper approach.
> > >>>> Otherwise, should we not allow specifying different sunit/swidth
> > >>>> during mount?
> > >
> > > I propose a (somewhat) different solution to this problem:
> > >
> > > Port to libxfs the code that determines where mkfs/repair expect the
> > > root inode.  Whenever we want to update the geometry information in the
> > > superblock from mount options, we can test the new ones to see if that
> > > would cause sb_rootino to change.  If there's no change, we update
> > > everything like we do now.  If it would change, either we run with those
> > > parameters incore only (which I think is possible for su/sw?) or refuse
> > > them (because corruption is bad).
> > >
> > > This way we don't lose the su/sw updating behavior we have now, and we
> > > also gain the ability to shut down an entire class of accidental sb
> > > geometry corruptions.
> >
>
> Indeed, I was thinking about something similar with regard to
> validation. ISTM that we either need some form of runtime validation...
>
> > I also wonder if we should be putting so much weight on the root inode
> > location in repair, or if we could get away with other consistency checks
> > to be sure it's legit, since we've always been able to move the
> > "expected" Location.
> >
>
> ... or to fix xfs_repair. ;) Fixing the latter seems ideal to me, but
> I'm not sure how involved that is compared to a runtime fix. Clearly the
> existing repair check is not a sufficient corruption check on its own.
> Perhaps we could validate the inode pointed to by the superblock in
> general and if that survives, verify it looks like a root directory..?
> The unexpected location thing could still be a (i.e. bad alignment)
> warning, but that's probably a separate topic.
>
> I'm not opposed to changing runtime behavior even with a repair fix,
> fwiw. I wonder if conditionally updating the superblock is the right
> behavior as it might be either too subtle for users or too disruptive if
> some appliance out there happens to use a mount cycle to update su/sw.
> Failing the mount seems preferable, but raises similar questions wrt to
> changing behavior. Yes, it is corruption otherwise, but unless I'm
> missing something it seems like a pretty rare corner case (e.g. how many
> people change alignment like this? of those that do, how many ever run
> xfs_repair?).

>To me, the ideal behavior is for mount options to always
> dictate runtime behavior and for a separate admin tool or script to make
> persistent changes (with associated validation) to the superblock.
This sounds inline with the proposed patch.

>
> Brian
>
