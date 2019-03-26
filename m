Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60578 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbfCZR2o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Mar 2019 13:28:44 -0400
Subject: Re: [PATCH 22/36] xfs_info: use findmnt to handle mounted block
 devices
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259756550.31886.4299958077869009509.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <6d3b8b3d-d547-fe3a-ed37-36132105e9a8@sandeen.net>
Date: Tue, 26 Mar 2019 12:28:43 -0500
MIME-Version: 1.0
In-Reply-To: <155259756550.31886.4299958077869009509.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/19 4:06 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Use findmnt to determine if the passed-in argument is associated with a
> mount point, and if so, use spaceman to query the mounted filesystem.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  debian/control       |    2 +-
>  spaceman/xfs_info.sh |   14 +++++++++++---
>  2 files changed, 12 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/debian/control b/debian/control
> index f4f807b0..0b3205f5 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -8,7 +8,7 @@ Standards-Version: 4.0.0
>  Homepage: https://xfs.wiki.kernel.org/
>  
>  Package: xfsprogs
> -Depends: ${shlibs:Depends}, ${misc:Depends}, python3:any
> +Depends: ${shlibs:Depends}, ${misc:Depends}, python3:any, util-linux
>  Provides: fsck-backend
>  Suggests: xfsdump, acl, attr, quota
>  Breaks: xfsdump (<< 3.0.0)
> diff --git a/spaceman/xfs_info.sh b/spaceman/xfs_info.sh
> index ecf17f61..70978164 100755
> --- a/spaceman/xfs_info.sh
> +++ b/spaceman/xfs_info.sh
> @@ -24,11 +24,19 @@ set -- extra "$@"
>  shift $OPTIND
>  case $# in
>  	1)
> -		if [ -b "$1" ] || [ -f "$1" ]; then
> -			xfs_db -p xfs_info -c "info" $OPTS "$1"
> +		arg="$1"
> +
> +		# See if we can map the arg to a loop device
> +		loopdev="$(losetup -n -O NAME -j "${arg}" 2> /dev/null)"

hm, -n has existed since 2013...

commit 9f56106df6b49864ba604f6824f9fad5aeabd17a
Author: Karel Zak <kzak@redhat.com>
Date:   Mon May 13 12:00:24 2013 +0200

    losetup: add --raw and --noheadings
    
    Signed-off-by: Karel Zak <kzak@redhat.com>

and -O since 2012:

commit 896352d3906c19e8519670f1a511afb01083ed5e
Author: Ondrej Oprala <ooprala@redhat.com>
Date:   Mon Nov 12 13:08:00 2012 +0100

    losetup: add --list and --output option

So, granted, that is a /long time/.  And yet, somehow, my RHEL7 box does not
have -n....

# losetup -j fsfile | awk -F: '{print $1}'
/dev/loop0

perhaps, for older compatibility?

(and do we need to handle association w/ more than 1 loop dev? urk...)


> +		test -n "${loopdev}" && arg="${loopdev}"
> +
> +		# If we find a mountpoint for the device, do a live query;
> +		# otherwise try reading the fs with xfs_db.
> +		if mountpt="$(findmnt -f -n -o TARGET "${arg}" 2> /dev/null)"; then
> +			xfs_spaceman -p xfs_info -c "info" $OPTS "${mountpt}"
>  			status=$?
>  		else
> -			xfs_spaceman -p xfs_info -c "info" $OPTS "$1"
> +			xfs_db -p xfs_info -c "info" $OPTS "${arg}"
>  			status=$?
>  		fi
>  		;;
> 
