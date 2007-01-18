Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 18 Jan 2007 08:49:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0IGnnqw014331
	for <linux-xfs@oss.sgi.com>; Thu, 18 Jan 2007 08:49:49 -0800
Message-ID: <45AFA4F6.5040806@sandeen.net>
Date: Thu, 18 Jan 2007 10:48:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs-questions
References: <45AF4A1A.50805@science.ru.nl>
In-Reply-To: <45AF4A1A.50805@science.ru.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Wim Janssen <WGHM.Janssen@science.ru.nl>
Cc: linux-xfs@oss.sgi.com

Wim Janssen wrote:
> Hello Folks,
> 
> Yesterday I downloaded from the SGI-ftpsite the module:
>        kernel-module-xfs-2.6.9-22.EL-0.1-1.src.rpm
> This because I like to work with the xfs-filesystem on my storage-unit.
>  ( a Dell PowerEdge1950 with a MD1000-diskarray )
> As Eric pointed out in the readme-file he tested it a bit with the 
> 2.6.9-22 kernel
> and it might also work with other RHEL kernels.
> On my storage-unit I installed the 64-bit RHEL4 AS with the kernel:
>    2.6.9-42.ELsmp  x86_64

I would suggest
http://sandeen.net/rhel4_xfs/kernel-module-xfs-2.6.9-42.0.2.EL-0.2-1.src.rpm

which is a little more up to date; see also
http://sandeen.net/rhel4_xfs/
for more info

> My questions:
> - If I install the xfs-module, how can I test that it is working 
> properly ???

you could use the xfstests suite in xfs cvs

> - How can I be sure about the stability ???

or you could test it in your environment

>   Do you have some test about this ???
> - Does a more recent version of the module exists ???

see above

> - How do I have to deal with the kernel-updates I get from RedHat ???

This does not change your kernel, though it may change your support when
it's loaded.  When you update your rh kernel, you'll need to rebuild the
above src.rpm for the new kernel.

> - Can you give me some hints/advice how to proceed and avoid difficulties.
>   Because the storage-unit is going to be a very critical part of our 
> IT-infra-structure.

Then you should test the heck out of it before it's fully deployed :)

Let me know if you have trouble,

Thanks,
-Eric

> For many years I have worked with the xfs-filesystem on the SGI Indigo- and
> Challenge-systems and was always very pleased with the stability, 
> performance
> and managability. That's why I consider to implement the xfs-filesystem 
> for our storage-unit.
> I hope you can help me with my questions.
> 
> Kind regards and many thanks in advance,
> 
>                                                                          
>                                    Wim Janssen
> P.S.
> It would be nice if I can report a success in the neaar future.
> 
