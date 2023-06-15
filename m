Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1458EB64D9
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Jun 2023 23:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjFOXdO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Jun 2023 19:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjFOXdN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Jun 2023 19:33:13 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FFF10F6
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 16:33:12 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-666a63f7907so250818b3a.2
        for <linux-xfs@vger.kernel.org>; Thu, 15 Jun 2023 16:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1686871992; x=1689463992;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Add4PQpFWkLwifsPKQal74qjHK1zuFuZJi2esb6zqKM=;
        b=mmBsSu08mhhEehZwOOHT0nSajVV0IyViQz7hJd7g1+UC3CGJ/uxVlW0KT6Y121v+Zv
         rGjEN5p9fiUb9sbjkGAefp+3gYtACvwHmE2GVToOhE/axgQ2Ek837YViIKCFKcFElDT7
         T/WTI6lCO87UJ0/Si4MzD9q2w99OLn9k8AVNfplEutX3idc+p19veXF3yqOjTyyjZqek
         yoFpps2Y5HFBCB++BV9INaZ4Zz8WKsco0w0vj2oJ92L2RT2iTynQQU0H84RkiZ5J8jXR
         MVjJt/COKutjpnRfQqHpK8yrfOoZVscl9b4kstkNXBmBjS1xnkuXVJXyHZanVYtokdbg
         LgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686871992; x=1689463992;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Add4PQpFWkLwifsPKQal74qjHK1zuFuZJi2esb6zqKM=;
        b=Y+qryX3KBm9pevSCl/7iAuhu7cG5jkYx7MpSIN3UncrpcdS3pkkh27pl/newnpOrnx
         rIk12Ny6czAQFNl79MbFNKvkiRUSGRmbT8H4cZPbjWoAn+eVp8D7mb/0/CAydpjH06mo
         wi0X5XxVW4835mjwVNF3XboJSOM9UUnlNlb2j220N7SCe+XLdxZ7svnCLCtMh+i/Wisu
         6Q/rCNhBN76gNGaADOEJyRpShExvih9oDFjzy5SIZWnMsAxwQqRdFJCZtCLfZMGUIlO5
         NksJYE6GMEkLt+riI/Oq6+JDISOf+O/juUyNY+gBGw61vNaI6zj0iy1ZQvjSZ1+YujTw
         0sfQ==
X-Gm-Message-State: AC+VfDwyTaDav1J7fa09GW9TLRbicp7/YQrvfM0KcWqY8l+Ppd4Yn5QK
        DOq4ZTaBI4YBmsAaqyM6Q2KeWc/anHBCAOgph5A=
X-Google-Smtp-Source: ACHHUZ7i7Scjk6Yy3dQUXrhOpM9QGSfpa3S/vDZiWxZuXUknHhqxXIzvVIkT+SFSA5A6yjBf4QI29g==
X-Received: by 2002:a05:6a20:6a2b:b0:10f:1d33:d667 with SMTP id p43-20020a056a206a2b00b0010f1d33d667mr1092677pzk.5.1686871991842;
        Thu, 15 Jun 2023 16:33:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-13-202.pa.nsw.optusnet.com.au. [49.180.13.202])
        by smtp.gmail.com with ESMTPSA id l3-20020a170902f68300b001ac896ff65fsm14563264plg.129.2023.06.15.16.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 16:33:11 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1q9wSj-00CG0r-04;
        Fri, 16 Jun 2023 09:33:09 +1000
Date:   Fri, 16 Jun 2023 09:33:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Wengang Wang <wen.gang.wang@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "chandanrlinux@gmail.com" <chandanrlinux@gmail.com>
Subject: Re: [PATCH 1/3] xfs: pass alloc flags through to
 xfs_extent_busy_flush()
Message-ID: <ZIuftY4gKcjygvYv@dread.disaster.area>
References: <20230615014201.3171380-1-david@fromorbit.com>
 <20230615014201.3171380-2-david@fromorbit.com>
 <25F855D8-F944-45D0-9BB2-3E475A301EDB@oracle.com>
 <ZIuNV8UqlOFmUmOY@dread.disaster.area>
 <3EEEEF48-A255-459E-99A9-5C92344B4B7A@oracle.com>
 <8E15D551-C11A-4A0F-86F0-21EA6447CBF5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8E15D551-C11A-4A0F-86F0-21EA6447CBF5@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 15, 2023 at 11:09:41PM +0000, Wengang Wang wrote:
> When mounting the problematic metadump with the patches, I see the following reported.
> 
> For more information about troubleshooting your instance using a console connection, see the documentation: https://docs.cloud.oracle.com/en-us/iaas/Content/Compute/References/serialconsole.htm#four
> =================================================
> [   67.212496] loop: module loaded
> [   67.214732] loop0: detected capacity change from 0 to 629137408
> [   67.247542] XFS (loop0): Deprecated V4 format (crc=0) will not be supported after September 2030.
> [   67.249257] XFS (loop0): Mounting V4 Filesystem af755a98-5f62-421d-aa81-2db7bffd2c40
> [   72.241546] XFS (loop0): Starting recovery (logdev: internal)
> [   92.218256] XFS (loop0): Internal error ltbno + ltlen > bno at line 1957 of file fs/xfs/libxfs/xfs_alloc.c.  Caller xfs_free_ag_extent+0x3f6/0x870 [xfs]
> [   92.249802] CPU: 1 PID: 4201 Comm: mount Not tainted 6.4.0-rc6 #8

What is the test you are running? Please describe how you reproduced
this failure - a reproducer script would be the best thing here.

Does the test fail on a v5 filesytsem?

> I think that’s because that the same EFI record was going to be freed again
> by xfs_extent_free_finish_item() after it already got freed by xfs_efi_item_recover().
> I was trying to fix above issue in my previous patch by checking the intent
> log item’s lsn and avoid running iop_recover() in xlog_recover_process_intents().
> 
> Now I am thinking if we can pass a flag, say XFS_EFI_PROCESSED, from
> xfs_efi_item_recover() after it processed that record to the xfs_efi_log_item
> memory structure somehow. In xfs_extent_free_finish_item(), we skip to process
> that xfs_efi_log_item on seeing XFS_EFI_PROCESSED and return OK. By that
> we can avoid the double free.

I'm not really interested in speculation of the cause or the fix at
this point. I want to know how the problem is triggered so I can
work out exactly what caused it, along with why we don't have
coverage of this specific failure case in fstests already.

Indeed, if you have a script that is reproducing this, please turn
it into a fstests test so it becomes a regression test that is
always run...

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
