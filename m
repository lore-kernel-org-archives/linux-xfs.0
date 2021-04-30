Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6395C433ED
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 18:50:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6780E61423
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Apr 2021 18:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhD3Sva (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Apr 2021 14:51:30 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:40710 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhD3Sva (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Apr 2021 14:51:30 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lcYDm-003rGS-Ol; Fri, 30 Apr 2021 12:50:38 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1lcYDl-0005XY-Ur; Fri, 30 Apr 2021 12:50:38 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>, Jia He <justin.he@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
References: <20210427025805.GD3122264@magnolia>
        <CAHk-=wj6XUGJCgsr+hx3rz=4KvBP-kspn3dqG5v-cKMzzMktUw@mail.gmail.com>
        <20210427195727.GA9661@lst.de>
        <CAHk-=wjrpinf=8gAjxyPoXT0jbK6-U3Urawiykh-zpxeo47Vhg@mail.gmail.com>
        <20210428061706.GC5084@lst.de>
        <CAHk-=whWnFu4wztnOtySjFVYXmBR4Mb2wxrp6OayZqnpKeQw0g@mail.gmail.com>
        <20210428064110.GA5883@lst.de>
        <CAHk-=wjeUhrznxM95ni4z+ynMqhgKGsJUDU8g0vrDLc+fDtYWg@mail.gmail.com>
        <1de23de2-12a9-2b13-3b86-9fe4102fdc0c@rasmusvillemoes.dk>
        <CAHk-=wimsMqGdzik187YWLb-ru+iktb4MYbMQG1rnZ81dXYFVg@mail.gmail.com>
        <26d06c27-4778-bf75-e39a-3b02cd22d0e3@rasmusvillemoes.dk>
        <CAHk-=whJmDjTLYLeF=Ax31vTOq4PHXKo6JUqm1mQNGZdy-6=3Q@mail.gmail.com>
Date:   Fri, 30 Apr 2021 13:50:34 -0500
In-Reply-To: <CAHk-=whJmDjTLYLeF=Ax31vTOq4PHXKo6JUqm1mQNGZdy-6=3Q@mail.gmail.com>
        (Linus Torvalds's message of "Thu, 29 Apr 2021 09:45:39 -0700")
Message-ID: <m135v7y5c5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lcYDl-0005XY-Ur;;;mid=<m135v7y5c5.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18agHbZHv9HW27hzebg3yTrw+mKNECNwgo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [GIT PULL] iomap: new code for 5.13-rc1
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Apr 28, 2021 at 11:40 PM Rasmus Villemoes
> <linux@rasmusvillemoes.dk> wrote:
>>
>> > That also does explain the arguably odd %pD defaults: %pd came first,
>> > and then %pD came afterwards.
>>
>> Eh? 4b6ccca701ef5977d0ffbc2c932430dea88b38b6 added them both at the same
>> time.
>
> Ahh, I looked at "git blame", and saw that file_dentry_name() was
> added later. But that turns out to have been an additional fix on top,
> not actually "later support".
>
> Looking more at that code, I am starting to think that
> "file_dentry_name()" simply shouldn't use "dentry_name()" at all.
> Despite that shared code origin, and despite that similar letter
> choice (lower-vs-upper case), a dentry and a file really are very very
> different from a name standpoint.
>
> And it's not the "a filename is the whale pathname, and a dentry has
> its own private dentry name" issue. It's really that the 'struct file'
> contains a _path_ - which is not just the dentry pointer, but the
> 'struct vfsmount' pointer too.
>
> So '%pD' really *could* get the real path right (because it has all
> the required information) in ways that '%pd' fundamentally cannot.
>
> At the same time, I really don't like printk specifiers to take any
> real locks (ie mount_lock or rename_lock), so I wouldn't want them to
> use the full  d_path() logic.

Well prepend_path the core of d_path, which is essentially the logic
I think you are suggesting to use does:
read_seqbegin_or_lock(&mount_lock, ...);
read_seqbegin_or_lock(&rename_lock, ...);

A printk specific variant could easily be modified to always restart or
to simply ignore renames and changes to the mount tree.  There are
always the corner cases when there is no sensible full path to display.
A rename or a mount namespace operation could be handled like one of
those.

Eric

