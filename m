Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BE3EC83F01
	for <linux-xfs@archiver.kernel.org>; Sat, 26 Aug 2023 03:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbjHZDh4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Aug 2023 23:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbjHZDhb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Aug 2023 23:37:31 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6EB2132
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2023 20:37:29 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-68a56401c12so1169315b3a.2
        for <linux-xfs@vger.kernel.org>; Fri, 25 Aug 2023 20:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693021048; x=1693625848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AYb9ZYPJnOulK1g6I1rugUOqmJE2XqOkxVeFeG6gUZ8=;
        b=S4RZ+efspjU1kKXytdLHbxwvoDIws7m1oHKys1C2Xdf4VvfxsaU+9yRgIg3EmP6qu0
         6dzvG/5o7DWbeltPgYFBzq+fVXc/JsZJRdyRJyWcPanBQQ/dUUx5GT7TIrrsMsqxyTki
         y6F92qQ74/PeVIQiGdYIvdVVCW8iPD42GGbAXdV/lSpAnUwrc3X8SbkkDZAjYAsLohaZ
         hbTMuswCi3v50/OHNIBECjcUbJ7mxKTI2cLXzNbhyXmmELWPcwL2+3Bw59V1SrZzQm5r
         noPyr/LSVISYSbiLWs+a6Uno1e+TAjzYLNognhnZrYSeK8FCek6NyZo6tcnN5q/CRj5h
         H9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693021048; x=1693625848;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AYb9ZYPJnOulK1g6I1rugUOqmJE2XqOkxVeFeG6gUZ8=;
        b=YnI3v5TrWVZ0KSKEH4REthXCHnmIqaOuT1DJHznx5f5MP+33mJBQK2oBQrUUtPzHoE
         nuGq95iyitEZkHKAybw/USpGnFmhWKpttX0jtIwsxfVmcDd6n4o6KE4h2eUwAf1yA/wR
         oqbIcG5cKHf8Z82reqtUtrp8kfmkaDjhGDtCw+uRJi8xyxzWQ6Ezzqur17AbXhzwxcSy
         Tiy0Hygg3D0Whhzv3/JzADp94yesb6UALO9lqef1bYzPCUhTRsH2B8GhR3HhEpSO4j+P
         4O/nehiExNoOZdysgM7iJO2GfspZn+AhEdvjBOvuQ+Y0pMgUhtqb3DRmRhhghJ3KZH2L
         VKcw==
X-Gm-Message-State: AOJu0YzKcMr7i15Q4KU9fk5Vv6eXWaEg5z02kOcWwM/UZTrCSM6s7Wsy
        ABXMuK1RFx1krPR2KZzWJuPyLXchu2G3ZZL++io=
X-Google-Smtp-Source: AGHT+IHYpwDiNutkUYmM5eEIiJ+SnRSxc+rB2Kxqa3xqv1i4orfAc13L+QJxQ30WnZIdJxwBplsMlg==
X-Received: by 2002:a05:6a20:2c2:b0:13f:67b6:b65f with SMTP id 2-20020a056a2002c200b0013f67b6b65fmr13854205pzb.54.1693021047634;
        Fri, 25 Aug 2023 20:37:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id f7-20020a170902860700b001bbc8d65de0sm2565966plo.67.2023.08.25.20.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 20:37:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qZk72-006bbl-0x;
        Sat, 26 Aug 2023 13:37:24 +1000
Date:   Sat, 26 Aug 2023 13:37:24 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Wengang Wang <wen.gang.wang@oracle.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Srikanth C S <srikanth.c.s@oracle.com>
Subject: Re: Question: reserve log space at IO time for recover
Message-ID: <ZOlzdNT/DWb+fmPq@dread.disaster.area>
References: <ZLeBvfTdRbFJ+mj2@dread.disaster.area>
 <2A3BFAC0-1482-412E-A126-7EAFE65282E8@oracle.com>
 <ZL3MlgtPWx5NHnOa@dread.disaster.area>
 <2D5E234E-3EE3-4040-81DA-576B92FF7401@oracle.com>
 <ZMCcJSLiWIi3KBOl@dread.disaster.area>
 <BED64CCE-93D1-4110-B2C8-903A00D0013C@oracle.com>
 <3B6E1DAE-5191-4050-BE97-75B4D22BDE24@oracle.com>
 <20230824045234.GK11263@frogsfrogsfrogs>
 <ZOcGl/tujTv2MjEr@dread.disaster.area>
 <20230824220154.GA17912@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230824220154.GA17912@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 24, 2023 at 03:01:54PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 24, 2023 at 05:28:23PM +1000, Dave Chinner wrote:
> > On Wed, Aug 23, 2023 at 09:52:34PM -0700, Darrick J. Wong wrote:
> > > On Fri, Aug 18, 2023 at 03:25:46AM +0000, Wengang Wang wrote:
> > > 
> > > Since xfs_efi_item_recover is only performing one step of what could be
> > > a chain of deferred updates, it never rolls the transaction that it
> > > creates.  It therefore only requires the amount of grant space that
> > > you'd get with tr_logcount == 1.  It is therefore a bit silly that we
> > > ask for more than that, and in bad cases like this, hang log recovery
> > > needlessly.
> > 
> > But this doesn't fix the whatever problem lead to the recovery not
> > having the same full tr_itruncate reservation available as was held
> > by the transaction that logged the EFI and was running the extent
> > free at the time the system crashed. There should -always- be enough
> > transaction reservation space in the journal to reserve space for an
> > intent replay if the intent recovery reservation uses the same
> > reservation type as runtime.
> > 
> > Hence I think this is still just a band-aid over whatever went wrong
> > at runtime that lead to the log not having enough space for a
> > reservation that was clearly held at runtime and hadn't yet used.
> 
> Maybe I'm not remembering accurately how permanent log reservations
> work.  Let's continue picking on tr_itruncate from Wengang's example.
> IIRC, he said that tr_itruncate on the running system was defined
> roughly like so:
> 
> tr_itruncate = {
> 	.tr_logres	= 180K
> 	.tr_logcount	= 2,
> 	.tr_logflags	= XFS_TRANS_PERM_LOG_RES,
> }
> 
> At runtime, when we want to start a truncation update, we do this:
> 
> 	xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, ...);
> 
> Call sequence: xfs_trans_alloc -> xfs_trans_reserve -> xfs_log_reserve
> -> xlog_ticket_alloc.  Ticket allocation assigns tic->t_unit_res =
> (tr_logres + overhead) and tic->t_cnt = tr_logcount.
> 
> (Let's pretend for the sake of argument that the overhead is 5K.)
> 
> Now xfs_log_reserve calls xlog_grant_head_check.  That does:
> 
> 	*need_bytes = xlog_ticket_reservation(log, head, tic);
> 
> For the reserve head, the ticket reservation computation is
> (tic->t_unit_res * tic->t_cnt), which in this case is (185K * 2) ==
> 370K, right?  So we make sure there's at least 370K free in the reserve
> head, then add that to the reserve and write heads.
> 
> Now that we've allocated the transaction, delete the bmap mapping,
> log an EFI to free the space, and roll the transaction as part of
> finishing the deferops chain.  Rolling creates a new xfs_trans which
> shares its ticket with the old transaction.  Next, xfs_trans_roll calls
> __xfs_trans_commit with regrant == true, which calls xlog_cil_commit
> with the same regrant parameter.
> 
> xlog_cil_commit calls xfs_log_ticket_regrant, which decrements t_cnt and
> subtracts t_curr_res from the reservation and write heads.
> 
> If the filesystem is fresh and the first transaction only used (say)
> 20K, then t_curr_res will be 165K, and we give that much reservation
> back to the reservation head.  Or if the file is really fragmented and
> the first transaction actually uses 170K, then t_curr_res will be 15K,
> and that's what we give back to the reservation.
> 
> Having done that, we're now headed into the second transaction with an
> EFI and 185K of reservation, correct?

Ah, right, I overlooked that the long running truncates only regrant a
single reservation unit at a time when they roll, and the runtime
instances I seen of this are with long running truncate operations
(i.e. inactivation after unlink for multi-thousand extent inodes).

So, yes, all types of intent recovery must only use a single unit
reservation, not just EFIs, because there is no guarantee that there
is a full unit * count reservation available in the journal whenever
that intent was first logged. Indeed, at best it will be 'count - 1'
that is avaialble, becuase the transaction that logged the intent
will have used a full unit of the original reservation....

> IOWs, I'm operating on an assumption that we have two problems to solve:
> the runtime acconting bug that you've been chasing, and Wengang's where
> log recovery asks for more log space than what had been in the log
> ticket at the time of the crash.

OK, yes, it does seem there are two problems here...

> > I suspect that the cause of this recovery issue is the we require an
> > overcommit of the log space accounting before we throttle incoming
> > transaction reservations (i.e. the new reservation has to overrun
> > before we throttle). I think that the reservation accounting overrun
> > detection can race to the first item being placed on the wait list,
> 
> Yeah, I was wondering that myself when I was looking at the logic
> between list_empty_careful and the second xlog_grant_head_wait and
> wondering if that "careful" construction actually worked.

Well, it's not the careful check that is the problem; the race is
much simpler than that. We just have to have two concurrent
reservations that will both fit in the remaining log space
individually but not together. i.e. this is the overcommit race
window:

P1				P2
---------------------------	--------------------------
xfs_log_reserve(10000 bytes)
  xlog_grant_head_check()
    xlog_space_left()
      <sees 12000 bytes>
    OK, doesn't wait
  				xfs_log_reserve(10000 bytes)
				  xlog_grant_head_check()
				    xlog_space_left()
				      <sees 12000 bytes>
				    OK, doesn't wait
    xlog_grant_add_space(10k)
    				  xlog_grant_add_space(10k)

And now we've overcommitted the log by 8000 bytes....

The current byte based grant head patch set does not address this;
the attempt I made to fix it didn't work properly, so I split the
rework of the throttling out of the byte based accounting patchset
(which seems to work correctly without reworking
xlog_grant_head_check()) and now I'm trying to address this race
condition as a separate patchset...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
