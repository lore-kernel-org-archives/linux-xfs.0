Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBLCbLYL039196 for <xfs@oss.sgi.com>; Mon, 21 Dec 2009 06:37:21 -0600
Date: Mon, 21 Dec 2009 13:36:54 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv2 00/12]posix_acl: Add the check items
Message-ID: <20091221123654.GA9201@lst.de>
References: <4B2F6153.8010609@gmail.com>
Mime-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B2F6153.8010609@gmail.com>
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
To: Liuwenyi <qingshenlwy@gmail.com>
Cc: adilger@sun.com, jack@suse.cz, neilb@suse.de, jeffm@suse.com, joel.becker@oracle.com, bfields@fieldses.org, linux-mtd@lists.infradead.org, onlyflyer@gmail.com, hch@lst.de, tiger.yang@oracle.com, strongzgy@gmail.com, ffilzlnx@us.ibm.com, sandeen@sandeen.net, jmorris@namei.org, cluster-devel@redhat.com, aelder@sgi.com, cjb@laptop.org, mfasheh@suse.com, bharrosh@panasas.com, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, viro@zeniv.linux.org.uk, swhiteho@redhat.com, chris.mason@oracle.com, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, tytso@mit.edu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, serue@us.ibm.com, dwmw2@infradead.org, ocfs2-devel@oss.oracle.com

I like taking these checks into posix_acl_valid, but I think the patch
submission needs a bit more work.

All the patches are extremly whitespace mangled.  And I don't think
splitting them up makes a whole lot of sense, when we do API changes
like this we usually fix up all callers.  So please try to fix your
mailer, merged them all into one, and maybe also chose a more
descriptive subject line, e.g.

Subject: take checks for NULL and error pointers into posix_acl_valid()


And btw, at least the XFS change seems incorrect - previously we
returned NULL acl pointer and this patch changes it to -EINVAL.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
