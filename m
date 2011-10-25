Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9PBsVCb169798 for <xfs@oss.sgi.com>; Tue, 25 Oct 2011 06:54:31 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 419B91CB8F7C
	for <xfs@oss.sgi.com>; Tue, 25 Oct 2011 04:54:30 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zAGesr7qnwLpCgPP for <xfs@oss.sgi.com>;
	Tue, 25 Oct 2011 04:54:30 -0700 (PDT)
Date: Tue, 25 Oct 2011 07:54:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: A question in the context of independent pquota
Message-ID: <20111025115428.GC22103@infradead.org>
References: <1319151746.1959.63.camel@chandra-lucid.austin.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1319151746.1959.63.camel@chandra-lucid.austin.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

Hi Chandra,

I don't think there is an easy way to add a field there.  Please
just add a new Q_XGETQSTAT_2 call that takes the new, larger structure.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
