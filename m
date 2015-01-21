Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ED78A7F4E
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 10:08:05 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BECC9304066
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 08:08:05 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id Cs7BrRhbbUNnNT73 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2015 08:07:59 -0800 (PST)
Date: Wed, 21 Jan 2015 17:07:57 +0100
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3] xfs: buffer types need to be set
Message-ID: <20150121160757.GA20357@quack.suse.cz>
References: <1421800780-26008-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421800780-26008-1-git-send-email-david@fromorbit.com>
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
Cc: jack@suse.cz, xfs@oss.sgi.com

   Hi Dave,

On Wed 21-01-15 11:39:37, Dave Chinner wrote:
> These three patches detect and fix the issues you reported with log
> recovery finding buffers with a format type of zero. The type of
> zero (XFS_BLFT_UNKNOWN_BUF) is only valid for buffers that have
> been cancelled (i.e. invalidated or marked stale as they have been
> freed), so the series adds asserts to ensure these conditions are
> met during transaction commit. Hence we shouldn't ever get new code
> that fails to set the buffer type getting through testing.
> 
> The last two patches fix the cases that running xfstests uncovered
> where we don't set the buffer type appropriately. There may be more,
> but doing this much made my head hurt and xfstests is clean, so it's
> as much as I'm going to do right now. Can you test it and see if it
> runs clean (with CONFIG_XFS_WARN=y or CONFIG_XFS_DEBUG=y) on your
> test setup?
  Thanks for a quick response with patches. My test round has finished and
the new assertion didn't trigger so things look fine. I've also provided a
test kernel to the guy seeing these issues in the wild but there it took
days / weeks to trigger so I wouldn't wait for it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
