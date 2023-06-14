Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5632BEB64D9
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jun 2023 09:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243904AbjFNJNi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jun 2023 05:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234645AbjFNJNd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jun 2023 05:13:33 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5ED41FE4
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 02:13:29 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id af79cd13be357-75d4b85b3ccso183413485a.2
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jun 2023 02:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686734008; x=1689326008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/jwOdnEDU8ms2akjVGvT1Q0D87zIjzot5Y6GxcjnR4I=;
        b=fF5lOmuju8olD8HuC9mplgc0Cpn4jOINck3s/q4YiQRCSFQTYl+s4SEwf4JxaDOghf
         so1mOy5DKgo2+B4GYeLAHr/zTyQ9PFwmDsWwszLuL6u3znN9ylk0sk8WG6/yjdc95Yy3
         lzzJn1a/Z01nJbWg1EyRKCEkJapthuhRbyBKGS7e4Y+NI4NW+gcrZFdxs6z02+0Jaf3I
         VdPAkl190/0Izz3uZ2ePuFANLFQXv6C+6zAG9GqS9dOvl9S1Ml0/zl8Qrfx3Agn8GwXB
         QQMnVikXyV/LggZBzhCWuG/NWd3ZgtVEgOUnKy90iy3NUhuoBgSg/3Zb42LqdbwFsSXM
         s9EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686734008; x=1689326008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/jwOdnEDU8ms2akjVGvT1Q0D87zIjzot5Y6GxcjnR4I=;
        b=D0kng3T2kTk8e1LJNgXniGa063BqBn7VrfUmXSwcfJ70obZ3itC5yhSD767l3ESpPr
         9TFJpKweaCRvP7jscwS91hPlCHaNMMH3CPZWbNjIv71GQR4ilH2wfTj9O26Aom/5B4Us
         xo6PNxmGdi3ZdS/HCBySoU01nJsBBNkc7bUofY1YU7vQ+eGZWLQ6haq8CsQSR+8No5Vr
         xYpoAkI+4bqMLykSoV1AosM3v0zkErcKH+ZuuUF2w6e2n6E8JYJtIiYzFfMQViDroOWO
         W/4w1pdjkxfDOAGgyjJ5pix0tjetWvoB5jmBfXCEjoaTSESZ/2nwmTM3xSig/RMd3FAj
         wb/w==
X-Gm-Message-State: AC+VfDwhEm9UxUBA3FnBl88u2086QPK/xPL2MbEOO/DpN1ZUXnCKx3O4
        juXK6PNMvicEqWcEiugdxW+rpEMQ623yoy2X8NY=
X-Google-Smtp-Source: ACHHUZ7nFJFTrgMg5cWuTSeRwiQOdNdKAeC9S5rwz5G6JuLfz9jtOdbgYDOSRaqhvRvU9PiOq2Hv4g==
X-Received: by 2002:a05:620a:2852:b0:761:9445:affc with SMTP id h18-20020a05620a285200b007619445affcmr5562507qkp.38.1686734008671;
        Wed, 14 Jun 2023 02:13:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id h16-20020aa786d0000000b006413e6e7578sm9939707pfo.5.2023.06.14.02.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 02:13:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q9MZB-00BcST-0H;
        Wed, 14 Jun 2023 19:13:25 +1000
Date:   Wed, 14 Jun 2023 19:13:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/11] xfs: logging the on disk inode LSN can make it go
 backwards
Message-ID: <ZImEtbErW1SSCAqk@dread.disaster.area>
References: <20210727071012.3358033-9-david@fromorbit.com>
 <87a5x3am7m.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5x3am7m.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 13, 2023 at 11:50:03AM +0530, Chandan Babu R wrote:
> On Tue, Jul 27, 2021 at 05:10:09PM +1000, Dave Chinner wrote:
> 
> Hi Dave,
> 
> I am trying to backport this patch to Linux-v5.4 LTS kernel. I am unable to
> understand as to how log recovery could overwrite a disk inode (holding newer
> contents) with a Log inode (containing stale contents). Please refer to my
> query below.

I've paged most of this out of my brain.

> 
> > From: Dave Chinner <dchinner@redhat.com>
> 
> > When we log an inode, we format the "log inode" core and set an LSN
> > in that inode core. We do that via xfs_inode_item_format_core(),
> > which calls:
> >
> > 	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
> 
> > to format the log inode. It writes the LSN from the inode item into
> > the log inode, and if recovery decides the inode item needs to be
> > replayed, it recovers the log inode LSN field and writes it into the
> > on disk inode LSN field.
> 
> > Now this might seem like a reasonable thing to do, but it is wrong
> > on multiple levels. Firstly, if the item is not yet in the AIL,
> > item->li_lsn is zero. i.e. the first time the inode it is logged and
> > formatted, the LSN we write into the log inode will be zero. If we
> > only log it once, recovery will run and can write this zero LSN into
> > the inode.
> 
> Assume that the following is the state before the inode is written back,
> Disk inode LSN = x
> Log inode LSN = 0
> Transaction LSN = x + 1
> 
> At this point, if the filesystem shuts down abruptly, log recovery could
> change the disk inode's LSN to zero.

Yes, that happened when we first logged a clean inode, so it was
dirty in memory but hadn't been placed in the AIL.

> > This means that the next time the inode is logged and log recovery
> > runs, it will *always* replay changes to the inode regardless of
> > whether the inode is newer on disk than the version in the log and
> > that violates the entire purpose of recording the LSN in the inode
> > at writeback time (i.e. to stop it going backwards in time on disk
> > during recovery).
> 
> After the log recovery indicated by me above, if the filesystem modifies the
> inode then the following is the state of metadata in memory and on disk,
> 
> Disk inode LSN = 0 (Due to changes made by log recovery during mount)
> Log inode LSN = 0 (xfs_log_item->li_lsn is zero until the log item is moved to
>                    the AIL in the current mount cycle)
> Transaction LSN = x + 2
>
> Now, if the filesystem shuts down abruptly once again, log recovery replays
> the contents of the Log dinode since Disk inode's LSN is less than
> transaction's LSN. In this example, the Log inode's contents were newer than
> the disk inode.

I'm not sure about the log shutdown aspects you talk about - the
test that exposed the issue wasn't doing shutdowns.  The test that
exposed this problem was generic/482, which uses dm-logwrites to
replay the filesystem up to each FUA operation, at which point it
mounts it to perform recovery and then runs reapir to check it for
consistency.

IOWs, it performs "recovery at every checkpoint in the log"
independently to determine if log recovery is doing the write
things. It tripped over recovery failing to replay inode changes
due to log/on-disk inode lsn inconsistencies like the following:

Checkpoint	log inode lsn	disk inode lsn		recovery disk inode lsn
1		0			0		0 (wrong!)
2		1			0		1 (wrong!)
3		2			0		2 (wrong!)
		<inode writeback>
					3		2 -should be 3-
		<inode reclaimed>
4		0 			3		-wont get replayed-
							-wrong!-
							-corruption!-

5		4			3		4 (wrong!)
6		5			3		5 (wrong!)
.....
25		6			3		6 (wrong!)
		<inode writeback>
					25		6 -should be 25-
26		25			25		25 -wrong!-


Do you see how the log inode LSN does not match up with the actual
LSN that is written into the inode at writeback time?

Do you see how the log inode LSN could magically go zero in the
middle of the log (Ckpt 4)? That's going to cause the inode log item
to be skipped, when it should have been replayed. That's a
corruption event.

Then if we look at checkpoint 26, where the on-disk inode LSN is 25,
and the log inode LSN is 25 - that log inode should not get replayed
because the LSNs are the same, but the old code did perform replay
and so this bug largely masked the typical off-by-one checkpoint the
log inode lsn contained.

> Your description suggests that there could be a scenario where a Log inode
> holding stale content can still overwrite the contents of the Disk inode
> holding newer content. I am unable to come with an example of how that could
> happen. Could please explain this to me.

I can't really remember. There are lots of ways using the wrong LSN
for recovery can go wrong; I was really just describing stuff I saw
in the test failures.....

> > Secondly, if we commit the CIL to the journal so the inode item
> > moves to the AIL, and then relog the inode, the LSN that gets
> > stamped into the log inode will be the LSN of the inode's current
> > location in the AIL, not it's age on disk. And it's not the LSN that
> > will be associated with the current change. That means when log
> > recovery replays this inode item, the LSN that ends up on disk is
> > the LSN for the previous changes in the log, not the current
> > changes being replayed. IOWs, after recovery the LSN on disk is not
> > in sync with the LSN of the modifications that were replayed into
> > the inode. This, again, violates the recovery ordering semantics
> > that on-disk writeback LSNs provide.

... and this is clearly evident in the example I give above.

> 
> > Hence the inode LSN in the log dinode is -always- invalid.
> 
> > Thirdly, recovery actually has the LSN of the log transaction it is
> > replaying right at hand - it uses it to determine if it should
> > replay the inode by comparing it to the on-disk inode's LSN. But it
> > doesn't use that LSN to stamp the LSN into the inode which will be
> > written back when the transaction is fully replayed. It uses the one
> > in the log dinode, which we know is always going to be incorrect.

This is also demonstrated in the example I give above.

Really, I don't remember any of the finer details of this fix now;
it was a long time ago and I don't really have the time to go back
an reconstruct it from first principles right now.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
