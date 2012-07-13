Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6DINV9f179689 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 13:23:31 -0500
Message-ID: <500067A0.2010809@sgi.com>
Date: Fri, 13 Jul 2012 13:23:28 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstest: test corruption with multi extent in PAGE.
References: <20120601185815.883227033@sgi.com>
	<20120601185935.708235862@sgi.com>
	<20120605091352.GL4347@dastard> <4FCDFA16.9050808@sgi.com>
	<4FFFF528.8060909@sgi.com>
In-Reply-To: <4FFFF528.8060909@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alain Renaud <arenaud@sgi.com>
Cc: xfs@oss.sgi.com

On 07/13/12 05:15, Alain Renaud wrote:
> Since I got no feedback on the updated version let me send it again.
>
> xfstest: test corruption with multi extent in PAGE.
>
> Test using extsize/resvspace to create a file with multiple extent in
> one PAGE.
> This show an error in the block conversion from unwritten to real.
> As a result we tag raw disk block as valid(3-4)
> and valid data as unwritten(5-6)
>
> On an x86_64 machine the page should look like this.
>
> buffer content
> 0 empty b_state = 0
> 1 DATA b_state = 0x1023
> 2 DATA b_state = 0x1023
> 3 empty b_state = 0
> 4 empty b_state = 0
> 5 DATA b_state = 0x1023
> 6 DATA b_state = 0x1023
> 7 empty b_state = 0
>
> Signed-off-by: Alain Renaud <arenaud@sgi.com>

Tested with and without commit 7d0fa3ecba2f12ceef93fffe615e5dd9b50bb794
Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
