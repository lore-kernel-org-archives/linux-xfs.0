Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3AA2629DFB
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 13:51:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0C969304032
	for <xfs@oss.sgi.com>; Sun, 22 Sep 2013 11:51:21 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id NLxd976hxmYqI6AY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 22 Sep 2013 11:51:17 -0700 (PDT)
Date: Sun, 22 Sep 2013 11:51:04 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] stable_kernel_rules.txt: Exclude networking from stable
	rules
Message-ID: <20130922185104.GA7515@infradead.org>
References: <alpine.LRH.2.02.1309191229480.32035@file01.intranet.prod.int.rdu2.redhat.com>
	<20130919.135628.1201613770803318193.davem@davemloft.net>
	<alpine.LRH.2.02.1309191359300.12162@file01.intranet.prod.int.rdu2.redhat.com>
	<1379615474.22168.13.camel@joe-AO722>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1379615474.22168.13.camel@joe-AO722>
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
To: Joe Perches <joe@perches.com>
Cc: linux-doc@vger.kernel.org, netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, stephen@networkplumber.org, Mikulas Patocka <mpatocka@redhat.com>, Rob Landley <rob@landley.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>

This is also the preferred way to do it for XFS.  Maybe word it in a way
that we can easily add subsystems.

To me it generally seems to be the best way to do it - having random Ccs
and lots of stable trees doesn't seem like a very good way of handling
it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
