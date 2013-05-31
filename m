Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D93FD7F37
	for <xfs@oss.sgi.com>; Fri, 31 May 2013 00:35:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 74F19AC006
	for <xfs@oss.sgi.com>; Thu, 30 May 2013 22:35:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id kVABXOjJTBMw3WZ1 for <xfs@oss.sgi.com>;
	Thu, 30 May 2013 22:35:09 -0700 (PDT)
Message-ID: <51A8368C.8090006@sandeen.net>
Date: Fri, 31 May 2013 00:35:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 3.9.4 Oops running xfstests (WAS Re: 3.9.3: Oops running xfstests)
References: <510292845.4997401.1369279175460.JavaMail.root@redhat.com>
	<1985929268.4997720.1369279277543.JavaMail.root@redhat.com>
	<20130523035115.GY24543@dastard>
	<986348673.5787542.1369385526612.JavaMail.root@redhat.com>
	<20130527053608.GS29466@dastard>
	<1588848128.8530921.1369885528565.JavaMail.root@redhat.com>
	<20130530052049.GK29466@dastard>
	<1824023060.8558101.1369892432333.JavaMail.root@redhat.com>
	<1462663454.9294499.1369969415681.JavaMail.root@redhat.com>
In-Reply-To: <1462663454.9294499.1369969415681.JavaMail.root@redhat.com>
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
To: CAI Qian <caiqian@redhat.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, xfs@oss.sgi.com

On 5/30/13 10:03 PM, CAI Qian wrote:
> OK, so the minimal workload to trigger this I found so far was to
> run trinity, ltp and then xfstests. I have been able to easily
> reproduced on 3 servers so far, and I'll post full logs here for
> LKML and linux-mm as this may unrelated to XFS only. As far as
> I can tell from the previous testing results, this has never been
> reproduced back in 3.9 GA time. This seems also been reproduced
> on 3.10-rc3 mostly on s390x so far.
> CAI Qian
> 

Can you hit it w/o trinity?   I ask because trinity's stated
goal is to fuzz and corrupt, right - so it's quite possible
that blowing up later in xfs is a side effect?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
