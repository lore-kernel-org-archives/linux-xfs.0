Return-Path: <SRS0=Pnyc=XE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FFE9C00307
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 06:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F39282067D
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 06:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfIIGHD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Sep 2019 02:07:03 -0400
Received: from mga05.intel.com ([192.55.52.43]:17442 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbfIIGHD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Sep 2019 02:07:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Sep 2019 23:07:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,483,1559545200"; 
   d="scan'208";a="186411116"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.6]) ([10.239.13.6])
  by orsmga003.jf.intel.com with ESMTP; 08 Sep 2019 23:07:00 -0700
Subject: Re: [xfs] 610125ab1e: fsmark.app_overhead -71.2% improvement
To:     Dave Chinner <dchinner@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-xfs@vger.kernel.org,
        lkp@01.org
References: <20190909015849.GN15734@shao2-debian> <20190909053236.GP2254@rh>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <df5f4105-58a9-492d-882e-0963fd5cb23f@intel.com>
Date:   Mon, 9 Sep 2019 14:06:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190909053236.GP2254@rh>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Dave,

On 9/9/19 1:32 PM, Dave Chinner wrote:
> On Mon, Sep 09, 2019 at 09:58:49AM +0800, kernel test robot wrote:
>> Greeting,
>>
>> FYI, we noticed a -71.2% improvement of fsmark.app_overhead due to commit:
> A negative improvement? That's somewhat ambiguous...

Sorry for causing the misunderstanding, it's a improvement not a regression.


>
>> 0e822255f95db400 610125ab1e4b1b48dcffe74d9d8
>> ---------------- ---------------------------
>>           %stddev     %change         %stddev
>>               \          |                \
>>   1.095e+08           -71.2%   31557568        fsmark.app_overhead
>>        6157           +95.5%      12034        fsmark.files_per_sec
> So, the files/s rate doubled, and the amount of time spent in
> userspace by the fsmark app dropped by 70%.
>
>>      167.31           -47.3%      88.25        fsmark.time.elapsed_time
>>      167.31           -47.3%      88.25        fsmark.time.elapsed_time.max
> Wall time went down by 50%.
>
>>       91.00            -8.8%      83.00        fsmark.time.percent_of_cpu_this_job_got
>>      148.15           -53.2%      69.38        fsmark.time.system_time
> As did system CPU.
>
> IOWs, this change has changed create performance by a factor of 4 -
> the file create is 2x faster for half the CPU spent.
>
> I don't think this is a negative improvement - it's a large positive
> improvement.  I suspect that you need to change the metric
> classifications for this workload...
To avoid misunderstanding, we'll use fsmark.files_per_sec instead of 
fsmark.app_overhead in the subject.

Best Regards,
Rong Chen
