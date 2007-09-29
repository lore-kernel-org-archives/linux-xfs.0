Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Sep 2007 09:29:23 -0700 (PDT)
Received: from slurp.thebarn.com (cattelan-host202.dsl.visi.com [208.42.117.202])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8TGTCuC020913
	for <xfs@oss.sgi.com>; Sat, 29 Sep 2007 09:29:15 -0700
Message-ID: <46FE7CF2.9070806@thebarn.com>
Date: Sat, 29 Sep 2007 11:27:30 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: PARTIAL TAKE 971050 - Remove linux-2.4 build support
References: <20070926083416.C441A30A90AD@linuxbuild.melbourne.sgi.com> <20070929094032.GA29241@infradead.org>
In-Reply-To: <20070929094032.GA29241@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: donaldd@sgi.com, xfs@oss.sgi.com

Christoph Hellwig wrote:
> On Wed, Sep 26, 2007 at 06:34:16PM +1000, donaldd@sgi.com wrote:
>   
>> Remove Makefile wrappers in XFS
>>
>> Makefile (and Kbuild) would include Makefile-linux-26
>> I doubt XFS will really still compile on 2.4; so drop that. This
>> moves Makefile-linux-26 into Makefile and drops Kbuild.
>> Also having wrappers as both Kbuild and Makefile seemed redundant
>> anyways.
>>     
>
> After pulling this patch I can't build XFS anymore, because
> in the CVS export there's a zero-size fs/xfs/Kbuild file left and the
> kernel build thus doesn't actually look at fs/xfs/Makefile.
>
> Can someone from SGI check if the file really isn't deleted in ptools
> or whether is is a fuckup in the cvs export script?
>
>   
I might be a combination of both, the Attic processing is a bit tricky.
I'll try and figure out what is going wrong and get the SGI guys to
adjust things if need be.
