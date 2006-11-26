Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Nov 2006 06:06:53 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAQE6iaG015090
	for <xfs@oss.sgi.com>; Sun, 26 Nov 2006 06:06:45 -0800
Message-ID: <45699F40.9090700@sandeen.net>
Date: Sun, 26 Nov 2006 08:05:52 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] Make stuff static
References: <45338DDE.8020903@sandeen.net> <4533FAEA.2080500@sandeen.net> <20061016232250.GM11034@melbourne.sgi.com> <1161042943.5723.117.camel@xenon.msp.redhat.com> <20061017005038.GN11034@melbourne.sgi.com> <AED98B89E193744D39BAC541@pmmelb207.melbourne.sgi.com> <20061017215706.GI8394166@melbourne.sgi.com> <1161125131.5723.158.camel@xenon.msp.redhat.com> <20061122004216.GT11034@melbourne.sgi.com> <1164157783.19915.46.camel@xenon.msp.redhat.com> <20061122042445.GR37654165@melbourne.sgi.com>
In-Reply-To: <20061122042445.GR37654165@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Russell Cattelan <cattelan@thebarn.com>, Tim Shimmin <tes@sgi.com>, xfs@oss.sgi.com

David Chinner wrote:

> Performance appears to be slight faster with the noinline
> patch, but the variation is within the error margins of
> my measurements so I'd say it's neutral.
> 
> Comments?

with fewer inlines & more function calls, what about stack frames adding 
up?  can we measure that?

-Eric
