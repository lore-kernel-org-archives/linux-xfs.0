Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:37866 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753522AbdCTJl2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Mar 2017 05:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <20170316193540.CF2E5660939@gitolite.kernel.org>
References: <20170316193540.CF2E5660939@gitolite.kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 20 Mar 2017 10:41:16 +0100
Message-ID: <CAMuHMdVpE2efAMNZzPs37jVnCWJz-jQqGPEhVx+8VFUNg+4yTg@mail.gmail.com>
Subject: Re: xfs: verify inline directory data forks
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Thu, Mar 16, 2017 at 8:35 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Web:        https://git.kernel.org/torvalds/c/630a04e79dd41ff746b545d4fc0=
52e0abb836120
> Commit:     630a04e79dd41ff746b545d4fc052e0abb836120
> Parent:     2fcc319d2467a5f5b78f35f79fd6e22741a31b1e
> Refname:    refs/heads/master
> Author:     Darrick J. Wong <darrick.wong@oracle.com>
> AuthorDate: Wed Mar 15 00:24:25 2017 -0700
> Committer:  Darrick J. Wong <darrick.wong@oracle.com>
> CommitDate: Wed Mar 15 00:24:25 2017 -0700
>
>     xfs: verify inline directory data forks
>
>     When we're reading or writing the data fork of an inline directory,
>     check the contents to make sure we're not overflowing buffers or eati=
ng
>     garbage data.  xfs/348 corrupts an inline symlink into an inline
>     directory, triggering a buffer overflow bug.
>
>     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>     Reviewed-by: Brian Foster <bfoster@redhat.com>

> --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> +++ b/fs/xfs/libxfs/xfs_dir2_sf.c

> +/* Verify the consistency of an inline directory. */
> +int
> +xfs_dir2_sf_verify(
> +       struct xfs_mount                *mp,
> +       struct xfs_dir2_sf_hdr          *sfp,
> +       int                             size)
> +{

> +               /* Don't allow names with known bad length. */
> +               XFS_WANT_CORRUPTED_RETURN(mp, sfep->namelen > 0);
> +               XFS_WANT_CORRUPTED_RETURN(mp, sfep->namelen < MAXNAMELEN)=
;

With gcc 4.1.2:

fs/xfs/libxfs/xfs_dir2_sf.c: In function =E2=80=98xfs_dir2_sf_verify=E2=80=
=99:
fs/xfs/libxfs/xfs_dir2_sf.c:680: warning: comparison is always true
due to limited range of data type

As sfep->namelen is __u8, and MAXNAMELEN =3D 256, none of the two checks
above can be true.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
