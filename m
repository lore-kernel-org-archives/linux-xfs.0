Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 05 Jul 2008 21:18:54 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m664Ikwg011867
	for <xfs@oss.sgi.com>; Sat, 5 Jul 2008 21:18:47 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 25CDC1BB218D
	for <xfs@oss.sgi.com>; Sat,  5 Jul 2008 21:19:48 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id ELDckLtAwivUrBDP for <xfs@oss.sgi.com>; Sat, 05 Jul 2008 21:19:48 -0700 (PDT)
Date: Sun, 6 Jul 2008 14:19:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Xfs Access to block zero  exception and system crash
Message-ID: <20080706041945.GH29319@disturbed>
References: <20080702065652.GS14251@build-svl-1.agami.com> <486B6062.6040201@pmc-sierra.com> <486C4F89.9030009@sandeen.net> <486C6053.7010503@pmc-sierra.com> <486CE9EA.90502@sandeen.net> <486DF8F0.5010700@pmc-sierra.com> <20080704122726.GG29319@disturbed> <340C71CD25A7EB49BFA81AE8C839266702997641@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca> <486E5F4D.1010009@sandeen.net> <340C71CD25A7EB49BFA81AE8C839266702997658@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <340C71CD25A7EB49BFA81AE8C839266702997658@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Sagar Borikar <Sagar_Borikar@pmc-sierra.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Nathan Scott <nscott@aconex.com>, xfs@oss.sgi.com

On Fri, Jul 04, 2008 at 10:51:47AM -0700, Sagar Borikar wrote:
> 
> Copy is of the same file to 30 different directories and it is basically
> overwrite.

Not an overwrite - cp truncates the destination file first:

# cp t.t fred
# strace cp -f t.t fred
.....
stat("fred", {st_mode=S_IFREG|0644, st_size=5, ...}) = 0
stat("t.t", {st_mode=S_IFREG|0644, st_size=5, ...}) = 0
stat("fred", {st_mode=S_IFREG|0644, st_size=5, ...}) = 0
open("t.t", O_RDONLY)                   = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=5, ...}) = 0
open("fred", O_WRONLY|O_TRUNC)          = 4
             ^^^^^^^^^^^^^^^^
fstat(4, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
read(3, "fred\n", 4096)                 = 5
write(4, "fred\n", 5)                   = 5
close(4)                                = 0
close(3)                                = 0
.....


That being said, I can't reproduce it on a 2.6.24 (debian)
kernel, either.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
