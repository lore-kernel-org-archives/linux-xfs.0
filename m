Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ECA4A7F3F
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 15:34:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DAB16304043
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 13:34:09 -0700 (PDT)
Received: from smtprelay.hostedemail.com (smtprelay0064.hostedemail.com
	[216.40.44.64]) by cuda.sgi.com with ESMTP id LG0Mh6GbGFf98TX9
	for <xfs@oss.sgi.com>; Mon, 23 Sep 2013 13:34:08 -0700 (PDT)
Message-ID: <1379968445.3575.60.camel@joe-AO722>
Subject: Re: [PATCH] stable_kernel_rules.txt: Exclude networking from stable
	rules
From: Joe Perches <joe@perches.com>
Date: Mon, 23 Sep 2013 13:34:05 -0700
In-Reply-To: <20130922185104.GA7515@infradead.org>
References: <alpine.LRH.2.02.1309191229480.32035@file01.intranet.prod.int.rdu2.redhat.com>
	<20130919.135628.1201613770803318193.davem@davemloft.net>
	<alpine.LRH.2.02.1309191359300.12162@file01.intranet.prod.int.rdu2.redhat.com>
	<1379615474.22168.13.camel@joe-AO722>
	<20130922185104.GA7515@infradead.org>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-doc@vger.kernel.org, netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, stephen@networkplumber.org, Mikulas Patocka <mpatocka@redhat.com>, Rob Landley <rob@landley.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>

On Sun, 2013-09-22 at 11:51 -0700, Christoph Hellwig wrote:
> This is also the preferred way to do it for XFS.  Maybe word it in a way
> that we can easily add subsystems.
> 
> To me it generally seems to be the best way to do it - having random Ccs
> and lots of stable trees doesn't seem like a very good way of handling
> it.

Maybe adding a mechanism to MAINTAINERS would be better.
Maybe a default B: (backport?) of stable@vger.kernel.org
with a per-subsystem override?

SUBSYSTEM TYPE
M:	maintainer@email.address
L:	list@email.address
S:	Supported
F:	file/pattern/
B:	stable@email.address


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
