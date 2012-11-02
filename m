Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2H8GTq156339 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 12:08:16 -0500
Message-ID: <5093FE6A.2050703@sgi.com>
Date: Fri, 02 Nov 2012 12:10:02 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/6] xfs: fix buffer shudown reference count mismatch
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<1351816724-3000-6-git-send-email-david@fromorbit.com>
	<20121102024351.GU29378@dastard>
	<20121102131326.GG12578@infradead.org>
In-Reply-To: <20121102131326.GG12578@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 11/02/12 08:13, Christoph Hellwig wrote:
> I don't like this.  ioend processing is very different for synchrous
> writes, with the most important difference being that synchronous
> writes need to wake the submitter at I/O completion.  From all I can
> see your v2 patch breaks that beahviour.  For 3.7-rc I'd suggest
> taking the additional reference conditionally.
>
> For 3.8 I'm going to look into simply acquiring an additional reference
> for synchronous writes during I/O submission to kill these special cases
> all over the buffer code.

Testing shows that conditionally taking the additional reference does
work at avoiding the b_bhold is zero assert without causing pag is not
empty assert.

Thanks,

--Mark Tinguely.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
