Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E65ECAAD8
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Aug 2022 05:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiHaFEy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 31 Aug 2022 01:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiHaFEy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Aug 2022 01:04:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6018C6422
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 22:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661922290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b5gxHTKDGrJsusy7uQh63TgtOXGH0p07uIzhImTI+Zs=;
        b=RNrTMohp5EX+ifZn1H7Oe+shyS6I439+SEpZvk9m3X9ZQ+XwNtXMC5bHGQqepDDzWkDR6q
        3flKnYn0TanGu6Kg3zzCTL4o4ErwmlnEVj4s9Z9+WmhKNmc09ROt2JA/vlzLMk4B9fvjC9
        tJaskwQWtSaqQA3/KASkXd7kmitolqs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-546-IHvjpIR_NNWD8YJNN9nYPg-1; Wed, 31 Aug 2022 01:04:48 -0400
X-MC-Unique: IHvjpIR_NNWD8YJNN9nYPg-1
Received: by mail-qk1-f198.google.com with SMTP id bm11-20020a05620a198b00b006bb2388ef0cso10835033qkb.5
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 22:04:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=b5gxHTKDGrJsusy7uQh63TgtOXGH0p07uIzhImTI+Zs=;
        b=2a3DYpBfStIK5YAqNOpaqbTi100EkauP+LEGc2AULD+dZ2goSYqCePHk5RjMFOFcGA
         bhv4CV3BLZKHzFONSd3OuIIKPEB021Y47xlnu1V+SM6SONV780x7TZVqcTb1K/M6KPJB
         I9kK6Gd+Jvg8Ydk0JqSxmTte0JAmFnP5LKr9jQ0aXpbufMG+38MGVxZ5Qw1eOY0pBlxo
         RQJ7I+09poN6/lB7LMM1yjn8UgVw+YFM/RGNeaNZxPMY2JL0rp1HEbYtzTxBskDUmN5r
         ajjrQU2yworZmngwtmZBKIzu4ZZwfOOegy7LnpW/J0VbRJTWhXmcXLU2Km8lJLa6wzBq
         woIw==
X-Gm-Message-State: ACgBeo0+eNSeEWI7B67Rkub1VXgntklwYgEGH9isPkcyyTdEQIoLsLJj
        NaHcc0lG68OsXqujm0U4xXpYTppPox0IvNJz3OytsVAHpozvPst92ZgGBbiqQrkW2KONClGQEFr
        nUvXqA6LQnxPUOtwlcrn/
X-Received: by 2002:a05:620a:1432:b0:6be:6c4a:b800 with SMTP id k18-20020a05620a143200b006be6c4ab800mr14048555qkj.578.1661922288243;
        Tue, 30 Aug 2022 22:04:48 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6gk/E2OoF5DEgmHuDO5REqL3SbSG3ncTYG+PP/8q2HOdOXBbN5PqLLwS+I7Dq3rFhJ7mzwtQ==
X-Received: by 2002:a05:620a:1432:b0:6be:6c4a:b800 with SMTP id k18-20020a05620a143200b006be6c4ab800mr14048540qkj.578.1661922287942;
        Tue, 30 Aug 2022 22:04:47 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f10-20020a05620a408a00b006bb208bd889sm10142139qko.120.2022.08.30.22.04.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 22:04:47 -0700 (PDT)
Date:   Wed, 31 Aug 2022 13:04:41 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Murphy Zhou <jencce.kernel@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     fstests <fstests@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] tests: increase fs size for mkfs
Message-ID: <20220831050441.i5ln7swukn7tjlvo@zlang-mailbox>
References: <20220830044433.1719246-1-jencce.kernel@gmail.com>
 <20220830044433.1719246-2-jencce.kernel@gmail.com>
 <20220830073634.7qklqvl2la53kbv4@zlang-mailbox>
 <Yw4i0Pxz80ez7m0X@magnolia>
 <20220830190748.nnylphtuugxxmoy3@zlang-mailbox>
 <CADJHv_tFtH_fihVFGLUB=GyjGJ+Neo-pj8S5DGJDFOHrW12EOA@mail.gmail.com>
 <CADJHv_v1sJSythY2RDA6tYBtuY7O_0zgKLxXhAPw7zpvMunXvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADJHv_v1sJSythY2RDA6tYBtuY7O_0zgKLxXhAPw7zpvMunXvA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 31, 2022 at 09:53:55AM +0800, Murphy Zhou wrote:
> Oops.. Darrick left a workaround in the xfsprogs code for fstests. My
> test setup missed TEST_DEV export somehow and the workaround was not
> working.
> 
> Nevermind for this patchset..  My bloody hours...

Thanks for reminding me, I just checked that patch, and yes:

+       /*
+        * fstests has a large number of tests that create tiny filesystems to
+        * perform specific regression and resource depletion tests in a
+        * controlled environment.  Avoid breaking fstests by allowing
+        * unsupported configurations if TEST_DIR, TEST_DEV, and QA_CHECK_FS
+        * are all set.
+        */
+       if (getenv("TEST_DIR") && getenv("TEST_DEV") && getenv("QA_CHECK_FS"))
+               return;

So we need to set QA_CHECK_FS to use this workaround... that's a little tricky
for xfsprogs, I never thought it would like to do this.

Your patchset is still helpful, I think it's still worth dealing with the minimal
fs size situation, better to make it configurable, or can be detected automatically.
For example:

        # A workaround in xfsprogs can break the limitation of xfs minimal size
        if [ -n "$QA_CHECK_FS" ];then
            export XFS_MIN_SIZE=$((300 * 1024 * 1024))
        else
            export XFS_MIN_SIZE=$((16 * 1024 * 1024))  # or "unlimited"??
        fi
...
        init_min_fs_size()
        {
            if [ -n "$FS_MIN_SIZE" ];then
                return
            fi

            case $FSTYP in
            xfs)
                FS_MIN_SIZE=$XFS_MIN_SIZE
                ;;
            *)
                FS_MIN_SIZE="unlimited"  # or a big enough size??
                ;;
            esac
        }

But a configurable FS_MIN_SIZE might break some golden image. Hmm... need think
about it more, any suggestions are welcome :)

Thanks,
Zorro

> 
> On Wed, Aug 31, 2022 at 8:18 AM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> >
> > On Wed, Aug 31, 2022 at 3:07 AM Zorro Lang <zlang@redhat.com> wrote:
> > >
> > > On Tue, Aug 30, 2022 at 07:46:40AM -0700, Darrick J. Wong wrote:
> > > > On Tue, Aug 30, 2022 at 03:36:34PM +0800, Zorro Lang wrote:
> > > > > On Tue, Aug 30, 2022 at 12:44:30PM +0800, Murphy Zhou wrote:
> > > > > > Since this xfsprogs commit:
> > > > > >   6e0ed3d19c54 mkfs: stop allowing tiny filesystems
> > > > > > XFS requires filesystem size bigger then 300m.
> > > > >
> > > > > I'm wondering if we can just use 300M, or 512M is better. CC linux-xfs to
> > > > > get more discussion about how to deal with this change on mkfs.xfs.
> > > > >
> > > > > >
> > > > > > Increase thoese numbers to 512M at least. There is no special
> > > > > > reason for the magic number 512, just double it from original
> > > > > > 256M and being reasonable small.
> > > > >
> > > > > Hmm... do we need a global parameter to define the minimal XFS size,
> > > > > or even minimal local fs size? e.g. MIN_XFS_SIZE, or MIN_FS_SIZE ...
> > > >
> > > > I think it would be a convenient time to create a helper to capture
> > > > that, seeing as the LTP developers recently let slip that they have such
> > > > a thing somewhere, and min fs size logic is scattered around fstests.
> > >
> > > It's a little hard to find out all cases which use the minimal fs size.
> > > But for xfs, I think we can do that with this chance. We can have:
> > >
> > >   export XFS_MIN_SIZE=$((300 * 1024 * 1024))
> > >   export XFS_MIN_LOG_SIZE=$((64 * 1024 * 1024))
> > >
> > > at first, then init minimal $FSTYP size likes:
> > >
> > >   init_min_fs_size()
> > >   {
> > >       case $FSTYP in
> > >       xfs)
> > >           FS_MIN_SIZE=$XFS_MIN_SIZE
> > >           ;;
> > >       *)
> > >           FS_MIN_SIZE="unlimited"  # or a big enough size??
> > >           ;;
> > >       esac
> > >   }
> > >
> > > Then other fs can follow this to add their size limitation.
> > > Any better ideas?
> >
> > In generic/042 f2fs has a similar kind of limitation.
> >
> > Let me check how LTP guys handle this.
> >
> > Thanks,
> > Murphy
> >
> > >
> > > Thanks,
> > > Zorro
> > >
> > > >
> > >
> > snipped
> > >
> 

