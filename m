Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CD5D429DF5
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 14:23:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A94D930405F
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 12:23:01 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id zf5AiDr8p6qSC4n9 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 12:23:00 -0700 (PDT)
Date: Mon, 17 Aug 2015 12:23:00 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/11] xfsprogs: Add ifdef dirent checks where it was
	missing
Message-ID: <20150817192300.GC26222@infradead.org>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
	<1439828606-7886-3-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439828606-7886-3-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Mon, Aug 17, 2015 at 06:23:17PM +0200, Jan Tulak wrote:
> Add check for _DIRENT_HAVED_RECLEN/_OFF to read_directory().
> In dump_dirent() these checks already are used, but they were
> missing in read_directory.
> 
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

(and didn't I review this one previously?)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
