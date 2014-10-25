Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4F73E7F77
	for <xfs@OSS.SGI.com>; Sat, 25 Oct 2014 14:30:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E1ED4AC004
	for <xfs@OSS.SGI.com>; Sat, 25 Oct 2014 12:30:39 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id GiHn3TeH3FtpuWSq
	for <xfs@OSS.SGI.com>; Sat, 25 Oct 2014 12:30:35 -0700 (PDT)
Message-ID: <544BFA7A.2070504@hardwarefreak.com>
Date: Sat, 25 Oct 2014 14:31:06 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Problem about very high Average Read/Write Request Time
References: <CALSoAzD4ccHXBuD6mT3ggqMf1j_kDEK-RNMOeRLq+N+NiWVQXg@mail.gmail.com>	<20141018143848.3baf3266@galadriel.home>	<21571.36364.518119.806191@tree.ty.sabi.co.uk>	<5444C122.4080104@fastmail.fm>	<21574.42382.795064.152229@tree.ty.sabi.co.uk>	<54492AD5.3040704@fastmail.fm>	<21577.24715.712978.617220@tree.ty.sabi.co.uk>	<20141024214525.GA4317@dastard>
	<21579.33469.878654.99125@tree.ty.sabi.co.uk>
In-Reply-To: <21579.33469.878654.99125@tree.ty.sabi.co.uk>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Peter Grandi <pg@xfs.list.sabi.co.UK>, Linux fs XFS <xfs@OSS.SGI.com>

On 10/25/2014 06:00 AM, Peter Grandi wrote:
...
> Another poster went far further in guesswork, and stated what I
> was describing as guesses instead as obvious facts:
> =

>   http://oss.sgi.com/archives/xfs/2014-10/msg00337.html
>   > As others mentioned this isn't an XFS problem. The problem is that
>   > your RAID geometry doesn't match your workload. Your very wide
>   > parity stripe is apparently causing excessive seeking with your
>   > read+write workload due to read-modify-write operations.

When a parity array's throughput drops 2 orders of magnitude, from ~1.5
GB/s to 100 MB/s, RMW is historically the most likely cause, especially
with such a wide stripe.  So yes, this is a guess, but an educated one.

> and went on to make a whole discussion wholly unrelated to XFS
> based on that:
> =

>   > To mitigate this, and to increase resiliency, you should
>   > switch to RAID6 with a smaller chunk. If you need maximum
>   > capacity make a single RAID6 array with 16 KiB chunk size.
>   > This will yield a 496 KiB stripe width, increasing the odds
>   > that all writes are a full stripe, and hopefully eliminating
>   > much of the RMW problem.
>   =

>   > A better option might be making three 10 drive RAID6 arrays
>   > (two spares) with 32 KiB chunk, 256 KiB stripe width, and
>   > concatenating the 3 arrays with mdadm --linear.

XFS is a layer of the Linux IO stack, and none of these layers exist in
isolation.  If someone using XFS has a problem and it may not be XFS
specific, we're still going to lend assistance where we can.

> The above assumptions and offtopic suggestions have been
> unquestioned; by myself too, even if I disagree with some of the
> recommendations, also as I think them premature because we don't
> know what the requirements really are beyond what can be guessed
> from =ABthe reported information=BB. That's also why I suggested to
> continue the discussion on the Linux RAID list.

If you haven't noticed Peter, the Chinese guys seem to post once and
never come back.  I don't know if this is a cultural thing or other, but
that's the way they seem to operate.  There is rarely interaction with
them, no follow ups, no additional information provided.  So I tend to
give them many ideas on the obvious path to work with in my reply, after
asking for additional information, which will likely never arrive.
Moving the thread to linux-raid wouldn't help.

And I'm sure you know Dave didn't come down on you due to the guesswork
in your posts, but because of your delivery style, and attitude and
behavior towards others.  It seems the latter prompted his critique of
the former.

Cheers,
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
