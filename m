Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 59B167F55
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 10:42:16 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4D80C8F8065
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 08:42:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id o4wlmXTeWqRlT0yY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Dec 2013 08:41:54 -0800 (PST)
Date: Fri, 13 Dec 2013 08:41:54 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] xfs: allow linkat() on O_TMPFILE files
Message-ID: <20131213164154.GH20803@infradead.org>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
	<1386944873-16796-6-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386944873-16796-6-git-send-email-zwu.kernel@gmail.com>
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
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, Dec 13, 2013 at 10:27:53PM +0800, Zhi Yong Wu wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> Enable O_TMPFILE support in linkat().
> For more info, please refer to:
>   http://oss.sgi.com/archives/xfs/2013-08/msg00341.html

Generall you should provide all reasonable information in the changelog
instead of linking to it.

> +	if (sip->i_d.di_nlink == 0)
> +		tres = &M_RES(mp)->tr_link_tmpfile;
> +	else
> +		tres = &M_RES(mp)->tr_link;

As mentioned before I think Dave wanted you to always use the same
reservation, but I'll leave that discussion to him.

> +/* For creating a link to an O_TMPFILE inode, except modifying
> + * those metadata for regular inode, we still need to remove an inode
> + * from unlinked list at first. That is,  we can modify:
> + *    the agi hash list and counters: sector size
> + *    the on disk inode before ours in the agi hash list: inode cluster size
> + */

We always have an emptry content

/*

line at the beginning of comments in XFS and the Linux kernel in
general.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
