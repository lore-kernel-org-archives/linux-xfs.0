Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EA8C77B7A
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Jun 2023 11:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbjFFLXn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 07:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjFFLXm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Jun 2023 07:23:42 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55CDE55
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2023 04:23:40 -0700 (PDT)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1q6Uml-0001ej-VO; Tue, 06 Jun 2023 13:23:36 +0200
Message-ID: <0e702e19-cc93-77ac-bd1d-401b8883fc0b@leemhuis.info>
Date:   Tue, 6 Jun 2023 13:23:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: xfs: system fails to boot up due to Internal error
 xfs_trans_cancel
Content-Language: en-US, de-DE
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     Linux regressions mailing list <regressions@lists.linux.dev>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        shrikanth hegde <sshegde@linux.vnet.ibm.com>,
        dchinner@redhat.com, linux-xfs@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        ojaswin@linux.ibm.com
References: <87zg88atiw.fsf@doe.com>
 <33c9674c-8493-1b23-0efb-5c511892b68a@leemhuis.info>
 <20230418045615.GC360889@frogsfrogsfrogs>
 <57eeb4d5-01de-b443-be8e-50b08c132e95@leemhuis.info>
 <20230605215745.GC1325469@frogsfrogsfrogs>
 <ZH6d938Hw/msm95A@dread.disaster.area>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <ZH6d938Hw/msm95A@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1686050620;7911ab33;
X-HE-SMSGID: 1q6Uml-0001ej-VO
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 06.06.23 04:46, Dave Chinner wrote:
> On Mon, Jun 05, 2023 at 02:57:45PM -0700, Darrick J. Wong wrote:
>> On Mon, Jun 05, 2023 at 03:27:43PM +0200, Thorsten Leemhuis wrote:
>>> /me waves friendly
>>>
>>> On 18.04.23 06:56, Darrick J. Wong wrote:
>>>> On Mon, Apr 17, 2023 at 01:16:53PM +0200, Linux regression tracking (Thorsten Leemhuis) wrote:
>>>>> Hi, Thorsten here, the Linux kernel's regression tracker. Top-posting
>>>>> for once, to make this easily accessible to everyone.
>>>>>
>>>>> Has any progress been made to fix below regression? It doesn't look like
>>>>> it from here, hence I wondered if it fall through the cracks. Or is
>>>>> there some good reason why this is safe to ignore?
>>>>
>>>> Still working on thinking up a reasonable strategy to reload the incore
>>>> iunlink list if we trip over this.  Online repair now knows how to do
>>>> this[1], but I haven't had time to figure out if this will work
>>>> generally.  [...]
>>>
>>> I still have this issue on my list of tracked regressions, hence please
>>> allow me to ask: was there any progress to resolve this? Doesn't look
>>> like it, but from my point it's easy to miss something.
>>
>> Yeah

BTW, many thx for your detailed answer.

>> -- Dave put "xfs: collect errors from inodegc for unlinked inode
>> recovery" in for-next yesterday, and I posted a draft of online repair
>> for the unlinked lists that corrects most of the other problems that we
>> found in the process of digging into this problem:
>> https://lore.kernel.org/linux-xfs/168506068642.3738067.3524976114588613479.stgit@frogsfrogsfrogs/T/#m861e4b1259d9b16b9970e46dfcfdae004a5dd634
>>
>> But that's looking at things from the ground up, which isn't terribly
>> insightful as to what's going on, as you've noted. :)

Let me just mark this regression as resolved in the tracking then; this
is, well, clearly not your typical every day regression and at the same
time something your clearly work on resolving, hence not really worth
tracking, as there are bigger fish to fry.

#regzbot inconclusive: pretty special regression; fix for part of it now
in -next, work ongoing to solve other parts (see discussion)

>>> BTW, in case this was not yet addressed: if you have a few seconds,
>>> could you please (just briefly!) explain why it seems to take quite a
>>> while to resolve this? A "not booting" regressions sounds like something
>>> that I'm pretty sure Linus normally wants to see addressed rather sooner
>>> than later. But that apparently is not the case here. I know that XFS
>>> devs normally take regressions seriously, hence I assume there are good
>>> reasons for it. But I'd like to roughly understand them (is this a
>>> extremely corner case issue others are unlike to run into or something
>>> like that?), as I don't want Linus on my back with questions like "why
>>> didn't you put more pressure on the XFS maintainers" or "you should have
>>> told me about this".
>>
>> First things first -- Ritesh reported problems wherein a freshly mounted
>> filesystem would fail soon after because of some issue or other with the
>> unlinked inode list.  He could reproduce this problem, but (AFAIK) he's
>> the only user who's actually reported this.  It's not like *everyone*
>> with XFS cannot boot anymore, it's just this system.  Given the sparsity
>> of any other reports with similar symptoms, I do not judge this to be
>> a hair-on-fire situation.

Definitely; don't worry, I noticed that, otherwise I'd have made more
noise early. :-D

>> (Contrast this to the extent busy deadlock problem that Wengang Wang is
>> trying to solve, which (a) is hitting many customer systems and (b)
>> regularly.  Criteria like (a) make things like that a higher severity
>> problem IMHO.)
> 
> Contrast this to the regression from 6.3-rc1 that caused actual user
> data loss and filesystem corruption after 6.3 was released.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=2208553
> 
> That's so much more important than any problem seen in a test
> environment it's not funny.
> 
> We'd already fixed this regression that caused it in 6.4-rc1 - the
> original bug report (a livelock in data writeback) happened 2 days
> before 6.3 released. It took me 3 days from report to having a fix
> out for review (remember that timeframe).
> 
> At the time we didn't recognise the wider corruption risk the
> failure we found exposed us to, so we didn't push it to stable
> immediately. Hence when users started tripping over corruption and I
> triaged it down to misdirected data write from -somewhere-. Eric
> then found a reproducer and bisected to a range of XFS changes, and
> I then realised what the problem was....
> 
> Stuff like this takes days of effort and multiple people to get to
> the bottom of, and -everything else- gets ignored while we work
> through the corruption problem.

Yeah, and many other developers are good as this as well; that's why I
don't even add some regressions to the tracking I notice. And I'm also
well aware that I only notice some regressions once Linus mainlines a fix.

But nevertheless my tracking helps in quite a few cases, as developers
sometimes are humans and let things fall through the cracks. And there
always have and still are developers and subsystems are not as good as
XFS and don't handle regressions like Linus wants them to be handled. I
also help reporters to reach the right developers and improve their bug
reports (e.g. by telling them to bisect and things like that). Guess all
that is why Linus and Greg apparently seem happy about my work.

That being said: there still a lot of room for improvements, but it's a
start.

> Thorsten, I'm betting that you didn't even know about this
> regression - 

Then you lost your bet. ;) I can even prove that I saw the "[PATCH,
STABLE 6.3.x] xfs: fix livelock in delayed allocation at ENOSPC" mail
https://fosstodon.org/@kernellogger/110446215848501171

But I'm pretty sure I was aware of it earlier already and decided to not
interfere, as you clearly were working on it with the required priority
(thx for that, btw).

> it's been reported, tracked, triaged and fixed
> completely outside the scope and visibility of the "kernel
> regression tracker". Which clearly shows that we don't actually need
> some special kernel regression tracker infrastructure to do our jobs
> properly, nor do we need a nanny to make sure we actually are
> prioritising things correctly....
> ....

I'm not getting into that discussion. Convince Linus and Greg that my
work is not worth it at all; if it hear it from them I'll stop.

Ciao, Thorsten
