Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34336C00140
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Aug 2022 16:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343731AbiHRQFg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Aug 2022 12:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245340AbiHRQFf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Aug 2022 12:05:35 -0400
Received: from sandeen.net (sandeen.net [63.231.237.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E1F94BC100;
        Thu, 18 Aug 2022 09:05:34 -0700 (PDT)
Received: from [10.0.0.146] (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id C3C2F514E45;
        Thu, 18 Aug 2022 11:04:10 -0500 (CDT)
Message-ID: <f03c6929-9a14-dd58-3726-dd2c231d0981@sandeen.net>
Date:   Thu, 18 Aug 2022 11:05:33 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Content-Language: en-US
To:     Petr Vorel <pvorel@suse.cz>
Cc:     Dave Chinner <david@fromorbit.com>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Hannes Reinecke <hare@suse.de>, linux-xfs@vger.kernel.org,
        ltp@lists.linux.it
References: <YvZc+jvRdTLn8rus@pevik> <YvZUfq+3HYwXEncw@pevik>
 <YvZTpQFinpkB06p9@pevik> <20220814224440.GR3600936@dread.disaster.area>
 <YvoSeTmLoQVxq7p9@pevik> <8d33a7a0-7a7c-47a1-ed84-83fd25089897@sandeen.net>
 <Yv5Z7eu5RGnutMly@pevik>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: LTP test df01.sh detected different size of loop device in v5.19
In-Reply-To: <Yv5Z7eu5RGnutMly@pevik>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/18/22 10:25 AM, Petr Vorel wrote:
> Hi Eric, all,
> 

...

> 
>> IOWS, I think the test expects that free space is reflected in statfs numbers
>> immediately after a file is removed, and that's no longer the case here. They
>> change in between the df check and the statfs check.
> 
>> (The test isn't just checking that the values are correct, it is checking that
>> the values are /immediately/ correct.)
> 
>> Putting a "sleep 1" after the "rm -f" in the test seems to fix it; IIRC
>> the max time to wait for inodegc is 1s. This does slow the test down a bit.
> 
> Sure, it looks like we can sleep just 50ms on my hw (although better might be to
> poll for the result [1]), I just wanted to make sure there is no bug/regression
> before hiding it with sleep.
> 
> Thanks for your input!
> 
> Kind regards,
> Petr
> 
> [1] https://people.kernel.org/metan/why-sleep-is-almost-never-acceptable-in-tests
> 
>> -Eric
> 
> +++ testcases/commands/df/df01.sh
> @@ -63,6 +63,10 @@ df_test()
>  		tst_res TFAIL "'$cmd' failed."
>  	fi
>  
> +	if [ "$DF_FS_TYPE" = xfs ]; then
> +		tst_sleep 50ms
> +	fi
> +

Probably worth at least a comment as to why ...

Dave / Darrick / Brian - I'm not sure how long it might take to finish inodegc?
A too-short sleep will let the flakiness remain ...

-Eric

>  	ROD_SILENT rm -rf mntpoint/testimg
>  
>  	# flush file system buffers, then we can get the actual sizes.
> 
