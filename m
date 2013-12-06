Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 45BCD29E1B
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 13:47:23 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1FA08304048
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 11:47:23 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id AtXYnlA5SOquyheA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 11:47:22 -0800 (PST)
Date: Fri, 6 Dec 2013 11:47:20 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Cluster-devel] [PATCH 16/18] gfs2: use generic posix ACL
	infrastructure
Message-ID: <20131206194720.GB32122@infradead.org>
References: <20131201115903.910559036@bombadil.infradead.org>
	<20131201120656.539995924@bombadil.infradead.org>
	<1386159157.2711.11.camel@menhir>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1386159157.2711.11.camel@menhir>
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
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Christoph Hellwig <hch@infradead.org>, linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org

On Wed, Dec 04, 2013 at 12:12:37PM +0000, Steven Whitehouse wrote:
> >  		error = posix_acl_equiv_mode(acl, &mode);
> > +		if (error < 0)
> >  
> Andy Price has pointed out a missing "return error;" here
> 
> > -		if (error <= 0) {
> > -			posix_acl_release(acl);
> > +		if (error == 0)
> >  			acl = NULL;
> >  
> > -			if (error < 0)
> > -				return error;
> > -		}
> > -
> 
> Also, there seems to be a white space error in the xfs patch around line
> 170 in fs/xfs/xfs_iops.c where there is an added "if (default_acl)" with
> a space before the tab,

I'll take care of these for the next version.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
