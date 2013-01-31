Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1DA987F50
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 13:32:07 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 071398F8049
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 11:32:06 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id YxIcbgvwJgfxgSSp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Jan 2013 11:32:05 -0800 (PST)
Date: Thu, 31 Jan 2013 11:31:57 -0800
From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 0/4 v2] Fix possible use after free with AIO
Message-ID: <20130131193156.GA20817@localhost>
References: <1359502081-20240-1-git-send-email-jack@suse.cz>
	<20130130144535.GK4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130130144535.GK4503@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, ocfs2-devel@oss.oracle.com, xfs@oss.sgi.com

On Wed, Jan 30, 2013 at 02:45:35PM +0000, Al Viro wrote:
> On Wed, Jan 30, 2013 at 12:27:57AM +0100, Jan Kara wrote:
> > 
> >   Hi,
> > 
> >   since nobody seem to have picked up any of the patches (at least
> > nobody told me so), I've added acks I received to the patches and I'm
> > sending them to Al for merging. Al, can you please merge these? Thanks.
> 
> VFS part (4/4) picked; IMO at least ext* and xfs should go through the
> filesystem trees.  If ocfs2 folks don't pick fs/ocfs2 part, I'll grab
> it as well - not sure how active their tree is these days...

	I thought akpm had this through -mm.  I acked it there.

Joel

> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

"Same dancers in the same old shoes.
 You get too careful with the steps you choose.
 You don't care about winning but you don't want to lose
 After the thrill is gone."

			http://www.jlbec.org/
			jlbec@evilplan.org

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
