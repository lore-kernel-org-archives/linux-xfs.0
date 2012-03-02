Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q227k0c6008016 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 01:46:00 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	8jkVQwSIlarKdHzi (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 01 Mar 2012 23:45:59 -0800 (PST)
Date: Fri, 2 Mar 2012 02:45:58 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] xfsprogs: replace deprecated ustat call with statfs
	in libxfs/linux.c
Message-ID: <20120302074558.GB4117@infradead.org>
References: <1330636285-11200-1-git-send-email-kdasu.kdev@gmail.com>
	<de74feb44ebd887269fe85d9a5879765afccf4c2.1330635228.git.kdasu.kdev@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <de74feb44ebd887269fe85d9a5879765afccf4c2.1330635228.git.kdasu.kdev@gmail.com>
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
To: Kamal Dasu <kdasu.kdev@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Mar 01, 2012 at 04:11:24PM -0500, Kamal Dasu wrote:
> >From the ustat man page
> 
> NOTES
>        ustat() is deprecated and has only  been  provided  for  compatibility.
>        All new programs should use statfs(2) instead.

xfsprogs isn't new :)

More seriously - ustat provides the benefit to check if the block device
is mounted anywhere, which we make use of here.  A statfs of the block
device path doesn't provide that functionality at all.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
