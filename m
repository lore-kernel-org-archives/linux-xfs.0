Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6FD4dQ233155 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 09:13:04 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78C531A31317
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 07:13:03 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	LHwHgo2yDo1IPxGg for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 07:13:03 -0800 (PST)
Date: Tue, 6 Dec 2011 10:13:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: check if qa user can execute commands
Message-ID: <20111206151300.GA11874@infradead.org>
References: <1323165389-5419-1-git-send-email-list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1323165389-5419-1-git-send-email-list.btrfs@jan-o-sch.net>
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
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Dec 06, 2011 at 10:56:29AM +0100, Jan Schmidt wrote:
> _require_user only checks if the qa user exists in /etc/passwd. It may exist
> though still not be able to execute anything (e.g. with a /bin/false shell).
> 
> _user_do cannot determine failure to execute the given command, as it uses
> _user_do_filter for post-processing which succeeds even if the command
> fails. Thus, the check should be performed by _require_user.

Looks good.  Wouldn't

	su $qa_user -c /bin/true

be the more normal way to write that test?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
