Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9507E7CA0
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 09:40:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5618F8F8064
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2016 07:40:12 -0700 (PDT)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 8POcGzQmuYcV0nw9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 30 Aug 2016 07:40:08 -0700 (PDT)
Date: Tue, 30 Aug 2016 16:40:06 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/4] xfs: make xfs_inode_set_eofblocks_tag cheaper for
	the common case
Message-ID: <20160830144006.GA14504@lst.de>
References: <1471816273-28940-1-git-send-email-hch@lst.de>
	<1471816273-28940-4-git-send-email-hch@lst.de>
	<20160825123808.GC25041@bfoster.bfoster>
	<20160826142616.GA21535@lst.de>
	<20160826160209.GB17728@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160826160209.GB17728@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Aug 26, 2016 at 12:02:09PM -0400, Brian Foster wrote:
> > I don't think taking it should be too bad, but given the ops ordering
> > it also seems entirely pointless to even take it.
> > 
> 
> Then why are we taking it? I assumed it at least served as a memory
> barrier...

I meant to take it for that early check, not in general.

I guess this is another hint we should try to look into using proper
atomic bitops here..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
