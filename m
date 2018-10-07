Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf1-f47.google.com ([209.85.167.47]:36276 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbeJGQuK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Oct 2018 12:50:10 -0400
Received: by mail-lf1-f47.google.com with SMTP id d4-v6so12025376lfa.3
        for <linux-xfs@vger.kernel.org>; Sun, 07 Oct 2018 02:43:26 -0700 (PDT)
MIME-Version: 1.0
References: <20181004205749.2042-1-stefanrin@gmail.com> <20181004205749.2042-2-stefanrin@gmail.com>
 <CAAxjCEw0prn7P3dn-OuuxbmMTgzs2HydpZsgkwH8RVBkedQXOA@mail.gmail.com> <20181005204057.GB19324@magnolia>
In-Reply-To: <20181005204057.GB19324@magnolia>
From: Stefan Ring <stefanrin@gmail.com>
Date: Sun, 7 Oct 2018 11:43:16 +0200
Message-ID: <CAAxjCEzGykBJLp7mssn7f3MJoS3nx6DmsXSuiNn+T7qGSYPk4w@mail.gmail.com>
Subject: Re: [PATCH 1/1] xfs_metadump: Zap more stale data
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Fri, Oct 5, 2018 at 10:41 PM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > I forgot to mention this: sb_blocksize is used conspicuously rarely in
> > this file. Is this the right metric to lean on?
>
> No, because directory blocks span multiple fs blocks (good self catch!).
>
> You could look it up in the directory geometry structure in the
> xfs_mount *.

Interestingly my file system has dirblklog = 0. I guess I'll have to
start creating some toy file system images for experimentation.
