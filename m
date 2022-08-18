Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC996C00140
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Aug 2022 16:27:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343573AbiHRQ1g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Aug 2022 12:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344768AbiHRQ1Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Aug 2022 12:27:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE319E0E;
        Thu, 18 Aug 2022 09:27:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D95A6159B;
        Thu, 18 Aug 2022 16:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F1CC433C1;
        Thu, 18 Aug 2022 16:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660840043;
        bh=+y9aJbWtiam2o1FbJCokyrxLMhC6wEx/VJe+9gMP4BM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HCYTENFSNzfPwqtXc6baKz8uyObAhcMjLQlI+gZ8nUjLQSDv6obQGrZAPwpybp3Ni
         M5T5gYDlcwSfZ8rcdejnIZFt9gNcaTQK9dUGkPuJU+9+SgpTWnV9cFO6aaro1/y/Mh
         GCW3ltEWKlQFmsVAKNeyPfbBHIsg22HV+uYWDeFRTJBKBHp1Bwg0HLQg1scBTP4rcG
         UtUoJjcFZbk1gH55MomnQ99FgmvkNlNYGcOvTlPyi0kL7Wfjqk1iaTakwjj6XMo2AF
         ZkWhHAVE3fxY+Hnv8b0Gyjb/fnc12vBdvJvsP2z82xIp/DtPPPRp2BrAmE5gj8usnI
         S9SYzLgOaxPbg==
Date:   Thu, 18 Aug 2022 09:27:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Petr Vorel <pvorel@suse.cz>, Dave Chinner <david@fromorbit.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Jan Kara <jack@suse.cz>, Hannes Reinecke <hare@suse.de>,
        linux-xfs@vger.kernel.org, ltp@lists.linux.it
Subject: Re: LTP test df01.sh detected different size of loop device in v5.19
Message-ID: <Yv5oaxsX6z2qxxF3@magnolia>
References: <YvZc+jvRdTLn8rus@pevik>
 <YvZUfq+3HYwXEncw@pevik>
 <YvZTpQFinpkB06p9@pevik>
 <20220814224440.GR3600936@dread.disaster.area>
 <YvoSeTmLoQVxq7p9@pevik>
 <8d33a7a0-7a7c-47a1-ed84-83fd25089897@sandeen.net>
 <Yv5Z7eu5RGnutMly@pevik>
 <f03c6929-9a14-dd58-3726-dd2c231d0981@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f03c6929-9a14-dd58-3726-dd2c231d0981@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 18, 2022 at 11:05:33AM -0500, Eric Sandeen wrote:
> On 8/18/22 10:25 AM, Petr Vorel wrote:
> > Hi Eric, all,
> > 
> 
> ...
> 
> > 
> >> IOWS, I think the test expects that free space is reflected in statfs numbers
> >> immediately after a file is removed, and that's no longer the case here. They
> >> change in between the df check and the statfs check.
> > 
> >> (The test isn't just checking that the values are correct, it is checking that
> >> the values are /immediately/ correct.)
> > 
> >> Putting a "sleep 1" after the "rm -f" in the test seems to fix it; IIRC
> >> the max time to wait for inodegc is 1s. This does slow the test down a bit.
> > 
> > Sure, it looks like we can sleep just 50ms on my hw (although better might be to
> > poll for the result [1]), I just wanted to make sure there is no bug/regression
> > before hiding it with sleep.
> > 
> > Thanks for your input!
> > 
> > Kind regards,
> > Petr
> > 
> > [1] https://people.kernel.org/metan/why-sleep-is-almost-never-acceptable-in-tests
> > 
> >> -Eric
> > 
> > +++ testcases/commands/df/df01.sh
> > @@ -63,6 +63,10 @@ df_test()
> >  		tst_res TFAIL "'$cmd' failed."
> >  	fi
> >  
> > +	if [ "$DF_FS_TYPE" = xfs ]; then
> > +		tst_sleep 50ms
> > +	fi
> > +
> 
> Probably worth at least a comment as to why ...
> 
> Dave / Darrick / Brian - I'm not sure how long it might take to finish inodegc?
> A too-short sleep will let the flakiness remain ...

A fsfreeze -f / fsfreeze -u cycle will force all the background garbage
collection to run to completion when precise free space accounting is
being tested.

--D

> -Eric
> 
> >  	ROD_SILENT rm -rf mntpoint/testimg
> >  
> >  	# flush file system buffers, then we can get the actual sizes.
> > 
