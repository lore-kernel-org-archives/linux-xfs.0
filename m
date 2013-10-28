Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 602FF7F3F
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 15:18:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3AB65304064
	for <xfs@oss.sgi.com>; Mon, 28 Oct 2013 13:18:06 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id NPgmnPqguOHXhmEI for <xfs@oss.sgi.com>;
	Mon, 28 Oct 2013 13:18:03 -0700 (PDT)
Message-ID: <526EC674.9060705@suse.com>
Date: Mon, 28 Oct 2013 16:17:56 -0400
From: Jeff Mahoney <jeffm@suse.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] xfstests: btrfs/022: test sysfs exports of allocation
	and device membership info
References: <20131028195204.611287480@sled1.home.jeffreymahoney.com>
	<20131028195242.496745223@sled1.home.jeffreymahoney.com>
In-Reply-To: <20131028195242.496745223@sled1.home.jeffreymahoney.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7684617980641652368=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org, jbacik@fusionio.com

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============7684617980641652368==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="KTj42JP8Ff8DjHsGHiUL27I4ic0ODbRoW"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KTj42JP8Ff8DjHsGHiUL27I4ic0ODbRoW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/28/13, 3:52 PM, Jeff Mahoney wrote:
> This tests the sysfs publishing for btrfs allocation and device
> membership info under a number of different layouts, similar to the
> btrfs replace test. We test the allocation files only for existence and=

> that they contain numerical values. We test the device membership
> by mapping the devices used to create the file system to sysfs paths
> and matching them against the paths used for the device membership
> symlinks.
>=20
> Since this is a new feature, it passes on kernels without
> a /sys/fs/btrfs/<fsid> directory.
>=20
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  common/config       |    1 +
>  tests/btrfs/022     |  190 +++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  tests/btrfs/022.out |    2 +
>  3 files changed, 193 insertions(+), 0 deletions(-)
>  create mode 100755 tests/btrfs/022
>  create mode 100644 tests/btrfs/022.out
>=20
> Index: xfstests/common/config
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- xfstests.orig/common/config
> +++ xfstests/common/config
> @@ -209,6 +209,7 @@ case "$HOSTOS" in
>          export MKFS_UDF_PROG=3D"`set_prog_path mkudffs`"
>          export MKFS_BTRFS_PROG=3D"`set_btrfs_mkfs_prog_path_with_opts`=
"
>          export BTRFS_UTIL_PROG=3D"`set_prog_path btrfs`"
> +        export UDEVADM_PROG=3D"`set_prog_path udevadm`"
>          export BTRFS_SHOW_SUPER_PROG=3D"`set_prog_path btrfs-show-supe=
r`"
>          export XFS_FSR_PROG=3D"`set_prog_path xfs_fsr`"
>          export MKFS_NFS_PROG=3D"false"
> Index: xfstests/tests/btrfs/022
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null
> +++ xfstests/tests/btrfs/022
> @@ -0,0 +1,190 @@
> +#! /bin/bash
> +# FS QA Test No. 022
> +#
> +# Test of the btrfs sysfs publishing
> +#
> +#---------------------------------------------------------------------=
--
> +# Copyright (C) 2013 SUSE.  All rights reserved.
> +#
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License as
> +# published by the Free Software Foundation.
> +#
> +# This program is distributed in the hope that it would be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +#
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write the Free Software Foundation,=

> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> +#
> +#---------------------------------------------------------------------=
--
> +#
> +
> +seq=3D`basename $0`
> +seqres=3D$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=3D`pwd`
> +tmp=3D/tmp/$$
> +status=3D1
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_need_to_be_root
> +_supported_fs btrfs
> +_require_scratch
> +_require_scratch_dev_pool
> +_require_command $UDEVADM_PROG
> +
> +rm -f $seqres.full
> +rm -f $tmp.tmp
> +
> +check_file() {
> +	local file=3D$1
> +	base=3D"$(echo "$file" | sed -e 's#/sys/fs/btrfs/[0-9a-f-][0-9a-f-]*/=
##')"
> +	if [ ! -f "$file" ]; then
> +		echo "$base missing."
> +		return 0
> +	else
> +		value=3D"$(cat $file)"
> +		if [ -n "$(echo $value | tr -d 0-9)" ]; then
> +			echo "ERROR: $base: numerical value expected" \
> +			     "(got $value)"
> +			return 0
> +		fi
> +	fi
> +	return 1
> +}
> +
> +check_chunk() {
> +	path=3D$1
> +	mkfs_options=3D$2
> +	error=3Dfalse
> +
> +	chunktype=3D$(basename $path)
> +	if [ ! -d "$path" ]; then
> +		echo "No $chunktype directory."
> +		exit 1
> +	fi
> +
> +	for file in bytes_may_use bytes_pinned bytes_reserved bytes_used \
> +		    disk_total flags total_bytes total_bytes_pinned; do
> +		if check_file "$path/$file"; then
> +			error=3Dtrue
> +		fi
> +	done
> +
> +	if [ "$chunktype" =3D "data" -o "$chunktype" =3D "mixed" ]; then
> +		opt=3D"-d"
> +	elif [ "$chunktype" =3D "metadata" -o "$chunktype" =3D "system" ]; th=
en
> +		opt=3D"-m"
> +	fi
> +
> +	profile=3D$(echo $mkfs_options | sed -e "s/.*$opt \([[:alnum:]]*\).*/=
\1/")
> +	if [ ! -d "$path/$profile" ]; then
> +		echo "No $profile dir for $chunktype"
> +		exit 1
> +	fi
> +
> +	for file in total_bytes used_bytes; do
> +		if check_file $path/$profile/$file; then
> +			error=3Dtrue
> +		fi
> +	done
> +
> +	$error && exit 1
> +}
> +
> +check_dev_link() {
> +	local dev=3D$1
> +	DEV=3D"/sys/$($UDEVADM_PROG info --query=3Dpath $dev)"
> +	DEV=3D"$(readlink -f $DEV)"
> +	found=3Dfalse
> +	for link in $sysfs_base/devices/*; do
> +		LINK=3D"$(readlink -f $link)"
> +		if [ "$LINK" =3D "$DEV" ]; then
> +			found=3Dtrue
> +			break
> +		fi
> +	done
> +	if ! $found; then
> +		echo "Symlink for $dev missing in $sysfs_base/devices"
> +		return 1
> +	fi
> +	return 0
> +}
> +
> +workout()
> +{
> +	local mkfs_options=3D"$1"
> +	local num_devs4raid=3D"$2"
> +	local fssize
> +
> +	if [ "`echo $SCRATCH_DEV_POOL | wc -w`" -lt $num_devs4raid ]; then
> +		echo "Skip workout $1 $2 $3 $4"
> +		echo "Too few devices in SCRATCH_DEV_POOL $SCRATCH_DEV_POOL," \
> +		     "required: $num_devs4raid"
> +		echo "Skip workout $1 $2 $3 $4" >> $seqres.full
> +		echo "Too few devices in SCRATCH_DEV_POOL $SCRATCH_DEV_POOL," \
> +		     "required: $num_devs4raid" >> $seqres.full
> +		return 0
> +	fi
> +
> +	used_devs=3D$(echo $SCRATCH_DEV_POOL|tr '\t' ' '| \
> +		    cut -d ' ' -f 1-$num_devs4raid)
> +
> +	_scratch_mkfs $mkfs_options $used_devs >> $seqres.full 2>&1 || \
> +	_fail "mkfs failed"
> +
> +	_scratch_mount
> +
> +	# Check allocation
> +	sysfs_base=3D"/sys/fs/btrfs/$(_btrfs_get_fsid $SCRATCH_DEV)"
> +
> +	# Feature isn't present for testing
> +	if [ ! -d "$sysfs_base" ]; then
> +		echo "Skipping sysfs test: $sysfs_base not found." \
> +		     >> $seqres.full
> +		return

Oops. This doesn't umount when run with a proper device pool.

-Jeff

> +	fi
> +
> +	mixed=3Dfalse
> +	case "$mkfs_options" in
> +	*-M*)
> +		mixed=3Dtrue;
> +		;;
> +	esac
> +
> +	check_chunk "$sysfs_base/allocation/system" "$mkfs_options"
> +	if $mixed; then
> +		check_chunk "$sysfs_base/allocation/mixed" "$mkfs_options"
> +	else
> +		check_chunk "$sysfs_base/allocation/data" "$mkfs_options"
> +		check_chunk "$sysfs_base/allocation/metadata" "$mkfs_options"
> +	fi
> +
> +	for dev in $used_devs; do
> +		check_dev_link $dev || exit 1
> +	done
> +
> +	umount $SCRATCH_MNT > /dev/null 2>&1
> +}
> +
> +workout "-m single -d single" 1
> +workout "-m single -d single -M" 1
> +workout "-m dup -d single" 1
> +workout "-m dup -d dup -M" 1
> +workout "-m raid0 -d raid0" 2
> +workout "-m raid1 -d raid1" 2
> +workout "-m raid5 -d raid5" 2
> +workout "-m raid6 -d raid6" 3
> +workout "-m raid10 -d raid10" 4
> +
> +echo "Silence is golden."
> +status=3D0
> +exit
> Index: xfstests/tests/btrfs/022.out
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- /dev/null
> +++ xfstests/tests/btrfs/022.out
> @@ -0,0 +1,2 @@
> +QA output created by 022
> +Silence is golden


--=20
Jeff Mahoney
SUSE Labs


--KTj42JP8Ff8DjHsGHiUL27I4ic0ODbRoW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJSbsZ3AAoJEB57S2MheeWyWR8P/i0x07SPcT4Fstn6sUws6W+G
xhXuHhn6WrIuTkYwcy9EoTmpyVp/ZnzrdNGzMC3nEjgd98yyQtKqAVRlAIh7VsHX
H3H23cVlgSv5AB8HFB6XI7xZ5ptCmdNJEs8cIcFNeq2SzzIooh8LTgeYtfSe/p0n
zoekAKmerPN91MXvXHuOGVODiFxzCAbT3wB5Hbw0edWH+IrNwXll58WdtlTAlTot
Cs1CJPIUVDlkKaR88Pq1uVdW2CrYnepDqFNdrCKkCFBDgiRZkUWM4zRt3GtiEMs9
bEIdSmRMqnZPFI39fG0hysS1n+Pw6mdaQPths2GKI4UGV98Xn2Nv6cr5E+7HUQkw
6kZihJpYa68SM/LpTfuWOE4waqGk7NJ2n+L0tEXa6mxCZM+me4B2eF/NLrBtnCez
pz0w3SYwAhqE6UCGktkJS4AotMZgd0N8u9nEBELFsPdgHnLp/rI0LQuPAfEYyzU9
lufdbfuvSW7Y4DWXLkQGyUheRE5BO20yyzNkuBl/s5eNj67hHmihI+6tiOO9NOrw
88K68BpiFpD7POeNMABIx48+DWfSbgAeZjyilkZN+URpbLIdtOsbUviKPEbc6YkJ
Bp9rdP6tpnte+RiiVHYsu+sySurrgER2OxgGBd5ujuvjHsyXXXpLHdrrRLtX6c77
JlGOnncRu/PKcIGji4pF
=YQV/
-----END PGP SIGNATURE-----

--KTj42JP8Ff8DjHsGHiUL27I4ic0ODbRoW--


--===============7684617980641652368==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7684617980641652368==--
