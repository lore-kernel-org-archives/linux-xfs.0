Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2482B7CA7
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 03:27:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E8ACE8F8035
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 01:27:40 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id cyh2eQaCuAVB3ilB (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 12 Feb 2016 01:27:35 -0800 (PST)
Date: Fri, 12 Feb 2016 01:27:35 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix two memory leaks in xfs_attr_list.c error paths
Message-ID: <20160212092735.GA27496@infradead.org>
References: <1455129337-19255-1-git-send-email-mguzik@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1455129337-19255-1-git-send-email-mguzik@redhat.com>
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
To: Mateusz Guzik <mguzik@redhat.com>
Cc: stable@vger.kernel.org, xfs@oss.sgi.com

On Wed, Feb 10, 2016 at 07:35:37PM +0100, Mateusz Guzik wrote:
> This plugs 2 trivial leaks in xfs_attr_shortform_list and
> xfs_attr3_leaf_list_int.

Can you please add a out: label before the kmem_free at the end of
the function, return the actual error value there and make all others
returns after the kmem_alloc jump to that label?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
