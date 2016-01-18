Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3E84B7F53
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 05:00:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 26488304032
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 03:00:51 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id p89dehkkKYGTlEMI (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Jan 2016 03:00:49 -0800 (PST)
Date: Mon, 18 Jan 2016 03:00:46 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] quota: add new quotactl Q_XGETQUOTA2
Message-ID: <20160118110046.GA25594@infradead.org>
References: <568FEA2C.6080708@redhat.com>
	<20160109072600.GA21636@infradead.org>
	<20160111132617.GD6262@quack.suse.cz>
	<5693D33A.5090307@sandeen.net>
	<20160111162807.GK6262@quack.suse.cz>
	<5696D27A.9070700@sandeen.net>
	<20160115093507.GA15950@quack.suse.cz>
	<56992CD4.6030408@sandeen.net>
	<20160118103302.GD6850@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160118103302.GD6850@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Eric Sandeen <sandeen@redhat.com>

On Mon, Jan 18, 2016 at 11:33:02AM +0100, Jan Kara wrote:
> OK, ok. I like Dave's proposal for quotactl2(). So let's leave the unification
> for later and implent Q_GETNEXTQUOTA and Q_XGETNEXTQUOTA with the
> functionality of your original Q_XGETQUOTA2. Having separate call to get
> next ID would save us one new quotactl but OTOH we would need two syscalls
> (and quota structure lookups) to report one structure and there are
> potentially *lots* of them.

Oh well.  Guess I should give in and just accept the original patch..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
