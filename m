Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:37977 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932282AbeEWKoQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 May 2018 06:44:16 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAPaz=E+=aVagu2g3ZUiD-SjvnAAU0zb0SSaPKUitHT9CWuKW8A@mail.gmail.com>
References: <CAPaz=E+=aVagu2g3ZUiD-SjvnAAU0zb0SSaPKUitHT9CWuKW8A@mail.gmail.com>
From: Filipe Manana <fdmanana@gmail.com>
Date: Wed, 23 May 2018 11:44:14 +0100
Message-ID: <CAL3q7H7n9cTZyhdbvfLUXZ7u7W7ed5FLXBQBEQyTE9SrUWK3tw@mail.gmail.com>
Subject: Re: Strange behavior (possible bugs) in btrfs
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Vijay Chidambaram <vvijay03@gmail.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, Soujanya Ponnapalli <soujanyap95@gmail.com>, Jayashree Mohan <jayashree2912@gmail.com>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>

On Mon, Apr 30, 2018 at 5:04 PM, Vijay Chidambaram <vvijay03@gmail.com> wro=
te:
> Hi,
>
> We found two more cases where the btrfs behavior is a little strange.
> In one case, an fsync-ed file goes missing after a crash. In the
> other, a renamed file shows up in both directories after a crash.
>
> Workload 1:
>
> mkdir A
> mkdir B
> mkdir A/C
> creat B/foo
> fsync B/foo
> link B/foo A/C/foo
> fsync A
> -- crash --
>
> Expected state after recovery:
> B B/foo A A/C exist

Why don't you expect A/C/foo as well? I would expect it to be persisted.
With xfs we don't get A/C/foo persisted, but it's persisted with ext4 and f=
2fs.

Adding xfs folks in cc to confirm the expected behaviour.

>
> What we find:
> Only B B/foo exist
>
> A is lost even after explicit fsync to A.
>
> Workload 2:
>
> mkdir A
> mkdir A/C
> rename A/C B
> touch B/bar
> fsync B/bar
> rename B/bar A/bar
> rename A B (replacing B with A at this point)
> fsync B/bar
> -- crash --
>
> Expected contents after recovery:
> A/bar
>
> What we find after recovery:
> A/bar
> B/bar
>
> We think this breaks rename's atomicity guarantee. bar should be
> present in either A or B, but now it is present in both.
>
> Thanks,
> Vijay
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
