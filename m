Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q038NDDp009896 for <xfs@oss.sgi.com>; Tue, 3 Jan 2012 02:23:13 -0600
Received: from smtp-tls.univ-nantes.fr (smtp-tls2.univ-nantes.fr
	[193.52.101.146]) by cuda.sgi.com with ESMTP id
	4SeeuX4Fv9DDXMw7 for <xfs@oss.sgi.com>;
	Tue, 03 Jan 2012 00:23:10 -0800 (PST)
Message-ID: <4F02BA35.9040909@univ-nantes.fr>
Date: Tue, 03 Jan 2012 09:20:05 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
References: <CACaf2aYTsxOBXEJEbQu7gwAminBc3R2usDHvypJW0AqOfnz0Pg@mail.gmail.com>
	<20111212010053.GM14273@dastard>
	<CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
	<4EF1A224.2070508@univ-nantes.fr>
	<4EF1F6DD.8020603@hardwarefreak.com>
	<4EF21DD2.3060004@univ-nantes.fr> <20111221222623.GF23662@dastard>
	<4EF2F702.4050902@univ-nantes.fr> <4EF30E5D.7060608@univ-nantes.fr>
	<4F0181A2.5010505@univ-nantes.fr> <20120102203543.GP23662@dastard>
In-Reply-To: <20120102203543.GP23662@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

Le 02/01/2012 21:35, Dave Chinner a =E9crit :
> On Mon, Jan 02, 2012 at 11:06:26AM +0100, Yann Dupont wrote:

>> Hello, happy new year everybody ,
>>
>> Did someone had time to examine the 2 blktrace ? (and, by chance,
>> can see the root cause of the increased load ?)
>
> I've had a bit of a look, but most peopl ehave been on holidays.

yep, of course, I was too :)

>
> As it is, I can't see any material difference between the traces.
> both reads and writes are taking the same amount of time to service,
> so I don't think there's any problem here.

ok,
>
> I do recall that some years ago that we changed one of the ways we

Do you recall exactly what some years ago means ? Is this post 2.6.26 era ?

> slept in XFS which meant those blocked IOs contributed to load
> average (as tehy are supposed to). That meant that more IO
> contributed to the load average (it might have been read related),
> so load averages were then higher for exactly the same workloads.
>

> Indeed:
>
> load average: 0.64, 0.15, 0.09
>
> (start 40 concurrent directory traversals w/ unlinks)
>
> (wait a bit)
>
> load average: 39.96, 23.75, 10.06
>
> Yup, that is spot on - 40 processes doing blocking IO.....
>
> So absent any measurable performance problem, I don't think the
> change in load average is something to be concerned about.

You're probably right : I have a graph on cacti showing load average =

usage and detailed load usage (System/User/Nice,Wait, etc...). The load =

average is much higher now with 3.1.6 , but the detailed load seems not =

different than before.

And for the moment, in real world usage (that is, storing mail in =

folders and serving imap) the server seems no slower than before.

I'll keep an eye on it during high load.

Thanks for your answer,
Cheers,
-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
