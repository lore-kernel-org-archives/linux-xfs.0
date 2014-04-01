Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 039D17F5D
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 13:56:57 -0500 (CDT)
Message-ID: <533B0BF5.5000404@sgi.com>
Date: Tue, 01 Apr 2014 13:56:53 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH xfstests] tests for file hash collisions on xfs filesystems
References: <20140327074156.GJ29498@order.stressinduktion.org>
	<20140401184903.GA13434@order.stressinduktion.org>
In-Reply-To: <20140401184903.GA13434@order.stressinduktion.org>
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
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: xfs@oss.sgi.com

On 04/01/14 13:49, Hannes Frederic Sowa wrote:
> This patch adds a new check for xfstests, which generates directories with 64
> distinct hash values and afterwards tries to delete the directory. This caused
> a hash ordering issue.
>
> The file-hash-tool can also generate files (this should result in the same
> original problem as with directories) and generate only filenames with one
> hash (this can be very well optimized in future).
>
> This is just a preview. Dave Chiner seems to want this as soon as possible,
> thus please review and suggest changes so I can adapt this patch ASAP.
>
> Thanks!
>
> Signed-off-by: Hannes Frederic Sowa<hannes@stressinduktion.org>
> ---

I had some suggestions for the C and xfstests that cross paths with this 
post.

--Mark.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
