Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 04F2329DF5
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 10:31:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D51DB304043
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2016 08:31:34 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id rsBbNVppxOB9whOf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2016 08:31:32 -0800 (PST)
Date: Tue, 9 Feb 2016 17:31:30 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: reflink log reservations
Message-ID: <20160209163130.GA29654@lst.de>
References: <20160204074617.GB20496@lst.de>
	<20160204081620.GL20038@birch.djwong.org>
	<20160204133133.GA28701@lst.de>
	<20160204180551.GB27899@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160204180551.GB27899@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

I've still seen the assert a couple of times with the fix, and
with yesterdays tree update they are back reproducibly (always in
generic/168 over NFS).

I suspect the problem is that xfs_refcountbt_alloc_block fully
recurses into the allocator and thus could basically double
the log reservation.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
