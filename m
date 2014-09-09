Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1F30F7F55
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 17:29:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E25C78F8049
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 15:28:59 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id Ei01gzYMXHvkDek2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 15:28:57 -0700 (PDT)
Date: Tue, 9 Sep 2014 15:28:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs_repair: clear bad flgs in process_dinode_int
Message-ID: <20140909222856.GA27349@infradead.org>
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
	<1410108065-18156-2-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1410108065-18156-2-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 07, 2014 at 11:41:01AM -0500, Eric Sandeen wrote:
> process_dinode_int() reports bad flags if
> dino->di_flags & ~XFS_DIFLAG_ANY - i.e. if
> any flags are set outside the known set.  But
> then instead of clearing them, it does
> flags &= ~XFS_DIFLAG_ANY which keeps *only*
> the bad flags.  This leads to persistent,
> unrepairable errors of the form:

You know you can use up to 75 characters per line for your commit messages,
don't you? :)

Otherwise looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
