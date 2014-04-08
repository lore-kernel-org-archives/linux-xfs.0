Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AEE047FC5
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 11:51:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 22500AC012
	for <xfs@oss.sgi.com>; Tue,  8 Apr 2014 09:51:42 -0700 (PDT)
Received: from mail-bk0-f41.google.com (mail-bk0-f41.google.com
	[209.85.214.41]) by cuda.sgi.com with ESMTP id 6OvpdJP2Z8YOvKXo
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 08 Apr 2014 09:51:39 -0700 (PDT)
Received: by mail-bk0-f41.google.com with SMTP id d7so803566bkh.0
	for <xfs@oss.sgi.com>; Tue, 08 Apr 2014 09:51:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1396971770-23553-1-git-send-email-lczerner@redhat.com>
References: <20140404211224.GX17603@dastard>
	<1396971770-23553-1-git-send-email-lczerner@redhat.com>
Date: Tue, 8 Apr 2014 17:51:38 +0100
Message-ID: <CAL3q7H4J5q9aEN=AsrqoVreDHCs8ygyi9rjHK6K=_uuZmquLgA@mail.gmail.com>
Subject: Re: [PATCH 1/3] xfstests: Fix SCRATCH_DEV_POOL handling
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
> With changes introduced in 667308dd97bf41382d4ab299fa5b56c235cfeb27
> it is no longer possible to use SCRATCH_DEV_POOL variable because of
> error:
>
>  common/config: Error: $SCRATCH_DEV should be unset when
>  $SCRATCH_DEV_POOL is set
>
> This was because get_next_config() would get called twice and hence it
> would complain on the second run that SCRATCH_DEV is already set. Fix
> it by making sure that we call get_next_config() only once if there
> are no sections in the config file.
>
> Also make sure that we export SCRATCH_DEV in the case we're deducing it
> from SCRATCH_DEV_POOL.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Filipe David Manana <fdmanana@gmail.com>

Tested-by: Filipe David Manana <fdmanana@gmail.com>

Tests working for btrfs now.
Thanks Lukas.

> ---
>  common/config | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/common/config b/common/config
> index 4178c27..6fa18e2 100644
> --- a/common/config
> +++ b/common/config
> @@ -360,6 +360,10 @@ parse_config_section() {
>  }
>
>  get_next_config() {
> +       if [ ! -z "$CONFIG_INCLUDED" ] && ! $OPTIONS_HAVE_SECTIONS; then
> +               return 0
> +       fi
> +
>         local OLD_FSTYP=$FSTYP
>         local OLD_MOUNT_OPTIONS=$MOUNT_OPTIONS
>         local OLD_MKFS_OPTIONS=$MKFS_OPTIONS
> @@ -414,10 +418,11 @@ get_next_config() {
>         # to SCRATCH_DEV and rest to SCRATCH_DEV_POOL to maintain the backward compatibility
>         if [ ! -z "$SCRATCH_DEV_POOL" ]; then
>                 if [ ! -z "$SCRATCH_DEV" ]; then
> -                       echo "common/config: Error: \$SCRATCH_DEV should be unset when \$SCRATCH_DEV_POOL is set"
> +                       echo "common/config: Error: \$SCRATCH_DEV ($SCRATCH_DEV) should be unset when \$SCRATCH_DEV_POOL ($SCRATCH_DEV_POOL) is set"
>                         exit 1
>                 fi
>                 SCRATCH_DEV=`echo $SCRATCH_DEV_POOL | awk '{print $1}'`
> +               export SCRATCH_DEV
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
