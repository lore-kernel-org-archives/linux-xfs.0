Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 May 2008 11:34:51 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4GIYlxP030448
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 11:34:49 -0700
Received: from gv-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 63C8716D9871
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 11:35:33 -0700 (PDT)
Received: from gv-out-0910.google.com (gv-out-0910.google.com [216.239.58.191]) by cuda.sgi.com with ESMTP id wIlIL5PDeKvrNwIC for <xfs@oss.sgi.com>; Fri, 16 May 2008 11:35:33 -0700 (PDT)
Received: by gv-out-0910.google.com with SMTP id n29so125795gve.9
        for <xfs@oss.sgi.com>; Fri, 16 May 2008 11:35:32 -0700 (PDT)
Message-ID: <6101e8c40805161135w7470123uaac93ca59caee026@mail.gmail.com>
Date: Fri, 16 May 2008 20:35:32 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: Regression- XFS won't mount on partitioned md array
In-Reply-To: <482DCCCD.8020503@dgreaves.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <482DC043.5000307@dgreaves.com>
	 <alpine.DEB.1.10.0805161316100.3118@p34.internal.lan>
	 <482DCCCD.8020503@dgreaves.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Greaves <david@dgreaves.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, David Chinner <dgc@sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

this[1] patch fixed?

this patch is for 2.6.25.5 kernel

1: http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=queue-2.6.25/block-do_mounts-accept-root-non-existant-partition.patch;h=097cda9928b434994dbb157065b2ca38e7cec3a1;hb=8cc4c3b370d59deb16c2e92165a466c82e914020

On 5/16/08, David Greaves <david@dgreaves.com> wrote:
>> Ouch, still on 2.6.25.1 here, didn't reboot yet, but I do not use
>> mdraid'ed partitions, just regular mdraid, if you boot back to 2.6.20.7
>> does it work again?
> Yes, no probs.
>
> It came in prior to 2.6.25-rc1
> The machine has a root xfs filesystem with an internal log on a sata disk
> and a
> data filesystem on a partitioned array with an external log (also on the
> partitioned array).
> Only the partitioned array/external-log filesystem is affected.
>
> David
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
