Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6FEZQf233270 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 09:14:35 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBA8B29EAEC
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 07:14:34 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	a2QqFaTEQXugtjfC for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 07:14:34 -0800 (PST)
Date: Tue, 6 Dec 2011 10:14:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] security: Delay freeing inode->i_security till the end
	of RCU grace period
Message-ID: <20111206151429.GB11874@infradead.org>
References: <1323110541.31919.1451.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1323110541.31919.1451.camel@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>, linux-security-module@vger.kernel.org, XFS Mailing List <xfs@oss.sgi.com>

On Mon, Dec 05, 2011 at 12:42:21PM -0600, Chandra Seetharaman wrote:
> while running test case 234 from xfstests test suite, I was getting an
> occational memory fault in inode_has_perm() with the following stack

Interesting.  Given that have no good way to free other data with the
normal inode callback it looks like we indeed need to do this
separately.

What about IMA or similar monsters?  Posix ACLs already are covered at
least.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
