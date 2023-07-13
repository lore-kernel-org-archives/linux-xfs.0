Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E10BEB64DA
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 00:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbjGMAbK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 20:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjGMAbJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 20:31:09 -0400
Received: from smtp2.onthe.net.au (smtp2.onthe.net.au [203.22.196.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E729B2111
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 17:31:07 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp2.onthe.net.au (Postfix) with ESMTP id 7674D649;
        Thu, 13 Jul 2023 10:31:05 +1000 (AEST)
Received: from smtp2.onthe.net.au ([10.200.63.13])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10024)
        with ESMTP id y-W5srrCSn0V; Thu, 13 Jul 2023 10:31:05 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp2.onthe.net.au (Postfix) with ESMTP id 11A92377;
        Thu, 13 Jul 2023 10:31:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=onthe.net.au;
        s=default; t=1689208265;
        bh=Cmk5jjgg8GADPzNBsWuZ3fPdlPsya5dr3VaSHopN6vU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fWVkTzM1c2KkNkE+huBEgucPncgQ2THh9mbrDtsFpcGi7Y5pOVFG44pQPuSF7dc6c
         itSNhgR+eN8aPjzH2PzmPwFAQqi1RAPc6ZY5nQl1Gi2Uw7VUL0jjGb/fa2SXIgWmMA
         mggZP60NacR8O7RQNur/jbOjGKuuQyiMEec42K5JybbRZEH2gfijF3YonfrG+uytwa
         /Bf6by8dunR7Vrj/TQEWKrb9fuNR3C80GxE9XLAbdO2NbBB+AHQrhAzN2ABMDrflf1
         w+P2JpjMjUwql+OLVotF6gDcYEPlvhgzfKZ0XDkU5XbkdSFwJFhJIEDhmSlchqD2iH
         FFdBH/9LQMabQ==
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id E960B68061C; Thu, 13 Jul 2023 10:31:04 +1000 (AEST)
Date:   Thu, 13 Jul 2023 10:31:04 +1000
From:   Chris Dunlop <chris@onthe.net.au>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <lrumancik@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        Leah Rumancik <leah.rumancik@gmail.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: Subject: v5.15 backport - 5e672cd69f0a xfs: non-blocking inodegc
 pushes
Message-ID: <20230713003104.GA1039855@onthe.net.au>
References: <20230710215354.GA679018@onthe.net.au>
 <20230711001331.GA683098@onthe.net.au>
 <20230711015716.GA687252@onthe.net.au>
 <ZKzIE6m+iCEd+ZWk@dread.disaster.area>
 <20230711070530.GA761114@onthe.net.au>
 <ZK3V1wQ6jQCxtTZJ@dread.disaster.area>
 <20230712011356.GB886834@onthe.net.au>
 <ZK4E/gGuaBu+qvKL@dread.disaster.area>
 <20230712021713.GA902741@onthe.net.au>
 <CAOQ4uxi1h323CPy2J2=MA5H630Uv6FCfxhnrJ7GSzD5NzXuzfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxi1h323CPy2J2=MA5H630Uv6FCfxhnrJ7GSzD5NzXuzfg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 12, 2023 at 12:26:54PM +0300, Amir Goldstein wrote:
> On Wed, Jul 12, 2023 at 5:37 AM Chris Dunlop <chris@onthe.net.au> wrote:
>>
>> Request for backport to v5.15:
>>
>> 5e672cd69f0a xfs: non-blocking inodegc pushes
>
> This is not the subject of above commit, it was the
> subject of the cover letter:
> https://www.spinics.net/lists/linux-xfs/msg61813.html
>
> containing the following upstream commits:
> 7cf2b0f9611b xfs: bound maximum wait time for inodegc work
> 5e672cd69f0a xfs: introduce xfs_inodegc_push()
...
> Leah has already queued these two patches for 5.15 backport,
> but she is now on sick leave, so that was not done yet.
>
> We did however, identify a few more inodegc fixes from 6.4,
> which also fix a bug in one of the two commits above:
>
> 03e0add80f4c xfs: explicitly specify cpu when forcing inodegc delayed
> work to run immediately
>   Fixes: 7cf2b0f9611b ("xfs: bound maximum wait time for inodegc work")
> b37c4c8339cd xfs: check that per-cpu inodegc workers actually run on that cpu
> 2254a7396a0c xfs: fix xfs_inodegc_stop racing with mod_delayed_work
>   Fixes: 6191cf3ad59f ("xfs: flush inodegc workqueue tasks before cancel")
>
> 6191cf3ad59f ("xfs: flush inodegc workqueue tasks before cancel") has already
> been applied to 5.15.y.
>
> stable tree rules require that the above fixes from 6.4 be applied to 6.1.y
> before 5.15.y, so I have already tested them and they are ready to be posted.
> I wanted to wait a bit after the 6.4.0 release to make sure that we did not pull
> the blanket too much to the other side, because as the reports from Chris
> demonstrate, the inodegc fixes had some unexpected outcomes.

Just to clarify: whilst I updated to 6.1 specifically to gain access to 
the non-blocking inodegc commits, there's no evidence those inodegc 
commits had anything at all to do with my issue on 6.1, and Dave's sense 
is that they probably weren't involved.

That said, those "Fixes:" commits that haven't yet made it to 6.1 look at 
least a little suspicious to my naive eye.

> Anyway, it is 6.4.3 already and I haven't seen any shouts on the list,
> plus the 6.4 fixes look pretty safe, so I guess this is a good time for me
> to post the 6.1.y backports.
>
> w.r.t testing and posting the 5.15.y backports, we currently have a problem.
> Chandan said that he will not have time to fill in for Leah and I don't have
> a baseline established for 5.15 and am going on vacation next week anyway.
>
> So either Chandan can make an exception for this inodegc series, or it will
> have to wait for Leah to be back.

I might gird my loins and try 6.1 again once those further fixes are in.


Cheers,

Chris
