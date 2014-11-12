Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0C1707F3F
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 12:58:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DEB99304043
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 10:58:46 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id GpM3K1S9jfNOnkDg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 10:58:45 -0800 (PST)
Date: Wed, 12 Nov 2014 10:58:45 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9] xfsdump: Fix overflow of "question" string in
	Media_prompt_erase()
Message-ID: <20141112185845.GA24616@infradead.org>
References: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
	<1415818638-32700-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415818638-32700-3-git-send-email-sandeen@redhat.com>
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

On Wed, Nov 12, 2014 at 12:57:11PM -0600, Eric Sandeen wrote:
> The string we were sprintf'ing is trivially longer than the array
> we allocated for it.
> 
> Allocate something big enough, and snprintf to avoid overflow

How about switching it to asprintf() to get rid of that dangerous static
buffer entirely?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
