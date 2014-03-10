Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D2037F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 14:49:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3BAA08F8035
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 12:49:14 -0700 (PDT)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id vhBrjUxA6txNLGHC
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 12:49:13 -0700 (PDT)
Message-ID: <531E171B.8090204@fb.com>
Date: Mon, 10 Mar 2014 15:48:43 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/3] xfstests/btrfs: add stress test for btrfs quota
	operations
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<1394423051-17356-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1394423051-17356-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, xfs@oss.sgi.com
Cc: linux-btrfs@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/09/2014 11:44 PM, Wang Shilong wrote:
> So this is a stress test for btrfs quota operations. it can also 
> detect the following commit fixed problem:
> 
> 4082bd3d73(Btrfs: fix oops when writting dirty qgroups to disk)
> 
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com> --- 
> v1->v2: switch into new helper _run_btrfs_util_prog() --- 
> tests/btrfs/043     | 76
> +++++++++++++++++++++++++++++++++++++++++++++++++++++ 
> tests/btrfs/043.out |  2 ++ tests/btrfs/group   |  1 + 3 files
> changed, 79 insertions(+) create mode 100755 tests/btrfs/043 create
> mode 100644 tests/btrfs/043.out
> 
> diff --git a/tests/btrfs/043 b/tests/btrfs/043 new file mode
> 100755 index 0000000..d6c4bf3 --- /dev/null +++ b/tests/btrfs/043 
> @@ -0,0 +1,76 @@ +#! /bin/bash +# FS QA Test No. 043 +# +#
> stresstest for btrfs quota operations. we run fsstress and quota +#
> operations concurrently. +# 
> +#-----------------------------------------------------------------------
>
> 
+# Copyright (c) 2014 Fujitsu.  All Rights Reserved.
> +# +# This program is free software; you can redistribute it
> and/or +# modify it under the terms of the GNU General Public
> License as +# published by the Free Software Foundation. +# +# This
> program is distributed in the hope that it would be useful, +# but
> WITHOUT ANY WARRANTY; without even the implied warranty of +#
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the +#
> GNU General Public License for more details. +# +# You should have
> received a copy of the GNU General Public License +# along with
> this program; if not, write the Free Software Foundation, +# Inc.,
> 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA 
> +#-----------------------------------------------------------------------
>
> 
+#
> + +seq=`basename $0` +seqres=$RESULT_DIR/$seq +echo "QA output
> created by $seq" + +here=`pwd` +tmp=/tmp/$$ +status=1	# failure is
> the default! +trap "_cleanup; exit \$status" 0 1 2 3 15 + 
> +_cleanup() +{ +	cd / +	rm -f $tmp.* +} + +# get standard
> environment, filters and checks +. ./common/rc +. ./common/filter 
> + +_supported_fs btrfs +_supported_os Linux +_require_scratch + +rm
> -f $seqres.full + +_quota_enabled_background() +{ +	i=1 +	while [
> $i -le 5 ] +	do +		_run_btrfs_util_prog quota enable $SCRATCH_MNT +
> _run_btrfs_util_prog quota disable $SCRATCH_MNT +		i=$(($i+1)) +
> sleep 1 +	done +} + +MKFS_SIZE=$((1024 * 1024 * 1024)) +run_check
> _scratch_mkfs_sized $MKFS_SIZE +run_check _scratch_mount + 
> +_quota_enabled_background & +run_check $FSSTRESS_PROG -d
> $SCRATCH_MNT -w -p 5 -n 1000 \ +	$FSSTRESS_AVOID + +run_check
> _scratch_unmount +_check_scratch_fs +

You should probably be doing something to make sure the background
quota stuff exits properly before your script exits, my fio box can
run the fsstress in way less than 5 seconds.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHhcbAAoJEANb+wAKly3B5Y0P/3z2IPMHDb95QwtmK0Ehsy8G
meD44ew0yy8f4hMED5VAnHeKEctRfNierXz+pJAKlxvREzbNKIlnTSDLgwYxMCeO
OQruW1Dp6W4WtSNltF8YfIVZqhLksHpkoW7zYrSr+qCZeQsNal61rjqQ2cydWb4u
nCnICJa/KkLT84MW4WrZU+S2RJE7kvfqQoZkXND4rH2Nw9hAaAnF6bK4+ZfvKwni
uDrBl3vdrQWIps304zIGaYxpnheIskeVdEG2AtL/KsCpCuSI/m/yjFsU8w/yTJ64
g4Kbd9l3sTNSfErujeBZ9brEpVRwslUzSnw0u5g5PNABRYsTcnyh+tkelCIMH8MI
2StpONvNXLQeaL2N378/syV4oWvAez6qUtFVFHTCfjKlugxn92juJXQKaS98K4Un
V1+CrJ6cH2bGLjOKVnDsIf8aY77hSuP6Qn/wNMcZvO10ajlpRhFS9FYy12jyoC7M
1aSLX+6R9pk+MvCwFAS+9w2hYTj5ksDhVZWXIwPxK9rQE/NYitNrv+y6QzcF0xhi
udgTPl5XDdtiDWcDabMHEr6ky5gbnz6oiLcRy4V/XHbr9ymInaiB7fhBJ0DOX78m
I19DBe/QIPCGBwFcgKHmadZAudihory6UzMaMkFlzbt4AVjBEYujS7U4LDhFN0lx
UYXoSJdzjA2OZWhUXfdL
=jTbe
-----END PGP SIGNATURE-----

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
