Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8306EC001B2
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 02:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiLTCUR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 21:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiLTCUQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 21:20:16 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B042DC2;
        Mon, 19 Dec 2022 18:20:14 -0800 (PST)
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MSt8W-1pKCTM2qJK-00UIsV; Tue, 20
 Dec 2022 03:20:03 +0100
Message-ID: <51d9d9af-1302-e555-ca8a-c57a5a89b848@gmx.com>
Date:   Tue, 20 Dec 2022 10:19:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 3/8] report: capture the time zone in the test report
 timestamp
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com
References: <167149446381.332657.9402608531757557463.stgit@magnolia>
 <167149448068.332657.14583277548579655582.stgit@magnolia>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <167149448068.332657.14583277548579655582.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:x1LzitBWs/le09YHBfX6J2LTjozyzp4VtS5ohMgfg+EdVLW0mhr
 9qbD7+UJS9C04wqGnEUQpL8UdofDZIcN6rraRmwL8YYjPdG3LoNhYdWmGrrNRsedv9x/8++
 kyutDL7NGofg/OvPUSA/miE5wX7JmlwFFWerzdC8o9/mE/I9pqlB5nImAZLmASBEBSbi3ip
 FrEfqkKzTJ6rMcjognV1g==
UI-OutboundReport: notjunk:1;M01:P0:b4riFa13R0w=;939ZH4wSnWxKj7B+E6aGv0er9Sf
 Baahh4dd9HmMrFeB+1TxWu02YKtCXKGrBv1BMVgv06akO0t5jZhX2Iv+8p1Ciqx+E04DMN/1U
 QzlP0dICAEeZS3pe3L5nm65/g9F+xKCgn2X+lWMG3g1Zi2MARlmzgSuPPOTISQUug+eyWYqHe
 3sqzpj9xGheZrRyiacMtgz5skKXdRNkEQ7m6qz0DJN65+GQDq1VJsWX9Cz7X70VxGtgNpdiPS
 GQ/mG8cupfbVjSyLLaeEVN/sb1eRoVhjHaAQbMsJ3hGk+ErJU4HetWTS2YBqyIENIfwZmu2LN
 rAWz2tsMxBQDtLqAfJc1QEoyE5K0GMlON1vnBLYZIspQq9jgs/6ejhGY2xBJ1TYMggTHYZ2up
 wYSyTTigbCqE/2abLt6ggnCsDgsGal8BSer6xsyit4yex5XcJNEFCWB25qQpY0dGtlY3i9Zp+
 to53A6AcRkxnfk1axOPOe1F6josZ8jUQECzYB5Lz89Vd0hK0uDFbtT2czgFCXjb6CLTsJJxXE
 qWEHkS2RM8v1Fh+5djm/9pSN1JR9mmr6+ssfi/1bOJRIjCC0Zzs6xFXo83yIMJ7Dz202+72pF
 HSqWwklI2GPjkYmO0U7xiYwG3pD74o5kCfsmLGG+RA20S+31u7919pPBxjg/aFmG3SH6Hmljx
 ZNgayY/qZ6JvPFvUT4ZCp61d3WHc6keQZ27Xqzj2Mz0xlhpZKY3TO72Aog8tSMzzXQgAcCELn
 hnXeqV0VGndOjWcA5JiulFKCRSlIiG+ExprqLlLlNDNXLzgXCBaSNEy//sb76AZMh/H3PWoS9
 kF7aLV4nkH5ska0j671MBMGrggPAzZjKJ5TSfKTHiBk+poefMwql+9ODfiz9lxnmANryob8YX
 T1kf/784lhQSgH2hOQB4uJ2+eStVoVhij/3HEivvzVXThIJs+617aitF/a2J8S4I61geL1B/5
 LDmD7K1Qp1HfeoLn9v/yMuhihZ4=
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2022/12/20 08:01, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure we put the time zone of the system running the test in the
> timestamp that is recorded in the xunit report.  `date "+%F %T"' reports
> the local time zone, not UTC.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>   common/report |    9 ++++++---
>   doc/xunit.xsd |    2 +-
>   2 files changed, 7 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/common/report b/common/report
> index 1d84650270..1817132d51 100644
> --- a/common/report
> +++ b/common/report
> @@ -38,6 +38,7 @@ _xunit_make_section_report()
>   	local bad_count="$3"
>   	local notrun_count="$4"
>   	local sect_time="$5"
> +	local timestamp
>   
>   	if [ $sect_name == '-no-sections-' ]; then
>   		sect_name='global'
> @@ -45,8 +46,10 @@ _xunit_make_section_report()
>   	local report=$tmp.report.xunit.$sect_name.xml
>   	# Header
>   	echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $REPORT_DIR/result.xml
> -	if [ -z "$date_time" ]; then
> -		date_time=$(date +"%F %T")
> +	if [ -n "$date_time" ]; then
> +		timestamp="$(date -Iseconds --date="$date_time")"
> +	else
> +		timestamp="$(date -Iseconds)"
>   	fi
>   
>   	local fstests_ns="https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git"
> @@ -58,7 +61,7 @@ _xunit_make_section_report()
>   
>    name="xfstests"
>    failures="$bad_count" skipped="$notrun_count" tests="$tests_count" time="$sect_time"
> - hostname="$HOST" timestamp="${date_time/ /T}">
> + hostname="$HOST" timestamp="$timestamp">
>   ENDL
>   
>   	# Properties
> diff --git a/doc/xunit.xsd b/doc/xunit.xsd
> index 0aef8a9839..67f586b816 100644
> --- a/doc/xunit.xsd
> +++ b/doc/xunit.xsd
> @@ -12,7 +12,7 @@
>   	<xs:element name="testsuite" type="testsuite"/>
>   	<xs:simpleType name="ISO8601_DATETIME_PATTERN">
>   		<xs:restriction base="xs:dateTime">
> -			<xs:pattern value="[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}"/>
> +			<xs:pattern value="[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[+-][0-9]{2}:[0-9]{2}"/>
>   		</xs:restriction>
>   	</xs:simpleType>
>   	<xs:element name="testsuites">
> 
