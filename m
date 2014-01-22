Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F039C7F7C
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 08:54:54 -0600 (CST)
Message-ID: <52DFDBBF.50803@sgi.com>
Date: Wed, 22 Jan 2014 08:54:55 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfsprogs 3.1.12 and 3.2.0 releases?
References: <201401201822.48520.arekm@maven.pl>
	<20140120230814.GA4287@infradead.org>
	<20140120231158.GL1935@sgi.com> <201401210917.38674.arekm@maven.pl>
	<20140121234151.GJ13997@dastard> <52DFD801.40801@sgi.com>
In-Reply-To: <52DFD801.40801@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 01/22/14 08:38, Mark Tinguely wrote:
...

> Thanks for making the list. I agree with Dave above about 3 feature
> patches and the directory file type changes.
>
> The following patch that is in your "not sure" list looks like a good
> bug fix that is not CRC related:
>
> ba28b64e69ce3a7989df88f71a5cb608b1c71e3 xfs_repair: drop buffer
> reference on symlink error
>

Take that back, if (fsbno == NULLDFSBNO) then bp will be NULL also. So 
we do not want to do the libxfs_putbuf()... this patch is not 
appropriate for 3.1.12.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
