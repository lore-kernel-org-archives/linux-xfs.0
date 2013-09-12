Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B272A29DFB
	for <xfs@oss.sgi.com>; Thu, 12 Sep 2013 09:50:27 -0500 (CDT)
Date: Thu, 12 Sep 2013 09:50:26 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: remove dead code from xlog_recover_inode_pass2
Message-ID: <20130912145026.GA1935@sgi.com>
References: <20130912140122.873071199@sgi.com>
	<20130912140127.489098296@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130912140127.489098296@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, xfs@oss.sgi.com

On Thu, Sep 12, 2013 at 09:01:23AM -0500, Mark Tinguely wrote:
> Additional code in the error handler of xlog_recover_inode_pass2()
> results in the following error:
> 
> static checker warning: "fs/xfs/xfs_log_recover.c:2999
> xlog_recover_inode_pass2()
> 	 info: ignoring unreachable code."
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Mark Tinguely <tinguely@sgi.com>

Looks fine.  Applied.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
