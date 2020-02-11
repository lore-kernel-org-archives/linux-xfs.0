Return-Path: <SRS0=3qtu=37=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD131C352A3
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 12:55:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A27B720675
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Feb 2020 12:55:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S852iwOP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgBKMzM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Feb 2020 07:55:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25241 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728266AbgBKMzM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Feb 2020 07:55:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581425710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aynTrMRw5bpcHy69MG4Vbgad9XuWaOm027mCPExcPnE=;
        b=S852iwOPEO6pHG1V/pa3M+UAiMCkdEWyKPBcMShUG+7eLBI7Mm/lCHGDOk5JmHv4lj4Ia+
        O6ND/UAZhT54TZTjYDzHuOJWyFL6QKeEq4AvfcVo/a4LiyEC1XuEKsKtIeuk1SRxDFfjxl
        J9S2W/4juP24Ons/G4uwRBFjBQ8HA20=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-340-NcGbmWESNBG33KFjcSyVEg-1; Tue, 11 Feb 2020 07:55:08 -0500
X-MC-Unique: NcGbmWESNBG33KFjcSyVEg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E67181005516;
        Tue, 11 Feb 2020 12:55:06 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C8715D9E2;
        Tue, 11 Feb 2020 12:55:06 +0000 (UTC)
Date:   Tue, 11 Feb 2020 07:55:04 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Aaron Sierra <asierra@xes-inc.com>,
        Vincent Fazio <vfazio@xes-inc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: fallback to readonly during recovery
Message-ID: <20200211125504.GA2951@bfoster>
References: <20200210211037.1930-1-vfazio@xes-inc.com>
 <99259ceb-2d0d-1054-4335-017f1854ba14@sandeen.net>
 <829353330.403167.1581373892759.JavaMail.zimbra@xes-inc.com>
 <400031d2-dbcb-a0de-338d-9a11f97c795c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <400031d2-dbcb-a0de-338d-9a11f97c795c@sandeen.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 10, 2020 at 05:40:03PM -0600, Eric Sandeen wrote:
> On 2/10/20 4:31 PM, Aaron Sierra wrote:
> >> From: "Eric Sandeen" <sandeen@sandeen.net>
> >> Sent: Monday, February 10, 2020 3:43:50 PM
> >=20
> >> On 2/10/20 3:10 PM, Vincent Fazio wrote:
> >>> Previously, XFS would fail to mount if there was an error during lo=
g
> >>> recovery. This can occur as a result of inevitable I/O errors when
> >>> trying to apply the log on read-only ATA devices since the ATA laye=
r
> >>> does not support reporting a device as read-only.
> >>>
> >>> Now, if there's an error during log recovery, fall back to norecove=
ry
> >>> mode and mark the filesystem as read-only in the XFS and VFS layers=
.
> >>>
> >>> This roughly approximates the 'errors=3Dremount-ro' mount option in=
 ext4
> >>> but is implicit and the scope only covers errors during log recover=
y.
> >>> Since XFS is the default filesystem for some distributions, this ch=
ange
> >>> allows users to continue to use XFS on these read-only ATA devices.
> >>
> >> What is the workload or scenario where you need this behavior?
> >>
> >> I'm not a big fan of ~silently mounting a filesystem with latent err=
ors,
> >> tbh, but maybe you can explain a bit more about the problem you're s=
olving
> >> here?
> >=20
> > Hi Eric,
> >=20
> > We use SSDs from multiple vendors that can be configured at power-on =
(via
> > GPIO) to be read-write or write-protected. When write-protected we ge=
t I/O
> > errors for any writes that reach the device. We believe that behavior=
 is
> > correct.
> >=20
> > We have found that XFS fails during log recovery even when the log is=
 clean
> > (apparently due to metadata writes immediately before actual recovery=
).
>=20
> There should be no log recovery if it's clean ...
>=20
> And I don't see that here - a clean log on a readonly device simply mou=
nts
> RO for me by default, with no muss, no fuss.
>=20
> # mkfs.xfs -f fsfile
> ...
> # losetup /dev/loop0 fsfile
> # mount /dev/loop0 mnt
> # touch mnt/blah
> # umount mnt
> # blockdev --setro /dev/loop0
> # dd if=3D/dev/zero of=3D/dev/loop0 bs=3D4k count=3D1
> dd: error writing =E2=80=98/dev/loop0=E2=80=99: Operation not permitted
> # mount /dev/loop0 mnt
> mount: /dev/loop0 is write-protected, mounting read-only
> # dmesg
> [  419.941649] /dev/loop0: Can't open blockdev
> [  419.947106] XFS (loop0): Mounting V5 Filesystem
> [  419.952895] XFS (loop0): Ending clean mount
> # uname -r
> 5.5.0
>=20
> > Vincent and I believe that mounting read-only without recovery should=
 be
> > fine even when the log is not clean, since the filesystem will be con=
sistent,
> > even if out-of-date.
>=20
> I think that you may be making too many assumptions here, i.e. that "lo=
g
> recovery failure leaves the filesystem in a consistent state" - and tha=
t
> may not be true in all cases.
>=20
> IOWS, transitioning to a new RO state for your particular case may be s=
afe,
> but I'm not sure that's universally true for all log replay failures.
>=20

Agreed. Just to double down on this bit, this is definitely a misguided
assumption. Generally speaking, XFS logging places ordering rules on
metadata writes to the filesystem such that we can guarantee we can
always recover to a consistent point after a crash. By skipping recovery
of a dirty log, you are actively bypassing that mechanism.

For example, if a filesystem transaction modifies several objects, those
objects are logged in a transaction and committed to the physical log.
Once the transaction is committed to the physical log, the individual
objects are free to be written back in any arbitrary order because of
the transactional guarantee that log recovery provides. So nothing
prevents one object from being written back while another is reused (and
re-pinned) before a crash that leaves the filesystem in a corrupted
state. Log recovery is required to update the associated metadata
objects and make the fs consistent again.

In short, it's probably safer to assume any filesystem mounted with a
dirty log and norecovery is in fact corrupted as opposed to the other
way around.

Brian

> > Our customers' use often requires nonvolatile memory to be write-prot=
ected
> > or not based on the device being installed in a development or deploy=
ed
> > system. It is ideal for them to be able to mount their filesystems re=
ad-
> > write when possible and read-only when not without having to alter mo=
unt
> > options.
>=20
> From my example above, I'd like to understand more why/how you have a
> clean log that fails to mount by default on a readonly block device...
> in my testing, no writes get sent to the device when mounting a clean
> log.
>=20
> -Eric
>=20

