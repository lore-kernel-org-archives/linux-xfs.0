Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF82C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 07:23:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2B442070A
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 07:23:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731519AbgEZHX3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 03:23:29 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:44623 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731270AbgEZHX3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 03:23:29 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 6E62AD792E3
        for <linux-xfs@vger.kernel.org>; Tue, 26 May 2020 17:23:22 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jdTvg-0003ge-RG
        for linux-xfs@vger.kernel.org; Tue, 26 May 2020 17:23:16 +1000
Date:   Tue, 26 May 2020 17:23:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: intents vs AIL
Message-ID: <20200526072316.GX2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=gFk46TBeNdJUMnf5lIAA:9 a=oovXZDbr1qzbtZkK:21 a=dxZsS29_6R3Ji797:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

HI folks,

Just noticed this interesting thing when looking at a trace or an
rm -rf worklaod of fsstress directories (generic/051 cleanup, FWIW).
The trace fragment is this, trimmed for brevity:

       255.854202: xfs_ail_insert:  lip 0xffff888136421540 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854202: xfs_ail_insert:  lip 0xffff888216cc8848 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854203: xfs_ail_insert:  lip 0xffff8881364217e8 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854203: xfs_ail_insert:  lip 0xffff888216cc86a0 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854204: xfs_ail_insert:  lip 0xffff888834e71090 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854204: xfs_ail_insert:  lip 0xffff8885ca67e120 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854205: xfs_ail_insert:  lip 0xffff888800660ff0 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854205: xfs_ail_insert:  lip 0xffff888828bee618 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854206: xfs_ail_insert:  lip 0xffff888800661298 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854206: xfs_ail_insert:  lip 0xffff888828bee7c0 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854207: xfs_ail_insert:  lip 0xffff8885ca67e2c8 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854207: xfs_ail_insert:  lip 0xffff888834e71238 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854208: xfs_ail_insert:  lip 0xffff888136421a90 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854208: xfs_ail_insert:  lip 0xffff888216cc84f8 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854208: xfs_ail_insert:  lip 0xffff888136421d38 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854209: xfs_ail_insert:  lip 0xffff888216cc8350 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854209: xfs_ail_insert:  lip 0xffff888834e713e0 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854210: xfs_ail_insert:  lip 0xffff8885ca67e470 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854210: xfs_ail_insert:  lip 0xffff8885ca67e618 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854211: xfs_ail_insert:  lip 0xffff888800661540 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854211: xfs_ail_insert:  lip 0xffff888828bee968 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854212: xfs_ail_insert:  lip 0xffff8888006617e8 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854213: xfs_ail_insert:  lip 0xffff888828beeb10 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854214: xfs_ail_insert:  lip 0xffff888834e71588 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854215: xfs_ail_insert:  lip 0xffff888136421fe0 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854215: xfs_ail_insert:  lip 0xffff888216cc81a8 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854215: xfs_ail_insert:  lip 0xffff888136422288 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854216: xfs_ail_insert:  lip 0xffff88810deefd48 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854216: xfs_ail_insert:  lip 0xffff888834e71730 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854217: xfs_ail_insert:  lip 0xffff8885ca67e7c0 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854217: xfs_ail_insert:  lip 0xffff888800661a90 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854218: xfs_ail_insert:  lip 0xffff888828beecb8 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854219: xfs_ail_delete:  lip 0xffff888136421540 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854220: xfs_ail_delete:  lip 0xffff888216cc8848 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854220: xfs_ail_delete:  lip 0xffff8881364217e8 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854221: xfs_ail_delete:  lip 0xffff888216cc86a0 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854222: xfs_ail_delete:  lip 0xffff888834e71090 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854223: xfs_ail_delete:  lip 0xffff8885ca67e120 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854224: xfs_ail_delete:  lip 0xffff888800660ff0 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854224: xfs_ail_delete:  lip 0xffff888828bee618 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854225: xfs_ail_delete:  lip 0xffff888800661298 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854226: xfs_ail_delete:  lip 0xffff888828bee7c0 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854227: xfs_ail_delete:  lip 0xffff8885ca67e2c8 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854227: xfs_ail_delete:  lip 0xffff888834e71238 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854228: xfs_ail_delete:  lip 0xffff888136421a90 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854229: xfs_ail_delete:  lip 0xffff888216cc84f8 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854229: xfs_ail_delete:  lip 0xffff888136421d38 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854230: xfs_ail_delete:  lip 0xffff888216cc8350 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854231: xfs_ail_delete:  lip 0xffff888834e713e0 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854231: xfs_ail_delete:  lip 0xffff8885ca67e470 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854232: xfs_ail_delete:  lip 0xffff8885ca67e618 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854233: xfs_ail_delete:  lip 0xffff888800661540 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854234: xfs_ail_delete:  lip 0xffff888828bee968 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854234: xfs_ail_delete:  lip 0xffff8888006617e8 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854235: xfs_ail_delete:  lip 0xffff888828beeb10 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854235: xfs_ail_delete:  lip 0xffff888834e71588 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854236: xfs_ail_delete:  lip 0xffff888136421fe0 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854237: xfs_ail_delete:  lip 0xffff888216cc81a8 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854238: xfs_ail_delete:  lip 0xffff888136422288 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854239: xfs_ail_delete:  lip 0xffff888834e71730 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854240: xfs_ail_delete:  lip 0xffff88810deefd48 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
       255.854242: xfs_ail_delete:  lip 0xffff888800661a90 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
       255.854243: xfs_ail_delete:  lip 0xffff8885ca67e7c0 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
       255.854244: xfs_ail_delete:  lip 0xffff888828beecb8 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL

It's part of a checkpoint commit completion item processing
intent and intent done items in the checkpoint.

Basically, that series of inserts is exactly a batch of 32 inserts,
followed by exactly a batch of 32 deletes. journal item completion
batches processing into groups of 32 items, so this is two
consecutive batches.

So what makes this interesting? The interesting thing is the two
batches contain -exactly the same intents-.

IOWs, this is a series of intents, followed instantly in the same
commit by their Done counterparts that remove the intents from the
AIL.

So why am I pointing this out?

Well, if both the intent and the intent done are in the same
checkpoint (we can see they are as teh "new lsn" is the current
commit lsn), why did we bother to insert the intent into the AIL?
We just did a -heap- of unnecessary processing - we can simply just
free both the intent and the intent done without even putting them
into the AIL in this situation.

In the trace which is removing about 25,000 files and about a
million filesystem blocks, there are this many intents logged:

$ grep ail_insert: s.t |wc -l
244547
$ grep ail_insert: s.t |grep "CUI\|EFI\|RUI" |wc -l
203906

So >80% of the items being inserted into the AIL are intents, and a
large number of them have this "intent and done in the same
checkpoint" pattern associated with them. We should be catching this
during the CIL formatting (i.e. catching that the intent and the
intent done in teh same CIL checkpoint) and making sure we don't put
these anywhere near the AIL checkpoint completion....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
