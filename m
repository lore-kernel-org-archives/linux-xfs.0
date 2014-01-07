Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC5AF7F3F
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 09:53:38 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C5A0E304077
	for <xfs@oss.sgi.com>; Tue,  7 Jan 2014 07:53:37 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id WwLCC0r64qXAz0Yw (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 07 Jan 2014 07:53:36 -0800 (PST)
Date: Tue, 7 Jan 2014 07:53:24 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/21] Consolidate Posix ACL implementation V3
Message-ID: <20140107155324.GA24113@infradead.org>
References: <20131220131635.650823732@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131220131635.650823732@bombadil.infradead.org>
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
To: viro@zeniv.linux.org.uk
Cc: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>, xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com, linux-mtd@lists.infradead.org, Joel Becker <jlbec@evilplan.org>, jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

On Fri, Dec 20, 2013 at 05:16:35AM -0800, Christoph Hellwig wrote:
> This series consolidates the various cut'n'pasted Posix ACL implementations
> into a single common one based on the ->get_acl method Linus added a while
> ago and a new ->set_acl counterpart.
> 
> This remove ~1800 lines of code and provides a single place to implement
> various nasty little gems of the semantics.

Any more comments?  Al, what's the best way to make sure this doesn't
miss 3.14?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
