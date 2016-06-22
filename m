Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D6C3F7CA1
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 07:59:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9C3DE8F8037
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2016 05:59:33 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id jCghfKBC5FCF7hB9 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 22 Jun 2016 05:59:32 -0700 (PDT)
Date: Wed, 22 Jun 2016 05:59:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/6] libxfs/linux.c: Replace use of ustat by stat
Message-ID: <20160622125930.GA11203@infradead.org>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112195945.GC568@nyan> <20160113075501.GC21939@infradead.org>
	<20160113174241.GC10942@nyan>
	<20160114102009.GD27644@infradead.org>
	<20160618145349.GA17760@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160618145349.GA17760@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Sorr for not getting back to you.  It turns out that simply using
O_EXCL is fairly easy, but fitting it into a portabilitity framework
isn't.  So I think I'll have to give up on that attempt for now.

That being said I think ustat fits pretty well for this use case,
so getting rid of it might need a little more justification.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
