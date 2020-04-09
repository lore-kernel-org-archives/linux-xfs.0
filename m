Return-Path: <SRS0=CSRb=5Z=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBD4EC2D0EA
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 08:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6A7920784
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Apr 2020 08:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgDIIZd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 04:25:33 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:44103 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgDIIZd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Apr 2020 04:25:33 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1Mgek6-1ioCXY1hfA-00h4ph; Thu, 09 Apr 2020 10:25:32 +0200
Received: by mail-qk1-f170.google.com with SMTP id x66so3117714qkd.9;
        Thu, 09 Apr 2020 01:25:32 -0700 (PDT)
X-Gm-Message-State: AGi0PuaRmb4juulWAfPh2l8kqAvM/i5ediCwczpWfGyPJiU0C2Zfl1h9
        7pTU+JPo51JVRgMNICXhak5sUPJvx+ooL6Bxl3s=
X-Google-Smtp-Source: APiQypISSRCOKwtmRYkGMPrK6f49oZnYmg/Zcysqh4wgbESenxhGKqJngP0I3e7b9KiO8AKiA61DY3g3vv7MuqDtpXM=
X-Received: by 2002:a37:8707:: with SMTP id j7mr3704253qkd.394.1586420731222;
 Thu, 09 Apr 2020 01:25:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190205133821.1a243836@gandalf.local.home> <20190206021611.2nsqomt6a7wuaket@treble>
 <20190206121638.3d2230c1@gandalf.local.home> <CAK8P3a1hsca02=jPQmBG68RTUAt-jDR-qo=UFwf13nZ0k-nDgA@mail.gmail.com>
 <20200406221614.ac2kl3vlagiaj5jf@treble> <CAK8P3a3QntCOJUeUfNmqogO51yh29i4NQCu=NBF4H1+h_m_Pug@mail.gmail.com>
 <CAK8P3a2Bvebrvj7XGBtCwV969g0WhmGr_xFNfSRsZ7WX1J308g@mail.gmail.com>
 <20200407163253.mji2z465ixaotnkh@treble> <CAK8P3a3piAV7BbgH-y_zqj4XmLcBQqKZ-NHPcqo4OTF=4H3UFA@mail.gmail.com>
 <20200409074130.GD21033@infradead.org>
In-Reply-To: <20200409074130.GD21033@infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 9 Apr 2020 10:25:14 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1mg=53Ab9ZWtRvPSWxq-BUxdsFE2O0FbZeh1++F40mVQ@mail.gmail.com>
Message-ID: <CAK8P3a1mg=53Ab9ZWtRvPSWxq-BUxdsFE2O0FbZeh1++F40mVQ@mail.gmail.com>
Subject: Re: libelf-0.175 breaks objtool
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-xfs <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:XX4E2CaONhjPU0BWN0HFAWW7DPyd9Qc+c/7GQNH1D/plZIB3Rir
 DYO6s48rGIIeXoP0Lzovfig7rZ8hxORVRcgObgtdvAUdzwI2+AatnjoZLuwk5UK3baq5Ofq
 ODwCy7rfyDZ6jKUCafuz9fyeGrwr7LuYooeEFzlcNH+rh3KeUgCdl0UBBX2nen5uAITOPEF
 37hKoJkgGPY0b7lC4GK4w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:G9/o93pYvcw=:GQir1iDMP3cXxkpBq1txWx
 0q2Eh5cuJPFUpZSuL1pA1/k8wndLH+MigJDfpAf5vK8n4seDtWneBV9VnV9VVDrz6t1I6zVSb
 WBHlTXOL1WCh7C8eX0YgcNa6pCZ4PQjfQmpA4iJuRdoty8/Jhm5WNlNUNYfIINNHHtUqokQ/y
 K2dT7VZMq3hzWFBs7pV7iOvu2EsjQA8DXxpGwVSxGThsjs1Jbq+DzZnP52UxZFYxBuydFVOpm
 Oez+2P+/5V3EjUgKQqT4vPjvXgwlpL3oaTj2kVglXd0nsGDZB8xx2YxGiKZmFRyLGAdIC/Dov
 g81rYfSFq5XMwpQanW8TTSiRs0HMpUPovtC3oMwU5TF2hok7yJ9casWFXHseYd6MS/3E6pXlL
 4M1zwjS8pkUGnwyWtyHXaxnJQn3qLNEmlzlX3kooI96PzL8ElxbvwDr3SbOAawBlWrqCEDrta
 mu2hy+AkcLfuEw/1rPVupGMArKIoLXo6quI149pVyCwfl21cS3EfjUcVeUnTbeEhUYbH2M2Dm
 Gr7n/qSR6ExjE6tdrYy8nJOjWUZrAAkt169GOYJEH0VMR7Eu2pkeeYDVzqjwO9ShIQYVQovpX
 S1v5vjZ39K+d6IQPP2vx1nXC3qL8MXlMrViK1bsCjiGZ2cygBUYL5GmvL+bARv0uIcwYsdfU8
 uN5J0hJvaNiH77kAO4HQfmpq8FWV8fx4cduNeReHX5r/MDzOcM/jYQzbX+nXXpetkMnn+aDCw
 dfOQYKDc2v5ADGHP8cjgAnlNiBO9dZsHGUjFKuF4LTcxO0y5Y14TaRT+AXP/g1FzyEGv/8aqn
 8NXDfNdZeHI8GK6EjChjd5rIY0UVRlqB94fgW6B8YZCSurM6ck=
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 9, 2020 at 9:41 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Apr 07, 2020 at 08:44:11PM +0200, Arnd Bergmann wrote:
> > That is very possible. The -g has been there since xfs was originally merged
> > back in 2002, and I could not figure out why it was there (unlike the
> > -DSTATIC=""
> > and -DDEBUG flags that are set in the same line).
> >
> > On the other hand, my feeling is that setting -g should not cause problems
> > with objtool, if CONFIG_DEBUG_INFO is ok.
>
> I suspect we shouldn't force -g ourselves in xfs.  Care to send a patch?

Done.

On a related topic, I noticed how the CONFIG_DEBUG flag used to control
whether functions marked STATIC get inlined or not, but now they are always
marked noinline, apparently in an attempt to get more readable object code
even when not debugging. I also see that during early v2.6, XFS used
'STATIC' almost exclusively, while newly added functions tend to use plain
'static' instead.

Is this something worth revisiting to see if inlining would make a difference
to performance or are you reasonably sure it does not?

       Arnd
