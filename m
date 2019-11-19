Return-Path: <SRS0=NxuP=ZL=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1563C432C0
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 13:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84EA9222DF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Nov 2019 13:55:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dK8GcTpZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfKSNzC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 08:55:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25429 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725904AbfKSNzB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Nov 2019 08:55:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574171700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xMZrU4Iyr3pDepWLu58bcmyclyUr4D2AccbVWerNr/4=;
        b=dK8GcTpZH/ciEXz55kJM/bvsdB9Qph4CTiXzciLjklkSKYP5Vq9u9amZs6dtiMemSo7fep
        DAGvY9I73AsjlqJCCnq+Kq/swH6bcrsNWxiLT8Q4TWHYQTczd6ucpuLXzGz9z6b/RHIKH6
        v4s0egQfvhCVqm8Dsj+T+wR76CNRN1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-adaEmDNmPiShltajBCj4BQ-1; Tue, 19 Nov 2019 08:54:57 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3ED1E800686;
        Tue, 19 Nov 2019 13:54:56 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B9E2910375CE;
        Tue, 19 Nov 2019 13:54:55 +0000 (UTC)
Date:   Tue, 19 Nov 2019 08:54:55 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Patrick Rynhart <patrick@rynhart.co.nz>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: Inflight Corruption of XFS filesystem on CentOS 7.7 VMs
Message-ID: <20191119135455.GB10763@bfoster>
References: <CAMbe+5D9cSEpR2YTWTmigi77caw93p6qR-iAYf-X_3_OJQMROw@mail.gmail.com>
 <80429a04-4b19-ec4a-1255-67b15c7b01f5@sandeen.net>
 <CAMbe+5A9OtVodSeiDo10ufAAT4Wn50yH0FjgdO_5_ax3dLvyCw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAMbe+5A9OtVodSeiDo10ufAAT4Wn50yH0FjgdO_5_ax3dLvyCw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: adaEmDNmPiShltajBCj4BQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Nov 16, 2019 at 06:51:41PM +1300, Patrick Rynhart wrote:
> On Sat, 16 Nov 2019 at 18:29, Eric Sandeen <sandeen@sandeen.net> wrote:
> >
> > On 11/15/19 9:33 PM, Patrick Rynhart wrote:
> > > Hi all,
> > >
> > > A small number of our CentOS VMs (about 4 out of a fleet of 200) are
> > > experiencing ongoing, regular XFS corruption - and I'm not sure how t=
o
> > > troubleshoot the problem.  They are all CentOS 7.7 VMs are are using
> > > VMWare Paravirtual SCSI.  The version of xfsprogs being used is
> > > 4.5.0-20.el7.x86_64, and the kernel is 3.10.0-1062.1.2.el7.x86_64.
> > > The VMWare version is ESXi, 6.5.0, 14320405.
> > >
> > > When the fault happens - the VMs will go into single user mode with
> > > the following text displayed on the console:
> > >
> > > sd 0:0:0:0: [sda] Assuming drive cache: write through
> > > XFS (dm-0): Internal error XFS_WANT_CORRUPTED_GOTO at line 1664 of
> > > file fs/xfs/libxfs
> > > /xfs_alloc.c. Caller xfs_free_extent+0xaa/0x140 [xfs]
> > > XFS (dm-0): Internal error xfs_trans_cancel at line 984 of file
> > > fs/xfs/xfs_trans.c.
> > > Caller xfs_efi_recover+0x17d/0x1a0 [xfs]
> > > XFS (dm-0): Corruption of in-memory data detected. Shutting down file=
system
> > > XFS (dm-0): Please umount the filesystem and rectify the problem(s)
> > > XFS (dm-0): Failed to recover intents
> >
> > Seems like this is not the whole relevant log; "Failed to recover inten=
ts"
> > indicates it was in log replay but we don't see that starting.  Did you
> > cut out other interesting bits?
>=20
> Thank you for the reply.  When the problem happens the system ends up
> in the EL7 dracut emergency shell.  Here's a picture of what the
> console looks like right now (I haven't rebooted yet):
>=20
> https://pasteboard.co/IGUpPiN.png
>=20
> How can I get some debug information re the (attempted ?) log replay
> for debug / analysis ?
>=20

At this point I'm not sure there's a ton to gain from recovery analysis.
The filesystem shows free space corruption where on log recovery, it is
attempting to free some space that is already marked free. The
corruption occurred some time in the past and recovery is just the first
place we detect it and can fail. What we really want to find out is how
this corruption is introduced in the first place. That may not be
trivial, but it might be possible with instrumentation or custom debug
code if you can reproduce this reliably enough and are willing to go
that route. When you say 4 out of 200 VMs show this problem, is it
consistently the same set of VMs or is that just the rate of failure of
random guests out of the 200?

Logistical questions aside, I think the first technical question to
answer is why are you in recovery in the first place? We'd want to know
that because that could rule out a logging/recovery problem vs. a
runtime bug introducing the corruption. Recovery should only be required
after a crash or unclean shutdown. Do you know what kind of event caused
the unclean shutdown? Did you see a runtime crash and filesystem
shutdown with a similar corruption report as shown here, or was it an
unrelated event? Please post system log output if you happen to have a
record of an instance of the former. If there is such a corruption
report, an xfs_metadump of the filesystem might also be useful to look
at before you run xfs_repair.

Brian

> > -Eric
>=20

