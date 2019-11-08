Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCAACFA372C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 11:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3B78222CE
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 11:48:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="It2/YBhP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732882AbfKHLsr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:48:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36060 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403860AbfKHLsq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 06:48:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573213725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y6PLFXcv3/y916sTlLIonQUOjQAP6FIAh/asvrcXC6g=;
        b=It2/YBhPn3wtSnp9IEqjhfLHAPq1mvUdypoxeIrsCZXz0hgRFYBGbAmB3uO3dG1B8e7L6S
        NgO6RHX7OxwY3SD7Rv3FVGQORw8PP579h4PAK6xYazPWKtgPbyB+Dj5pTivyxDvOeu6vHt
        PIY42/tXdIL9LyfCrJHKWJyCcDI3Cns=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-357-Eb-a8K-tOoqy8xth0a6xcA-1; Fri, 08 Nov 2019 06:48:41 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB628800C72;
        Fri,  8 Nov 2019 11:48:40 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 03282272A7;
        Fri,  8 Nov 2019 11:48:39 +0000 (UTC)
Date:   Fri, 8 Nov 2019 06:48:38 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        kaixuxia <xiakaixu1987@gmail.com>, linux-xfs@vger.kernel.org,
        newtongao@tencent.com, jasperwang@tencent.com
Subject: Re: [PATCH v2] xfs: Fix deadlock between AGI and AGF when target_ip
 exists in xfs_rename()
Message-ID: <20191108114838.GA24009@bfoster>
References: <1572947532-4972-1-git-send-email-kaixuxia@tencent.com>
 <20191106045630.GO15221@magnolia>
 <20191106124932.GA37080@bfoster>
 <20191106154612.GH4153244@magnolia>
 <20191107034621.GG4614@dread.disaster.area>
MIME-Version: 1.0
In-Reply-To: <20191107034621.GG4614@dread.disaster.area>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: Eb-a8K-tOoqy8xth0a6xcA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 07, 2019 at 02:46:21PM +1100, Dave Chinner wrote:
> On Wed, Nov 06, 2019 at 07:46:12AM -0800, Darrick J. Wong wrote:
> > On Wed, Nov 06, 2019 at 07:49:32AM -0500, Brian Foster wrote:
> > > > >  /*
> > > > > + * Check whether the replace operation need more blocks.
> > > > > + */
> > > > > +bool
> > > > > +xfs_dir2_sf_replace_needblock(
> > > >=20
> > > > Urgggh.  This is a predicate that we only ever call from xfs_rename=
(),
> > > > right?  And it addresses a particular quirk of the locking when the
> > > > caller wants us to rename on top of an existing entry and drop the =
link
> > > > count of the old inode, right?  So why can't this just be a predica=
te in
> > > > xfs_inode.c ?  Nobody else needs to know this particular piece of
> > > > information, AFAICT.
> > > >=20
> > > > (Apologies, for Brian and I clearly aren't on the same page about
> > > > that...)
> > > >=20
> > >=20
> > > Hmm.. the crux of my feedback on the previous version was simply that=
 if
> > > we wanted to take this approach of pulling up lower level dir logic i=
nto
> > > the higher level rename code, to simply factor out the existing check=
s
> > > down in the dir replace code that currently trigger a format conversi=
on,
> > > and use that new helper in both places. That doesn't appear to be wha=
t
> > > this patch does, and I'm not sure why there are now two new helpers t=
hat
> > > each only have one caller instead of one new helper with two callers.=
..
> >=20
> > Aha, got it.  I'd wondered if that had been your intent. :)
>=20
> So as a structural question: should this be folded into
> xfs_dir_canenter(), which is the function used to check if the
> directory modification can go ahead without allocating blocks....
>=20
> This seems very much like it is a "do we need to allocate blocks
> during the directory modification?" sort of question being asked
> here...
>=20

I _think_ Kaixu brought this up briefly in looking at the previous
version of this patch. From a code standpoint, I agree that this path
seems like the most logical fit, but my understanding was that the
canenter thing is kind of an inconsistent and unreliable mechanism at
this point. IIRC, we've explicitly removed its use from the create path
to work around things like block reservation overruns leading to fs
shutdowns as opposed to digging into the mechanism and fixing whatever
accounting was broken. See commit f59cf5c299 ("xfs: remove
"no-allocation" reservations for file creations"), for example. I
believe the discussion around that patch basically concluded that the
complexity of maintaining/debugging the canenter path wasn't worth the
benefit of squeezing every last block out of the fs, but that was a
while ago now.

That aside, I don't have a strong opinion on the best way to fix this
particular deadlock problem. The only other thing (outside of
reliability) I might question with the canenter approach is whether it
has ever been used in situations outside of -ENOSPC, and if not, whether
there's any potential performance impact of invoking it more frequently.

Brian

> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com

