Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EA23329DFA
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 14:50:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D51B18F8037
	for <xfs@oss.sgi.com>; Wed, 24 Apr 2013 12:50:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id XmNiomGiLoMmo5d2 for <xfs@oss.sgi.com>;
	Wed, 24 Apr 2013 12:50:01 -0700 (PDT)
Message-ID: <51783768.5050508@sandeen.net>
Date: Wed, 24 Apr 2013 14:50:00 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Support in RHEL Server 6.4 x86_64
References: <5177B899.4000707@dermichi.com>
In-Reply-To: <5177B899.4000707@dermichi.com>
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
To: Michael Weissenbacher <mw@dermichi.com>
Cc: xfs@oss.sgi.com

On 4/24/13 5:48 AM, Michael Weissenbacher wrote:
> Hi List!
> I was under the impression that XFS was officially supported by Red Hat
> Enterprise Linux.
> 
> During the installation i noticed that Anaconda wouldn't allow XFS as
> root file system. Well, that's not a big problem for me. But after
> installation i realized that they don't even include xfsprogs so that i
> could do mkfs.xfs. Well, also not a big problem, i used the latest
> tarball and compiled them myself.

Which gets you into unsupported land I'm afraid.  As others mentioned,
it's an add-on product in RHEL6, available w/ a separate subscription.
That subscription comes with official RHEL xfsprogs, and support.

> But the big question now is: can anybody actually recommend using XFS on
> stock RHEL? It does feel like being just a stepchild there. On the other
> hand there seem be be quite a number of patches that were backported for
> Red Hat's kernel and it does use delaylog by default (which IIRC wasn't
> the default with a stock 2.6.32 Kernel).

As Ric said, it's very much *not* a stepchild.  :)

-Eric
 
> tia,
> Michael
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
