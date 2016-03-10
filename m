Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5D4727CA0
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 03:18:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0E7D0304048
	for <xfs@oss.sgi.com>; Thu, 10 Mar 2016 01:18:25 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id rEb0lDWhw7J70lqJ (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Mar 2016 01:18:20 -0800 (PST)
Date: Thu, 10 Mar 2016 10:18:40 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: linux-next: manual merge of the xfs tree with the ext4 tree
Message-ID: <20160310091840.GC5026@quack.suse.cz>
References: <20160310104056.78033e72@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160310104056.78033e72@canb.auug.org.au>
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
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jan Kara <jack@suse.cz>, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu 10-03-16 10:40:56, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the xfs tree got a conflict in:
> 
>   fs/ext4/inode.c
> 
> between commit:
> 
>   109811c20fb8 ("ext4: simplify io_end handling for AIO DIO")
> 
> from the ext4 tree and commit:
> 
>   74c66bcb7eda ("ext4: Fix data exposure after failed AIO DIO")
> 
> from the xfs tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks. The merge looks correct.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
