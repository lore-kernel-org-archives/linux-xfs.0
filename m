Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38694 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757244AbcKBVF7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2016 17:05:59 -0400
Received: by mail-wm0-f53.google.com with SMTP id n67so62755684wme.1
        for <linux-xfs@vger.kernel.org>; Wed, 02 Nov 2016 14:05:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20161102204838.GD14023@dastard>
References: <CAPvv1vytjK-n7Z3=Zi+vScuV-ej3CagQ5rFc9ppVC8JEihZPkQ@mail.gmail.com>
 <8bd7b65f-d85d-2958-dd7d-ba97c91ac9ea@telefonica.net> <CAPvv1vx-Juge8e=36bq4AFvGxs8Kf7-V_v0j+a9LGWYdDo5h+w@mail.gmail.com>
 <20161031194212.GU14023@dastard> <CAPvv1vxUW94s-NSkE9gXYLZLH=a-zP-2-r-fv=vhtMhQXeVX-A@mail.gmail.com>
 <20161102204838.GD14023@dastard>
From: "Steffen D." <sdumke@gmail.com>
Date: Wed, 2 Nov 2016 22:05:57 +0100
Message-ID: <CAPvv1vzQK3R=F2DQ4u-PEJTES4XFC=E-KsgWnvi2-PKjLcYhaA@mail.gmail.com>
Subject: Re: Fwd: mounting a xfs file system gives the message: "failure code
 -3003" and "structure needs cleaning"
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

Thank You! worked perfect!

2016-11-02 21:48 GMT+01:00 Dave Chinner <david@fromorbit.com>:
> On Wed, Nov 02, 2016 at 08:33:48PM +0100, Steffen D. wrote:
>> Hi Dave,
>>
>> 2016-10-31 20:42 GMT+01:00 Dave Chinner <david@fromorbit.com>:
>>
>> >>
>> >
>> > hmmm - AGFL sizing issue?
>> >
>> > xfs_reapir -L should fix it, but I'd like to understand what the
>>
>> Do you think it works? Or is it very risky?
>
> xfs_repair rebuilds the AGFL from scratch regardless of whether it
> is ok to begin with or not. As for the log being discarded, there's
> not a of inconsistency - mainly unlinked inodes that get cleaned up,
> which log recovery would do anyway...
>
> So there's isn't any obvious significant risks to do this.
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Signatur ausser Betrieb.
