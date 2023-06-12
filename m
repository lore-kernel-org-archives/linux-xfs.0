Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 764CAC7EE23
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Jun 2023 09:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbjFLJZ0 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 05:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234552AbjFLJYu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Jun 2023 05:24:50 -0400
X-Greylist: delayed 2008 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Jun 2023 02:18:50 PDT
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E693525B;
        Mon, 12 Jun 2023 02:18:49 -0700 (PDT)
Received: from in02.mta.xmission.com ([166.70.13.52]:58520)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1q8dAu-00GXSG-LO; Mon, 12 Jun 2023 02:45:20 -0600
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:39804 helo=email.froward.int.ebiederm.org.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1q8dAt-00FC9s-H1; Mon, 12 Jun 2023 02:45:20 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
References: <20230611124836.whfktwaumnefm5z5@zlang-mailbox>
        <ZIZSPyzReZkGBEFy@dread.disaster.area>
        <20230612015145.GA11441@frogsfrogsfrogs>
        <ZIaBQnCKJ6NsqGhd@dread.disaster.area>
        <CAHk-=whJqZLKPR-cpX-V4wJTXVX-_tG5Vjuj2q9knvKGCPdfkg@mail.gmail.com>
        <ZIaqMpGISWKgHLK6@dread.disaster.area>
        <CAHk-=wgwJptCbaHwt+TpGgh04fTVAHd60AY3Jj1rX+Spf0fVyg@mail.gmail.com>
        <ZIax1FLfNajWk25A@dread.disaster.area>
        <CAHk-=wj0NuJaRNC4o6FVAJgKAFJ5HWcBV5VJw6RGV0ZahqOOZA@mail.gmail.com>
Date:   Mon, 12 Jun 2023 03:45:12 -0500
In-Reply-To: <CAHk-=wj0NuJaRNC4o6FVAJgKAFJ5HWcBV5VJw6RGV0ZahqOOZA@mail.gmail.com>
        (Linus Torvalds's message of "Sun, 11 Jun 2023 23:11:28 -0700")
Message-ID: <87r0qhrrvr.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1q8dAt-00FC9s-H1;;;mid=<87r0qhrrvr.fsf@email.froward.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=pass
X-XM-AID: U2FsdGVkX19zDZ9UDOy2LwKxs184+u4u0p0/xsgHgcs=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [6.5-rc5 regression] core dump hangs (was Re: [Bug report]
 fstests generic/051 (on xfs) hang on latest linux v6.5-rc5+)
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sun, Jun 11, 2023 at 10:49 PM Dave Chinner <david@fromorbit.com> wrote:
>>
>> On Sun, Jun 11, 2023 at 10:34:29PM -0700, Linus Torvalds wrote:
>> >
>> > So that "!=" should obviously have been a "==".
>>
>> Same as without the condition - all the fsstress tasks hang in
>> do_coredump().
>
> Ok, that at least makes sense. Your "it made things worse" made me go
> "What?" until I noticed the stupid backwards test.
>
> I'm not seeing anything else that looks odd in that commit
> f9010dbdce91 ("fork, vhost: Use CLONE_THREAD to fix freezer/ps
> regression").
>
> Let's see if somebody else goes "Ahh" when they wake up tomorrow...

It feels like there have been about half a dozen bugs pointed out in
that version of the patch.  I am going to have to sleep before I can get
as far as "Ahh"

One thing that really stands out for me is.

if (test_if_loop_should_continue) {
	set_current_state(TASK_INTERRUPTIBLE);
        schedule();
}

/* elsewhere */
llist_add(...);
wake_up_process()

So it is possible that the code can sleep indefinitely waiting for a
wake-up that has already come, because the order of set_current_state
and the test are in the wrong order.

Unfortunately I don't see what would effect a coredump on a process that
does not trigger the vhost_worker code.



About the only thing I can image is if io_uring is involved.  Some of
the PF_IO_WORKER code was changed, and the test
"((t->flags & (PF_USER_WORKER | PF_IO_WORKER)) != PF_USER_WORKER)"
was sprinkled around.

That is the only code outside of vhost specific code that was changed.


Is io_uring involved in the cases that hang?


Eric

