Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C83BB7F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 11:38:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B4C1B30404E
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 09:38:17 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id 1tOoIJfbfidVao9f (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 13 Nov 2014 09:38:16 -0800 (PST)
Date: Thu, 13 Nov 2014 09:38:13 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/9 V2] xfsdump: Fix overflow of "question" string in
	Media_prompt_erase()
Message-ID: <20141113173813.GA9959@infradead.org>
References: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
	<1415818638-32700-3-git-send-email-sandeen@redhat.com>
	<5463AF7A.8040006@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5463AF7A.8040006@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

> +	asprintf( &question, 
> +		 "overwrite data on media in drive %u?\n",
>  		 (unsigned int)drivep->d_index );

Where is the error handling?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
