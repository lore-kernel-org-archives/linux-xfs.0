Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A25C83F10
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Aug 2023 02:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbjH1CBW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Aug 2023 22:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjH1CBK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Aug 2023 22:01:10 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D93B124
        for <linux-xfs@vger.kernel.org>; Sun, 27 Aug 2023 19:01:04 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1bdbf10333bso21246225ad.1
        for <linux-xfs@vger.kernel.org>; Sun, 27 Aug 2023 19:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693188063; x=1693792863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0OOpuUC9WrHx63XO3krpOCYmcaUxFgd3zsU66GiE1hw=;
        b=b5odctLENGHiUXUUOYeCbtNMq5u5z9PG7r9KsSdSJT7eeN5m7IU4YGCKsk1zHZyLXg
         Y0asyU+ab7/lI94c8aeOj7s8ivO6LLnQSubfLICsXQlL/ROeNnjTiwFU0R5cBdKkXlfV
         c6F0spa4eLgt5JMAS2AdLqMwlW6D6IFRV3aym5QEw3SNWZ/QMyZ2Kp9f6QhYZsVhTUKB
         MWWoWKWZ3D5pq/PACsrZQFNhWtkMzm8Sddp7xjksFp+i2HITffC0KMQIECKPTYNvn4Ec
         fohDUpzKt0phRnnm12roN3tR+3L8lV7fe02UkYUr5kH7saI0hiNXkyErfqkT4hfukdoi
         A4zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693188063; x=1693792863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0OOpuUC9WrHx63XO3krpOCYmcaUxFgd3zsU66GiE1hw=;
        b=MBTZz4YhfvA5Rgm02D1dVfFYGaEP41lfslm13oIOMflg8y5vSx3LwkKIs2QlGfDTEE
         7RATlO53N6xqSnyoQmk0j7ErPClUMSyHLIqlNR/dij1QlVGq1y423IfQDQFjnyPCusOy
         /wfB74eFQldAo4HYdrD3Mpok0qWG4GQP6Qe5ChhkWt8B5nHsxJcLKzfNRxnq2woVvSzT
         9c86paKXwyIePSdrbNDjg3pgE7n20PyBEp60KAiNZwo3oakncYXudsxMULJM8HVe6cqA
         SlEIGlrT39GKGOb5kMFF1nj2ZEemTCOj4xnJLm3f7nqc0beJKIOafL9bmqCa9roSFsJ+
         Rmfg==
X-Gm-Message-State: AOJu0Yz7irHY0+kvkjLw+/oP3Dm87jlJmJBYtfixEV55EJFvoRf/jh9h
        LcoOkQN9as6DjSPX93kJlkTzKw==
X-Google-Smtp-Source: AGHT+IEQEHw7cE3n9TM3j1prdwB4ECxh3iyjWx1gyrgkJRwQQLFZVC0IFBpmMuhOfxkpj1752eqbwQ==
X-Received: by 2002:a17:902:8f97:b0:1b8:400a:48f2 with SMTP id z23-20020a1709028f9700b001b8400a48f2mr25586214plo.62.1693188063462;
        Sun, 27 Aug 2023 19:01:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id jk17-20020a170903331100b001b890b3bbb1sm5964667plb.211.2023.08.27.19.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Aug 2023 19:01:02 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qaRYp-007Rne-0S;
        Mon, 28 Aug 2023 12:00:59 +1000
Date:   Mon, 28 Aug 2023 12:00:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@redhat.com>, xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [RFC PATCH] fstests: test fix for an agbno overflow in
 __xfs_getfsmap_datadev
Message-ID: <ZOv/25JEPQblNx1n@dread.disaster.area>
References: <20230823010046.GD11286@frogsfrogsfrogs>
 <20230823010239.GE11263@frogsfrogsfrogs>
 <20230827130644.nhdi6ihobn5qne3a@zlang-mailbox>
 <20230827155646.GA28202@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230827155646.GA28202@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Aug 27, 2023 at 08:56:46AM -0700, Darrick J. Wong wrote:
> On Sun, Aug 27, 2023 at 09:06:44PM +0800, Zorro Lang wrote:
> > On Tue, Aug 22, 2023 at 06:02:39PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Dave Chinner reported that xfs/273 fails if the AG size happens to be an
> > > exact power of two.  I traced this to an agbno integer overflow when the
> > > current GETFSMAP call is a continuation of a previous GETFSMAP call, and
> > > the last record returned was non-shareable space at the end of an AG.
> > > 
> > > This is the regression test for that bug.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
.....
> > > +echo "desired asize=$desired_agsize" >> $seqres.full
> > > +_scratch_mkfs -d "agsize=${desired_agsize}b" | _filter_mkfs 2> $tmp.mkfs >> $seqres.full
> > > +source $tmp.mkfs
> > > +
> > > +test "$desired_agsize" -eq "$agsize" || _notrun "wanted agsize=$desired_agsize, got $agsize"
> > > +
> > > +_scratch_mount
> > > +$XFS_IO_PROG -c 'fsmap -n 1024 -v' $SCRATCH_MNT >> $tmp.big
> > > +$XFS_IO_PROG -c 'fsmap -n 1 -v' $SCRATCH_MNT >> $tmp.small
> > 
> > This line reports:
> > 
> >   xfs_io: xfsctl(XFS_IOC_GETFSMAP) iflags=0x0 ["/mnt/xfstests/scratch"]: Invalid argument
> > 
> > when the test case fails. Is that normal?
> 
> Yes.  The attached bugfix should make that go away.

The kernel bug fix fixes the same problem with xfs/273; I haven't
tested this specific new regression test.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
