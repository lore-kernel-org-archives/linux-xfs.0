Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:47782 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752995AbdJKN7c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 09:59:32 -0400
Received: by mail-oi0-f41.google.com with SMTP id h200so3207600oib.4
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2017 06:59:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171011135415.6omvzcdflflqghbo@XZHOUW.usersys.redhat.com>
References: <20170925014006.5tvdkjszrbj6uhgc@XZHOUW.usersys.redhat.com>
 <20170925084903.fsjgrn7rfernou5j@hades.localdomain> <20171011135415.6omvzcdflflqghbo@XZHOUW.usersys.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Oct 2017 06:59:31 -0700
Message-ID: <CAPcyv4gGgFtTQ1f2BxtY_55Msg=qDppW9X_kamnroKDZOJ09BA@mail.gmail.com>
Subject: Re: ffsb job does not exit on xfs 4.14-rc1+
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Xiong Zhou <xzhou@redhat.com>
Cc: linux-xfs@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>

On Wed, Oct 11, 2017 at 6:54 AM, Xiong Zhou <xzhou@redhat.com> wrote:
> On Mon, Sep 25, 2017 at 10:49:03AM +0200, Carlos Maiolino wrote:
>> On Mon, Sep 25, 2017 at 01:40:06AM +0000, Xiong Zhou wrote:
>> > Hi,
>> >
>> > ffsb test won't exit like this on Linus tree 4.14-rc1+.
>> > Latest commit cd4175b11685
>>
>> Can you provide more information? Do you have any kernel log from this issue?
>> dmesg, Oopses, traces, etc.
>> Storage configuration might also be required here.
>
> Turns out this only repreduces on nvdimm devices, xfs without dax
> mount option. More logs are attached.
>
>>
>> have you also tried to reproduce it with another filesystem? If so, is the same
>> problem reproducible with another filesystem or only with XFS?
>
> Only xfs. Test on ext4 ends shortly.
>
>>
>> P.S. please avoid sending it to all lists (mainly LKML).
>
> Why?  I thought LKML was better archived.
>
>> Unless it's a more generic kernel problem, keep it in fsdevel and/or the
>> respective filesystem list if it's related to a single filesystem only.
>
> 4.14-rc1+ won't survive this script, while 4.13 can.

Can you try a git bisect?
