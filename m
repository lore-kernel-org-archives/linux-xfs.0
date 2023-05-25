Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BE2C77B7A
	for <linux-xfs@archiver.kernel.org>; Thu, 25 May 2023 02:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbjEYCUh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 May 2023 22:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236857AbjEYCUe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 May 2023 22:20:34 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C39D12B
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 19:20:31 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id d9443c01a7336-1ae3a5dfa42so7034905ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 24 May 2023 19:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1684981230; x=1687573230;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uSDKu1ZhyI+GOoIu+nwqOrmtLrG1r8buOz+TyEWhqKk=;
        b=zrYhgHdxsFyO6H10ZVFxFmB0l7PK/NPjzL6g17TRE5SvND1M+Szy9neWovRK3RuYCe
         JCwikWpXpSp6wZkaKePzVp3bDhPCS9cYaP1XGmL870g6i0JfN5CEbbdJRjyHYsVVBjKc
         vwG+tmilv8db4IfpF5xonqmgAFkyi8O/QvFB5dbsL5rsB3YNNBa2nbBlH4CJ1oXybzrn
         xzUGT1E3+/xvM7aQRHKCSLal+ZXg3yB7jJ0RZB/VWn9mbmv39+ROgTtcAW2YLAJKkw+6
         MhbFXOcM/T5pE8n7KlvB8gOsNvKLMEhJwdvPP9K1qoSioefzSP+ehbsBaSGsVOrWDCir
         j//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684981230; x=1687573230;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uSDKu1ZhyI+GOoIu+nwqOrmtLrG1r8buOz+TyEWhqKk=;
        b=FUThEUxl/J8jUffzG7O7uy6Vds3uBe7SPANRXcw4mHBD84Ls5kyAZ1eStOZUlUIwmn
         YmyetaTVPb/mha7tOPC49X1kh9Y8q3Z0y2ABdaxwovMch+qOpKr4VfEp72axRrD4NIwE
         DYiXMJTZ2WFK5bjaXZtxr9P+bQedr8Vu6ovTC0vHy2xSwlCwGyVEP/tfwh9npWoy/Ovg
         9QMN7UsKaobON6VU61tno2SNz+EsVdNrWTWaM0zJ1CKwwO07gw0jR1i3N/syTf5+MedF
         afI1bMSMuOPDPGHcmNkZMlcemmgNrOqBqS/y2D67I6p4D5tkMqNdYseYTmCkmRms1T7F
         MChg==
X-Gm-Message-State: AC+VfDzfRsPM4JpE/cnwL2s5pzGfNqDvdPeZzeZ/+p0Vx5tgdBsah/lR
        0JZlGjzNc4PzC8Dxn46Pi9YM+eIEVTavdbx2lb8=
X-Google-Smtp-Source: ACHHUZ5iVdery5raQCxojhTduYfT6bwshJusaWmF7+YPWaXFeE3o8BVKLWbm4ep28L28D9tz9CXadQ==
X-Received: by 2002:a17:903:1247:b0:1ae:8b4b:327d with SMTP id u7-20020a170903124700b001ae8b4b327dmr22488813plh.42.1684981230563;
        Wed, 24 May 2023 19:20:30 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-188.pa.nsw.optusnet.com.au. [49.179.0.188])
        by smtp.gmail.com with ESMTPSA id ji9-20020a170903324900b001a526805b86sm133651plb.191.2023.05.24.19.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 19:20:29 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q20aZ-003Yed-10;
        Thu, 25 May 2023 12:20:27 +1000
Date:   Thu, 25 May 2023 12:20:27 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: Don't block in xfs_extent_busy_flush
Message-ID: <ZG7F6xj5N/ahwOMH@dread.disaster.area>
References: <20230519171829.4108-1-wen.gang.wang@oracle.com>
 <ZGrCpXoEk9achabI@dread.disaster.area>
 <E6E92519-4AD7-4115-903F-00D7633B1B3A@oracle.com>
 <ZGvvZaQWvxf2cqlz@dread.disaster.area>
 <8DD695CE-4965-4B33-8F16-6B907D8A0884@oracle.com>
 <20230524002743.GF11620@frogsfrogsfrogs>
 <7D3E40A7-4D94-4EF0-8BED-FE11C76B8A84@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7D3E40A7-4D94-4EF0-8BED-FE11C76B8A84@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 24, 2023 at 04:27:19PM +0000, Wengang Wang wrote:
> > On May 23, 2023, at 5:27 PM, Darrick J. Wong <djwong@kernel.org> wrote:
> > On Tue, May 23, 2023 at 02:59:40AM +0000, Wengang Wang wrote:
> >>> On May 22, 2023, at 3:40 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>> On Mon, May 22, 2023 at 06:20:11PM +0000, Wengang Wang wrote:
> >>>>> On May 21, 2023, at 6:17 PM, Dave Chinner <david@fromorbit.com> wrote:
> >>>>> On Fri, May 19, 2023 at 10:18:29AM -0700, Wengang Wang wrote:
> >>>>>> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> >>>> For existing other cases (if there are) where new intents are added,
> >>>> they don’t use the capture_list for delayed operations? Do you have example then? 
> >>>> if so I think we should follow their way instead of adding the defer operations
> >>>> (but reply on the intents on AIL).
> >>> 
> >>> All of the intent recovery stuff uses
> >>> xfs_defer_ops_capture_and_commit() to commit the intent being
> >>> replayed and cause all further new intent processing in that chain
> >>> to be defered until after all the intents recovered from the journal
> >>> have been iterated. All those new intents end up in the AIL at a LSN
> >>> index >= last_lsn.
> >> 
> >> Yes. So we break the AIL iteration on seeing an intent with lsn equal to
> >> or bigger than last_lsn and skip the iop_recover() for that item?
> >> and shall we put this change to another separated patch as it is to fix
> >> an existing problem (not introduced by my patch)?
> > 
> > Intent replay creates non-intent log items (like buffers or inodes) that
> > are added to the AIL with an LSN higher than last_lsn.  I suppose it
> > would be possible to break log recovery if an intent's iop_recover
> > method immediately logged a new intent and returned EAGAIN to roll the
> > transaction, but none of them do that;
> 
> I am not quite sure for above. There are cases that new intents are added
> in iop_recover(), for example xfs_attri_item_recover():
> 
> 632         error = xfs_xattri_finish_update(attr, done_item);
> 633         if (error == -EAGAIN) {
> 634                 /*
> 635                  * There's more work to do, so add the intent item to this
> 636                  * transaction so that we can continue it later.
> 637                  */
> 638                 xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_ATTR, &attr->xattri_list);
> 639                 error = xfs_defer_ops_capture_and_commit(tp, capture_list);
> 640                 if (error)
> 641                         goto out_unlock;
> 642
> 643                 xfs_iunlock(ip, XFS_ILOCK_EXCL);
> 644                 xfs_irele(ip);
> 645                 return 0;
> 646         }
> 
> I am thinking line 638 and 639 are doing so.

I don't think so. @attrip is the attribute information recovered
from the original intent - we allocated @attr in
xfs_attri_item_recover() to enable the operation indicated by
@attrip to be executed.  We copy stuff from @attrip (the item we are
recovering) to the new @attr structure (the work we need to do) and
run it through the attr modification state machine. If there's more
work to be done, we then add @attr to the defer list.

If there is deferred work to be continued, we still need a new
intent to indicate what attr operation needs to be performed next in
the chain.  When we commit the transaction (639), it will create a
new intent log item for the deferred attribute operation in the
->create_intent callback before the transaction is committed.

IOWs, we never re-use the incoming intent item that we are
recovering. The new log item will end up in the AIL at/beyond
last_lsn when the CIL is committed. It does not get further
processing work done until all the intents in the log that need
recovery have had their initial processing performed and the log
space they consume has been freed up.

> > and I think the ASSERT you moved would detect such a thing.
> 
> ASSERT is nothing in production kernel, so it has less chance to
> detect things.

Please understand that we do actually know how the ASSERT
infrastructure works and we utilise it to our advantage in many
ways.  We often use asserts to document design/code constraints and
use debug kernels to perform runtime design rule violation
detection.

Indeed, we really don't want design/code constraints being checked on
production kernels, largely because we know they are never going to
be tripped in normal production system operation. IOWs, these checks
are unnecessary in production systems because we've already done all
the constraint/correctness checking of the code on debug kernels
before we release the software to production.

If a particular situation is a production concern, we code it as an
error check, not an ASSERT. If it's a design or implementation
constraint check, it's an ASSERT. The last_lsn ASSERT is checking
that the code is behaving according to design constraints (i.e.
CIL/AIL ordering has not been screwed up, intent recovery has not
changed behaviour, and new objects always appear at >= last_lsn).
None of these things should ever occur in a production system - if
any of them occur do then we'll have much, much worse problems to
address than log recovery maybe running an intent too early.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
