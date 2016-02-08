Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 43BDD29DF5
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 08:27:38 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 338108F8035
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2016 06:27:35 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id smBlhlpdPmAjX83W (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2016 06:27:33 -0800 (PST)
Date: Mon, 8 Feb 2016 15:27:49 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] quota: Add support for ->get_nextdqblk() for VFS quota
Message-ID: <20160208142749.GD9451@quack.suse.cz>
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
	<1454596087-6814-2-git-send-email-jack@suse.cz>
	<20160205010519.GJ459@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160205010519.GJ459@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri 05-02-16 12:05:19, Dave Chinner wrote:
> On Thu, Feb 04, 2016 at 03:28:05PM +0100, Jan Kara wrote:
> > Add infrastructure for supporting get_nextdqblk() callback for VFS
> > quotas. Translate the operation into a callback to appropriate
> > filesystem and consequently to quota format callback.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> I'm a little confused here. What patchset is this dependent on? i.e.
> what introduces the ->get_nextdqblk method?

It depends on the patches Eric sent which introduce ->get_nextdqblk.

> The patches I currently have in my XFS working tree introduce this
> (quota: add new quotactl Q_XGETNEXTQUOTA) and everythign else is
> dependent on this. I looked a coupl eof days ago and I wasnt' able
> to find this in your tree.

Yeah, I have this patch as well, I just didn't push out.

> I'd much prefer that one of us publish a stable branch with just the
> quotactl() infrastructure (i.e. commands and bits up to the
> ->get_nextdqblk() callback) that we can then both base the different
> subsystem implementations off, rather than one of us having to pull
> in a whole tree of changes just to get the one commit we need...

Sure, I have pushed out:

'getnextquota' branch into my tree

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git 

which contains the patches from Eric I carry (including fixups in comments
other minor stuff I have found during final review). Can you please base
XFS patches on top of this branch? Thanks!

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
