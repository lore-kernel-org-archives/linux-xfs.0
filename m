Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B64FC0502C
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Aug 2022 09:34:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiHaJet (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Aug 2022 05:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiHaJet (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Aug 2022 05:34:49 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72104F63;
        Wed, 31 Aug 2022 02:34:46 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id r69so13033756pgr.2;
        Wed, 31 Aug 2022 02:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Z2EsbQBJzcOCmYGj5EV6Gf8agT6lCNg/Yr6aM9a0oQk=;
        b=YoHADcO9JMj3KohjRmTAI+tgIBS9SQwBwYJQpOEBXBrUkG6+uG8ZSl9tmQdQXHy8u9
         oHPH20KLbfmMd8NLmAn+c+85Z0TksCO3CXTUpMQMhWWUmNOlSSXd6rkUhv/U4+HMRP60
         GuLVgtYNK2sLWoiOlp36vivAc1bmVXmWjodCQvul7JOIGc9jh7FVkbf4r2+ehNxhwF2m
         zhYlJgzwfI3FlpZvvoTrFITbPkholsbe3bEFqy7/yWDXSsD2WBZTSG9FaP9DLacVCrkC
         qgnvxxMQP2iaIj1ck0HDGbuLLl9gEpBK13sqtD2q9mhV6PmXPMZWnrndrENRt/wdAsZD
         PuBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Z2EsbQBJzcOCmYGj5EV6Gf8agT6lCNg/Yr6aM9a0oQk=;
        b=bwNOWheJiME8uOgr7w5B6h/GKPKrNVy7zoZmAzEzx36rgPAImW8OqLOZTkmSDoM1o5
         Fj3zTFORiBOrBa9r1qeJEcpCwKKfLzzNuQ369jBz9evgR/6+vY3tkZDHMic3TyufD56g
         n+VyCI5L1SET3uwCzT3cm79z5Qabj5NMef3eH8lFCMZzyAIXdohlfEVD87Sc0yfPTuU/
         UhZP98PRf2gM7mnJkDEo0oAZHqBLHp97I7MKsuv+OHi91+gLdG7mDEma2zrKv/AjsSHd
         5MWejGKp2iCKnFNF7EDSbhVgAGUHQUckRV1Zl85aUJ9MEWHrWklA9wVSaXmDPA2Y6HQI
         u2PQ==
X-Gm-Message-State: ACgBeo1M2dDCJdWCJk4Hd7XBuMBmKWUKUWfnZsy5c4SlWubXRYzMqRqP
        6b2M8T06DCB0nptX63HPKbaSv1VOyo4xqYgIYDYWFjxjdNM=
X-Google-Smtp-Source: AA6agR6pE5rXeseM14mkUuFDVlwo902EUXpiuSpGQ9acMNkyQNqzC1HnrO88s4cQUor05jK+dbbN/aIwcmT5F14GFac=
X-Received: by 2002:a63:fc65:0:b0:42a:59ed:878f with SMTP id
 r37-20020a63fc65000000b0042a59ed878fmr20966321pgk.608.1661938485977; Wed, 31
 Aug 2022 02:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
 <20220830044433.1719246-2-jencce.kernel@gmail.com> <20220830073634.7qklqvl2la53kbv4@zlang-mailbox>
 <Yw4i0Pxz80ez7m0X@magnolia> <20220830190748.nnylphtuugxxmoy3@zlang-mailbox>
 <CADJHv_tFtH_fihVFGLUB=GyjGJ+Neo-pj8S5DGJDFOHrW12EOA@mail.gmail.com>
 <CADJHv_v1sJSythY2RDA6tYBtuY7O_0zgKLxXhAPw7zpvMunXvA@mail.gmail.com> <20220831050441.i5ln7swukn7tjlvo@zlang-mailbox>
In-Reply-To: <20220831050441.i5ln7swukn7tjlvo@zlang-mailbox>
From:   Murphy Zhou <jencce.kernel@gmail.com>
Date:   Wed, 31 Aug 2022 17:34:33 +0800
Message-ID: <CADJHv_vKEX5Jy5VfX-2NmKxq0sCg6zkWchM=Of2rAtpeG1Vu5Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] tests: increase fs size for mkfs
To:     Zorro Lang <zlang@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 31, 2022 at 1:04 PM Zorro Lang <zlang@redhat.com> wrote:
>
> On Wed, Aug 31, 2022 at 09:53:55AM +0800, Murphy Zhou wrote:
> > Oops.. Darrick left a workaround in the xfsprogs code for fstests. My
> > test setup missed TEST_DEV export somehow and the workaround was not
> > working.
> >
> > Nevermind for this patchset..  My bloody hours...
>
> Thanks for reminding me, I just checked that patch, and yes:
>
> +       /*
> +        * fstests has a large number of tests that create tiny filesystems to
> +        * perform specific regression and resource depletion tests in a
> +        * controlled environment.  Avoid breaking fstests by allowing
> +        * unsupported configurations if TEST_DIR, TEST_DEV, and QA_CHECK_FS
> +        * are all set.
> +        */
> +       if (getenv("TEST_DIR") && getenv("TEST_DEV") && getenv("QA_CHECK_FS"))
> +               return;
>
> So we need to set QA_CHECK_FS to use this workaround... that's a little tricky
> for xfsprogs, I never thought it would like to do this.

QA_CHECK_FS is already set in `check`. My setup was missing TEST_DEV somehow,
after adding export in local.config like the example, everything works fine.

>
> Your patchset is still helpful, I think it's still worth dealing with the minimal
> fs size situation, better to make it configurable, or can be detected automatically.

Unless it's a hard limit, I think it's not worth the effort. Like
Darrick said, backward
compatibility is also important. Random magic numbers may bring more test
coverage.

Thanks,
Murphy

> For example:
>
>         # A workaround in xfsprogs can break the limitation of xfs minimal size
>         if [ -n "$QA_CHECK_FS" ];then
>             export XFS_MIN_SIZE=$((300 * 1024 * 1024))
>         else
>             export XFS_MIN_SIZE=$((16 * 1024 * 1024))  # or "unlimited"??
>         fi
> ...
>         init_min_fs_size()
>         {
>             if [ -n "$FS_MIN_SIZE" ];then
>                 return
>             fi
>
>             case $FSTYP in
>             xfs)
>                 FS_MIN_SIZE=$XFS_MIN_SIZE
>                 ;;
>             *)
>                 FS_MIN_SIZE="unlimited"  # or a big enough size??
>                 ;;
>             esac
>         }
>
> But a configurable FS_MIN_SIZE might break some golden image. Hmm... need think
> about it more, any suggestions are welcome :)
>
> Thanks,
> Zorro
>
> >
> > On Wed, Aug 31, 2022 at 8:18 AM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> > >
> > > On Wed, Aug 31, 2022 at 3:07 AM Zorro Lang <zlang@redhat.com> wrote:
> > > >
> > > > On Tue, Aug 30, 2022 at 07:46:40AM -0700, Darrick J. Wong wrote:
> > > > > On Tue, Aug 30, 2022 at 03:36:34PM +0800, Zorro Lang wrote:
> > > > > > On Tue, Aug 30, 2022 at 12:44:30PM +0800, Murphy Zhou wrote:
> > > > > > > Since this xfsprogs commit:
> > > > > > >   6e0ed3d19c54 mkfs: stop allowing tiny filesystems
> > > > > > > XFS requires filesystem size bigger then 300m.
> > > > > >
> > > > > > I'm wondering if we can just use 300M, or 512M is better. CC linux-xfs to
> > > > > > get more discussion about how to deal with this change on mkfs.xfs.
> > > > > >
> > > > > > >
> > > > > > > Increase thoese numbers to 512M at least. There is no special
> > > > > > > reason for the magic number 512, just double it from original
> > > > > > > 256M and being reasonable small.
> > > > > >
> > > > > > Hmm... do we need a global parameter to define the minimal XFS size,
> > > > > > or even minimal local fs size? e.g. MIN_XFS_SIZE, or MIN_FS_SIZE ...
> > > > >
> > > > > I think it would be a convenient time to create a helper to capture
> > > > > that, seeing as the LTP developers recently let slip that they have such
> > > > > a thing somewhere, and min fs size logic is scattered around fstests.
> > > >
> > > > It's a little hard to find out all cases which use the minimal fs size.
> > > > But for xfs, I think we can do that with this chance. We can have:
> > > >
> > > >   export XFS_MIN_SIZE=$((300 * 1024 * 1024))
> > > >   export XFS_MIN_LOG_SIZE=$((64 * 1024 * 1024))
> > > >
> > > > at first, then init minimal $FSTYP size likes:
> > > >
> > > >   init_min_fs_size()
> > > >   {
> > > >       case $FSTYP in
> > > >       xfs)
> > > >           FS_MIN_SIZE=$XFS_MIN_SIZE
> > > >           ;;
> > > >       *)
> > > >           FS_MIN_SIZE="unlimited"  # or a big enough size??
> > > >           ;;
> > > >       esac
> > > >   }
> > > >
> > > > Then other fs can follow this to add their size limitation.
> > > > Any better ideas?
> > >
> > > In generic/042 f2fs has a similar kind of limitation.
> > >
> > > Let me check how LTP guys handle this.
> > >
> > > Thanks,
> > > Murphy
> > >
> > > >
> > > > Thanks,
> > > > Zorro
> > > >
> > > > >
> > > >
> > > snipped
> > > >
> >
>
