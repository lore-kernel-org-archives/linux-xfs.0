Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8CDCA7F6B
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 11:01:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 63E6B30408C
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 09:01:08 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id DyeFDGjxJZE74Lnp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 23 Dec 2013 09:01:07 -0800 (PST)
Date: Mon, 23 Dec 2013 09:01:03 -0800
From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 00/21] Consolidate Posix ACL implementation V3
Message-ID: <20131223170103.GA14856@infradead.org>
References: <20131220131635.650823732@bombadil.infradead.org>
	<1387817904.8080.4.camel@ret.masoncoding.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1387817904.8080.4.camel@ret.masoncoding.com>
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
To: Chris Mason <clm@fb.com>
Cc: "andreas.gruenbacher@linbit.com" <andreas.gruenbacher@linbit.com>, "jfs-discussion@lists.sourceforge.net" <jfs-discussion@lists.sourceforge.net>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "mfasheh@suse.com" <mfasheh@suse.com>, "reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "hch@infradead.org" <hch@infradead.org>, "cluster-devel@redhat.com" <cluster-devel@redhat.com>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>

On Mon, Dec 23, 2013 at 04:57:58PM +0000, Chris Mason wrote:
> On Fri, 2013-12-20 at 05:16 -0800, Christoph Hellwig wrote:
> > This series consolidates the various cut'n'pasted Posix ACL implementations
> > into a single common one based on the ->get_acl method Linus added a while
> > ago and a new ->set_acl counterpart.
> > 
> > This remove ~1800 lines of code and provides a single place to implement
> > various nasty little gems of the semantics.
> 
> Is this in a git tree somewhere?

Only on my box.  Given how shitty kernel.org is to use these days I
don't bother with it anymore.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
