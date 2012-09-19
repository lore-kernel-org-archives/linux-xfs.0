Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8JDDaT4202705 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 08:13:36 -0500
Message-ID: <5059C541.7090202@sgi.com>
Date: Wed, 19 Sep 2012 08:14:41 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [RFC, PATCH 0/102]: xfs: 3.0.x stable kernel update
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
	<50587E28.7090704@sgi.com> <20120918235049.GB31501@dastard>
In-Reply-To: <20120918235049.GB31501@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/18/12 18:50, Dave Chinner wrote:
> On Tue, Sep 18, 2012 at 08:59:04AM -0500, Mark Tinguely wrote:
>> This looks great. Like I said earlier, I did not find Brian Foster's
>> log patch:
>>    xfs: check for stale inode before acquiring iflock on push
>>    Upstream commit: 9a3a5dab63461b84213052888bf38a962b22d035
>> sample implementation listed on:
>>    http://oss.sgi.com/archives/xfs/2012-09/msg00188.html
>>
>> Reviewed-by: Mark Tinguely<tinguely@sgi.com>
>
> Thatnks for looking over this, Mark.
>
> The above patch does not directly apply to the 3.0.x branch because
> the rework of the log item lock/push logic in the AIL was not
> included in the series. Hence I'm not sure that backportingthis
> patch is necessary because the problem only arose after we change
> the locking/push logic...
>
> Cheers,
>
> Dave.

Hi Dave.

The original problem was in Linux 2.6.X.

The patch in the above link is a 3.0.42 port of Brian's top of tree
patch. This version places the tests in AIL trylock routine. We have
been using it on Linux 3.0.x for a couple months and it has avoided
the hangs that we used to get before.

Thank-you again for the work.

--Mark T.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
