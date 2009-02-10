Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1ANU0v9082914 for <xfs@oss.sgi.com>; Tue, 10 Feb 2009 17:30:01 -0600
Message-ID: <49920EC9.6060600@sgi.com>
Date: Wed, 11 Feb 2009 10:33:29 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Re-dirty pages on I/O error
References: <4990DCF6.5000900@sgi.com> <20090210100129.GN8830@disturbed>
In-Reply-To: <20090210100129.GN8830@disturbed>
Reply-To: lachlan@sgi.com
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
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Tue, Feb 10, 2009 at 12:48:38PM +1100, Lachlan McIlroy wrote:
>> [This patch seems to have slipped through the proverbial crack.]
>>
>> If we get an error in xfs_page_state_convert() - and it's not EAGAIN - then
>> we throw away the dirty page without converting the delayed allocation.  This
>> leaves delayed allocations that can never be removed and confuses code that
>> expects a flush of the file to clear them.  We need to re-dirty the page on
>> error so we can try again later or report that the flush failed.
> 
> As discussed previously, the fix that is needed in the page
> invalidation path. i.e.  the page invalidate path clears the
> buffer_delay() flag (via discard_buffer) before we get to
> ->releasepage and so releasepage fails to convert the delalloc
> extent before tossing the page....

I'll leave it up to you to implement that then Dave since I think you
are the only one who understands your angle of attack.

Meanwhile we have this patch running on customer systems and it's fixed
the problems they were having with orphaned delayed allocations being
left behind due to pages being erroneously invalidated.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
