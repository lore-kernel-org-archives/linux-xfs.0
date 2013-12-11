Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 45FE27F73
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:40:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1CC608F8039
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:40:21 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id j2nu1ZImuxmfEPSJ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:40:20 -0800 (PST)
Date: Tue, 10 Dec 2013 23:40:19 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 01/10] xfstests: Add tmpfs support
Message-ID: <20131211074019.GA19248@infradead.org>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
	<1386706321-15795-2-git-send-email-jayr@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386706321-15795-2-git-send-email-jayr@google.com>
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
To: Junho Ryu <jayr@google.com>
Cc: hughd@google.com, tytso@mit.edu, branto@redhat.com, xfs@oss.sgi.com

On Tue, Dec 10, 2013 at 12:11:52PM -0800, Junho Ryu wrote:
> From: Boris Ranto <branto@redhat.com>
> 
> This is just a simple patch to get the tmpfs working as a target file
> system. The patch copies the way nfs is handled in xfstests.
> 
> I didn't change the xfstests logic to recognize a proper SCRATCH_DEV.
> Hence, the SCRATCH_DEV for tmpfs should be in nfs form (with ':' sign
> in it) in order for this to work properly.
> 
> Signed-off-by: Boris Ranto <branto@redhat.com>
> Signed-off-by: Junho Ryu <jayr@google.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
