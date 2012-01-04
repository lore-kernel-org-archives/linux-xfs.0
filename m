Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04IhkBA163616 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 12:43:47 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	q05aY41tEuhOuRSy for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 10:43:45 -0800 (PST)
Date: Wed, 4 Jan 2012 13:43:44 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 276: Ensure lost+found is not created with
	wrong link count (V2)
Message-ID: <20120104184344.GA8364@infradead.org>
References: <1323887614-21290-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1323887614-21290-1-git-send-email-cmaiolino@redhat.com>
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
To: cmaiolino@redhat.com
Cc: xfs@oss.sgi.com

On Wed, Dec 14, 2011 at 04:33:34PM -0200, cmaiolino@redhat.com wrote:
> From: Carlos Maiolino <cmaiolino@redhat.com>
> 
> xfs_repair was leaving lost+found directory with a wrong link count when a
> cleaned inode was re-used to create lost+found. This test case confirm that,
> after xfs_repair is executed, the lost+found inode is left in a consistent
> state.

This one is missing the 276.out file.  In the meantime the repository
also has testst 277 and 278 - can you resend with the output file
included against the current xfstests-dev repository?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
