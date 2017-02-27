Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36288 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751711AbdB0LXZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Feb 2017 06:23:25 -0500
Received: by mail-io0-f177.google.com with SMTP id l7so16200435ioe.3
        for <linux-xfs@vger.kernel.org>; Mon, 27 Feb 2017 03:23:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <004e01d2909e$d9ce1580$8d6a4080$@gmail.com>
References: <004e01d2909e$d9ce1580$8d6a4080$@gmail.com>
From: Stefan Ring <stefanrin@gmail.com>
Date: Mon, 27 Feb 2017 12:23:23 +0100
Message-ID: <CAAxjCEy0gGWS7FqxezRgAofD=Ou1bXypBzizi_nvxiAqX6=18Q@mail.gmail.com>
Subject: Re: With respect to XFS Bitmap flush to disk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Mon, Feb 27, 2017 at 3:11 AM, Halsey Pian <halsey.pian@gmail.com> wrote:
>
> I tried several solution, and find it out that I must execute xfs_freeze =
for the XFS partition in CentOS7, and it seems that xfs_freeze doesn=E2=80=
=99t work for XFS version included in Redhat6.5, I must umount/mount the xf=
s, then I can get the latest bitmap info related to the latest data located=
 in disk.

Why do you think that xfs_freeze does not work on el6?
