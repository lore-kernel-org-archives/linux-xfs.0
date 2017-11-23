Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:46954 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751643AbdKWI5n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Nov 2017 03:57:43 -0500
MIME-Version: 1.0
In-Reply-To: <20171114123310.25286-3-eguan@redhat.com>
References: <20171114123310.25286-1-eguan@redhat.com> <20171114123310.25286-3-eguan@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 23 Nov 2017 10:57:42 +0200
Message-ID: <CAOQ4uxhHY6QRV-xkY57Nx-Mwms0UPHETB47kP8PgFAXM+Q7t2A@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] overlay/036: filter busy mount message
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Nov 14, 2017 at 2:33 PM, Eryu Guan <eguan@redhat.com> wrote:
> util-linux v2.30 changed error message of a busy mount and caused
> overlay/036 to fail. e.g.
>
>  - mount: <device> is already mounted or <mountpoint> busy
>  + mount: <mountpoint>: <device> already mounted or mount point busy.
>
> Filter the mount output by a newly introduced _filter_busy_mount
> into a unified format.
>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  common/filter         | 12 ++++++++++++
>  tests/overlay/036     |  4 ++--
>  tests/overlay/036.out |  4 ++--
>  3 files changed, 16 insertions(+), 4 deletions(-)
>
> diff --git a/common/filter b/common/filter
> index d1bb94818e3d..b1cd558ab0e1 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -420,6 +420,18 @@ _filter_error_mount()
>         sed -e "s/mount:\(.*failed:\)/mount:/" | _filter_ending_dot
>  }
>
> +# Similar to _filter_error_mount, filter a busy mount output.
> +# Turn both old (prior to util-linux v2.30) and new (v2.30 and later) format to
> +# a simple one. e.g.
> +# old: mount: <device> is already mounted or <mountpoint> busy
> +# new: mount: <mountpoint>: <device> already mounted or mount point busy.
> +# filtered: mount: <device> already mounted or mount point busy
> +_filter_busy_mount()
> +{
> +       sed -e "s/.*: \([^ ]*\).* already mounted.*busy/mount: \1 already mounted or mount point busy/" | \
> +               _filter_ending_dot

Same comment as for romount error. Please canonicalize output to:
"mount: block device already mounted or mount point busy"
so we can do away with _filter_scratch.

_filter_scratch is not needed for overlay/036, but that is not the common case.

And a nit: I would keep the word "or" in the left side.
"already mounted or .*busy" is a nicer expression to read IMO.

Amir.
