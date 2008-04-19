Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 19 Apr 2008 07:35:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3JEYtmx012962
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 07:34:59 -0700
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A3F9A5AF84
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 07:35:32 -0700 (PDT)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155]) by cuda.sgi.com with ESMTP id ISL9bGY6VyCqvcoQ for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 07:35:32 -0700 (PDT)
Received: by fg-out-1718.google.com with SMTP id e12so848468fga.8
        for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 07:35:31 -0700 (PDT)
Message-ID: <6101e8c40804190735g17f1e0bj25c2bc0e2a6eac26@mail.gmail.com>
Date: Sat, 19 Apr 2008 16:35:31 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: x86: 4kstacks default
In-Reply-To: <20080419142329.GA5339@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	 <20080418142934.38ce6bf4.akpm@linux-foundation.org>
	 <20080419142329.GA5339@elte.hu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Hi Ingo!

with the older kernel is typical: xfs+nfs+4k stack(+lvm)



On 4/19/08, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > >  config 4KSTACKS
> > >  	bool "Use 4Kb for kernel stacks instead of 8Kb"
> > > -	depends on DEBUG_KERNEL
> > >  	depends on X86_32
> > > +	default y
> >
> > This patch will cause kernels to crash.
>
> what mainline kernels crash and how will they crash? Fedora and other
> distros have had 4K stacks enabled for years:
>
>   $ grep 4K /boot/config-2.6.24-9.fc9
>   CONFIG_4KSTACKS=y
>
> and we've conducted tens of thousands of bootup tests with all sorts of
> drivers and kernel options enabled and have yet to see a single crash
> due to 4K stacks. So basically the kernel default just follows the
> common distro default now. (distros and users can still disable it)
>
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
