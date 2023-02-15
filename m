Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1606C6379F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Feb 2023 02:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjBOCHA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Feb 2023 21:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBOCG7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2023 21:06:59 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE5823852;
        Tue, 14 Feb 2023 18:06:56 -0800 (PST)
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1M3DJl-1pP4vI0yXV-003bQm; Wed, 15
 Feb 2023 03:06:46 +0100
Message-ID: <9de304cc-2960-33ad-65dd-6c28e849dbaf@gmx.com>
Date:   Wed, 15 Feb 2023 10:06:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     zlang@redhat.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, leah.rumancik@gmail.com
References: <167149446381.332657.9402608531757557463.stgit@magnolia>
 <167149446946.332657.17186597494532662986.stgit@magnolia>
 <f447b1ab-ce5d-a736-6427-d1a3f33d20cf@gmx.com> <Y+vXEjKI08PXe95J@magnolia>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: [PATCH 1/8] check: generate section reports between tests
In-Reply-To: <Y+vXEjKI08PXe95J@magnolia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:NKyIdq2ItAJ0C5x7dSvaKXeRpcuc/SvQVe62huEqIc02oHYnolx
 K2KXPfN7yiVbsBPI5e9qzk39+ujee03d6MQ8lVUU82d51rpgrx8B9b26nIm+UYgFY2pQoGl
 CAK0oVzRQPrJIbfbLQ+5M4W72DxXlJ1f0408a/SYhbo+U7SggHicVW1MZ02fvj2O7hc1Ct5
 7m29+37M8z74tEnrW4sfg==
UI-OutboundReport: notjunk:1;M01:P0:EshktBQOcpw=;zQ5I9UIpJoeyzxIepNKRUFbc0YR
 mOvR/XBteK/nNxVsaZGUtMYRVCL6otDXCtBXD18KB/alHIgUu7snAWzW3mjvJ3wsOCSROTnru
 k7A5gqWCtGIdIUon6bvG9lUXGEWhHjsB0HB9Kkq9KWOPjBqMSTsvTBTBaFMrJlykw5zt9tSGd
 NjzgHHLTKOCmeIj7eSVAFsPHd+wryn8E5ITNSSWlMcSIJa8x4zdQuJ2uFJKrphvxy7zKxU3Zg
 ey6QjEKaF1cLBw6oI+OrW2kslkdM0HUeDXLLStdJkg2iiZzfleyEMdLXdM6pzxrxQMP7Juvsd
 x5gcMQNOOzhEKjvRNId0DzLC8fwutHq7QzFaFb8jf9Yag9rwd4G/5H2GN6myd8m4kOZpEUPlN
 XKkywYS316Ytsq2oxyUaGO6qtbn7NiCS4tHqAyaK3HfJtR465IYYanyA9qqozA4dcDw3nO2jA
 Vxc1Oju0V/l8Tv3qftT92sdIVen0wa27qoqDwcYh8t9LI3faiCmbPc1UOnMn0nItEJb+ouE6+
 569dfSux362vBIAiTq5o1Vl5r4ZoK9GUBV51aFHNW/8xScjUmDDA7E4OTSE2gKTi8+9Sh2KuO
 64f09kEZRPZhvrnleR9I6fGxCwSJXSYbCgLjiZrpJJll8tx9mk63rvWg5o36Ew6UNaBbB1Tg2
 wSmGktbP4JK5uvtpNOvMYDaaDlJRbc9hX/vLJwYFw6cvyCxzAKlOsYXmsNecyt81trRc7EK+V
 Ui6tGxp1UUporQnnbfSSoE0YzBgOEunZlAhLOx2mEIa/cUTiOW494IAg97hDCzIp5tb8dl6RJ
 GI/cdMeVmgWXIo0l+wpMrSzG6E3B1iq/Ok2wsf7fkxGsI/NfpDD9PYJlCfj1nHZhwhomNqeKi
 RiMncsCdEdTwHdJFrvWievvXL7P4l3bxjwFoHyMgfqITvL6A6alRgF2MAjiWAboCQwma1eREU
 uwWm7CzzDvX11HQzp7TNoiXLFfM=
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 2023/2/15 02:46, Darrick J. Wong wrote:
> On Tue, Dec 20, 2022 at 09:14:07AM +0800, Qu Wenruo wrote:
>>
>>
>> On 2022/12/20 08:01, Darrick J. Wong wrote:
>>> From: Darrick J. Wong <djwong@kernel.org>
>>>
>>> Generate the section report between tests so that the summary report
>>> always reflects the outcome of the most recent test.  Two usecases are
>>> envisioned here -- if a cluster-based test runner anticipates that the
>>> testrun could crash the VM, they can set REPORT_DIR to (say) an NFS
>>> mount to preserve the intermediate results.  If the VM does indeed
>>> crash, the scheduler can examine the state of the crashed VM and move
>>> the tests to another VM.  The second usecase is a reporting agent that
>>> runs in the VM to upload live results to a test dashboard.
>>>
>>> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
>>> ---
>>>    check |   10 ++++++++++
>>>    1 file changed, 10 insertions(+)
>>>
>>>
>>> diff --git a/check b/check
>>> index 1ff0f44af1..70a0b537b1 100755
>>> --- a/check
>>> +++ b/check
>>> @@ -842,6 +842,16 @@ function run_section()
>>>    		fi
>>>    		seqres="$REPORT_DIR/$seqnum"
>>> +		# Generate the entire section report with whatever test results
>>> +		# we have so far.  Leave the $sect_time parameter empty so that
>>> +		# it's a little more obvious that this test run is incomplete.
>>> +		if $do_report; then
>>> +			local sect_now=`_wallclock`
>>> +			_make_section_report "$section" "${#try[*]}" \
>>> +					     "${#bad[*]}" "${#notrun[*]}" \
>>> +					     "" &> /dev/null
>>> +		fi
>>> +
>>
>> In fact that's exactly what I just wanted to do next...
>>
>> However one problem I can't work around is the timestamp.
>>
>> Currently our timestamp is the finish time, with this change our timestamp
>> is the start time.
> 
> Er... what do you mean exactly by start and finish time?  The most
> recent test?  The entire run?

Personally speaking, I'd prefer start/finish time of the whole 
suite/section at least.

> 
>  From check:
> 
> 	if [ -w /dev/kmsg ]; then
> 		export date_time=`date +"%F %T"`
> 		echo "run fstests $seqnum at $date_time" > /dev/kmsg
> 		...
> 	fi
> 
>  From common/report:
> 
> 	if [ -z "$date_time" ]; then
> 		date_time=$(date +"%F %T")
> 	fi
> 
> 	...timestamp="${date_time/ /T}">
> 
> The "date_time" variable can be set by ./check just prior to starting
> each test, but only if /dev/kmsg is a writable file.  If it's set, then
> the timestamp in the xml file reflects the start time of the most recent
> test.
> 
> If date_time is not set, then the timestamp in the xml file records the
> point in time when the report is generated... which I suppose is a good
> enough estimate if we failed to record date_time when the test was
> started. >
>> I'm not sure if there is any strong definition on the timestamp, but
>> personally speaking, timestamp for the start time makes more sense to me.
>> But there may be some users relying on the timestamp to be the ending time?
> 
> The junit xml schema says that the timestamp should be "when the test
> was executed".  I think ./check ought to be setting date_time regardless
> of /dev/kmsg.  ATM my test dashboard computes the difference between now
> and the timestamp= attribute of the last report received to decide if it
> should flag a test VM as possibly stalled.
> 
> Though to undercut everything I just wrote, the junit xml schema defines
> testsuite and testcase as distinct entities and then refers to "the
> test".
> 
> Given that fstests doesn't strictly follow that schema anyway, I guess
> we can define the timestamp as we want, or add more timestamp
> attributes?
> 
> <testsuite suite_timestamp="..." timestamp="..." report_timestamp="..."...>

OK, then this looks much better.

Thanks,
Qu

> 
> --D
> 
>> Thanks,
>> Qu
>>
>>>    		mkdir -p $RESULT_DIR
>>>    		rm -f ${RESULT_DIR}/require_scratch*
>>>    		rm -f ${RESULT_DIR}/require_test*
>>>
