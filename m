Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 717577F8E
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 11:42:20 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F25F5AC005
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 09:42:19 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id 3RB8AX0GaOTuuqVg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 09:42:17 -0800 (PST)
Date: Tue, 6 Jan 2015 18:42:14 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 10/18] nfsd: implement pNFS layout recalls
Message-ID: <20150106174214.GB16200@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-11-git-send-email-hch@lst.de>
	<20150106172508.GE12067@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150106172508.GE12067@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

> This bothers me a little: cl_addr is just the address that the
> exchange_id came from.  In theory there's no one-to-one relationship
> between NFSv4 clients and IP addresses.  Is it likely the iscsi traffic
> could use a different interface than the MDS traffic?
> 
> If this is the best we can do, then maybe this should at least be
> documented.

The pNFS block fencing protocol bothers me a lot, it seems like very
little thought went into that part of the standard.

I proposed a new SCSI layout type that fixes those issues on the
NFSv4 WG list, but there's been zero interest in it:

http://www.ietf.org/mail-archive/web/nfsv4/current/msg13469.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
