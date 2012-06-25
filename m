Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5PM8LW0028493 for <xfs@oss.sgi.com>; Mon, 25 Jun 2012 17:08:21 -0500
Message-ID: <4FE8E14F.3080807@tlinx.org>
Date: Mon, 25 Jun 2012 15:08:15 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: Strange case of deleting lots of files and "df" not recognizing
	it....(unless I umount/mount) the disk...
References: <4FE7FDF4.6080506@tlinx.org>
	<20120625090211.3c5c2032@galadriel.home>
	<20120625205128.GA29979@sgi.com>
In-Reply-To: <20120625205128.GA29979@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>



Ben Myers wrote:
> On Mon, Jun 25, 2012 at 09:02:11AM +0200, Emmanuel Florac wrote:
>> Le Sun, 24 Jun 2012 22:58:12 -0700 vous =E9criviez:
>>
>>> So when does it actually synchronize w/o me forcing it?  (I.e.
>>> umount/mount)?
>>>
>> Yes, it happens sometimes and a umount/mount is needed to fix it.
> =

> You may find that this will get the job done:
> echo 3 > /proc/sys/vm/drop_caches
> =

> -Ben
> =

Yup...it went away for a LONG time...maybe 30 seconds...

Does that mean there was that much unsynchronized data being held in memory
that wasn't being written out??

It DID fix the space allocation issue.

When I read the value before changing it, it said '0'.

when it finished, I tried to set it back to '0', but got an invalid argumen=
t.???
Was it really '2' or something else?


BTW -- it had been in the weird state for 13 hours before I issued the
order to drop_caches... seems like a long time not to cache data...?


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
