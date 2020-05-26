Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACA44C433DF
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 08:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 874E020663
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 08:06:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgEZIG4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 04:06:56 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:41518 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726926AbgEZIGz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 04:06:55 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 5F3D21A84CE
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 18:06:50 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jdUbk-00042E-81
        for linux-xfs@vger.kernel.org; Tue, 26 May 2020 18:06:44 +1000
Date:   Tue, 26 May 2020 18:06:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: intents vs AIL
Message-ID: <20200526080644.GY2040@dread.disaster.area>
References: <20200526072316.GX2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526072316.GX2040@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=Stlabdp9UtnNfRHFdR4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 26, 2020 at 05:23:16PM +1000, Dave Chinner wrote:
> HI folks,
> 
> Just noticed this interesting thing when looking at a trace or an
> rm -rf worklaod of fsstress directories (generic/051 cleanup, FWIW).
> The trace fragment is this, trimmed for brevity:
> 
>        255.854202: xfs_ail_insert:  lip 0xffff888136421540 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854202: xfs_ail_insert:  lip 0xffff888216cc8848 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854203: xfs_ail_insert:  lip 0xffff8881364217e8 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854203: xfs_ail_insert:  lip 0xffff888216cc86a0 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854204: xfs_ail_insert:  lip 0xffff888834e71090 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854204: xfs_ail_insert:  lip 0xffff8885ca67e120 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854205: xfs_ail_insert:  lip 0xffff888800660ff0 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854205: xfs_ail_insert:  lip 0xffff888828bee618 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854206: xfs_ail_insert:  lip 0xffff888800661298 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854206: xfs_ail_insert:  lip 0xffff888828bee7c0 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854207: xfs_ail_insert:  lip 0xffff8885ca67e2c8 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854207: xfs_ail_insert:  lip 0xffff888834e71238 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854208: xfs_ail_insert:  lip 0xffff888136421a90 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854208: xfs_ail_insert:  lip 0xffff888216cc84f8 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854208: xfs_ail_insert:  lip 0xffff888136421d38 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854209: xfs_ail_insert:  lip 0xffff888216cc8350 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854209: xfs_ail_insert:  lip 0xffff888834e713e0 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854210: xfs_ail_insert:  lip 0xffff8885ca67e470 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854210: xfs_ail_insert:  lip 0xffff8885ca67e618 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854211: xfs_ail_insert:  lip 0xffff888800661540 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854211: xfs_ail_insert:  lip 0xffff888828bee968 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854212: xfs_ail_insert:  lip 0xffff8888006617e8 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854213: xfs_ail_insert:  lip 0xffff888828beeb10 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854214: xfs_ail_insert:  lip 0xffff888834e71588 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854215: xfs_ail_insert:  lip 0xffff888136421fe0 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854215: xfs_ail_insert:  lip 0xffff888216cc81a8 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854215: xfs_ail_insert:  lip 0xffff888136422288 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854216: xfs_ail_insert:  lip 0xffff88810deefd48 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854216: xfs_ail_insert:  lip 0xffff888834e71730 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854217: xfs_ail_insert:  lip 0xffff8885ca67e7c0 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854217: xfs_ail_insert:  lip 0xffff888800661a90 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854218: xfs_ail_insert:  lip 0xffff888828beecb8 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854219: xfs_ail_delete:  lip 0xffff888136421540 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854220: xfs_ail_delete:  lip 0xffff888216cc8848 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854220: xfs_ail_delete:  lip 0xffff8881364217e8 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854221: xfs_ail_delete:  lip 0xffff888216cc86a0 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854222: xfs_ail_delete:  lip 0xffff888834e71090 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854223: xfs_ail_delete:  lip 0xffff8885ca67e120 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854224: xfs_ail_delete:  lip 0xffff888800660ff0 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854224: xfs_ail_delete:  lip 0xffff888828bee618 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854225: xfs_ail_delete:  lip 0xffff888800661298 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854226: xfs_ail_delete:  lip 0xffff888828bee7c0 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854227: xfs_ail_delete:  lip 0xffff8885ca67e2c8 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854227: xfs_ail_delete:  lip 0xffff888834e71238 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854228: xfs_ail_delete:  lip 0xffff888136421a90 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854229: xfs_ail_delete:  lip 0xffff888216cc84f8 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854229: xfs_ail_delete:  lip 0xffff888136421d38 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854230: xfs_ail_delete:  lip 0xffff888216cc8350 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854231: xfs_ail_delete:  lip 0xffff888834e713e0 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854231: xfs_ail_delete:  lip 0xffff8885ca67e470 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854232: xfs_ail_delete:  lip 0xffff8885ca67e618 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854233: xfs_ail_delete:  lip 0xffff888800661540 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854234: xfs_ail_delete:  lip 0xffff888828bee968 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854234: xfs_ail_delete:  lip 0xffff8888006617e8 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854235: xfs_ail_delete:  lip 0xffff888828beeb10 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854235: xfs_ail_delete:  lip 0xffff888834e71588 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854236: xfs_ail_delete:  lip 0xffff888136421fe0 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854237: xfs_ail_delete:  lip 0xffff888216cc81a8 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854238: xfs_ail_delete:  lip 0xffff888136422288 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854239: xfs_ail_delete:  lip 0xffff888834e71730 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854240: xfs_ail_delete:  lip 0xffff88810deefd48 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
>        255.854242: xfs_ail_delete:  lip 0xffff888800661a90 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
>        255.854243: xfs_ail_delete:  lip 0xffff8885ca67e7c0 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
>        255.854244: xfs_ail_delete:  lip 0xffff888828beecb8 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> 
> It's part of a checkpoint commit completion item processing
> intent and intent done items in the checkpoint.
> 
> Basically, that series of inserts is exactly a batch of 32 inserts,
> followed by exactly a batch of 32 deletes. journal item completion
> batches processing into groups of 32 items, so this is two
> consecutive batches.
> 
> So what makes this interesting? The interesting thing is the two
> batches contain -exactly the same intents-.
> 
> IOWs, this is a series of intents, followed instantly in the same
> commit by their Done counterparts that remove the intents from the
> AIL.
> 
> So why am I pointing this out?
> 
> Well, if both the intent and the intent done are in the same
> checkpoint (we can see they are as teh "new lsn" is the current
> commit lsn), why did we bother to insert the intent into the AIL?
> We just did a -heap- of unnecessary processing - we can simply just
> free both the intent and the intent done without even putting them
> into the AIL in this situation.

Follow up question, after a bit of time with this rattling around my
empty skull: if the intent and intent done are in the same CIL
checkpoint, do they even need to be written to the journal?

i.e. can we cull in-memory intents from the CIL as soon as the
intent done is committed in memory to the CIL?

Given that everything that the intent is supposed to replay is
committed to the same CIL context, I don't see why the intent and
the intent done actually need to be written to the log. If they are
written to the log, then all that will happen is log recovery will
read, process and cancel them as there is nothing to replay....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
