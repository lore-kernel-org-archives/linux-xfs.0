Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC33C00140
	for <linux-xfs@archiver.kernel.org>; Thu, 18 Aug 2022 21:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346528AbiHRVIJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Aug 2022 17:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346520AbiHRVHX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Aug 2022 17:07:23 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF0EA30D;
        Thu, 18 Aug 2022 14:03:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-52-176.pa.nsw.optusnet.com.au [49.181.52.176])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A681E62D490;
        Fri, 19 Aug 2022 07:03:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oOmfL-00EjSC-6k; Fri, 19 Aug 2022 07:02:59 +1000
Date:   Fri, 19 Aug 2022 07:02:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Petr Vorel <pvorel@suse.cz>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
        Hannes Reinecke <hare@suse.de>, linux-xfs@vger.kernel.org,
        ltp@lists.linux.it
Subject: Re: LTP test df01.sh detected different size of loop device in v5.19
Message-ID: <20220818210259.GG3600936@dread.disaster.area>
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
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62fea908
        a=O3n/kZ8kT9QBBO3sWHYIyw==:117 a=O3n/kZ8kT9QBBO3sWHYIyw==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=goNm9uWxpVm3eJU7WO0A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
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

For a single 1MB file? inodegc is delayed 1 jiffie (max 10ms).
If it's processed immediately because everything else is idle and
nothing blocks, it will be done in 250-500 microsends.

Of course, the moment you put such tests in a VM on a host that is
running other VMs nothing is ever idle and inodegc delays are
outside the control of the guest kernel/filesystem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
