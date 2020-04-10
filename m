Return-Path: <SRS0=tPAf=52=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D83D4C2BA19
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Apr 2020 00:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B18EE20768
	for <linux-xfs@archiver.kernel.org>; Fri, 10 Apr 2020 00:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgDJAqo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 20:46:44 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56627 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726859AbgDJAqo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 20:46:44 -0400
Received: from dread.disaster.area (pa49-180-167-53.pa.nsw.optusnet.com.au [49.180.167.53])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id BBA4B3A34CD;
        Fri, 10 Apr 2020 10:46:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jMhob-00065s-97; Fri, 10 Apr 2020 10:46:37 +1000
Date:   Fri, 10 Apr 2020 10:46:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: libelf-0.175 breaks objtool
Message-ID: <20200410004637.GU24067@dread.disaster.area>
References: <20190206021611.2nsqomt6a7wuaket@treble>
 <20190206121638.3d2230c1@gandalf.local.home>
 <CAK8P3a1hsca02=jPQmBG68RTUAt-jDR-qo=UFwf13nZ0k-nDgA@mail.gmail.com>
 <20200406221614.ac2kl3vlagiaj5jf@treble>
 <CAK8P3a3QntCOJUeUfNmqogO51yh29i4NQCu=NBF4H1+h_m_Pug@mail.gmail.com>
 <CAK8P3a2Bvebrvj7XGBtCwV969g0WhmGr_xFNfSRsZ7WX1J308g@mail.gmail.com>
 <20200407163253.mji2z465ixaotnkh@treble>
 <CAK8P3a3piAV7BbgH-y_zqj4XmLcBQqKZ-NHPcqo4OTF=4H3UFA@mail.gmail.com>
 <20200409074130.GD21033@infradead.org>
 <CAK8P3a1mg=53Ab9ZWtRvPSWxq-BUxdsFE2O0FbZeh1++F40mVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a1mg=53Ab9ZWtRvPSWxq-BUxdsFE2O0FbZeh1++F40mVQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=2xmR08VVv0jSFCMMkhec0Q==:117 a=2xmR08VVv0jSFCMMkhec0Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10
        a=JfrnYn6hAAAA:8 a=7-415B0cAAAA:8 a=lf6KfvnyUBwg_oy_4p0A:9
        a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 09, 2020 at 10:25:14AM +0200, Arnd Bergmann wrote:
> On Thu, Apr 9, 2020 at 9:41 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Tue, Apr 07, 2020 at 08:44:11PM +0200, Arnd Bergmann wrote:
> > > That is very possible. The -g has been there since xfs was originally merged
> > > back in 2002, and I could not figure out why it was there (unlike the
> > > -DSTATIC=""
> > > and -DDEBUG flags that are set in the same line).
> > >
> > > On the other hand, my feeling is that setting -g should not cause problems
> > > with objtool, if CONFIG_DEBUG_INFO is ok.
> >
> > I suspect we shouldn't force -g ourselves in xfs.  Care to send a patch?
> 
> Done.
> 
> On a related topic, I noticed how the CONFIG_DEBUG flag used to control
> whether functions marked STATIC get inlined or not, but now they are always
> marked noinline, apparently in an attempt to get more readable object code
> even when not debugging. I also see that during early v2.6, XFS used
> 'STATIC' almost exclusively, while newly added functions tend to use plain
> 'static' instead.
> 
> Is this something worth revisiting to see if inlining would make a difference
> to performance or are you reasonably sure it does not?

The "noinline" here is really "noinline_for_stack", but it predates
the noinline_for_stack annotation and never got updated. i.e.
the noinline was added because of the historic stack usage problems
we had with 4k stacks on x86 and 8k stacks on x86-64. We had to
split large functions up to reduce the number of on-stack variables
in them, but that was then being undone by the compiler deciding to
automatically inline single use static functions.

I know the x86-64 stack issues have gone away now we have
CONFIG_VMAP_STACK, but people can still turn that off so we still
have to be careful about stack usage caused by inlining single use
functions...

Hence I'm not sure we can just remove this - we'd need to go back
and investigate what impact it has on stack usage in the writeback
allocation path and other historic problematic code paths to
determine if they should still be annotated or not. They could be
converted with s/STATIC/static noinline_for_stack/ on a case by case
basis, and then the rest could probably just be case converted with
sed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
