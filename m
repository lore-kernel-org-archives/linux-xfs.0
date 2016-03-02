Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2432B7CB1
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 07:14:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DBAE2304032
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 05:14:48 -0800 (PST)
Received: from mail-oi0-f41.google.com (mail-oi0-f41.google.com
	[209.85.218.41]) by cuda.sgi.com with ESMTP id xyRmzq5Nw7AGSqVX
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 02 Mar 2016 05:14:46 -0800 (PST)
Received: by mail-oi0-f41.google.com with SMTP id c203so59925504oia.2
	for <xfs@oss.sgi.com>; Wed, 02 Mar 2016 05:14:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160301072011.GF30721@dastard>
References: <3685DFAD20214109878873CF81232704@alyakaslap>
	<20160222212019.GI25832@dastard>
	<CAOcd+r1XY2kcp+qJ=mPOAQSmb90QUnLfmT3-FkMjQN_+Ejmt8A@mail.gmail.com>
	<20160222235628.GK25832@dastard>
	<D5578D3E98EE48B88EA9A1126B671155@alyakaslap>
	<20160223225926.GN25832@dastard>
	<BC0CC25E00CE4CEDA1FFDFC0A2F38742@alyakaslap>
	<20160229211628.GK29057@dastard> <20160301072011.GF30721@dastard>
Date: Wed, 2 Mar 2016 14:14:46 +0100
Message-ID: <CA+o=1OV3U=miqbaxJpPpioWmFnu4zDdb3+PwAdG7=2HtZqVyFQ@mail.gmail.com>
Subject: Re: xfs resize: primary superblock is not updated immediately
From: Fanael Linithien <fanael4@gmail.com>
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
Cc: Danny Shavit <danny@zadarastorage.com>, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Alex Lyakas <alex@zadarastorage.com>

2016-03-01 8:20 GMT+01:00 Dave Chinner <david@fromorbit.com>:
> than prior to the grow operation, then the new AGs will not have
> in-memory xfs_perag structurea associated with them.

                      ^^^^^^^^^^
structures

> This is easily fixed by simply re-initialising the perag structure
> after re-reading the superblock at the conclusion of the first pahse
> of log recovery.

                                                                 ^^^^^
phase

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
