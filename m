Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Nov 2006 08:14:13 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAMGE3aG010972
	for <xfs@oss.sgi.com>; Wed, 22 Nov 2006 08:14:05 -0800
Message-ID: <4564771B.4040004@sandeen.net>
Date: Wed, 22 Nov 2006 10:13:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] Make stuff static
References: <45338DDE.8020903@sandeen.net> <4533FAEA.2080500@sandeen.net> <20061016232250.GM11034@melbourne.sgi.com> <1161042943.5723.117.camel@xenon.msp.redhat.com> <20061017005038.GN11034@melbourne.sgi.com> <AED98B89E193744D39BAC541@pmmelb207.melbourne.sgi.com> <20061017215706.GI8394166@melbourne.sgi.com> <1161125131.5723.158.camel@xenon.msp.redhat.com> <20061122004216.GT11034@melbourne.sgi.com> <1164157783.19915.46.camel@xenon.msp.redhat.com> <20061122042445.GR37654165@melbourne.sgi.com> <4563D7DD.1060907@melbourne.sgi.com>
In-Reply-To: <4563D7DD.1060907@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: chatz@melbourne.sgi.com
Cc: David Chinner <dgc@sgi.com>, Russell Cattelan <cattelan@thebarn.com>, Tim Shimmin <tes@sgi.com>, xfs@oss.sgi.com

David Chatterton wrote:
> 
> David Chinner wrote:
>> Comments?
>>
> 
> Just reducing xfs_bmapi by 118 bytes makes this worthwhile doesn't it?
> 
> Out of interest, what estimated improvement does this have on one of Jesper's
> stacks?
> 
> Should we be concerned that there are now more functions with 100 or more bytes?

I don't think we need to worry about that, it is probably in the noise.

There will almost certainly be fallout from this change w.r.t. 4k 
stacks. It should probably at least be tested on 4k stacks over a fairly 
complex volume setup to see.

Also with respect to stack usage, is there extra stack space used, in 
addition to the explicit %esp adjustments, to set up each function call?

IOW is the total more than the sum of the parts? :)

I'm glad to hear that there's no apparent performance penalty....

-eric
