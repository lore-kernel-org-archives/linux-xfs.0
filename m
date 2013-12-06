Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C65B829E09
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 14:44:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4E129AC00C
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 12:44:19 -0800 (PST)
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id B26F07i9qhEtGvn1 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 12:44:17 -0800 (PST)
Date: Fri, 6 Dec 2013 15:44:04 -0500
Subject: Re: nfs vs xfstests 193
Message-ID: <20131206204404.GA12613@fieldses.org>
References: <20131106115648.GA24804@infradead.org> <52A1CF22.106@oracle.com>
	<20131206180858.GA2803@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206180858.GA2803@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Vasily Isaenko <vasily.isaenko@oracle.com>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com, "Sachin S. Prabhu" <sprabhu@redhat.com>, Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>

On Fri, Dec 06, 2013 at 10:08:58AM -0800, Christoph Hellwig wrote:
> On Fri, Dec 06, 2013 at 05:20:34PM +0400, Stanislav Kholmanskikh wrote:
> > Just to make the behaviour more consistent between NFS and other
> > "local" file systems as It was done by
> > commit https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=0953e620de0538cbd081f1b45126f6098112a598
> 
> Seems like we got others in line with XFS behavior.

But, not having tested the behavior, it looks like fs/open.c has a
simlar !S_ISDIR() check.  Where's that behavior implemented?

> I'd prefer to have NFS follow this as well.

Huh.  Sachin, do you remember if there was any other motivation behind
that patch?

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
