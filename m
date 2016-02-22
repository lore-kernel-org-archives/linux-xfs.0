Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3D19B7CB4
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 02:20:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BDE6CAC00F
	for <xfs@oss.sgi.com>; Mon, 22 Feb 2016 00:20:11 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id ZlGkvJg9dn9GFhYC (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 22 Feb 2016 00:01:04 -0800 (PST)
Date: Mon, 22 Feb 2016 09:01:24 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/3] quota: Add support for ->get_nextdqblk() for VFS quota
Message-ID: <20160222080124.GC7791@quack.suse.cz>
References: <1454596087-6814-1-git-send-email-jack@suse.cz>
	<1454596087-6814-2-git-send-email-jack@suse.cz>
	<56C7518E.4020204@sandeen.net>
	<20160219183342.GH30068@quack.suse.cz>
	<56C76241.9020203@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56C76241.9020203@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

On Fri 19-02-16 12:43:13, Eric Sandeen wrote:
> 
> 
> On 2/19/16 12:33 PM, Jan Kara wrote:
> > On Fri 19-02-16 11:31:58, Eric Sandeen wrote:
> >>
> >>
> >> On 2/4/16 8:28 AM, Jan Kara wrote:
> >>> Add infrastructure for supporting get_nextdqblk() callback for VFS
> >>> quotas. Translate the operation into a callback to appropriate
> >>> filesystem and consequently to quota format callback.
> >>>
> >>> Signed-off-by: Jan Kara <jack@suse.cz>
> >>> ---
> >>>  fs/ext4/super.c          |  1 +
> >>>  fs/quota/dquot.c         | 39 +++++++++++++++++++++++++++++++++++++++
> >>>  fs/reiserfs/super.c      |  1 +
> >>>  include/linux/quota.h    |  3 +++
> >>>  include/linux/quotaops.h |  3 +++
> >>>  5 files changed, 47 insertions(+)
> >>>
> >>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> >>> index f1b56ff01208..51649f442bf6 100644
> >>> --- a/fs/ext4/super.c
> >>> +++ b/fs/ext4/super.c
> >>> @@ -1100,6 +1100,7 @@ static const struct dquot_operations ext4_quota_operations = {
> >>>  	.write_info	= ext4_write_info,
> >>>  	.alloc_dquot	= dquot_alloc,
> >>>  	.destroy_dquot	= dquot_destroy,
> >>> +	.get_next_id	= dquot_get_next_id,
> >>>  };
> >>
> >> Hi Jan, doesn't this also need to set:
> >>
> >>
> >> +       .get_nextdqblk  = dquot_get_next_dqblk,
> >>
> >> in ext4_qctl_sysfile_operations?
> > 
> > Indeed, thanks for catching this. Patch added (with your authorship and
> > sign-off) into my tree and this time I've properly tested Q_GETNEXTQUOTA
> > for ext4 with quota in hidden inodes indeed works (previously I've tested
> > only visible quota files).
> 
> Thanks Jan, I wasn't quite sure what it should be doing, but this seemed
> right.  ;)  Sorry for not sending a proper patch.
> 
> So, when you tested visible quota files, I assume it was just falling
> back to the non-next variants of the quotactl, right?  We should not
> be hooking up the call for the visible quota files, right?

We are hooking up the call for visible quota files since it works without
issues. It is upto userspace to decide whether it wants to read the quota
file directly or use Q_GETNEXTQUOTA call to iterate over all dquots.

> FWIW, there is a test in [x]fstests now for the [X]GETNEXT calls, it's
> generic/244

Great, thanks!

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
