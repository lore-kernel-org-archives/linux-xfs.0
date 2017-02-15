Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from out03.mta.xmission.com ([166.70.13.233]:50416 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdBOCdl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Feb 2017 21:33:41 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1487008001.3125.41.camel@HansenPartnership.com>
        <20170213194337.GA9852@infradead.org> <20170213213416.GA15349@dastard>
        <20170214060809.GA21114@infradead.org>
        <1487053651.3125.72.camel@HansenPartnership.com>
        <1487053720.3125.73.camel@HansenPartnership.com>
        <87lgt9mcyv.fsf@xmission.com>
        <1487088593.3133.23.camel@HansenPartnership.com>
Date: Wed, 15 Feb 2017 15:29:05 +1300
In-Reply-To: <1487088593.3133.23.camel@HansenPartnership.com> (James
        Bottomley's message of "Tue, 14 Feb 2017 08:09:53 -0800")
Message-ID: <87y3x8dw5q.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [PATCH 1/2] fs: add inode helpers for fsuid and fsgid
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> On Tue, 2017-02-14 at 20:46 +1300, Eric W. Biederman wrote:
>> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
>> 
>> > Now that we have two different views of filesystem ids (the 
>> > filesystem view and the kernel view), we have a problem in that
>> > current_fsuid/fsgid() return the kernel view but are sometimes used 
>> > in filesystem code where the filesystem view shoud be used.  This
>> > patch introduces helpers to produce the filesystem view of current 
>> > fsuid and fsgid.
>> 
>> If I am reading this right what we are seeing is that xfs explicitly
>> opted out of type safety with predictable results.   Accidentally
>> confusing kuids and uids, which is potentially security issue.
>> 
>> All of that said where are you getting sb->s_user_ns != &init_user_ns
>> for an xfs filesystem?

James please answer this question:

 Where are you getting sb->s_user_ns != &init_user_ns for an xfs filesystem?

None of this matters if sb->s_user_ns == &init_user_ns.

This is signification because only xfs keeps any in-core data structure
in it's on-disk encoding.  So this problem is xfs specific.   So
understanding how you are getting xfs to have sb->s_user_ns !=
&init_user_ns is important for discussing which direction we go with
helper functions here.

xfs with sb->s_user_ns == &init_user_ns is perfectly fine and as such no
fixes are needed.

Eric
