Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7DNeD8U058143 for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 18:40:23 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 05E9D8F8112
	for <xfs@oss.sgi.com>; Thu, 13 Aug 2009 16:40:59 -0700 (PDT)
Message-Id: <D052E217-FED0-4954-9095-078D0D8AF322@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
In-Reply-To: <20090813231739.5c7db91d@galadriel.home>
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: XFS corruption with failover
Date: Thu, 13 Aug 2009 17:42:56 -0500
References: <4A8474D2.7050508@jquigley.com>
	<20090813231739.5c7db91d@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: John Quigley <jquigley@jquigley.com>, XFS Development <xfs@oss.sgi.com>


On Aug 13, 2009, at 4:17 PM, Emmanuel Florac wrote:

> Le Thu, 13 Aug 2009 15:17:22 -0500 vous =E9criviez:
>
>> Any advice or insight into what we're doing wrong would be very much
>> appreciated.  My apologies in advance for the somewhat off-topic
>> question.
>
> By killing abruptly the primary server while doing IO, you're probably
> pushing the envelope...

I don't think it's pushing too much. XFS was designed to
survive such events.

> You may have a somewhat better luck with a
> cluster fs, OCFS2 works very well for me usually (GFS is a complete
> PITA to setup).
>
>
> The better option would be to disallow completely write
> caching on the client side (because this is probably where it's going
> wrong) however I don't know how.

Client's caching can't affect the metadata and the log in particular
operations on the server. Client may indeed loose some data, but
that's completely different issue.

Felix

> You can get it to flush extremely
> often by playing with  /proc/sys/vm/dirty_expire_centiseconds
> and /proc/sys/vm/dirty_writeback_centisecs, though. Safer settings
> generally imply terrible performance, though, you've been warned.
>
> Ah another thing may be some cache option in the iSCSI target. what
> target are you using?
>
> -- =

> --------------------------------------------------
> Emmanuel Florac               www.intellique.com
> --------------------------------------------------
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
