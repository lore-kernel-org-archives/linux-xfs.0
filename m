Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n877PcBe221455 for <xfs@oss.sgi.com>; Mon, 7 Sep 2009 02:25:48 -0500
Received: from peace.netnation.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 672571B2C2A2
	for <xfs@oss.sgi.com>; Mon,  7 Sep 2009 00:26:34 -0700 (PDT)
Received: from peace.netnation.com (newpeace.netnation.com [204.174.223.7]) by
	cuda.sgi.com with ESMTP id WEgANDiLC6IFG3fD for
	<xfs@oss.sgi.com>; Mon, 07 Sep 2009 00:26:34 -0700 (PDT)
Received: from sim by peace.netnation.com with local (Exim 4.63)
	(envelope-from <sim@netnation.com>) id 1MkYbW-0002Og-1Z
	for xfs@oss.sgi.com; Mon, 07 Sep 2009 00:25:34 -0700
Date: Mon, 7 Sep 2009 00:25:34 -0700
From: Simon Kirby <sim@hostway.ca>
Subject: Re: XFS corruption [2.6.30.5+patches.2.6.30.tgz]
Message-ID: <20090907072534.GC4568@hostway.ca>
References: <20090907063724.GB4568@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090907063724.GB4568@hostway.ca>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hmm, I suspect the corruption here came from the RAID 6 implementation. 
I see corruption on another volume on this volume group now.  We happened
to test a two drive RAID 6 failure/rebuild shortly before this occurred.

So, perhaps it's not worth looking at this further other than perhaps the
part where the kernel hung. :)

Simon-

On Sun, Sep 06, 2009 at 11:37:24PM -0700, Simon Kirby wrote:

> Hello!
> 
> In a backup server attached to a Coraid shelf via AOE and DM, we saw
> 2.6.30.5+patches.2.6.30.tgz die with a corruption problem.  The kernel
> logged many similar errors, and then stopped responding some time later.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
