Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33073 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfEGMBb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 May 2019 08:01:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id e11so8909524wrs.0
        for <linux-xfs@vger.kernel.org>; Tue, 07 May 2019 05:01:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190506115212.9876-1-jtulak@redhat.com> <20190506131418.GA48302@bfoster>
 <206e3aba-2b44-bbda-502b-53d70ed27a4d@sandeen.net>
In-Reply-To: <206e3aba-2b44-bbda-502b-53d70ed27a4d@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Tue, 7 May 2019 14:01:18 +0200
Message-ID: <CACj3i722N2hOa-xQXgO__YQ+af-xXeN86rua3oC_2XqRBtt_Ow@mail.gmail.com>
Subject: Re: [PATCH] xfsdump: (style) remove spaces in front of commas/semicolons
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Mon, May 6, 2019 at 8:19 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 5/6/19 8:14 AM, Brian Foster wrote:
> > On Mon, May 06, 2019 at 01:52:12PM +0200, Jan Tulak wrote:
> >> diff --git a/common/drive.c b/common/drive.c
> >> index b01b916..a3514a9 100644
> >> --- a/common/drive.c
> >> +++ b/common/drive.c
> > ...
> >> @@ -3088,7 +3088,7 @@ prepare_drive(drive_t *drivep)
> >>       * if not present or write-protected during dump, return.
> >>       */
> >>      maxtries = 15;
> >> -    for (try = 1 ; ; sleep(10), try++) {
> >> +    for (try = 1;; sleep(10), try++) {
> >
> > FWIW, I think the spaces actually make sense in contexts like the above
> > where we've intentionally left a statement empty. Without the space this
> > kind of looks like a double semicolon, which is slightly misleading at a
> > glance.
>
> Haha, yikes, how DOES one make this prettier w/o just killing it
> with fire? ;)
>
> -Eric

TBH, I thought about rewriting it. But then I realised how deep that
rabbit hole leads... So I'm sticking with formatting changes for now.

Jan

--
Jan Tulak
