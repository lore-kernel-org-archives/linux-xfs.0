Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 67C357F4E
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 19:45:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 546C08F804B
	for <xfs@oss.sgi.com>; Mon,  7 Oct 2013 17:45:33 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	pKg5hI2ZFGd151AV for <xfs@oss.sgi.com>;
	Mon, 07 Oct 2013 17:45:32 -0700 (PDT)
Date: Tue, 8 Oct 2013 11:45:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfstests generic/260: get correct trimmed bytes
Message-ID: <20131008004528.GS4446@dastard>
References: <20131004010737.GE4446@dastard>
	<1380868376-16783-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1380868376-16783-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 04, 2013 at 02:32:56PM +0800, Eryu Guan wrote:
> Starting from util-linux v2.23 fstrim(1) reports trimmed bytes
> differently, e.g.
> 
> new fstrim: /mnt/ext4: 9.7 GiB (10411118592 bytes) trimmed
> old fstrim: /mnt/ext4: 10411118592 bytes were trimmed
> 
> generic/260 reports syntax error
> 
>     +./tests/generic/260: line 111: [: 9.7: integer expression expected
>     +./tests/generic/260: line 121: [: 9.7: integer expression expected
>     +./tests/generic/260: line 183: [: 9.7: integer expression expected
> 
> Add a new filter called _filter_fstrim in common/filter and get the
> correct trimmed bytes in generic/260, so the test passes with both old
> and new fstrim.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
> v2: add _filter_fstrim to filter the output as Dave suggested

Looks good!

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
