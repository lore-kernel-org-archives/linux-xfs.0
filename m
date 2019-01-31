Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lj1-f174.google.com ([209.85.208.174]:35990 "EHLO
        mail-lj1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727381AbfAaUZW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 15:25:22 -0500
Received: by mail-lj1-f174.google.com with SMTP id g11-v6so3859679ljk.3
        for <linux-xfs@vger.kernel.org>; Thu, 31 Jan 2019 12:25:21 -0800 (PST)
MIME-Version: 1.0
References: <CAOQ4uxgqm-m1Zj073o_vSnwkTbGObJiQ-CdWV2ESd_P-29=jZw@mail.gmail.com>
 <20190128125044.GC27972@quack2.suse.cz> <20190128212642.GQ4205@dastard>
 <CAOQ4uxgUDoSc_nVrLM1An_tH_0NMVonA8npJLBbi0ibD+mwnMw@mail.gmail.com>
 <20190129001826.GV4205@dastard> <CAOQ4uxiNe8i6YZ3dQvsW_fDNoPj5HPyY5ve93wXChmqAC10B4w@mail.gmail.com>
 <20190129230129.GD4205@dastard> <CAOQ4uxifnvHnM-i7LnHx6a9s9msx_=X_RweRxXu9US0_NEK2Hw@mail.gmail.com>
In-Reply-To: <CAOQ4uxifnvHnM-i7LnHx6a9s9msx_=X_RweRxXu9US0_NEK2Hw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 31 Jan 2019 13:25:08 -0700
Message-ID: <CAJCQCtSDsbA9ih_pBokCeG1Jkg-EFz8QxpjnQU08BOjk5oqT4w@mail.gmail.com>
Subject: Re: [LSF/MM TOPIC] Lazy file reflink
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Jan 30, 2019 at 6:30 AM Amir Goldstein <amir73il@gmail.com> wrote:

> generic_remap_file_range_prep() does not require that source
> file is not immutable. Does XFS? I don't know if "immutable"
> has ever been defined w.r.t file layout on disk. has it?
> I recon btrfs re-balancing would not stop at migrating "immutable"
> file blocks would it?

chattr +i does not pin the file to a particular physical location on a
device or even on a particular device, at least on Btrfs. A balance
operation, including device replace, or device add+remove, or changing
the raid profile, isn't inhibited - such operations happen at the
block group level, somewhat similar to LVM pvmove.

A directory containing an immutable file cannot be deleted until
immutable flag is unset; but a subvolume containing an immutable file
is deleted without complaint when using 'btrfs sub del'. I'm pretty
sure that's expected. Further, looks like now 'rmdir' and 'rm -rf'
will remove a subvolume; but in the case of it containing an immutable
file, 'rm -rf' fails just as if it were a directory even though 'btrfs
sub del' succeeds.

--
Chris Murphy
