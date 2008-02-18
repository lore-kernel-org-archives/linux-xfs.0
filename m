Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 02:08:35 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1IA8VII015338
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 02:08:32 -0800
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2226B5E9ED7
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 02:08:56 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155]) by cuda.sgi.com with ESMTP id VGkwtkTSr9fxgrxN for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 02:08:56 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id e12so1284876fga.8
        for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 02:08:55 -0800 (PST)
Message-ID: <47B952D3.2030900@gmail.com>
Date: Mon, 18 Feb 2008 11:41:39 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
MIME-Version: 1.0
Subject: Re: xfsaild causing 30+ wakeups/s on an idle system since 2.6.25-rcX
References: <47B863A9.5070206@gmail.com> <6101e8c40802170851w73db8130t9bcfdc5cf053f0dc@mail.gmail.com> <20080217224736.GX155407@sgi.com>
In-Reply-To: <20080217224736.GX155407@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Christoph Lameter <clameter@sgi.com>, Christoph Hellwig <hch@infradead.org>

David Chinner wrote:
> On Sun, Feb 17, 2008 at 05:51:08PM +0100, Oliver Pinter wrote:
>   
>> On 2/17/08, Török Edwin <edwintorok@gmail.com> wrote:
>>     
>>> Hi,
>>>
>>> xfsaild is causing many wakeups, a quick investigation shows
>>> xfsaild_push is always
>>> returning 30 msecs timeout value.
>>>       
>
> That's a bug

Ok. Your patches fixes the 30+ wakeups :)

> , and has nothing to do with power consumption. ;)
>   

I suggest using a sysctl value (such as
/proc/sys/vm/dirty_writeback_centisecs), instead of a hardcoded default
1000.
That would further reduce the wakeups.

>
> I only managed to reproduce this on a lazy superblock counter
> filesystem (i.e.  new mkfs and recent kernel), 

The filesystem was created in July 2007

> Can you see if the patch below fixes the problem.

Yes, it reduces wakeups to 1/sec.

Thanks,
--Edwin
