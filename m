Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3UN1AH9045618 for <xfs@oss.sgi.com>; Mon, 30 Apr 2012 18:01:10 -0500
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	ZXUcAkqV80AUGh0N for <xfs@oss.sgi.com>;
	Mon, 30 Apr 2012 16:01:08 -0700 (PDT)
Date: Tue, 1 May 2012 09:01:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: detecting case-insensitivity
Message-ID: <20120430230105.GL7015@dastard>
References: <20120407140029.GA24090@fieldses.org>
	<20120411200335.GD28816@infradead.org>
	<20120411203735.GB31706@fieldses.org>
	<20120430212649.GB22323@fieldses.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120430212649.GB22323@fieldses.org>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Apr 30, 2012 at 05:26:49PM -0400, J. Bruce Fields wrote:
> On Wed, Apr 11, 2012 at 04:37:35PM -0400, J. Bruce Fields wrote:
> > On Wed, Apr 11, 2012 at 04:03:35PM -0400, Christoph Hellwig wrote:
> > > Can you add a new s_feature_flags instead of s_flags which is shared
> > > with the mount user ABI?  MS_I_VERSION should also move there.
> > 
> > I was wondering about that.  Yes, that makes a lot more sense, I'll work
> > on it.
> 
> Just something like this?

.....

>  #define S_SYNC		1	/* Writes are synced at once */
> @@ -268,7 +271,7 @@ struct inodes_stat_t {
>  					((inode)->i_flags & (S_SYNC|S_DIRSYNC)))
>  #define IS_MANDLOCK(inode)	__IS_FLG(inode, MS_MANDLOCK)
>  #define IS_NOATIME(inode)   __IS_FLG(inode, MS_RDONLY|MS_NOATIME)
> -#define IS_I_VERSION(inode)   __IS_FLG(inode, MS_I_VERSION)
> +#define IS_I_VERSION(inode)  ((inode)->i_sb->s_flags & SF_I_VERSION)

(inode)->i_sb->s_feature_flags?

>  #define IS_NOQUOTA(inode)	((inode)->i_flags & S_NOQUOTA)
>  #define IS_APPEND(inode)	((inode)->i_flags & S_APPEND)
> @@ -1428,7 +1431,8 @@ struct super_block {
>  	const struct dquot_operations	*dq_op;
>  	const struct quotactl_ops	*s_qcop;
>  	const struct export_operations *s_export_op;
> -	unsigned long		s_flags;
> +	unsigned long		s_flags; /* mount flags */
> +	unsigned int		s_feature_flags;

why not an unsigned long like s_flags?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
