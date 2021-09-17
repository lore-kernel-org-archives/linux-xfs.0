Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F655C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 18:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F2E56124B
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Sep 2021 18:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236683AbhIQSgX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 14:36:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:31904 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231364AbhIQSgX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Sep 2021 14:36:23 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HHTk7o016127;
        Fri, 17 Sep 2021 14:34:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=FB4NPCSjmi9xoK3azYe3J+VFKef7afUK8OuuCZZk1Do=;
 b=ZkD0ucxRXVze4yTNhBpuSLylGyJgxKFiIJ8BjvXE1atqOOuKUqPbiigP9RWeiBgTyh2E
 PMlgJ3pfezf0SRIVaNJdMbp1tCr+bQ3E7eTge6Uc76PaZwR2veLzGccbC+TSDF/5mpTU
 Px0dlRzXtEaciX5oWUlWDTWUiT75lTD9sYtnBkR2PGD8uFEPNb0cukbfwKypmfZRUAQf
 8z7CBnNAFeWpj73Ri8F/7EGOwDlLAmf1W+WwlBnez9v6upsdivXaIjvZvP/vm4zjS3xE
 zfj7h94f4obNH9YBtR8cmAL6sAYUQ1MklNhN3Sr0LBYS7qKzuvxQqISIcNn90z7DzCsv oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b4uxx6rpb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 14:34:56 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18HIRGXC013263;
        Fri, 17 Sep 2021 14:34:55 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b4uxx6rnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 14:34:55 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18HIGw20010203;
        Fri, 17 Sep 2021 18:34:54 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3b0m3aycek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 18:34:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18HIUCZ359507056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 18:30:12 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79D9EA4054;
        Fri, 17 Sep 2021 18:34:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4D61A405B;
        Fri, 17 Sep 2021 18:34:50 +0000 (GMT)
Received: from localhost (unknown [9.43.63.221])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Sep 2021 18:34:50 +0000 (GMT)
Date:   Sat, 18 Sep 2021 00:04:49 +0530
From:   riteshh <riteshh@linux.ibm.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/1] generic: fsstress with cpu offlining
Message-ID: <20210917183449.wyvvy436j3ifeazx@riteshh-domain>
References: <163174934876.380813.7279783755501552575.stgit@magnolia>
 <163174935421.380813.6102795123954022876.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163174935421.380813.6102795123954022876.stgit@magnolia>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pw6ToadBOYEG2Fi4hNyNMDeAgc8-_iSz
X-Proofpoint-ORIG-GUID: v1MWzJI1SNraryeLAv3zJ3QShxggHOe5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_07,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 malwarescore=0 clxscore=1011 spamscore=0
 impostorscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109170110
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 21/09/15 04:42PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Exercise filesystem operations when we're taking CPUs online and offline
> throughout the test.

Nice test coverage. Btw, I may have missed older versions, but could you point
to the link which points to the bugs which this test uncovered?
I guess it will be good to add tha in the comment section of test description
too.

This also made me think whether doing memory online/offline while running
fsstress, makes any sense?

>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/726     |   74 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/726.out |    2 +
>  2 files changed, 76 insertions(+)
>  create mode 100755 tests/generic/726
>  create mode 100644 tests/generic/726.out
>
>
> diff --git a/tests/generic/726 b/tests/generic/726
> new file mode 100755
> index 00000000..1a3f2fad
> --- /dev/null
> +++ b/tests/generic/726
> @@ -0,0 +1,74 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 726
> +#
> +# Run an all-writes fsstress run with multiple threads while exercising CPU
> +# hotplugging to shake out bugs in the write path.
> +#
> +. ./common/preamble
> +_begin_fstest auto rw stress

Does it qualify for auto? This definitely is taking a longer time compared to
other auto tests on my qemu setup.

> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> +	wait	# for exercise_cpu_hotplug subprocess
> +	for i in "$sysfs_cpu_dir/"cpu*/online; do
> +		echo 1 > "$i" 2>/dev/null
> +	done
> +	test -n "$stress_dir" && rm -r -f "$stress_dir"
> +}
> +
> +exercise_cpu_hotplug()
> +{
> +	while [ -e $sentinel_file ]; do
> +		local idx=$(( RANDOM % nr_hotplug_cpus ))
> +		local cpu="${hotplug_cpus[idx]}"
> +		local action=$(( RANDOM % 2 ))
> +
> +		echo "$action" > "$sysfs_cpu_dir/cpu$cpu/online" 2>/dev/null
> +		sleep 0.5
> +	done
> +}
> +
> +_supported_fs generic
> +_require_test
> +_require_command "$KILLALL_PROG" "killall"
> +
> +sysfs_cpu_dir="/sys/devices/system/cpu"
> +
> +# Figure out which CPU(s) support hotplug.
> +nrcpus=$(getconf _NPROCESSORS_CONF)
> +hotplug_cpus=()
> +for ((i = 0; i < nrcpus; i++ )); do
> +	test -e "$sysfs_cpu_dir/cpu$i/online" && hotplug_cpus+=("$i")
> +done
> +nr_hotplug_cpus="${#hotplug_cpus[@]}"
> +test "$nr_hotplug_cpus" -gt 0 || _notrun "CPU hotplugging not supported"
> +
> +stress_dir="$TEST_DIR/$seq"
> +rm -r -f "$stress_dir"
> +mkdir -p "$stress_dir"
> +
> +echo "Silence is golden."
> +
> +sentinel_file=$tmp.hotplug
> +touch $sentinel_file
> +exercise_cpu_hotplug &
> +
> +# Cap the number of fsstress threads at one per hotpluggable CPU if we exceed
> +# 1024 IO threads, per maintainer request.
> +nr_cpus=$((LOAD_FACTOR * nr_hotplug_cpus))
> +test "$nr_cpus" -gt 1024 && nr_cpus="$nr_hotplug_cpus"
> +
> +nr_ops=$((25000 * TIME_FACTOR))
> +$FSSTRESS_PROG $FSSTRESS_AVOID -w -d $stress_dir -n $nr_ops -p $nr_cpus >> $seqres.full
> +rm -f $sentinel_file
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/726.out b/tests/generic/726.out
> new file mode 100644
> index 00000000..6839f8ce
> --- /dev/null
> +++ b/tests/generic/726.out
> @@ -0,0 +1,2 @@
> +QA output created by 726
> +Silence is golden.
>
