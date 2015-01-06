Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 022F87F67
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 11:59:56 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D76CE304043
	for <xfs@oss.sgi.com>; Tue,  6 Jan 2015 09:59:52 -0800 (PST)
Received: from mail-pd0-f174.google.com (mail-pd0-f174.google.com
	[209.85.192.174]) by cuda.sgi.com with ESMTP id
	zUY3NUYbntTkHlQQ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 06 Jan 2015 09:59:50 -0800 (PST)
Received: by mail-pd0-f174.google.com with SMTP id fp1so30672737pdb.5
	for <xfs@oss.sgi.com>; Tue, 06 Jan 2015 09:59:50 -0800 (PST)
Date: Tue, 6 Jan 2015 09:59:44 -0800
From: Tom Haynes <thomas.haynes@primarydata.com>
Subject: Re: [PATCH 10/18] nfsd: implement pNFS layout recalls
Message-ID: <20150106175943.GA14225@kitty.kitty>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-11-git-send-email-hch@lst.de>
	<20150106172508.GE12067@fieldses.org>
	<20150106174214.GB16200@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150106174214.GB16200@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

On Tue, Jan 06, 2015 at 06:42:14PM +0100, Christoph Hellwig wrote:
> > This bothers me a little: cl_addr is just the address that the
> > exchange_id came from.  In theory there's no one-to-one relationship
> > between NFSv4 clients and IP addresses.  Is it likely the iscsi traffic
> > could use a different interface than the MDS traffic?
> > 
> > If this is the best we can do, then maybe this should at least be
> > documented.
> 
> The pNFS block fencing protocol bothers me a lot, it seems like very
> little thought went into that part of the standard.
> 
> I proposed a new SCSI layout type that fixes those issues on the
> NFSv4 WG list, but there's been zero interest in it:
> 
> http://www.ietf.org/mail-archive/web/nfsv4/current/msg13469.html
> 

I don't know if I would say zero interest or normal apathy on the
NFSv4 WG list to replying outside of the IETF meeting venue.

I'd certainly like to see it go forward.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
