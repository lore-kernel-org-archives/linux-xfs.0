Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1SAB9SR173794 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 04:11:09 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id xfRhEu440hM4fgAD (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 02:11:07 -0800 (PST)
Date: Tue, 28 Feb 2012 11:11:05 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: Warning from unlock_new_inode
Message-ID: <20120228101105.GA4125@quack.suse.cz>
References: <20120222220137.GB3650@quack.suse.cz>
	<20120228083444.GB22995@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120228083444.GB22995@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Tue 28-02-12 03:34:44, Christoph Hellwig wrote:
> On Wed, Feb 22, 2012 at 11:01:37PM +0100, Jan Kara wrote:
> >   Hello,
> > 
> >   while running fsstress on XFS partition with 3.3-rc4 kernel + my freeze
> > fixes (they do not touch anything relevant AFAICT) I've got the following
> > warning:
> 
> That's stressing including freezes or without?  Do you have a better
> description of te workload?
  It was:
~/tests/xfstests-dev/ltp/fsstress -d /mnt -n 10000 -p 4

  while doing in parallel
while true; do freeze; sync; unfreeze; sleep 4; done
 
> Either way it's an odd one, I can't see any obvious way how this would
> happen.
  Yeah, and I never seen it again although I was stressing the filesystem
for quite a long time. So I think we can put this off for now.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
