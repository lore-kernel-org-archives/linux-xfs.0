Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 585CF7F4E
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 14:54:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D6AD2AC007
	for <xfs@oss.sgi.com>; Tue,  3 Dec 2013 12:54:42 -0800 (PST)
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id fFp8hgpNydtai7sF (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 03 Dec 2013 12:54:38 -0800 (PST)
Date: Tue, 3 Dec 2013 15:54:33 -0500
Subject: Re: [PATCH] fs: fix iversion handling
Message-ID: <20131203205433.GB2648@fieldses.org>
References: <20131119151707.GA13412@infradead.org>
	<20131202173636.GA17724@infradead.org>
	<529DA5C6.7040403@panasas.com>
	<20131203094507.GD4906@infradead.org>
	<529DB536.7050008@panasas.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <529DB536.7050008@panasas.com>
From: "J. Bruce Fields" <bfields@fieldses.org>
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
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, NFS list <linux-nfs@vger.kernel.org>, xfs@oss.sgi.com

On Tue, Dec 03, 2013 at 12:40:54PM +0200, Boaz Harrosh wrote:
> On 12/03/2013 11:45 AM, Christoph Hellwig wrote:
> > On Tue, Dec 03, 2013 at 11:35:02AM +0200, Boaz Harrosh wrote:
> >> Hi Christoph
> >>
> >> What happens with all other filesystems exported under KNFSD?
> >>
> >> As I understand inode_inc_iversion() is used in NFSv4 and up,
> >> what will increment the inode-version on changed attributes
> >> for them?
> > 
> > It's used by the filesystem for the change attribute that NFSDd
> > can optionally use.  Most filesystsems don't support it and work
> > okay enough when NFS exported.  No other filesystem will need
> > to adopt for this patch specificly, given that no other filesystem
> > uses this infrastructure.
> > 
> 
> OK Thanks, I did not know that. I assumed change-attribute is
> naturally supported.
> 
> I will look at ext4 example and wire up exofs. Because it is very
> important for me to support the change-attribute properly.

Just please don't follow ext4's example of making support dependent on a
mount option.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
