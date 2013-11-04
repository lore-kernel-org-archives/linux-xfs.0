Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E3827F4E
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 03:07:21 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3E5E28F8040
	for <xfs@oss.sgi.com>; Mon,  4 Nov 2013 01:07:18 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rB6TFDpCogxqhlbM (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 04 Nov 2013 01:07:17 -0800 (PST)
Date: Mon, 4 Nov 2013 01:07:16 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 22/30] db: add a special directory buffer verifier
Message-ID: <20131104090716.GC23564@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-23-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1383107481-28937-23-git-send-email-david@fromorbit.com>
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

On Wed, Oct 30, 2013 at 03:31:13PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because we only have a single directory type that is used for all
> the different buffer types, we need to provide a special verifier
> for the read code. That verifier needs to know all the directory
> types and when it find one it knows about, switch to the correct
> verifier and call it.
> 
> We already do this for certain readahead cases in the directory
> code, so there is precedence for this. If we don't find a magic
> number we recognise, the verifier fails...
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
