Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7AE287F37
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 09:30:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 16550AC005
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 07:30:24 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HqoJdEl0AWBjEGHI (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 01 Aug 2014 07:30:23 -0700 (PDT)
Date: Fri, 1 Aug 2014 07:30:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfs: dquot recovery needs verifiers
Message-ID: <20140801143023.GD26455@infradead.org>
References: <1406768509-32556-1-git-send-email-david@fromorbit.com>
	<1406768509-32556-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406768509-32556-5-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 31, 2014 at 11:01:49AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> dquot recovery should add verifiers to the dquot buffers that it
> recovers changes into. Unfortunately, it doesn't attached the
> verifiers to the buffers in a consistent manner. For example,
> xlog_recover_dquot_pass2() reads dquot buffers without a verifier
> and then writes it without ever having attached a verifier to the
> buffer.
> 
> Further, dquot buffer recovery may write a dquot buffer that has not
> been modified, or indeed, shoul dbe written because quotas are not
> enabled and hence changes to the buffer were not replayed. In this
> case, we again write buffers without verifiers attached because that
> doesn't happen until after the buffer changes have been replayed.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

The xlog_recover_do_reg_buffer look fine to me, but what's the rationale
for removing the xfs_dqcheck call?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
