Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0OBiseD247496 for <xfs@oss.sgi.com>; Tue, 24 Jan 2012 05:44:54 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ivu6dsMgk4yww2CH (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jan 2012 03:44:52 -0800 (PST)
Date: Tue, 24 Jan 2012 12:44:49 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/8] vfs: Protect write paths by sb_start_write -
	sb_end_write
Message-ID: <20120124114449.GC15974@quack.suse.cz>
References: <1327091686-23177-1-git-send-email-jack@suse.cz>
	<1327091686-23177-3-git-send-email-jack@suse.cz>
	<20120124082119.GO15102@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120124082119.GO15102@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Surbhi Palande <csurbhi@gmail.com>, Kamal Mostafa <kamal@canonical.com>, Eric Sandeen <sandeen@sandeen.net>, LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Tue 24-01-12 19:21:19, Dave Chinner wrote:
> On Fri, Jan 20, 2012 at 09:34:40PM +0100, Jan Kara wrote:
> > There are three entry points which dirty pages in a filesystem.  mmap (handled
> > by block_page_mkwrite()), buffered write (handled by
> > __generic_file_aio_write()), and truncate (it can dirty last partial page -
> > handled inside each filesystem separately). Protect these places with
> > sb_start_write() and sb_end_write().
> 
> fallocate can also dirty pages, either during preallocation or hole
> punching.  Hence if you are going to promote truncate to
> SB_FREEZE_WRITE protection then you need to promote everything else
> that can zero partial blocks as well.
> 
> That also means that anything the has implemented XFS_IOC_ ioctl
> interfaces for prellocation and hole punching (xfs, ocfs2 and gfs2
> IIRC) also needs to be protected in the same way.
  Yeah, you are right. As I wrote in the introductory mail, there's problem
with metadata operations (e.g. directory modifications) anyway so we'll
have to audit all places where transactions are started. First I'll do this
for ext4 as a POC and then I'll try to do that for XFS if Eric doesn't beat
me to it (he promised to have a look at XFS part ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
