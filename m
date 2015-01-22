Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 577017F54
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 09:45:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1ABC38F8037
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 07:45:37 -0800 (PST)
Received: from mail-qa0-f46.google.com (mail-qa0-f46.google.com
	[209.85.216.46]) by cuda.sgi.com with ESMTP id UFpmfNXctFoekR14
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 22 Jan 2015 07:45:33 -0800 (PST)
Received: by mail-qa0-f46.google.com with SMTP id j7so1674738qaq.5
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 07:45:33 -0800 (PST)
From: Jeff Layton <jeff.layton@primarydata.com>
Date: Thu, 22 Jan 2015 10:45:30 -0500
Subject: Re: [PATCH 03/20] fs: add FL_LAYOUT lease type
Message-ID: <20150122104530.44297670@tlielax.poochiereds.net>
In-Reply-To: <1421925006-24231-4-git-send-email-hch@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
	<1421925006-24231-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
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
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Thu, 22 Jan 2015 12:09:49 +0100
Christoph Hellwig <hch@lst.de> wrote:

> This (ab-)uses the file locking code to allow filesystems to recall
> outstanding pNFS layouts on a file.  This new lease type is similar but
> not quite the same as FL_DELEG.  A FL_LAYOUT lease can always be granted,
> an a per-filesystem lock (XFS iolock for the initial implementation)
> ensures not FL_LAYOUT leases granted when we would need to recall them.
> 
> Also included are changes that allow multiple outstanding read
> leases of different types on the same file as long as they have a
> differnt owner.  This wasn't a problem until now as nfsd never set
> FL_LEASE leases, and no one else used FL_DELEG leases, but given that
> nfsd will also issues FL_LAYOUT leases we will have to handle it now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/locks.c         | 14 ++++++++++----
>  include/linux/fs.h | 16 ++++++++++++++++
>  2 files changed, 26 insertions(+), 4 deletions(-)
> 

Abuse indeed. :)

I'd probably prefer to move this to a separate list within the i_flctx
instead of overloading the lease stuff, but I'm not religious about it.

I can live with this for now, and if and when we get around to
representing different types of file locks with different types of
structures, we can do that conversion then.

Acked-by: Jeff Layton <jlayton@primarydata.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
