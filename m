Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C4EF17CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 12:35:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F302AC003
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 10:35:38 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id s5BBkedCpcElajcB for <xfs@oss.sgi.com>;
	Tue, 31 May 2016 10:35:36 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id B202C2B18
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 12:35:35 -0500 (CDT)
Subject: Re: [PATCH 3/3] xfs: optimize bio handling in the buffer writeback
	path
References: <1458128681-10869-1-git-send-email-hch@lst.de>
	<1458128681-10869-4-git-send-email-hch@lst.de>
	<b8d49db2-131d-0735-c803-adec326f43bb@sandeen.net>
	<20160531163118.GA7016@infradead.org>
	<066e4a87-42f9-2c3c-3ab2-f9be58af8b97@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fe4d6255-69e1-5ed4-3fb5-67c549154d65@sandeen.net>
Date: Tue, 31 May 2016 12:35:36 -0500
MIME-Version: 1.0
In-Reply-To: <066e4a87-42f9-2c3c-3ab2-f9be58af8b97@sandeen.net>
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
To: xfs@oss.sgi.com

On 5/31/16 11:44 AM, Eric Sandeen wrote:

> Hrmph, I guess I have misunderstood what's going on.  :/  Sorry.

I wasn't aware of the whole bioset front_pad stuff.  Tricky and
clever and horrible all at the same time IMHO.  ;)  Makes sense
now.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
