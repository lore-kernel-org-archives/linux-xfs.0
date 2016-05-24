Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EAE977CA6
	for <xfs@oss.sgi.com>; Tue, 24 May 2016 08:11:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AB8BD8F804B
	for <xfs@oss.sgi.com>; Tue, 24 May 2016 06:11:03 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id p77HIpODrbKvuBK4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 24 May 2016 06:11:00 -0700 (PDT)
Date: Tue, 24 May 2016 15:10:58 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 09/15] fs: iomap based fiemap implementation
Message-ID: <20160524131058.GA21094@lst.de>
References: <1462783638-4968-1-git-send-email-hch@lst.de>
	<1462783638-4968-10-git-send-email-hch@lst.de>
	<1651455378.10041082.1464034166002.JavaMail.zimbra@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1651455378.10041082.1464034166002.JavaMail.zimbra@redhat.com>
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
To: Bob Peterson <rpeterso@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, vishal l verma <vishal.l.verma@intel.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Mon, May 23, 2016 at 04:09:26PM -0400, Bob Peterson wrote:
> I've been looking at this again. Where are the calls to the fs-specific bits
> for fiemap?

In the iomap_ops structure passed to iomap_fiemap.

> It looks like iomap_fiemap calls iomap_apply, which calls
> iomap_fiemap_actor, but that doesn't call any ops->iomap_get_iomap or similar.
> It calls the iomap_begin (which BTW has a comment that says "Execute a iomap
> write" which is probably wrong and should be more generic, as for cases like
> fiemap) and it calls iomap_end. But it never calls an fs-specific actor
> anywhere. Am I missing something? My earlier version passed in the actor
> function, as per Dave Chinner's request, but yours doesn't.

The iomap_begin callback is where you do the mapping.  the iomap_end
callback does any required cleanup, which in case of GFS2 probably
would be dropping the cluster lock protecting the mapping.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
