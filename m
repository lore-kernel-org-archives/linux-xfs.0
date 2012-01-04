Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04AvuGm129002 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 04:57:57 -0600
Received: from smtp-tls.univ-nantes.fr (smtp-tls1.univ-nantes.fr
	[193.52.101.145]) by cuda.sgi.com with ESMTP id
	ITejx3rzhNzYYKJu for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 02:57:55 -0800 (PST)
Message-ID: <4F042FF3.7090104@univ-nantes.fr>
Date: Wed, 04 Jan 2012 11:54:43 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
References: <CACaf2aYZ=k=x8sPFJs4f-4vQxs+qNyoO1EUi8X=iBjWjRhy99Q@mail.gmail.com>
	<20111211233929.GI14273@dastard>
	<CACaf2aYTsxOBXEJEbQu7gwAminBc3R2usDHvypJW0AqOfnz0Pg@mail.gmail.com>
	<20111212010053.GM14273@dastard>
	<CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
	<4EF1A224.2070508@univ-nantes.fr>
	<4EF1F6DD.8020603@hardwarefreak.com>
	<4EF21DD2.3060004@univ-nantes.fr> <20111221222623.GF23662@dastard>
	<4EF2F702.4050902@univ-nantes.fr> <4EF30E5D.7060608@univ-nantes.fr>
	<4F0181A2.5010505@univ-nantes.fr>
	<20225.54924.482210.587313@tree.ty.sabi.co.UK>
In-Reply-To: <20225.54924.482210.587313@tree.ty.sabi.co.UK>
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
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux fs XFS <xfs@oss.sgi.com>

On 02/01/2012 17:08, Peter Grandi wrote:
> [ ... ]
>
>>> On two particular server, with recent kernels, I experience a
>>> much higher load than expected, but it's very hard to tell
>>> what's wrong. The system seems more in I/O wait. Older
>>> kernels (2.6.32.xx and 2.6.26.xx) gives better results.
> [ ... ]
>> When I go back to older kernels, the load go down. With newer
>> kernel, all is working well too, but load (as reported by
>> uptime) is higher.
> [ ... ]
>>> birnie:~/TRACE# uptime
>>>    11:48:34 up 17:18,  3 users,  load average: 0.04, 0.18, 0.23
>
>>> penderyn:~/TRACE# uptime
>>>    11:48:30 up 23 min,  3 users,  load average: 4.03, 3.82, 3.21
> [ ... ]
>
> But 'uptime' reports the load average, which is (roughly)
> processes actually running on the CPU. If the load average is

More or less. I generally have 5000+ processes on those servers. The =

load generally reflect a mix between CPU usage (which is unchanged as =

dovecot setup is unchanged) and I/O wait. So naively, I'll say if load =

average is higher than usual, that's because I/O WAIT is higher.

As kernel had big changes, it could be XFS, but DM, or I/O scheduler as =

well.

But it don't seems the case.

> higher, that usually means that the file system is running
> better, not worse.

If delivery is I/O bound, yes but that's not the case in this particular =

setup.

  It looks as if you are not clear whether you
> have a regression or an improvement.

I was just signaling an unusual load average, nothing else. As far as I =

can see, response times are still correct. I'm not experiencing a =

performance proble. I'm not the first author of the thread. I probably =

should have changed the name of the thread, sorry for that.
>
> For a mail server the relevant metric is messages processed per
> second, or alternatively median and maximum times to process a
> message, rather than "average" processes running.
>
...
> So you are expecting for a large system critical problem for
> which you yourself do not have the resource to do testing to see
> quick response times over the Christmas and New Year period.
> What's your XFS Platinum Psychic Support Account number? :-)

I'm not expecting anything. I know open source. All is working fine, =

thank you. I was just "upping" because I saw that my traces have been =

downloaded last week. It's not always easy for non native speakers to =

send mails without sounding agressive/offendant . If that was the case,I =

can assure that was not the intent.


>
> BTW rereading the description of the setup:
>
>>>>>> Thoses servers are mail (dovecot) servers, with lots of
>>>>>> simultaneous imap clients (5000+) an lots of simultaneous
>>>>>> message delivery. These are linux-vservers, on top of LVM
>>>>>> volumes. The storage is SAN with 15k RPM SAS drives (and
>>>>>> battery backup). I know barriers were disabled in older
>>>>>> kernels, so with recents kernels, XFS volumes were mounted
>>>>>> with nobarrier.
>
>>>>> 1. What mailbox format are you using?  Is this a constant
>>>>> or variable?
>>>> Maildir++
>
> I am stunned by the sheer (euphemism alert) audacity of it all.
> This setup is (euphemism alert) amazing.

Can you elaborate, please ?? This particular setup is running fine for 7 =

years now , has very finely scaled up (up to 70k mailboxes with a =

similar setup for students) with little modifications (replacing =

courrier by dovecot, and upgrading servers for example) and has proved =

very stable since, despite numerous power outages, for example...

I can give you detailed setup if you want, off list, I think it has =

nothing to do with xfs.

>
> Unfortunately the problem of large busy mailstores is vastly
> underestimated by many, and XFS has little to do with it.
>

really not sure I underestimate it, but I'll glad to hear your =

recommendations. Offlist, I think.

Cheers,


-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
