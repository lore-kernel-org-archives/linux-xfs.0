Return-Path: <SRS0=6RgE=4M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF945C3567B
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 06:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D77A20828
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Feb 2020 06:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NLaDMSZR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbgBXGaS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Feb 2020 01:30:18 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:41578 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgBXGaR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 01:30:17 -0500
Received: by mail-io1-f66.google.com with SMTP id m25so9071892ioo.8
        for <linux-xfs@vger.kernel.org>; Sun, 23 Feb 2020 22:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/pLeoTKpEEUk6IC+B8atbm/ogMX6v431HNiZco9Aqf4=;
        b=NLaDMSZRLiBo+cfDTKh25p6tLuc8cx7XsAnF7UQTsThNAv53q7e3zyhKMXsr1bwLQi
         r6yz0GXDjlVxyfeVklpVl/KQWgadljznhKzmZ3LQQv0yqVXP7/ePitVu3n5ZYbmOtgjE
         0vwOB43lYpjuC1wtfE9xSThoEJ32TOp3DbakVRnFhsT+V/gZ6bwnrFBwki4t4i0h3Qxx
         m5uoejwYv22jgyW2UAIiBK6qyZduVFEQXj6nE/yFMuHPbWeTOPaP+QWLVSrmVd3tA3f7
         MFxg+5vFPvCPjKDuhNHQ9QDrXm0S2JSIay/G4jLoIevxbuTR/YQO6fSDcfzD6Lz5GxVF
         YOJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/pLeoTKpEEUk6IC+B8atbm/ogMX6v431HNiZco9Aqf4=;
        b=IOMB0O3dmibAxjyXQJB+AGMLSOr6zEzTNBxFk2I0jAY30kdhOSSuVf4SBOMAgsFCj2
         8vHCZfBmRpIV4kFop6+KKGQunAWTiOkw3sOzsPczw9dtrWc5pT41BcSW0MArRC6OYAEZ
         1TbmDbkxFIgrngn5X2NDbMszPdv/E+sBc5r30lk7OE131X0KqwMVl1l9cCJa4VyiulTP
         G5oMA5TjYBfcyBPmLh2OdtsYzV87mk2H+GbO+rMiLV6bG9deK4EK8OJD7qZI2htkVGCC
         mnMj0fNC6uxhAtgraFDWqha1wSVscCF5nRIRxOt6tCPih3yyFbUoP6p15G2Gd1ptFobZ
         Zv0w==
X-Gm-Message-State: APjAAAVfTGLxo/JrxhP5X4l68vEuhxAv4RH46cgtDMVsLTpiKLg3vPps
        0xKIaHwytYCR06waJJ6ptRM/UMeIsqAPaPn5dE0Zy766
X-Google-Smtp-Source: APXvYqzO4VXk031IdVs4AVAMBYwsQQuNccjOixYJEbetG7I/qItXaIiXWAYC8eiW6FvM62SSQVcpKMU4nXLspmSnx0Y=
X-Received: by 2002:a02:81cc:: with SMTP id r12mr47258122jag.93.1582525816931;
 Sun, 23 Feb 2020 22:30:16 -0800 (PST)
MIME-Version: 1.0
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <CAOQ4uxgvJOF6+jd9BuJfxxGQbiit6J7zVOVnigwLb-RWizRqfg@mail.gmail.com> <5b2ade02-0f1b-b976-2b38-d10fcb41d317@oracle.com>
In-Reply-To: <5b2ade02-0f1b-b976-2b38-d10fcb41d317@oracle.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 24 Feb 2020 08:30:05 +0200
Message-ID: <CAOQ4uxhhW2ZMVdF8zvHRPk65wsJTMn55tnCrJ7BVQK1CSAu3gQ@mail.gmail.com>
Subject: Re: [PATCH v7 00/19] xfs: Delayed Ready Attrs
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 23, 2020 at 6:02 PM Allison Collins
<allison.henderson@oracle.com> wrote:
>
>
>
> On 2/23/20 12:55 AM, Amir Goldstein wrote:
> > On Sun, Feb 23, 2020 at 4:06 AM Allison Collins
> > <allison.henderson@oracle.com> wrote:
> >>
> >> Hi all,
> >>
> >> This set is a subset of a larger series for delayed attributes. Which is
> >> a subset of an even larger series, parent pointers. Delayed attributes
> >> allow attribute operations (set and remove) to be logged and committed
> >> in the same way that other delayed operations do. This allows more
> >> complex operations (like parent pointers) to be broken up into multiple
> >> smaller transactions. To do this, the existing attr operations must be
> >> modified to operate as either a delayed operation or a inline operation
> >> since older filesystems will not be able to use the new log entries.
> >
> > High level question, before I dive into the series:
> >
> > Which other "delayed operations" already exist?
> > I think delayed operations were added by Darrick to handle the growth of
> > translation size due to reflink. Right? So I assume the existing delayed
> > operations deal with block accounting.
> Gosh, quite a few I think, but I'm not solid on what they all do.  If we
> take a peek at XFS_LI_TYPE_DESC, theres an identifier for each type, to
> give you an idea.  A lot of them do look like they are part of reflink
> operations though.
>
> > When speaking of parent pointers, without having looked into the details yet,
> > it seem the delayed operations we would want to log are operations that deal
> > with namespace changes, i.e.: link,unlink,rename.
> > The information needed to be logged for these ops is minimal.
> > Why do we need a general infrastructure for delayed attr operations?
> >
> > Thanks,
> > Amir.
> >
> Great question, this one goes back a ways.  I believe the train of logic
> we had is that because parent pointers also include the filename of the
> parent, its possible we can end up with really big attributes.  Which
> may run into a lot of block map/unmap activity for name space changes.
> We didnt want to end up with overly large transactions in the log, so we
> wanted to break them up by returning -EAGAIN where ever the transactions
> used to be rolled.  I'm pretty sure that covers a quick high level
> history of where we are now?  Did that answer your question?
>

Partly.
My question was like this:
It seems that your work is about implementing:
[intent to set xattr <new parent inode,gen,offset> <new name>]
[intent to remove xattr <old parent inode,gen,offset> <old name>]

While at a high level what the user really *intents* to do is:
[intent to link <inode> to <new parent inode>;<new name>]
[intent to unlink <inode> from <old parent inode>;<old name>]

I guess the log item sizes of the two variants is quite similar, so it
doesn't make much of a difference and deferred xattr ops are more
generic and may be used for other things in the future.

Another thing is that the transaction space required from directory
entry changes is (probably) already taken into account correctly
in the code, so there is no need to worry about deferred namespace
operations from that aspect, but from a pure design perspective,
if namespace operations become complex, *they* are the ones
that should be made into deferred operations.

Or maybe I am not reading the situations correctly at all...

Thanks,
Amir.
