Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p03Lu1jf132169 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 15:56:02 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 780B1230094
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 13:58:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id M7orZaovgcLE0qe6 for
	<xfs@oss.sgi.com>; Mon, 03 Jan 2011 13:58:08 -0800 (PST)
Date: Mon, 3 Jan 2011 16:57:21 -0500
From: Josef Bacik <josef@redhat.com>
Subject: Re: Hole Punching V3
Message-ID: <20110103215720.GA8392@localhost.localdomain>
References: <1290044780-2902-1-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1290044780-2902-1-git-send-email-josef@redhat.com>
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
To: Josef Bacik <josef@redhat.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, cluster-devel@redhat.com, cmm@us.ibm.com, joel.becker@oracle.com, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, linux-ext4@vger.kernel.org, torvalds@linux-foundation.org, linux-btrfs@vger.kernel.org

On Wed, Nov 17, 2010 at 08:46:14PM -0500, Josef Bacik wrote:
> This is version 3 of the hole punching series I've been posting.  Not much has
> changed, the history is below
> 
> V2->V3
> -FALLOC_FL_PUNCH_HOLE must also have FALLOC_FL_KEEP_SIZE in order to work
> -formatting fixes
> 
> V1->V2
> -Hole punching doesn't change file size
> -Fixed the mode checks in ext4/btrfs/gfs2 so they do what they are supposed to
> 
> I've updated my local copies of the xfsprogs patches I have to test this to use
> KEEP_SIZE and PUNCH_HOLE together, I'll post them after it looks like these
> patches are good to go, including the manpage update.  The xfstest I wrote ran
> fine both on xfs and btrfs (failing on btrfs obviously).  Thanks,
> 

I'd like to try and get this into the next merge window, it seems everybody is
happy with it so far, any other comments?  Provided everybody is ok with it, how
would you like me to send it to you Linus?  Would you prefer a pull request or
will you just pull the patches off the mailinglist?  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
