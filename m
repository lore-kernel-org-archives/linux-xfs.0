Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:41559 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752214AbeCMOdR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Mar 2018 10:33:17 -0400
Received: by mail-yw0-f196.google.com with SMTP id w12so7954027ywa.8
        for <linux-xfs@vger.kernel.org>; Tue, 13 Mar 2018 07:33:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180313131109.GB6260@lst.de>
References: <CAOQ4uxgVaGgwio=538-PP4QuRbcny6q0_CAeV-9bQEWBaxv2gA@mail.gmail.com>
 <20180129155054.GJ9359@magnolia> <CAOQ4uxjMfZGMtbq2vRN8dL5QvgC0=UD-yWDbNib=dckDTFR0Nw@mail.gmail.com>
 <20180201003511.GK4849@magnolia> <CAOQ4uxjE31j7XDpEGnnym7cgD_kqsPnio4KN2gphajsCNMrG1g@mail.gmail.com>
 <20180311162442.GB2013@kroah.com> <20180312162744.GB4865@magnolia>
 <CAOQ4uxjn8UN2-Hzr8u404ydKf8s41yVpMA93-n7r6Dr2VBz3dA@mail.gmail.com>
 <CAOQ4uxhdkhZup=ndukKCRtU13YVs8jQxT0zgOT_XN3_-tB8TfQ@mail.gmail.com>
 <CAOQ4uxhCjBA99X_C-GpEBf=jC4S_wSrxMwS6Ovj7BtWLK1GmUA@mail.gmail.com> <20180313131109.GB6260@lst.de>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 13 Mar 2018 16:33:15 +0200
Message-ID: <CAOQ4uxiDHSC19-fRdZmXM5BJB3-p9_LdPgSmxpjGrdCzhV2W2Q@mail.gmail.com>
Subject: Re: [PATCH v2] xfs: preserve i_rdev when recycling a reclaimable inode
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Eryu Guan <eguan@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Mar 13, 2018 at 3:11 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Tue, Mar 13, 2018 at 02:46:09PM +0200, Amir Goldstein wrote:
>> OK, found the patches the fix soft lockups in generic/269 and
>> assertion in generic/232, so expunging those 2 tests from v4.15.y
>> test runs.
>
> Which patches are those?  We should probably backport them to 4.15-stable.

Probably, but I guess Darrick has those in his TODO.

There is this series that refers to failure in generic/232:
https://marc.info/?l=linux-xfs&m=151701545720824&w=2

These 2 commits refer to generic/269 specifically in commit message:
 70c57dcd606f xfs: skip CoW writes past EOF when writeback races with truncate
 be78ff0e7277 xfs: recheck reflink / dirty page status before freeing
CoW reservations
and the thread on the second commit also mentions generic/270
(I found out the hard way that it also soft locks).

But there are surely more patches for stable in master.
I recon CC: stable and/or Fixes: tags could have been helpful,
but I don't see any of those in v4.16-rcX from the core xfs developers.

Cheers,
Amir.
