Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q13F4jPr137608 for <xfs@oss.sgi.com>; Fri, 3 Feb 2012 09:04:46 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	0qci0FySKjz9029B (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 03 Feb 2012 07:04:44 -0800 (PST)
Date: Fri, 3 Feb 2012 10:04:43 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_io: deprecate the "-F" foreign flag
Message-ID: <20120203150443.GA28301@infradead.org>
References: <4F2AC948.1050909@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F2AC948.1050909@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 02, 2012 at 11:35:04AM -0600, Eric Sandeen wrote:
> There's no real reason to force the user to specify "-F" for non-xfs
> files, when we can just test for that after it's opened.
> 
> * Remove the -F flag from usage() & man pages, but still accept it.
> * Set IO_FOREIGN when we open the file, if the fd tests as non-xfs.

Looks good. We probably should kill the IO_FOREIGN eventually too, but
let's do the user facing part first.


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
