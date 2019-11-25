Return-Path: <SRS0=T9vs=ZR=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436D3C432C0
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Nov 2019 13:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17F8E20862
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Nov 2019 13:08:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O90O1TeI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfKYNH7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Nov 2019 08:07:59 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53426 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725823AbfKYNH7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Nov 2019 08:07:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574687278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ONTxr3Xcod7C7mcR2DoHYWdDprFx2XO+fd2hOYNdRl0=;
        b=O90O1TeIOyUE6R7A5huIfjIM3cm11yQkqlMJQJoK6S+vyqUB+DiM2zli+Ru915SxNOq5Ey
        9zAiGo3HNXUW6ixiFE6P+mZlfBpdQIq5utND/7Pbtqz1G76D0iPhF7SoLS9kTvRPfrXNbW
        75LQS5NhJMeuCf4eCLdmT65SBH6+aNY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-KrFBd6I4PLekMyHcTuFPsg-1; Mon, 25 Nov 2019 08:07:54 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD4D1107ACE5;
        Mon, 25 Nov 2019 13:07:53 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0F5C55D6AE;
        Mon, 25 Nov 2019 13:07:52 +0000 (UTC)
Date:   Mon, 25 Nov 2019 08:07:52 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Alex Lyakas <alex@zadara.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC-PATCH] xfs: do not update sunit/swidth in the superblock to
 match those provided during mount
Message-ID: <20191125130752.GB44777@bfoster>
References: <1574359699-10191-1-git-send-email-alex@zadara.com>
 <20191122154314.GA31076@bfoster>
 <CAOcd+r3_gKYBv4vtM7nfPEPvkVp-FgHKvgQQx-_zMDt+QZ9z+g@mail.gmail.com>
 <20191124164012.GL6219@magnolia>
 <c807e9fb-3ad9-7110-fd5d-29b07a3d1c66@sandeen.net>
MIME-Version: 1.0
In-Reply-To: <c807e9fb-3ad9-7110-fd5d-29b07a3d1c66@sandeen.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: KrFBd6I4PLekMyHcTuFPsg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Nov 24, 2019 at 11:38:53AM -0600, Eric Sandeen wrote:
> On 11/24/19 10:40 AM, Darrick J. Wong wrote:
> > On Sun, Nov 24, 2019 at 11:13:09AM +0200, Alex Lyakas wrote:
>=20
> ...
>=20
> >>>> With the suggested patch, xfs repair is working properly also when m=
ount-provided sunit/swidth are different.
> >>>>
> >>>> However, I am not sure whether this is the proper approach.
> >>>> Otherwise, should we not allow specifying different sunit/swidth
> >>>> during mount?
> >=20
> > I propose a (somewhat) different solution to this problem:
> >=20
> > Port to libxfs the code that determines where mkfs/repair expect the
> > root inode.  Whenever we want to update the geometry information in the
> > superblock from mount options, we can test the new ones to see if that
> > would cause sb_rootino to change.  If there's no change, we update
> > everything like we do now.  If it would change, either we run with thos=
e
> > parameters incore only (which I think is possible for su/sw?) or refuse
> > them (because corruption is bad).
> >=20
> > This way we don't lose the su/sw updating behavior we have now, and we
> > also gain the ability to shut down an entire class of accidental sb
> > geometry corruptions.
>=20

Indeed, I was thinking about something similar with regard to
validation. ISTM that we either need some form of runtime validation...

> I also wonder if we should be putting so much weight on the root inode
> location in repair, or if we could get away with other consistency checks
> to be sure it's legit, since we've always been able to move the
> "expected" Location.
>=20

... or to fix xfs_repair. ;) Fixing the latter seems ideal to me, but
I'm not sure how involved that is compared to a runtime fix. Clearly the
existing repair check is not a sufficient corruption check on its own.
Perhaps we could validate the inode pointed to by the superblock in
general and if that survives, verify it looks like a root directory..?
The unexpected location thing could still be a (i.e. bad alignment)
warning, but that's probably a separate topic.

I'm not opposed to changing runtime behavior even with a repair fix,
fwiw. I wonder if conditionally updating the superblock is the right
behavior as it might be either too subtle for users or too disruptive if
some appliance out there happens to use a mount cycle to update su/sw.
Failing the mount seems preferable, but raises similar questions wrt to
changing behavior. Yes, it is corruption otherwise, but unless I'm
missing something it seems like a pretty rare corner case (e.g. how many
people change alignment like this? of those that do, how many ever run
xfs_repair?). To me, the ideal behavior is for mount options to always
dictate runtime behavior and for a separate admin tool or script to make
persistent changes (with associated validation) to the superblock.

Brian

