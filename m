Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AB2C47F3F
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 12:34:24 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7C4438F8033
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 10:34:24 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ZW9SF4JJsfAgiWeG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2014 10:34:18 -0800 (PST)
Date: Thu, 4 Dec 2014 19:34:16 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/5] fs: Fix WARN_ON in inode_set_mask()
Message-ID: <20141204183416.GA23273@quack.suse.cz>
References: <1417699659-14284-1-git-send-email-jack@suse.cz>
	<1417699659-14284-3-git-send-email-jack@suse.cz>
	<20141204143708.GM29748@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141204143708.GM29748@ZenIV.linux.org.uk>
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
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, Jan Kara <jack@suse.cz>, xfs@oss.sgi.com

On Thu 04-12-14 14:37:09, Al Viro wrote:
> On Thu, Dec 04, 2014 at 02:27:36PM +0100, Jan Kara wrote:
> > WARN_ON in inode_set_mask() warns if we don't clear all bits we are
> > setting instead of reverse - warning when caller requests setting and
> > clearing of the same bit.
> 
> WTF?  'mask' is "all bits we are asked to modify", 'flags' - "the values to
> put into those bits".  Have you even looked at the callers, let alone
> tested it?
  Sorry, I misunderstood how the function is supposed to work. Discard this
patch please.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
