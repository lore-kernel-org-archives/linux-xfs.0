Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5DF4B7F95
	for <xfs@oss.sgi.com>; Wed, 21 Aug 2013 01:44:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4738C3040BD
	for <xfs@oss.sgi.com>; Tue, 20 Aug 2013 23:44:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id mOd8eYnnSiTBdecS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Aug 2013 23:43:59 -0700 (PDT)
Date: Tue, 20 Aug 2013 23:43:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] quota: Add a new quotactl command Q_XGETQSTATV
Message-ID: <20130821064357.GA8822@infradead.org>
References: <1375828029-26360-1-git-send-email-sekharan@us.ibm.com>
	<1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1375828029-26360-2-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Abhijith Das <adas@redhat.com>, Jan Kara <jack@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>, xfs@oss.sgi.com

Sorry for being late to the game, but I don not like the in-kernel
interface here at all.  Given that Q_XGETQSTATV is a strict superset
of Q_XGETQSTAT there is no need for the second method - just always
fill out the larger in-kernel structure and only copy the smaller
information to userspace for the Q_XGETSTAT case.  That keeps the amount
of code required in the implementations of the methods low and follows
the model used elsewhere in the kernel (e.g. stat and statfs)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
