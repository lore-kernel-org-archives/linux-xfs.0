Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9TDP3KN168211 for <xfs@oss.sgi.com>; Mon, 29 Oct 2012 08:25:03 -0500
Message-ID: <508E8480.5020507@sgi.com>
Date: Mon, 29 Oct 2012 08:28:32 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: xfstests: test ext4 statfs
References: <5089749C.4050003@redhat.com> <508AD066.4090102@sgi.com>
	<508AD8E8.1040301@redhat.com>
In-Reply-To: <508AD8E8.1040301@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 10/26/2012 01:39 PM, Eric Sandeen wrote:
> On 10/26/12 1:03 PM, Rich Johnston wrote:
>> On 10/25/2012 12:19 PM, Eric Sandeen wrote:
>>> Calculating free blocks in ext[234] is surprisingly hard, since
>>> by default we report "bsd" style df which doesn't count filesystem
>>> "overhead" blocks as used.
>>>
>>> With a lot of code dedicated to sorting out what to report as
>>> free, things tend to go wrong surprisingly often.
>>>
>>> Here's a test to actually try to stop the next regression.  ;)
>>>
>>> NB: For bsddf, the kernel currently does not count journal blocks
>>> as overhead; it probably should.  But the test below looks to have
>>> the result within 1% of perfection, so it still passes even if
>>> the kernel doesn't count the journal against free blocks.
>>>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>>
>>> ---
>>>

>
>
> Yep - it's an ext4 bug.  I sent a patch to fix it.
>
> [PATCH] ext4: fix overhead calculations in ext4_stats, again
>
> You might want to retest w/ that.
>
> -Eric
>
>>> +

Thanks Eric,

Everything passes now.

Reviewed-by: Rich Johnston <rjohnston@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
