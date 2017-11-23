Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33045 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751984AbdKWIci (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Nov 2017 03:32:38 -0500
MIME-Version: 1.0
In-Reply-To: <20171114123310.25286-4-eguan@redhat.com>
References: <20171114123310.25286-1-eguan@redhat.com> <20171114123310.25286-4-eguan@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 23 Nov 2017 10:32:36 +0200
Message-ID: <CAOQ4uxhNqNEX5V3EFiYpYFAHdLEs+-0ut3DTpA2QBw-YvoCE0Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] fstests: filter readonly mount error messages
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Nov 14, 2017 at 2:33 PM, Eryu Guan <eguan@redhat.com> wrote:
> util-linux commit 6dede2f2f7c5 ("libmount: support MS_RDONLY on
> write-protected devices") changed the error message on read-only
> block device, and in the failure case printed one line message
> instead of two (for details please see comments in common/filter),
> and this change broke generic/050 and overlay/035.
>
> Fix it by adding more filter rules to _filter_ro_mount and updating
> associated .out files to unify the output from both old and new
> util-linux versions.
>
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  common/filter         | 35 ++++++++++++++++++++++++++++++++++-
>  tests/generic/050     |  8 ++++----
>  tests/generic/050.out |  8 ++++----
>  tests/overlay/035     |  9 +++++++--
>  4 files changed, 49 insertions(+), 11 deletions(-)
>
> diff --git a/common/filter b/common/filter
> index b1cd558ab0e1..357c4c9357c3 100644
> --- a/common/filter
> +++ b/common/filter
> @@ -399,9 +399,42 @@ _filter_ending_dot()
>
>  # Older mount output referred to "block device" when mounting RO devices
>  # It's gone in newer versions
> +#
> +# And util-linux v2.30 changed the output again, e.g.
> +# for a successful ro mount:
> +# prior to v2.30:  mount: <device> is write-protected, mounting read-only
> +# v2.30 and later: mount: <mountpoint>: WARNING: device write-protected, mounted read-only.
> +#
> +# a failed ro mount:
> +# prior to v2.30:
> +# mount: <device> is write-protected, mounting read-only
> +# mount: cannot mount <device> read-only
> +# v2.30 and later:
> +# mount: <mountpoint>: cannot mount <device> read-only.
> +#
> +# a failed rw remount:
> +# prior to v2.30:  mount: cannot remount <device> read-write, is write-protected
> +# v2.30 and later: mount: <mountpoint>: cannot remount <device> read-write, is write-protected.
> +#
> +# Now use _filter_ro_mount to unify all these differences across old & new
> +# util-linux versions.

Please document the unified filter result as you did with _filter_busy_mount

>  _filter_ro_mount() {
>         sed -e "s/mount: block device/mount:/g" \
> -           -e "s/mount: cannot mount block device/mount: cannot mount/g"
> +           -e "s/mount: cannot mount block device/mount: cannot mount/g" | \

Let's convert all new error formats to this legacy format, so we don't need
this extra sed to convert the legacy format to an xfstest invented format.

Besides, this filter is making an effort to preserve the <device> variable
and for what? for having to add _filter_scratch after it and covert <device>
to SCRATCH_DEV?
Better to let this filter already replace <device> with "block device" and do
away with the need to _filter_scratch.

> +       _filter_ending_dot | \
> +       perl -ne '
> +       if (/write-protected, mount.*read-only/) {
> +               print "mount: device write-protected, mounting read-only\n";
> +       } elsif (/mount: .*: cannot mount.*read-only/) {
> +               print "mount: device write-protected, mounting read-only\n";
> +               print "mount: cannot mount read-only\n";
> +       } elsif (/mount: .*: cannot remount (.*) read-write.*/) {
> +               print "mount: cannot remount $1 read-write, is write-protected\n";
> +       } elsif (/(^mount: cannot mount) .* (read-only$)/) {
> +               print "$1 $2\n";
> +       } else {
> +               print "$_";
> +       }'
>  }
>
[...]
> --- a/tests/overlay/035
> +++ b/tests/overlay/035
> @@ -45,6 +45,11 @@ _cleanup()
>  . ./common/rc
>  . ./common/filter
>
> +filter_mount()
> +{
> +       _filter_scratch | _filter_ro_mount
> +}

_filter_scratch not needed. helper not needed.

Amir.
