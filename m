Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Jul 2006 17:33:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6V0WODW003917
	for <xfs@oss.sgi.com>; Sun, 30 Jul 2006 17:32:36 -0700
Date: Mon, 31 Jul 2006 10:31:33 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: Re: [xfs] quota project problem
Message-ID: <20060731103133.G2280998@wobbly.melbourne.sgi.com>
References: <44CA1D89.3080104@mdlink.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44CA1D89.3080104@mdlink.de>; from fp@mdlink.de on Fri, Jul 28, 2006 at 04:22:01PM +0200
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Frank Patzig <fp@mdlink.de>
Cc: xfs@oss.sgi.com

On Fri, Jul 28, 2006 at 04:22:01PM +0200, Frank Patzig wrote:
> Hallo,
> 
> i have a problem with project quota. Can i help you.
> 
> combolix:~ # uname -a
> Linux combolix 2.6.18_rc1-jen27-default #1 Thu Jul 13 01:34:23 CEST 2006 
> i686
> i686 i386 GNU/Linux
> 
> combolix:~ # cat /etc/mtab
> /dev/hdc2 / xfs rw,uquota,gquota,pquota 0 0

This isn't correct - you can have either gquota or pquota,
not both.  You also need to set root flags via the kernel
boot option "rootflags=" - not via mtab (chicken vs egg).

> Project quota state on / (/dev/hdc2)
>    Accounting: OFF
>    Enforcement: OFF
>    Inode: #18446744073709551615 (0 blocks, 0 extents)

cheers.

-- 
Nathan
