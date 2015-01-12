Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F73D7F50
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2015 22:56:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5A4FC304053
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2015 20:56:13 -0800 (PST)
Received: from mail-yk0-f174.google.com (mail-yk0-f174.google.com
	[209.85.160.174]) by cuda.sgi.com with ESMTP id
	9F5636BtMpPeqrwg (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 11 Jan 2015 20:56:11 -0800 (PST)
Received: by mail-yk0-f174.google.com with SMTP id 10so8392377ykt.5
	for <xfs@oss.sgi.com>; Sun, 11 Jan 2015 20:56:10 -0800 (PST)
Date: Sun, 11 Jan 2015 23:56:06 -0500
From: Tom Haynes <thomas.haynes@primarydata.com>
Subject: Re: [PATCH 14/18] nfsd: pNFS block layout driver
Message-ID: <20150112045606.GA107426@slacker.internal.excfb.com>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-15-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1420561721-9150-15-git-send-email-hch@lst.de>
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

On Tue, Jan 06, 2015 at 05:28:37PM +0100, Christoph Hellwig wrote:
> Add a small shim between core nfsd and filesystems to translate the
> somewhat cumbersome pNFS data structures and semantics to something
> more palatable for Linux filesystems.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  .../filesystems/nfs/pnfs-block-server.txt          |  40 +++++
>  fs/nfsd/Makefile                                   |   2 +-
>  fs/nfsd/blocklayout.c                              | 194 +++++++++++++++++++++
>  fs/nfsd/blocklayoutxdr.c                           | 157 +++++++++++++++++
>  fs/nfsd/blocklayoutxdr.h                           |  62 +++++++
>  fs/nfsd/nfs4layouts.c                              |   7 +
>  fs/nfsd/pnfs.h                                     |   1 +
>  7 files changed, 462 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/filesystems/nfs/pnfs-block-server.txt
>  create mode 100644 fs/nfsd/blocklayout.c
>  create mode 100644 fs/nfsd/blocklayoutxdr.c
>  create mode 100644 fs/nfsd/blocklayoutxdr.h

Could you follow the client code convention by putting
each layout type in a directory?

lacker:linux loghyr$ ls -la fs/nfs/blocklayout/
total 80

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
