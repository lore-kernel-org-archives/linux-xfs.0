Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A111A7FD1
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 11:52:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D1F830406B
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 09:52:04 -0700 (PDT)
Received: from mail-bk0-f53.google.com (mail-bk0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id u2LYoL4IboLUbMqX
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 08 Apr 2014 09:52:03 -0700 (PDT)
Received: by mail-bk0-f53.google.com with SMTP id r7so776557bkg.26
	for <xfs@oss.sgi.com>; Tue, 08 Apr 2014 09:52:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396971770-23553-2-git-send-email-lczerner@redhat.com>
References: <20140404211224.GX17603@dastard>
	<1396971770-23553-1-git-send-email-lczerner@redhat.com>
	<1396971770-23553-2-git-send-email-lczerner@redhat.com>
Date: Tue, 8 Apr 2014 17:52:01 +0100
Message-ID: <CAL3q7H6eLTiWYHwAXpV6Vx77PcZaGo1cSHYqC0u=w-fywsLpVw@mail.gmail.com>
Subject: Re: [PATCH 2/3] xfstests: Unset SCRATCH_DEV when deduced from
	SCRATCH_DEV_POOL
From: Filipe David Manana <fdmanana@gmail.com>
Reply-To: fdmanana@gmail.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Apr 8, 2014 at 4:42 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> In the case that we already have sections in the config file we
> have to make sure that we unset SCRATCH_DEV if it has been deduced from
> the SCRATCH_DEV_POOL so that it does not complain about SCRATCH_DEV in
> this case.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Tested-by: Filipe David Manana <fdmanana@gmail.com>

Tests working for btrfs now.
Thanks Lukas.

> ---
>  common/config | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/common/config b/common/config
> index 6fa18e2..3163801 100644
> --- a/common/config
> +++ b/common/config
> @@ -372,10 +372,15 @@ get_next_config() {
>         unset MOUNT_OPTIONS
>         unset MKFS_OPTIONS
>         unset FSCK_OPTIONS
> +       # We might have deduced SCRATCH_DEV from the SCRATCH_DEV_POOL in the previous
> +       # run, so we have to unset it now.
> +       if [ "$SCRATCH_DEV_NOT_SET" == "true" ]; then
> +               unset SCRATCH_DEV
> +       fi
>
>         parse_config_section $1
>
> -       if [ -n "$OLD_FSTYP" ] && [ $OLD_FSTYP != $FSTYP ]; then
> +       if [ ! -z "$OLD_FSTYP" ] && [ $OLD_FSTYP != $FSTYP ]; then
>                 [ -z "$MOUNT_OPTIONS" ] && _mount_opts
>                 [ -z "$MKFS_OPTIONS" ] && _mkfs_opts
>                 [ -z "$FSCK_OPTIONS" ] && _fsck_opts
> @@ -423,6 +428,7 @@ get_next_config() {
>                 fi
>                 SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
>                 export SCRATCH_DEV
> +               export SCRATCH_DEV_NOT_SET=true
>         fi
>
>         echo $SCRATCH_DEV | grep -q ":" > /dev/null 2>&1
> --
> 1.8.3.1
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
