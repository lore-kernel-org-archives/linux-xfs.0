Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44312 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750784AbcIWEZD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Sep 2016 00:25:03 -0400
Date: Fri, 23 Sep 2016 12:25:00 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] fstests: make some xfs project quota tests generic
Message-ID: <20160923042500.GV27776@eguan.usersys.redhat.com>
References: <ffeed0c4-7e77-a7a0-1426-0890bf38a52f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffeed0c4-7e77-a7a0-1426-0890bf38a52f@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>

On Thu, Sep 22, 2016 at 05:51:03PM -0500, Eric Sandeen wrote:
> This patch makes some xfs project quota tests generic,
> so that there is at least some coverage on ext4 for this
> (semi-)new feature.
> 
> It requires bleeding edge xfsprogs, so that xfs_quota and 
> xfs_io's chproj command can operate on "foreign" filesystems,
> and requires relatively new e2fsprogs to enable the project
> quota feature on-disk.
> 
> The mechanism for enabling project quota on ext4 is a bit
> arcane, but hopefully I've encapsulated it reasonably well here.
> 
> Changes:
> 
> * look for "project" feature in _require_prjquota
> * look for accounting not enforcement (-P) in _require_prjquota
> * add a _scratch_enable_pquota to turn on project quota feature
> * s/pquota/quota/ in _qmount_option for ext4
> * add helper to test for xfs_io chproj on foreign filesystems
> * switch from block to inode quota in xfs/133 because empty
>   ext4 dirs consume one block
> * cosmetic/generic changes for mkfs, require tests, etc.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> Eryu, would you like to do the move-to-generic/ since you'll need
> to renumber them anyway? :)
> 
> Note -
> This requires the previous patch I sent to the fstests list,
> 
> [PATCH 2/3 V2] modify xfs/ quota tests to work on generic filesystems
> 
> diff --git a/common/quota b/common/quota
> index afc1606..556eba6 100644
> --- a/common/quota
> +++ b/common/quota
> @@ -92,12 +92,16 @@ _require_xfs_quota_foreign()
>  }
>  
>  #
> -# checks that the XFS project quota support in the kernel is enabled.
> +# checks that the project quota support in the kernel is enabled.
>  #
>  _require_prjquota()
>  {
>      [ -n "$1" ] && _dev="$1" || _dev="$TEST_DEV"
> -    src/feature -p $_dev
> +    if [ "$FSTYP" == "ext4" ]; then
> +	dumpe2fs -h $_dev 2>&1 | grep -qw project || \
> +		_notrun "Project quota not available on this ext4"
> +    fi
> +    src/feature -P $_dev
>      [ $? -ne 0 ] && _notrun "Installed kernel does not support project quotas"
>      if [ "$USE_EXTERNAL" = yes -a ! -z "$_dev" ]; then
>  	_notrun "Project quotas not supported on realtime filesystem"
> @@ -105,6 +109,16 @@ _require_prjquota()
>  }
>  
>  #
> +# ext4 (for now) is unique in that we must enable the project quota feature
> +# prior to mount.  This is a relatively new feature ...
> +_scratch_enable_pquota()
> +{
> +	[ "$FSTYP" != "ext4" ] && return
> +
> +	tune2fs -O quota,project $SCRATCH_DEV >>$seqres.full 2>&1
> +}
> +
> +#
>  # checks for user nobody in /etc/passwd and /etc/group.
>  #
>  _require_nobody()
> @@ -197,6 +211,8 @@ _qmount()
>  #
>  _qmount_option()
>  {
> +	OPTS=$1
> +
>  	# Replace any user defined quota options
>  	# with the quota option that we want.
>  	# Simplest to do this rather than delete existing ones first because
> @@ -210,16 +226,23 @@ _qmount_option()
>  		-e 's/gquota/QUOTA/g'      \
>  		-e 's/grpquota/QUOTA/g'    \
>  		-e 's/pquota/QUOTA/g'      \
> -		-e 's/prjquota/QUOTA/g'      \
> +		-e 's/prjquota/QUOTA/g'    \
>  		-e 's/quota/QUOTA/g'       \
>  		-e 's/uqnoenforce/QUOTA/g' \
>  		-e 's/gqnoenforce/QUOTA/g' \
>  		-e 's/pqnoenforce/QUOTA/g' \
>  		-e 's/qnoenforce/QUOTA/g'  \
> -		-e "s/QUOTA/$1/g"`
> +		-e "s/QUOTA/$OPTS/g"`
>  
> +	# ext4 doesn't _do_ "-o pquota/prjquota" because reasons
> +	# Switch it to "quota" to enable mkfs-time pquota
> +	if [ "$FSTYP" == "ext4" ]; then
> +		OPTS=`echo $OPTS \
> +		| sed	-e 's/pquota/quota/g'	\
> +			-e 's/prjquota/quota/g'`
> +	fi

This replaces "grpquota" to "grquota" and mount failed because of
unknown mount option "grquota". The following change works for me:

-             | sed   -e 's/pquota/quota/g'   \
+             | sed   -e 's/\bpquota/quota/g' \

If you can give me an ack (or another fix), I can fold it into the
original patch.

Thanks,
Eryu
