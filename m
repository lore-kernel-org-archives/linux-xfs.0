Return-Path: <SRS0=dAFJ=7I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0870C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 15:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A45DC206D5
	for <linux-xfs@archiver.kernel.org>; Tue, 26 May 2020 15:45:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JEnOGFZa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728270AbgEZPpy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 May 2020 11:45:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37195 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727926AbgEZPpy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 May 2020 11:45:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590507952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dmPPYdI+nmlYfe4SETtkzwqRVVtL1lSEXNbLzTdG/wE=;
        b=JEnOGFZaYwZFpgn2G3z8ntPkq+hGljW6SN/tNaBpn9L8fCWg/Lf75flTMNrL66GX1gx3mU
        N3HAgDdyYBFcp9hQ/BEe2KIj8QBvczDcQ6yLkEy4FdvoUd+3Zd9HXzafg55zBQiKIWGllf
        MLPgd3llzBhuUjRe2Lu+us4ic/2/DfY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-2CCFqayiM5uJ9al5No7qRQ-1; Tue, 26 May 2020 11:45:50 -0400
X-MC-Unique: 2CCFqayiM5uJ9al5No7qRQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99803872FE1;
        Tue, 26 May 2020 15:45:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AD9D6FB84;
        Tue, 26 May 2020 15:45:49 +0000 (UTC)
Date:   Tue, 26 May 2020 11:45:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: intents vs AIL
Message-ID: <20200526154547.GD5462@bfoster>
References: <20200526072316.GX2040@dread.disaster.area>
 <20200526080644.GY2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526080644.GY2040@dread.disaster.area>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 26, 2020 at 06:06:44PM +1000, Dave Chinner wrote:
> On Tue, May 26, 2020 at 05:23:16PM +1000, Dave Chinner wrote:
> > HI folks,
> > 
> > Just noticed this interesting thing when looking at a trace or an
> > rm -rf worklaod of fsstress directories (generic/051 cleanup, FWIW).
> > The trace fragment is this, trimmed for brevity:
> > 
> >        255.854202: xfs_ail_insert:  lip 0xffff888136421540 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854202: xfs_ail_insert:  lip 0xffff888216cc8848 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854203: xfs_ail_insert:  lip 0xffff8881364217e8 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854203: xfs_ail_insert:  lip 0xffff888216cc86a0 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854204: xfs_ail_insert:  lip 0xffff888834e71090 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854204: xfs_ail_insert:  lip 0xffff8885ca67e120 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854205: xfs_ail_insert:  lip 0xffff888800660ff0 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854205: xfs_ail_insert:  lip 0xffff888828bee618 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854206: xfs_ail_insert:  lip 0xffff888800661298 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854206: xfs_ail_insert:  lip 0xffff888828bee7c0 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854207: xfs_ail_insert:  lip 0xffff8885ca67e2c8 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854207: xfs_ail_insert:  lip 0xffff888834e71238 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854208: xfs_ail_insert:  lip 0xffff888136421a90 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854208: xfs_ail_insert:  lip 0xffff888216cc84f8 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854208: xfs_ail_insert:  lip 0xffff888136421d38 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854209: xfs_ail_insert:  lip 0xffff888216cc8350 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854209: xfs_ail_insert:  lip 0xffff888834e713e0 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854210: xfs_ail_insert:  lip 0xffff8885ca67e470 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854210: xfs_ail_insert:  lip 0xffff8885ca67e618 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854211: xfs_ail_insert:  lip 0xffff888800661540 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854211: xfs_ail_insert:  lip 0xffff888828bee968 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854212: xfs_ail_insert:  lip 0xffff8888006617e8 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854213: xfs_ail_insert:  lip 0xffff888828beeb10 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854214: xfs_ail_insert:  lip 0xffff888834e71588 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854215: xfs_ail_insert:  lip 0xffff888136421fe0 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854215: xfs_ail_insert:  lip 0xffff888216cc81a8 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854215: xfs_ail_insert:  lip 0xffff888136422288 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854216: xfs_ail_insert:  lip 0xffff88810deefd48 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854216: xfs_ail_insert:  lip 0xffff888834e71730 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854217: xfs_ail_insert:  lip 0xffff8885ca67e7c0 old lsn 0/0 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854217: xfs_ail_insert:  lip 0xffff888800661a90 old lsn 0/0 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854218: xfs_ail_insert:  lip 0xffff888828beecb8 old lsn 0/0 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854219: xfs_ail_delete:  lip 0xffff888136421540 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854220: xfs_ail_delete:  lip 0xffff888216cc8848 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854220: xfs_ail_delete:  lip 0xffff8881364217e8 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854221: xfs_ail_delete:  lip 0xffff888216cc86a0 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854222: xfs_ail_delete:  lip 0xffff888834e71090 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854223: xfs_ail_delete:  lip 0xffff8885ca67e120 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854224: xfs_ail_delete:  lip 0xffff888800660ff0 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854224: xfs_ail_delete:  lip 0xffff888828bee618 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854225: xfs_ail_delete:  lip 0xffff888800661298 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854226: xfs_ail_delete:  lip 0xffff888828bee7c0 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854227: xfs_ail_delete:  lip 0xffff8885ca67e2c8 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854227: xfs_ail_delete:  lip 0xffff888834e71238 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854228: xfs_ail_delete:  lip 0xffff888136421a90 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854229: xfs_ail_delete:  lip 0xffff888216cc84f8 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854229: xfs_ail_delete:  lip 0xffff888136421d38 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854230: xfs_ail_delete:  lip 0xffff888216cc8350 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854231: xfs_ail_delete:  lip 0xffff888834e713e0 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854231: xfs_ail_delete:  lip 0xffff8885ca67e470 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854232: xfs_ail_delete:  lip 0xffff8885ca67e618 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854233: xfs_ail_delete:  lip 0xffff888800661540 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854234: xfs_ail_delete:  lip 0xffff888828bee968 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854234: xfs_ail_delete:  lip 0xffff8888006617e8 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854235: xfs_ail_delete:  lip 0xffff888828beeb10 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854235: xfs_ail_delete:  lip 0xffff888834e71588 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854236: xfs_ail_delete:  lip 0xffff888136421fe0 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854237: xfs_ail_delete:  lip 0xffff888216cc81a8 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854238: xfs_ail_delete:  lip 0xffff888136422288 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854239: xfs_ail_delete:  lip 0xffff888834e71730 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854240: xfs_ail_delete:  lip 0xffff88810deefd48 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> >        255.854242: xfs_ail_delete:  lip 0xffff888800661a90 old lsn 75/28128 new lsn 76/296 type XFS_LI_RUI flags IN_AIL
> >        255.854243: xfs_ail_delete:  lip 0xffff8885ca67e7c0 old lsn 75/28128 new lsn 76/296 type XFS_LI_EFI flags IN_AIL
> >        255.854244: xfs_ail_delete:  lip 0xffff888828beecb8 old lsn 75/28128 new lsn 76/296 type XFS_LI_CUI flags IN_AIL
> > 
> > It's part of a checkpoint commit completion item processing
> > intent and intent done items in the checkpoint.
> > 
> > Basically, that series of inserts is exactly a batch of 32 inserts,
> > followed by exactly a batch of 32 deletes. journal item completion
> > batches processing into groups of 32 items, so this is two
> > consecutive batches.
> > 
> > So what makes this interesting? The interesting thing is the two
> > batches contain -exactly the same intents-.
> > 
> > IOWs, this is a series of intents, followed instantly in the same
> > commit by their Done counterparts that remove the intents from the
> > AIL.
> > 
> > So why am I pointing this out?
> > 
> > Well, if both the intent and the intent done are in the same
> > checkpoint (we can see they are as teh "new lsn" is the current
> > commit lsn), why did we bother to insert the intent into the AIL?
> > We just did a -heap- of unnecessary processing - we can simply just
> > free both the intent and the intent done without even putting them
> > into the AIL in this situation.
> 

ISTM this is part historical and perhaps part interface limitation (i.e.
the ->iop_*() callbacks pre-date the CIL). Presumably it never made
sense to remove dirty objects (outside of an abort) from the logging
pipeline before the CIL was introduced. The iop_*() interface is also
pretty rigid in terms of allowing items to react to log subsystem events
as opposed to controlling them.

> Follow up question, after a bit of time with this rattling around my
> empty skull: if the intent and intent done are in the same CIL
> checkpoint, do they even need to be written to the journal?
> 

Hmm... that sounds reasonable in theory. Some thoughts that come to
mind:

1.) We don't have to worry about crashing mid-checkpoint where the
intent might have been written to the log and the done item not since we
lose the entire checkpoint in that case, right?

2.) It's not immediately clear to me if relog would play well with such
an optimization. That said, with relog having fairly isolated use cases
and this being more of an optimization, we could always come up with a
bypass mechanism if we wanted to ensure certain intents are always
logged (outside of ops like quotaoff that IIRC uses sync transactions).

3.) What happens to implicit resources like the log reservation and log
vectors associated with the intent items if they are committed in
transactions as normal, but pulled out of the log pipeline "halfway
through?" At a glance it looks like reservation could just remain
associated with the CIL context, but we might need to do something to
clean up log vectors.

> i.e. can we cull in-memory intents from the CIL as soon as the
> intent done is committed in memory to the CIL?
> 
> Given that everything that the intent is supposed to replay is
> committed to the same CIL context, I don't see why the intent and
> the intent done actually need to be written to the log. If they are
> written to the log, then all that will happen is log recovery will
> read, process and cancel them as there is nothing to replay....
> 

The question to me is just how to implement it properly. The current
done item implementation(s) look like we act on the log completion event
of the done item, so we should expect to find the associated intent in
the AIL by that point. I suppose we could leave the intent items as is
and then wire up the ->iop_committing() for the done items. The latter
could check for CIL residency of the intent, remove both if found, or
otherwise fall back to the current logic. Hm?

Brian


> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

