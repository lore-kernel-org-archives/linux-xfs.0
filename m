Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 24A907F63
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 10:37:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A5AABAC009
	for <xfs@oss.sgi.com>; Fri, 10 Oct 2014 08:37:30 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id QHWd3N8r3zUQB132 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 10 Oct 2014 08:37:29 -0700 (PDT)
Date: Fri, 10 Oct 2014 17:37:27 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 01/12] quota: Allow each filesystem to specify which
	quota types it supports
Message-ID: <20141010153727.GB8705@quack.suse.cz>
References: <1412952910-7142-1-git-send-email-jack@suse.cz>
	<1412952910-7142-2-git-send-email-jack@suse.cz>
	<5437FAB1.1010005@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5437FAB1.1010005@oracle.com>
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
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net, Jan Kara <jack@suse.cz>, Jeff Mahoney <jeffm@suse.de>, Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org, tytso@mit.edu, linux-ext4@vger.kernel.org, Steven Whitehouse <swhiteho@redhat.com>, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Fri 10-10-14 10:26:41, Dave Kleikamp wrote:
> On 10/10/2014 09:54 AM, Jan Kara wrote:
> > diff --git a/include/linux/quota.h b/include/linux/quota.h
> > index 80d345a3524c..b52539f42e19 100644
> > --- a/include/linux/quota.h
> > +++ b/include/linux/quota.h
> > @@ -56,6 +56,11 @@ enum quota_type {
> >  	PRJQUOTA = 2,		/* element used for project quotas */
> >  };
> >  
> > +/* Masks for quota types when used as a bitmask */
> > +#define QTYPE_MASK_USER (1 << USRQUOTA)
> > +#define QTYPE_MASK_GROUP (1 << GRPQUOTA)
> > +#define QTYPE_MASK_PROJECT (1 << PRJQUOTA)
> 
> The uses of these masks use the names QTYPE_MASK_USR, QTYPE_MASK_GRP,
> and QTYPE_MASK_PRJ
  Sigh. Friday afternoon isn't a good time for sending out patch sets :(
Thanks for catching this. I'll wait if someone has other feedback before
resending the patches...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
