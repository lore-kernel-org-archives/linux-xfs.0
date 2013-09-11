Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 818F47F3F
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 10:50:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6F94B304043
	for <xfs@oss.sgi.com>; Wed, 11 Sep 2013 08:50:23 -0700 (PDT)
Received: from awesome.dsw2k3.info (awesome.dsw2k3.info [217.188.63.246]) by
	cuda.sgi.com with ESMTP id DIIyCOtlCy6MAn4n (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Sep 2013 08:50:22 -0700 (PDT)
Date: Wed, 11 Sep 2013 17:50:17 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: [PATCH] xfs: change the immutable in xfs_open_by_handle
Message-ID: <20130911155017.GA13575@citd.de>
References: <20130910184724.726933044@sgi.com>
	<20130911135502.GA21898@infradead.org> <52307CB6.3060506@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52307CB6.3060506@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Greg Banks <gbanks@sgi.com>, xfs@oss.sgi.com

On 11.09.2013 09:22, Mark Tinguely wrote:
> On 09/11/13 08:55, Christoph Hellwig wrote:
> >On Tue, Sep 10, 2013 at 01:47:20PM -0500, Mark Tinguely wrote:
> >>This patch allows clients like DMF to modify an immutable file
> >>without changing the immutable capability on the file, which
> >>would expose the file to change.
> >>
> >>This patch is restricted to holders of the CAP_LINUX_IMMUTABLE,
> >>so no addition security risk has been introduced.
> >
> >The immutable flag means that the file can't be modified, and
> >CAP_LINUX_IMMUTABLE allows setting/removing that restriction, but not
> >ignoring it.
> >
> >So: NAK, this is a change in semantics and long-standing behaviour.
> >
> 
> As you said, the CAP_LINUX_IMMUTABLE allows the holder of the
> capability to turn on/off the restriction. The holder of
> CAP_LINUX_IMMUTABLE could turn off immutability, modify it and then
> turn it back on, but during that window, others could modify it too
> which may be more undesirable than changing the behavior.

It's like setting a file you own "444" only because you CAN set it to 
666 doesn't mean that the check should be short-circuted.

$ touch test
$ chmod 444 test
$ echo 'Hallo' > test
-bash: test: Permission denied



-- 

Matthias

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
