Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C2AC001DD
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Jun 2023 00:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241493AbjFPATX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 20:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241087AbjFPASk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 20:18:40 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB60430CD
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 17:18:09 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-6667c54839bso256703b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 17:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686874670; x=1689466670;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Tct7K1ypSrlZ1iBgjESvSwHX4LeZ/aMYkG7OXKVjMBA=;
        b=Aw7yykEiaTBqY+6NGN5gcCxXNkGoIqV6prCQfU+WUvWcLz4ajI0YKRMqMGiWO79f8o
         X0lvrUT0Gr6qVY7bPinfOj7Ch2VhX9EcGrLvnEnK3JU8fIxeS+4rZX+UteDK1f0x4Ars
         SlRFqbW7ImOAVghz0bX+Iv4O0i83Gk/FzxXzspxTO7My/BUZWc8ymTzS2XjQD7YNE5og
         IoXDgO1w49pDBEUVhD1MMbo/Tpx8gl0KhOCWUdaSnG7eDHg6ubipu/TCslcMz/EeOmf5
         gJo7VvvrHlkk5jsE3eSD8RtNCspgp4x4Pl20BFGJ7lQTatNTLUooAKgNazfmxaqjoHzh
         qBxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686874670; x=1689466670;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tct7K1ypSrlZ1iBgjESvSwHX4LeZ/aMYkG7OXKVjMBA=;
        b=fl9DaWy4CHTt9rh97c3Ddfj9ruobQAZ1+srITXV0UFVa3MQyUTlUv+vlo1MWqsJXXs
         X8FyUJICb01bxvJv51v82J4auEvVs2FIc5W9U94UZy0K1ZWH6TRz8MVRyiKLRjwmQTyE
         HT+1Yheuogimbl08l60ZHH5aECX9ZmTtJQvDg6oiwYw9Cyw+RS9xvZyQKWfFTucGy7A+
         BkbzhNOYPL3yesLsbOp63cbG1ANcSriEwBCWDfxvN1QUPQvXEuQpvRjJHKC31KreTSt4
         s+IGKuvU6zASmOxdWca8BU2n5kv9gefphZACgolAWjxVAUtgcKR+GIBoWtT++5rTot15
         7epQ==
X-Gm-Message-State: AC+VfDxZdPqYSoCyH5K7r1spFbmXtrK307GdN9QZAd4YTGjEcuDd8+3N
        D7v40jHellpaZ3syfoHBrI1ExkH8fF+19ISyMGY=
X-Google-Smtp-Source: ACHHUZ43/vZcLebGZFHK61a8oLgn/cY6UzazvqV+ql3ffWyYxwYax/5chpaZsD8X8Lx+Ax3Ss3u0AQ==
X-Received: by 2002:a05:6a20:144e:b0:100:3964:6cb with SMTP id a14-20020a056a20144e00b00100396406cbmr1085144pzi.40.1686874669893;
        Thu, 15 Jun 2023 17:17:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902854600b001b3acbde983sm10491369plo.3.2023.06.15.17.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 17:17:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q9x9u-00CGg3-2H;
        Fri, 16 Jun 2023 10:17:46 +1000
Date:   Fri, 16 Jun 2023 10:17:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "chandanrlinux@gmail.com" <chandanrlinux@gmail.com>
Subject: Re: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Message-ID: <ZIuqKv58eTQL/Iij@dread.disaster.area>
References: <20230615014201.3171380-1-david@fromorbit.com>
 <20230615014201.3171380-2-david@fromorbit.com>
 <25F855D8-F944-45D0-9BB2-3E475A301EDB@oracle.com>
 <ZIuNV8UqlOFmUmOY@dread.disaster.area>
 <3EEEEF48-A255-459E-99A9-5C92344B4B7A@oracle.com>
 <8E15D551-C11A-4A0F-86F0-21EA6447CBF5@oracle.com>
 <ZIuftY4gKcjygvYv@dread.disaster.area>
 <396ACF78-518E-432A-9016-B2EAFD800B7C@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <396ACF78-518E-432A-9016-B2EAFD800B7C@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 15, 2023 at 11:51:09PM +0000, Wengang Wang wrote:
> 
> 
> > On Jun 15, 2023, at 4:33 PM, Dave Chinner <david@fromorbit.com> wrote:
> > 
> > On Thu, Jun 15, 2023 at 11:09:41PM +0000, Wengang Wang wrote:
> >> When mounting the problematic metadump with the patches, I see the following reported.
> >> 
> >> For more information about troubleshooting your instance using a console connection, see the documentation: https://docs.cloud.oracle.com/en-us/iaas/Content/Compute/References/serialconsole.htm#four
> >> =================================================
> >> [   67.212496] loop: module loaded
> >> [   67.214732] loop0: detected capacity change from 0 to 629137408
> >> [   67.247542] XFS (loop0): Deprecated V4 format (crc=0) will not be supported after September 2030.
> >> [   67.249257] XFS (loop0): Mounting V4 Filesystem af755a98-5f62-421d-aa81-2db7bffd2c40
> >> [   72.241546] XFS (loop0): Starting recovery (logdev: internal)
> >> [   92.218256] XFS (loop0): Internal error ltbno + ltlen > bno at line 1957 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_ag_extent+0x3f6/0x870 [xfs]
> >> [   92.249802] CPU: 1 PID: 4201 Comm: mount Not tainted 6.4.0-rc6 #8
> > 
> > What is the test you are running? Please describe how you reproduced
> > this failure - a reproducer script would be the best thing here.
> 
> I was mounting a (copy of) V4 metadump from customer.

Is the metadump obfuscated? Can I get a copy of it via a private,
secure channel?

> > Does the test fail on a v5 filesytsem?
> 
> N/A.
> 
> > 
> >> I think that’s because that the same EFI record was going to be freed again
> >> by xfs_extent_free_finish_item() after it already got freed by xfs_efi_item_recover().

How is this happening? Where (and why) are we defering an extent we
have successfully freed into a new xefi that we create a new intent
for and then defer?

Can you post the debug output and analysis that lead you to this
observation? I certainly can't see how this can happen from looking
at the code

> >> I was trying to fix above issue in my previous patch by checking the intent
> >> log item’s lsn and avoid running iop_recover() in xlog_recover_process_intents().
> >> 
> >> Now I am thinking if we can pass a flag, say XFS_EFI_PROCESSED, from
> >> xfs_efi_item_recover() after it processed that record to the xfs_efi_log_item
> >> memory structure somehow. In xfs_extent_free_finish_item(), we skip to process
> >> that xfs_efi_log_item on seeing XFS_EFI_PROCESSED and return OK. By that
> >> we can avoid the double free.
> > 
> > I'm not really interested in speculation of the cause or the fix at
> > this point. I want to know how the problem is triggered so I can
> > work out exactly what caused it, along with why we don't have
> > coverage of this specific failure case in fstests already.
> > 
> 
> I get to know the cause by adding additional debug log along with
> my previous patch.

Can you please post that debug and analysis, rather than just a
stack trace that is completely lacking in context? Nothing can be
inferred from a stack trace, and what you are saying is occurring
does not match what the code should actually be doing. So I need to
actually look at what is happening in detail to work out where this
mismatch is coming from....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
