Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2L3w6wE216548 for <xfs@oss.sgi.com>; Fri, 20 Mar 2009 22:58:26 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1975A1C5C90A
	for <xfs@oss.sgi.com>; Fri, 20 Mar 2009 20:57:46 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id B2iTWq5p0ep1SXTs for <xfs@oss.sgi.com>;
	Fri, 20 Mar 2009 20:57:46 -0700 (PDT)
Message-ID: <49C465AC.3010809@sandeen.net>
Date: Fri, 20 Mar 2009 22:57:32 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 4/5] xfs: remove m_litino
References: <20090318094119.561416000@bombadil.infradead.org>
	<20090318094132.224487000@bombadil.infradead.org>
In-Reply-To: <20090318094132.224487000@bombadil.infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:

> With the upcoming v3 inodes the inode data/attr area size needs to be
> calculated for each specific inode, so we can't cache it in the superblock
> anymore.

hm, ok, but why do this now?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
