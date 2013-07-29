Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7CE657F37
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 19:02:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5D5BA304032
	for <xfs@oss.sgi.com>; Sun, 28 Jul 2013 17:02:52 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	oHV7CpZwcr96XR3q for <xfs@oss.sgi.com>;
	Sun, 28 Jul 2013 17:02:50 -0700 (PDT)
Date: Mon, 29 Jul 2013 10:02:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
Message-ID: <20130729000247.GA13468@dastard>
References: <52C3E9E6-61DD-4537-9A64-C8CBFC86F6E3@gmail.com>
	<31450470.2412.1374978094689.JavaMail.root@benjamin.baylink.com>
	<CAAxjCEwwmu_4Xxc8xyPw5Jk2LLTag93698M_EQZb7TxnsVSqXw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAxjCEwwmu_4Xxc8xyPw5Jk2LLTag93698M_EQZb7TxnsVSqXw@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stefan Ring <stefanrin@gmail.com>
Cc: Jay Ashworth <jra@baylink.com>, Linux fs XFS <xfs@oss.sgi.com>

On Sun, Jul 28, 2013 at 09:18:52AM +0200, Stefan Ring wrote:
> > "You have to talk to whomever builds the kernel packages for the distro
> > you're working on; they should be able to tell you which XFS {version|
> > release|checkout} is built into that particular kernel RPM."
> 
> For what it's worth, you can try to pry this info out of Oracle's
> RedPatch <https://oss.oracle.com/projects/RedPatch/>, which actually
> doesn't look all that active anymore recently, but given that it's
> Oracle, one cannot seriously be surprised about anything.

Oh, that thing. It hasn't ben maintained because it didn't work
properly, needed lots of hand holding, and nobody actually cared.

> The thing is, that RHEL XFS and mainline XFS seem to have drifted
> apart a good deal, and as result, for an outsider, it is very
> difficult to correlate patches between the two branches.

Sure, they have diverged signficant;y as we've backported various
bits of XFs fetaures and bug fixes back into RHEL6. As have every
other distro that doesn't track mainline directly. That's why you
need to look at the kernel source package to know what code the
distro is running.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
