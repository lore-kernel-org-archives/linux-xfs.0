Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D7C9729E09
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 14:47:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BCBB48F8059
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 12:47:54 -0800 (PST)
Received: from fieldses.org (fieldses.org [174.143.236.118]) by cuda.sgi.com
	with ESMTP id 5k9RJaCxUR5QayHg (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 12:47:54 -0800 (PST)
Date: Fri, 6 Dec 2013 15:47:47 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: nfs vs xfstests 193
Message-ID: <20131206204747.GB12613@fieldses.org>
References: <20131106115648.GA24804@infradead.org> <52A1CF22.106@oracle.com>
	<20131206180858.GA2803@infradead.org>
	<20131206204404.GA12613@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131206204404.GA12613@fieldses.org>
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

On Fri, Dec 06, 2013 at 03:44:04PM -0500, bfields wrote:
> On Fri, Dec 06, 2013 at 10:08:58AM -0800, Christoph Hellwig wrote:
> > On Fri, Dec 06, 2013 at 05:20:34PM +0400, Stanislav Kholmanskikh wrote:
> > > Just to make the behaviour more consistent between NFS and other
> > > "local" file systems as It was done by
> > > commit https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=0953e620de0538cbd081f1b45126f6098112a598
> > 
> > Seems like we got others in line with XFS behavior.
> 
> But, not having tested the behavior, it looks like fs/open.c has a
> simlar !S_ISDIR() check.  Where's that behavior implemented?
> 
> > I'd prefer to have NFS follow this as well.
> 
> Huh.  Sachin, do you remember if there was any other motivation behind
> that patch?

Never mind, I see, the complaint is about the case where the id's don't
change, not about the directory case.  So Sachin's
0953e620de0538cbd081f1b45126f6098112a598 doesn't actually have anything
to do with this.

I'm fine with removing the id comparisons and changing the nfsd behavior
to match local filesystems.

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
