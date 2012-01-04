Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q04D9KYf137014 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 07:09:21 -0600
Received: from smtp-tls.univ-nantes.fr (smtp-tls2.univ-nantes.fr
	[193.52.101.146]) by cuda.sgi.com with ESMTP id
	Z4sLW5hYPTFgBD6o for <xfs@oss.sgi.com>;
	Wed, 04 Jan 2012 05:09:19 -0800 (PST)
Message-ID: <4F044EC7.3030203@univ-nantes.fr>
Date: Wed, 04 Jan 2012 14:06:15 +0100
From: Yann Dupont <Yann.Dupont@univ-nantes.fr>
MIME-Version: 1.0
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
References: <CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
	<4EF1A224.2070508@univ-nantes.fr>
	<4EF1F6DD.8020603@hardwarefreak.com>
	<4EF21DD2.3060004@univ-nantes.fr> <20111221222623.GF23662@dastard>
	<4EF2F702.4050902@univ-nantes.fr> <4EF30E5D.7060608@univ-nantes.fr>
	<4F0181A2.5010505@univ-nantes.fr> <20120102203543.GP23662@dastard>
	<4F02BA35.9040909@univ-nantes.fr>
	<20120104123331.GA12204@infradead.org>
In-Reply-To: <20120104123331.GA12204@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: stan@hardwarefreak.com, xfs@oss.sgi.com

On 04/01/2012 13:33, Christoph Hellwig wrote:
> On Tue, Jan 03, 2012 at 09:20:05AM +0100, Yann Dupont wrote:
>>> As it is, I can't see any material difference between the traces.
>>> both reads and writes are taking the same amount of time to service,
>>> so I don't think there's any problem here.
>>
>> ok,
>>>
>>> I do recall that some years ago that we changed one of the ways we
>>
>> Do you recall exactly what some years ago means ? Is this post 2.6.26 er=
a ?
>
> The only thing that I remember is Jens switching xfs_buf_wait_unpin from
> schedule to io_schedule in "block: remove per-queue plugging", which
> went into Linux 2.6.39.  With this processed that wait for buffers to
> be unpinned now count towards the load average.
>

Ok, that's probably the root cause. As I already said, I don't =

experience performance regression right now.

Thanks a lot for the explaination.

Cheers,



-- =

Yann Dupont - Service IRTS, DSI Universit=E9 de Nantes
Tel : 02.53.48.49.20 - Mail/Jabber : Yann.Dupont@univ-nantes.fr

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
