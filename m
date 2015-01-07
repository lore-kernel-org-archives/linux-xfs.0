Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 734C37F85
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 04:28:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4343A304039
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2015 02:28:06 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id TRGOq3Y0W664UFDx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 07 Jan 2015 02:28:04 -0800 (PST)
Date: Wed, 7 Jan 2015 11:28:02 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 14/18] nfsd: pNFS block layout driver
Message-ID: <20150107102802.GA28783@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-15-git-send-email-hch@lst.de>
	<20150106171658.GD12067@fieldses.org>
	<20150106173957.GA16200@lst.de>
	<20150106193949.GD28003@fieldses.org>
	<20150106114205.4151269c@synchrony.poochiereds.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150106114205.4151269c@synchrony.poochiereds.net>
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
To: Jeff Layton <jeff.layton@primarydata.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Jan 06, 2015 at 11:42:05AM -0800, Jeff Layton wrote:
> Or maybe an "on" switch?
> 
> We have some patches (not posted currently) that add a "pnfs" export
> option. Maybe we should add that and only enable pnfs on exports that
> have that option present?

I would defintively prefer the off switch.  I can add one if people want
it, but export options are a little annoying as they require support
not only in the kernel but also in nfs-utils.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
