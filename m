Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4662B7F6B
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 10:59:27 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C7253AC007
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 08:59:26 -0800 (PST)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id ezmtL6bQSxS5Va3p
	for <xfs@oss.sgi.com>; Mon, 23 Dec 2013 08:59:22 -0800 (PST)
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 00/21] Consolidate Posix ACL implementation V3
Date: Mon, 23 Dec 2013 16:57:58 +0000
Message-ID: <1387817904.8080.4.camel@ret.masoncoding.com>
References: <20131220131635.650823732@bombadil.infradead.org>
In-Reply-To: <20131220131635.650823732@bombadil.infradead.org>
Content-Language: en-US
Content-ID: <55F48838A946C644AC50A45C770BFE71@fb.com>
MIME-Version: 1.0
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
To: "hch@infradead.org" <hch@infradead.org>
Cc: "andreas.gruenbacher@linbit.com" <andreas.gruenbacher@linbit.com>, "jfs-discussion@lists.sourceforge.net" <jfs-discussion@lists.sourceforge.net>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "mfasheh@suse.com" <mfasheh@suse.com>, "reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "cluster-devel@redhat.com" <cluster-devel@redhat.com>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>

On Fri, 2013-12-20 at 05:16 -0800, Christoph Hellwig wrote:
> This series consolidates the various cut'n'pasted Posix ACL implementations
> into a single common one based on the ->get_acl method Linus added a while
> ago and a new ->set_acl counterpart.
> 
> This remove ~1800 lines of code and provides a single place to implement
> various nasty little gems of the semantics.

Is this in a git tree somewhere?  I'll pull in and test the btrfs bits.

-chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
