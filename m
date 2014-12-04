Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A72B7F3F
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 08:37:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 399D18F8035
	for <xfs@oss.sgi.com>; Thu,  4 Dec 2014 06:37:13 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id DYgFTsrJKJf7ZzbN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Dec 2014 06:37:11 -0800 (PST)
Date: Thu, 4 Dec 2014 14:37:09 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 2/5] fs: Fix WARN_ON in inode_set_mask()
Message-ID: <20141204143708.GM29748@ZenIV.linux.org.uk>
References: <1417699659-14284-1-git-send-email-jack@suse.cz>
	<1417699659-14284-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1417699659-14284-3-git-send-email-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, xfs@oss.sgi.com

On Thu, Dec 04, 2014 at 02:27:36PM +0100, Jan Kara wrote:
> WARN_ON in inode_set_mask() warns if we don't clear all bits we are
> setting instead of reverse - warning when caller requests setting and
> clearing of the same bit.

WTF?  'mask' is "all bits we are asked to modify", 'flags' - "the values to
put into those bits".  Have you even looked at the callers, let alone
tested it?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
