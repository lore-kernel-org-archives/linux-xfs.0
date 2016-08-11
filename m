Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA5FB7CA2
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 12:48:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9E0298F8052
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:48:58 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gIN0yq9Q5kgBJ6of (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 11 Aug 2016 10:48:57 -0700 (PDT)
Date: Thu, 11 Aug 2016 10:48:55 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfs: test attr_list_by_handle cursor iteration
Message-ID: <20160811174855.GD31540@infradead.org>
References: <20160802235251.GB8586@birch.djwong.org>
	<20160803225150.GC25565@birch.djwong.org>
	<20160804042448.GR27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160804042448.GR27776@eguan.usersys.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org

On Thu, Aug 04, 2016 at 12:24:48PM +0800, Eryu Guan wrote:
> I have to replace false/true with 0/1 to build it on RHEL6. I can fix it
> at commit time if there's no other major updates.

Simply including <stdbool.h> would fix that on RHEL6, wouldn't it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
