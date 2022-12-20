Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8857C4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 01:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbiLTBPq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 20:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232880AbiLTBPQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 20:15:16 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE5312A82;
        Mon, 19 Dec 2022 17:14:24 -0800 (PST)
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MulqN-1oqK803UtH-00rnmr; Tue, 20
 Dec 2022 02:14:12 +0100
Message-ID: <f447b1ab-ce5d-a736-6427-d1a3f33d20cf@gmx.com>
Date:   Tue, 20 Dec 2022 09:14:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com
References: <167149446381.332657.9402608531757557463.stgit@magnolia>
 <167149446946.332657.17186597494532662986.stgit@magnolia>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH 1/8] check: generate section reports between tests
In-Reply-To: <167149446946.332657.17186597494532662986.stgit@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:2gtNygUJgFsRNF3UeOSuwrTow2Ggc+ktQz93CTikVkVgWwAftqb
 tZw79OLS3XEREQtEL9b3hYjItdsko1MAvPKdD7sNLDjN0XWSasTFuPciygfk8ijiZl+VC9U
 mLB2FJOiQ8nkJDVECTKbACCJRj7ffuphNkO7IvmMyjSMpr+0ew5NoQqTMu83mGkPtadM4hk
 ZRmk3Nu2QvXAhPUqHm5Pw==
UI-OutboundReport: notjunk:1;M01:P0:3UV9RZGxgfo=;+xskkFKv3FjkAtVjFdCT7Fw26Sj
 bOOrqE5CaOA1cmGpH1piaPNPaqUO/V3GG2KhR/S/h4wM+SaiwZgace7u13IlKoiQMMu5rpQqI
 xRocpDeTxUaNMDRF4ZPt/PkKk9xOIgugG8m1W5ZOYHFBfP2Z+Flq0PPf2e+A7CDtQ4PGViBWn
 FrJP7zhAjp3j/mV9ePwKj5Ug688WlpBtCQWGLD+zy5a8duVPwwicgd1QLWfq9AXew08WiS5wt
 a+UKguJighbVsBY9BRlMkF5dCZvoIlu58JV+hTtWJ9Av8fYQm4gbkOF2xlVDG3Iw5YUVsGxeT
 ediY31lpuc8agNOgr1T0MPHcpwdIffGNFTF0Bxiuo3vzHZvpwF2Sk+CqgysvALlqdRrZi/dcu
 W/AB+rP+/GKkT4AYIP6yliSsSkw4KL255OLxHrRbKLJP4UgN8UPxZJNX+G7OZf7LrY2P5V9Dt
 MwdNU3VAr6L9MHLY0v0LrKxvtIVJg6srAY+8eAMZf6y20zSFeXXmdStWBzVkGbps9fifc6CdH
 u0/AIJAmFqRlw0c/r0nf9vzDt3nPwDhHsW3aFw/H7mUsXMZ7LDuXLE6jQ3rwd939e9ThWqRDa
 xfsbeUwH7+q7tyKHbGg89yLXVVri4opLFEkLnPYOHRGZYgDuX+49tH7+fNnULUGQZLQMveUsd
 JfycfIfFu7ZW4OECL4pC2+noMr+VG/Dp2ns80JdwS/FmZszHUTxkQvy77HTW4OrDb3O3S7Fa8
 uysNRcd2jK1wKy7wI5DscMNFfixjbFhu+8BLs0V63g0Z6VlQS7QvvUgdnVnGfgW0lhW/dUAQd
 kSHtTVMiJo2VmIY4fhOqFgBmfjw7ThQjnxJ9rY1bjrRBwzQYC0liLCecpRiLmPl5+/dTwUd4o
 9akFw3jXqnrEPVXFSuMLYifDmUvEeKZy0x0WLAIG0IU4uMltluimwFgfGpidDK9jCvzRg1Npq
 LIq508IHG7Vel5d108AqhEjmFwc=
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2022/12/20 08:01, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Generate the section report between tests so that the summary report
> always reflects the outcome of the most recent test.  Two usecases are
> envisioned here -- if a cluster-based test runner anticipates that the
> testrun could crash the VM, they can set REPORT_DIR to (say) an NFS
> mount to preserve the intermediate results.  If the VM does indeed
> crash, the scheduler can examine the state of the crashed VM and move
> the tests to another VM.  The second usecase is a reporting agent that
> runs in the VM to upload live results to a test dashboard.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>   check |   10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> 
> diff --git a/check b/check
> index 1ff0f44af1..70a0b537b1 100755
> --- a/check
> +++ b/check
> @@ -842,6 +842,16 @@ function run_section()
>   		fi
>   		seqres="$REPORT_DIR/$seqnum"
>   
> +		# Generate the entire section report with whatever test results
> +		# we have so far.  Leave the $sect_time parameter empty so that
> +		# it's a little more obvious that this test run is incomplete.
> +		if $do_report; then
> +			local sect_now=`_wallclock`
> +			_make_section_report "$section" "${#try[*]}" \
> +					     "${#bad[*]}" "${#notrun[*]}" \
> +					     "" &> /dev/null
> +		fi
> +

In fact that's exactly what I just wanted to do next...

However one problem I can't work around is the timestamp.

Currently our timestamp is the finish time, with this change our 
timestamp is the start time.

I'm not sure if there is any strong definition on the timestamp, but 
personally speaking, timestamp for the start time makes more sense to me.
But there may be some users relying on the timestamp to be the ending time?

Thanks,
Qu

>   		mkdir -p $RESULT_DIR
>   		rm -f ${RESULT_DIR}/require_scratch*
>   		rm -f ${RESULT_DIR}/require_test*
> 
