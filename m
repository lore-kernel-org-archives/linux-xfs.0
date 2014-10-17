Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1E6517F3F
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2014 04:36:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F1DA38F8039
	for <xfs@oss.sgi.com>; Fri, 17 Oct 2014 02:35:58 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id WcMgv88NUoY0xeWq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Oct 2014 02:35:57 -0700 (PDT)
Date: Fri, 17 Oct 2014 02:35:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfs_vn_rename by xfs_vn_rename2
Message-ID: <20141017093556.GA9146@infradead.org>
References: <1413397042-32229-1-git-send-email-cmaiolino@redhat.com>
	<1413397042-32229-2-git-send-email-cmaiolino@redhat.com>
	<20141016210457.GA33732@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141016210457.GA33732@bfoster.bfoster>
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
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Thu, Oct 16, 2014 at 05:04:57PM -0400, Brian Foster wrote:
> The function rename seems unnecessary..? Meh, not a big deal to me
> either way. Otherwise, this one seems Ok.

Yeah, we might as well keep the old name.  As far as I'm concerned
I'd love to get rid of the two different IOPS in the VFS, too.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
