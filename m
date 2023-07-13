Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5669AEB64DA
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Jul 2023 00:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjGMA6G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 12 Jul 2023 20:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbjGMA6F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jul 2023 20:58:05 -0400
Received: from smtp2.onthe.net.au (smtp2.onthe.net.au [203.22.196.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA4612710
        for <linux-xfs@vger.kernel.org>; Wed, 12 Jul 2023 17:57:46 -0700 (PDT)
Received: from localhost (smtp2.private.onthe.net.au [10.200.63.13])
        by smtp2.onthe.net.au (Postfix) with ESMTP id 140244D4;
        Thu, 13 Jul 2023 10:57:45 +1000 (AEST)
Received: from smtp2.onthe.net.au ([10.200.63.13])
        by localhost (smtp.onthe.net.au [10.200.63.13]) (amavisd-new, port 10024)
        with ESMTP id ADyYh0iDVaDV; Thu, 13 Jul 2023 10:57:44 +1000 (AEST)
Received: from athena.private.onthe.net.au (chris-gw2-vpn.private.onthe.net.au [10.9.3.2])
        by smtp2.onthe.net.au (Postfix) with ESMTP id E649627;
        Thu, 13 Jul 2023 10:57:44 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=onthe.net.au;
        s=default; t=1689209864;
        bh=PsA7KkTWEe6bH2193jswo5V2Mko3rfRcfUEIvynSXQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sdJjAjKQR1Z1g0+RC6UwtFHVhFwLgb1+TD1nYsDWg0UdHk/qA7DmDRY7cDaJD9an5
         4ew7NpAPvz5yvMAGubKQZ8ibsk+p7m2OQzz4m7ZDbmLqJA4axaUtDRjZDqNGPqcmKq
         aZ6QQtYeGxD2PkOq8GN6ON0U/+t8VVyYanZGkKR3w9iHDP4gGtcFyOWAZ2pTUVwN0c
         AGTPfnrR30bKM4FUs1/tdK3d3+oIX/NxG12Te3vqknABWph69e8RB35h8FDF7uL6Jv
         Nrg88Rn52FgJ/LQD8/8d6Ij/PeTpCTaMnvnKyuSg8eCLT5WBy+PEnq9cI241LBKNEr
         M9vE9FzexJaVw==
Received: by athena.private.onthe.net.au (Postfix, from userid 1026)
        id C734968061C; Thu, 13 Jul 2023 10:57:44 +1000 (AEST)
Date:   Thu, 13 Jul 2023 10:57:44 +1000
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
Message-ID: <20230713005744.GA1043347@onthe.net.au>
References: <20230711001331.GA683098@onthe.net.au>
 <20230711015716.GA687252@onthe.net.au>
 <ZKzIE6m+iCEd+ZWk@dread.disaster.area>
 <20230711070530.GA761114@onthe.net.au>
 <ZK3V1wQ6jQCxtTZJ@dread.disaster.area>
 <20230712011356.GB886834@onthe.net.au>
 <ZK4E/gGuaBu+qvKL@dread.disaster.area>
 <20230712021713.GA902741@onthe.net.au>
 <CAOQ4uxi1h323CPy2J2=MA5H630Uv6FCfxhnrJ7GSzD5NzXuzfg@mail.gmail.com>
 <20230713003104.GA1039855@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230713003104.GA1039855@onthe.net.au>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 13, 2023 at 10:31:04AM +1000, Chris Dunlop wrote:
> On Wed, Jul 12, 2023 at 12:26:54PM +0300, Amir Goldstein wrote:
>> On Wed, Jul 12, 2023 at 5:37 AM Chris Dunlop <chris@onthe.net.au> wrote:
>>>
>>> Request for backport to v5.15:
>>>
>>> 5e672cd69f0a xfs: non-blocking inodegc pushes
>>
>> This is not the subject of above commit, it was the
>> subject of the cover letter:
>> https://www.spinics.net/lists/linux-xfs/msg61813.html
>>
>> containing the following upstream commits:
>> 7cf2b0f9611b xfs: bound maximum wait time for inodegc work
>> 5e672cd69f0a xfs: introduce xfs_inodegc_push()
> ...
>> Leah has already queued these two patches for 5.15 backport,
>> but she is now on sick leave, so that was not done yet.
>>
>> We did however, identify a few more inodegc fixes from 6.4,
>> which also fix a bug in one of the two commits above:
>>
>> 03e0add80f4c xfs: explicitly specify cpu when forcing inodegc delayed
>> work to run immediately
>>  Fixes: 7cf2b0f9611b ("xfs: bound maximum wait time for inodegc work")
>> b37c4c8339cd xfs: check that per-cpu inodegc workers actually run on that cpu
>> 2254a7396a0c xfs: fix xfs_inodegc_stop racing with mod_delayed_work
>>  Fixes: 6191cf3ad59f ("xfs: flush inodegc workqueue tasks before cancel")
>>
>> 6191cf3ad59f ("xfs: flush inodegc workqueue tasks before cancel") has already
>> been applied to 5.15.y.
>>
>> stable tree rules require that the above fixes from 6.4 be applied to 6.1.y
>> before 5.15.y, so I have already tested them and they are ready to be posted.
>> I wanted to wait a bit after the 6.4.0 release to make sure that we did not pull
>> the blanket too much to the other side, because as the reports from Chris
>> demonstrate, the inodegc fixes had some unexpected outcomes.
>
> Just to clarify: whilst I updated to 6.1 specifically to gain access 
> to the non-blocking inodegc commits, there's no evidence those inodegc 
> commits had anything at all to do with my issue on 6.1, and Dave's 
> sense is that they probably weren't involved.
>
> That said, those "Fixes:" commits that haven't yet made it to 6.1 look 
> at least a little suspicious to my naive eye.

Hmmm.... in particular, this fix:

2254a7396a0c xfs: fix xfs_inodegc_stop racing with mod_delayed_work
  Fixes: 6191cf3ad59f ("xfs: flush inodegc workqueue tasks before cancel")

mentions:

----
For this to trip, we must have a thread draining the inodedgc workqueue
and a second thread trying to queue inodegc work to that workqueue.
This can happen if freezing or a ro remount race with reclaim poking our
faux inodegc shrinker and another thread dropping an unlinked O_RDONLY
file:
----

I'm indeed periodically freezing these filesystems to take snapshots.

So that could possibly be the source of my problem, although my kernel log 
does not have the WARN_ON_ONCE() mentioned in the patch.

Cheers,

Chris
