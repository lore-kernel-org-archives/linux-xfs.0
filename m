Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 Jul 2008 09:25:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m65GOu1V013339
	for <xfs@oss.sgi.com>; Sat, 5 Jul 2008 09:24:56 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2D3DDA7644
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2008 09:25:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id YQt8TxzrH9rj1mHL for <xfs@oss.sgi.com>; Sat, 05 Jul 2008 09:25:59 -0700 (PDT)
Message-ID: <486FA095.1050106@sandeen.net>
Date: Sat, 05 Jul 2008 11:25:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Xfs Access to block zero  exception and system crash
References: <486B01A6.4030104@pmc-sierra.com> <20080702051337.GX29319@disturbed> <486B13AD.2010500@pmc-sierra.com> <1214979191.6025.22.camel@verge.scott.net.au> <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com> <20080704122726.GG29319@disturbed> <340C71CD25A7EB49BFA81AE8C839266702997641@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486E5F4D.1010009@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702997658@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
In-Reply-To: <340C71CD25A7EB49BFA81AE8C839266702997658@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <Sagar_Borikar@pmc-sierra.com>
Cc: Dave Chinner <david@fromorbit.com>, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

Sagar Borikar wrote:
> Copy is of the same file to 30 different directories and it is basically
> overwrite.
> 
> Here is the setup:
> 
> It's a JBOD with Volume size 20 GB. The directories are empty and this
> is basically continuous copy of the file on all thirty directories. But
> surprisingly none of the copy succeeds. All the copy processes are in 
> Uninterruptible sleep state and xfs_repair log I have already attached 
> With the prep. As mentioned it is with 2.6.24 Fedora kernel.

It would probably be best to try a 2.6.26 kernel from rawhide to be sure
you're closest to the bleeding edge.

I tested on 2.6.24.7-92.fc8 on x86_64, and I did this, specifically, in
the root of a 30G xfs fs:

# for I in `seq 1 30`; do mkdir dir$I; done
# vi copyit.sh (your script)
# chmod +x copyit.sh
# dd if=/dev/zero of=300mbfile bs=1M count=300
# for I in `seq 1 30`; do ./copyit.sh 300mbfile dir$I & done

I got no errors or corruption after several iterations.

Might also be worth checking dmesg for any errors when you run.

-Eric
