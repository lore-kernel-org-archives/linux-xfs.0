Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 823227F3F
	for <xfs@oss.sgi.com>; Wed, 16 Oct 2013 15:50:50 -0500 (CDT)
Message-ID: <525EFC49.7090300@sgi.com>
Date: Wed, 16 Oct 2013 15:51:21 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 10/10 v2] xfstests: Remount file system if MOUNT_OPTIONS
	changed
References: <1373539085-8577-1-git-send-email-lczerner@redhat.com>
	<1373539085-8577-11-git-send-email-lczerner@redhat.com>
In-Reply-To: <1373539085-8577-11-git-send-email-lczerner@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>, xfs@oss.sgi.com

Hi Lukas,

On 07/11/2013 05:38 AM, Lukas Czerner wrote:
> When MOUNT_OPTIONS change we should remount TEST_DEV to put the changes
> in effect. This will allow us to have different MOUNT_OPTIONS in sections
> in configuration file.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
>   README.config-sections | 8 ++++++++
>   check                  | 8 ++++++++
>   2 files changed, 16 insertions(+)
>
> diff --git a/README.config-sections b/README.config-sections
> index 4d60272..2849fd5 100644
> --- a/README.config-sections
> +++ b/README.config-sections
> @@ -36,6 +36,14 @@ For every section xfstests will run with specified options and will produce
>   separate results in the '$RESULT_BASE/$section_name' directory.
>
>
> +Different mount options
> +-----------------------
> +
> +Specifying different mount options in difference config sections is allowed.
> +When MOUNT_OPTIONS differs in the following section TEST_DEV will be remounted
> +with new MOUNT_OPTIONS automatically before running the test.
> +
> +
>   Multiple file systems
>   ---------------------
>
> diff --git a/check b/check
> index 5775276..ef91260 100755
> --- a/check
> +++ b/check
> @@ -394,6 +394,7 @@ fi
>
>   for section in $HOST_OPTIONS_SECTIONS; do
>   	OLD_FSTYP=$FSTYP
> +	OLD_MOUNT_OPTIONS=$MOUNT_OPTIONS
>   	get_next_config $section
>
>   	mkdir -p $RESULT_BASE
> @@ -422,6 +423,13 @@ for section in $HOST_OPTIONS_SECTIONS; do
>   			exit 1
>   		fi
>   		_prepare_test_list
> +	elif [ "$OLD_MOUNT_OPTIONS" != "$MOUNT_OPTIONS" ]; then
> +		_umount_or_remount_ro $TEST_DEV 2>&1> /dev/null
> +		out=`_mount_or_remount_rw "$MOUNT_OPTIONS" $TEST_DEV $TEST_DIR`
> +		if [ $? -ne 1 ]; then
> +			echo $out
> +			exit 1
> +		fi
>   	fi
>
>   	init_rc
>

Sorry this took so long to get to but this no longer applies cleanly.

Thanks
--Rich

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
