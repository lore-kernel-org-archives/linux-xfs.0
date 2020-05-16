Return-Path: <SRS0=gkwD=66=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4123C433DF
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE75207D8
	for <linux-xfs@archiver.kernel.org>; Sat, 16 May 2020 17:24:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgEPRYB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 May 2020 13:24:01 -0400
Received: from sandeen.net ([63.231.237.45]:60046 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgEPRYB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 May 2020 13:24:01 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 210E417273;
        Sat, 16 May 2020 12:23:38 -0500 (CDT)
Subject: Re: [PATCH v3] generic: per-type quota timers set/get test
To:     Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
References: <20200329051801.8363-1-zlang@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 mQINBE6x99QBEADMR+yNFBc1Y5avoUhzI/sdR9ANwznsNpiCtZlaO4pIWvqQJCjBzp96cpCs
 nQZV32nqJBYnDpBDITBqTa/EF+IrHx8gKq8TaSBLHUq2ju2gJJLfBoL7V3807PQcI18YzkF+
 WL05ODFQ2cemDhx5uLghHEeOxuGj+1AI+kh/FCzMedHc6k87Yu2ZuaWF+Gh1W2ix6hikRJmQ
 vj5BEeAx7xKkyBhzdbNIbbjV/iGi9b26B/dNcyd5w2My2gxMtxaiP7q5b6GM2rsQklHP8FtW
 ZiYO7jsg/qIppR1C6Zr5jK1GQlMUIclYFeBbKggJ9mSwXJH7MIftilGQ8KDvNuV5AbkronGC
 sEEHj2khs7GfVv4pmUUHf1MRIvV0x3WJkpmhuZaYg8AdJlyGKgp+TQ7B+wCjNTdVqMI1vDk2
 BS6Rg851ay7AypbCPx2w4d8jIkQEgNjACHVDU89PNKAjScK1aTnW+HNUqg9BliCvuX5g4z2j
 gJBs57loTWAGe2Ve3cMy3VoQ40Wt3yKK0Eno8jfgzgb48wyycINZgnseMRhxc2c8hd51tftK
 LKhPj4c7uqjnBjrgOVaVBupGUmvLiePlnW56zJZ51BR5igWnILeOJ1ZIcf7KsaHyE6B1mG+X
 dmYtjDhjf3NAcoBWJuj8euxMB6TcQN2MrSXy5wSKaw40evooGwARAQABtCVFcmljIFIuIFNh
 bmRlZW4gPHNhbmRlZW5Ac2FuZGVlbi5uZXQ+iQI7BBMBAgAlAhsDBgsJCAcDAgYVCAIJCgsE
 FgIDAQIeAQIXgAUCUzMzbAIZAQAKCRAgrhaS4T3e4Fr7D/wO+fenqVvHjq21SCjDCrt8HdVj
 aJ28B1SqSU2toxyg5I160GllAxEHpLFGdbFAhQfBtnmlY9eMjwmJb0sCIrkrB6XNPSPA/B2B
 UPISh0z2odJv35/euJF71qIFgWzp2czJHkHWwVZaZpMWWNvsLIroXoR+uA9c2V1hQFVAJZyk
 EE4xzfm1+oVtjIC12B9tTCuS00pY3AUy21yzNowT6SSk7HAzmtG/PJ/uSB5wEkwldB6jVs2A
 sjOg1wMwVvh/JHilsQg4HSmDfObmZj1d0RWlMWcUE7csRnCE0ZWBMp/ttTn+oosioGa09HAS
 9jAnauznmYg43oQ5Akd8iQRxz5I58F/+JsdKvWiyrPDfYZtFS+UIgWD7x+mHBZ53Qjazszox
 gjwO9ehZpwUQxBm4I0lPDAKw3HJA+GwwiubTSlq5PS3P7QoCjaV8llH1bNFZMz2o8wPANiDx
 5FHgpRVgwLHakoCU1Gc+LXHXBzDXt7Cj02WYHdFzMm2hXaslRdhNGowLo1SXZFXa41KGTlNe
 4di53y9CK5ynV0z+YUa+5LR6RdHrHtgywdKnjeWdqhoVpsWIeORtwWGX8evNOiKJ7j0RsHha
 WrePTubr5nuYTDsQqgc2r4aBIOpeSRR2brlT/UE3wGgy9LY78L4EwPR0MzzecfE1Ws60iSqw
 Pu3vhb7h3bkCDQROsffUARAA0DrUifTrXQzqxO8aiQOC5p9Tz25Np/Tfpv1rofOwL8VPBMvJ
 X4P5l1V2yd70MZRUVgjmCydEyxLJ6G2YyHO2IZTEajUY0Up+b3ErOpLpZwhvgWatjifpj6bB
 SKuDXeThqFdkphF5kAmgfVAIkan5SxWK3+S0V2F/oxstIViBhMhDwI6XsRlnVBoLLYcEilxA
 2FlRUS7MOZGmRJkRtdGD5koVZSM6xVZQSmfEBaYQ/WJBGJQdPy94nnlAVn3lH3+N7pXvNUuC
 GV+t4YUt3tLcRuIpYBCOWlc7bpgeCps5Xa0dIZgJ8Louu6OBJ5vVXjPxTlkFdT0S0/uerCG5
 1u8p6sGRLnUeAUGkQfIUqGUjW2rHaXgWNvzOV6i3tf9YaiXKl3avFaNW1kKBs0T5M1cnlWZU
 Utl6k04lz5OjoNY9J/bGyV3DSlkblXRMK87iLYQSrcV6cFz9PRl4vW1LGff3xRQHngeN5fPx
 ze8X5NE3hb+SSwyMSEqJxhVTXJVfQWWW0dQxP7HNwqmOWYF/6m+1gK/Y2gY3jAQnsWTru4RV
 TZGnKwEPmOCpSUvsTRXsVHgsWJ70qd0yOSjWuiv4b8vmD3+QFgyvCBxPMdP3xsxN5etheLMO
 gRwWpLn6yNFq/xtgs+ECgG+gR78yXQyA7iCs5tFs2OrMqV5juSMGmn0kxJUAEQEAAYkCHwQY
 AQIACQUCTrH31AIbDAAKCRAgrhaS4T3e4BKwD/0ZOOmUNOZCSOLAMjZx3mtYtjYgfUNKi0ki
 YPveGoRWTqbis8UitPtNrG4XxgzLOijSdOEzQwkdOIp/QnZhGNssMejCnsluK0GQd+RkFVWN
 mcQT78hBeGcnEMAXZKq7bkIKzvc06GFmkMbX/gAl6DiNGv0UNAX+5FYh+ucCJZSyAp3sA+9/
 LKjxnTedX0aygXA6rkpX0Y0FvN/9dfm47+LGq7WAqBOyYTU3E6/+Z72bZoG/cG7ANLxcPool
 LOrU43oqFnD8QwcN56y4VfFj3/jDF2MX3xu4v2OjglVjMEYHTCxP3mpxesGHuqOit/FR+mF0
 MP9JGfj6x+bj/9JMBtCW1bY/aPeMdPGTJvXjGtOVYblGZrSjXRn5++Uuy36CvkcrjuziSDG+
 JEexGxczWwN4mrOQWhMT5Jyb+18CO+CWxJfHaYXiLEW7dI1AynL4jjn4W0MSiXpWDUw+fsBO
 Pk6ah10C4+R1Jc7dyUsKksMfvvhRX1hTIXhth85H16706bneTayZBhlZ/hK18uqTX+s0onG/
 m1F3vYvdlE4p2ts1mmixMF7KajN9/E5RQtiSArvKTbfsB6Two4MthIuLuf+M0mI4gPl9SPlf
 fWCYVPhaU9o83y1KFbD/+lh1pjP7bEu/YudBvz7F2Myjh4/9GUAijrCTNeDTDAgvIJDjXuLX pA==
Message-ID: <31c4658a-5ae7-0bd7-5861-5f3e846314d3@sandeen.net>
Date:   Sat, 16 May 2020 12:23:58 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200329051801.8363-1-zlang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 3/29/20 12:18 AM, Zorro Lang wrote:
> Set different grace time, make sure each of quota (user, group and
> project) timers can be set (by setquota) and get (by repquota)
> correctly.
> 

Sorry for the late review; this works now on xfs & ext4, with my
per-type patches in the kernel.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> V2 did below changes:
> 1) Filter default quota timer (suggested by Eric Sandeen).
> 2) Try to merge the case from Darrick (please review):
> https://marc.info/?l=fstests&m=158207247224104&w=2
> 
> V3 did below changes:
> 1) _require_scratch_xfs_crc if tests on XFS (suggested by Eryu Guan)
> 
> Thanks,
> Zorro
> 
>  tests/generic/594     | 108 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/594.out |  50 +++++++++++++++++++
>  tests/generic/group   |   1 +
>  3 files changed, 159 insertions(+)
>  create mode 100755 tests/generic/594
>  create mode 100644 tests/generic/594.out
> 
> diff --git a/tests/generic/594 b/tests/generic/594
> new file mode 100755
> index 00000000..e501d54c
> --- /dev/null
> +++ b/tests/generic/594
> @@ -0,0 +1,108 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 594
> +#
> +# Test per-type(user, group and project) filesystem quota timers, make sure
> +# each of grace time can be set/get properly.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +# V4 XFS doesn't support to mount project and group quota together
> +if [ "$FSTYP" = "xfs" ];then
> +	_require_scratch_xfs_crc
> +fi
> +_require_quota
> +
> +_scratch_mkfs >$seqres.full 2>&1
> +_scratch_enable_pquota
> +_qmount_option "usrquota,grpquota,prjquota"
> +_qmount
> +_require_prjquota $SCRATCH_DEV
> +
> +MIN=60
> +
> +# get default time at first
> +def_time=`repquota -u $SCRATCH_MNT | \
> +		sed -n -e "/^Block/s/.* time: \(.*\); .* time: \(.*\)/\1 \2/p"`
> +echo "Default block and inode grace timers are: $def_time" >> $seqres.full
> +
> +filter_repquota()
> +{
> +	local blocktime=$1
> +	local inodetime=$2
> +
> +	_filter_scratch | sed -e "s,$blocktime,DEF_TIME,g" \
> +			      -e "s,$inodetime,DEF_TIME,g"
> +}
> +
> +echo "1. set project quota timer"
> +setquota -t -P $((10 * MIN)) $((20 * MIN)) $SCRATCH_MNT
> +repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $def_time
> +echo
> +
> +echo "2. set group quota timer"
> +setquota -t -g $((30 * MIN)) $((40 * MIN)) $SCRATCH_MNT
> +repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $def_time
> +echo
> +
> +echo "3. set user quota timer"
> +setquota -t -u $((50 * MIN)) $((60 * MIN)) $SCRATCH_MNT
> +repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $def_time
> +echo
> +
> +# cycle mount, make sure the quota timers are still right
> +echo "4. cycle mount test-1"
> +_qmount
> +repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $def_time
> +echo
> +
> +# Run repair to force quota check
> +echo "5. fsck to force quota check"
> +_scratch_unmount
> +_repair_scratch_fs >> $seqres.full 2>&1
> +echo
> +
> +# Remount (this time to run quotacheck) and check the limits.  There's a bug
> +# in quotacheck where we would reset the ondisk default grace period to zero
> +# while the incore copy stays at whatever was read in prior to quotacheck.
> +# This will show up after the /next/ remount.
> +echo "6. cycle mount test-2"
> +_qmount
> +repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $def_time
> +echo
> +
> +# Remount and check the limits
> +echo "7. cycle mount test-3"
> +_qmount
> +repquota -ugP $SCRATCH_MNT | grep "Report\|^Block" | filter_repquota $def_time
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/594.out b/tests/generic/594.out
> new file mode 100644
> index 00000000..f25e0fac
> --- /dev/null
> +++ b/tests/generic/594.out
> @@ -0,0 +1,50 @@
> +QA output created by 594
> +1. set project quota timer
> +*** Report for user quotas on device SCRATCH_DEV
> +Block grace time: DEF_TIME; Inode grace time: DEF_TIME
> +*** Report for group quotas on device SCRATCH_DEV
> +Block grace time: DEF_TIME; Inode grace time: DEF_TIME
> +*** Report for project quotas on device SCRATCH_DEV
> +Block grace time: 00:10; Inode grace time: 00:20
> +
> +2. set group quota timer
> +*** Report for user quotas on device SCRATCH_DEV
> +Block grace time: DEF_TIME; Inode grace time: DEF_TIME
> +*** Report for group quotas on device SCRATCH_DEV
> +Block grace time: 00:30; Inode grace time: 00:40
> +*** Report for project quotas on device SCRATCH_DEV
> +Block grace time: 00:10; Inode grace time: 00:20
> +
> +3. set user quota timer
> +*** Report for user quotas on device SCRATCH_DEV
> +Block grace time: 00:50; Inode grace time: 01:00
> +*** Report for group quotas on device SCRATCH_DEV
> +Block grace time: 00:30; Inode grace time: 00:40
> +*** Report for project quotas on device SCRATCH_DEV
> +Block grace time: 00:10; Inode grace time: 00:20
> +
> +4. cycle mount test-1
> +*** Report for user quotas on device SCRATCH_DEV
> +Block grace time: 00:50; Inode grace time: 01:00
> +*** Report for group quotas on device SCRATCH_DEV
> +Block grace time: 00:30; Inode grace time: 00:40
> +*** Report for project quotas on device SCRATCH_DEV
> +Block grace time: 00:10; Inode grace time: 00:20
> +
> +5. fsck to force quota check
> +
> +6. cycle mount test-2
> +*** Report for user quotas on device SCRATCH_DEV
> +Block grace time: 00:50; Inode grace time: 01:00
> +*** Report for group quotas on device SCRATCH_DEV
> +Block grace time: 00:30; Inode grace time: 00:40
> +*** Report for project quotas on device SCRATCH_DEV
> +Block grace time: 00:10; Inode grace time: 00:20
> +
> +7. cycle mount test-3
> +*** Report for user quotas on device SCRATCH_DEV
> +Block grace time: 00:50; Inode grace time: 01:00
> +*** Report for group quotas on device SCRATCH_DEV
> +Block grace time: 00:30; Inode grace time: 00:40
> +*** Report for project quotas on device SCRATCH_DEV
> +Block grace time: 00:10; Inode grace time: 00:20
> diff --git a/tests/generic/group b/tests/generic/group
> index dc95b77b..a83f95cb 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -595,3 +595,4 @@
>  591 auto quick rw pipe splice
>  592 auto quick encrypt
>  593 auto quick encrypt
> +594 auto quick quota
> 
