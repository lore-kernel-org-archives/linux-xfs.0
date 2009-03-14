Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2EKH8K1225960 for <xfs@oss.sgi.com>; Sat, 14 Mar 2009 15:17:28 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABFA71C4230B
	for <xfs@oss.sgi.com>; Sat, 14 Mar 2009 13:16:46 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id SDwGHBK5zMxeFf6S for <xfs@oss.sgi.com>;
	Sat, 14 Mar 2009 13:16:46 -0700 (PDT)
Message-ID: <49BC0EB4.7040308@sandeen.net>
Date: Sat, 14 Mar 2009 15:08:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: LWN article: ext4 and data loss
References: <200903121239.35442@zmi.at>	<200903121514.12732.Martin@lichtvoll.de>	<49B92423.4020708@sandeen.net>	(sfid-20090312_171308_416656_6FF6859A)	<200903142042.51574.Martin@lichtvoll.de>
	<49BC0D38.5060106@sandeen.net>
In-Reply-To: <49BC0D38.5060106@sandeen.net>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: xfs@oss.sgi.com

Eric Sandeen wrote:
> Martin Steigerwald wrote:
>> Am Donnerstag 12 M=E4rz 2009 schrieb Eric Sandeen:
> ...
> =

>>> Filesystems can hack around some heuristics to try to make unsafe apps
>>> safer, but in the end, it's the app's job to make sure a buffered write
>>> hits permanent storage when it matters.
>> Hmmm, okay. So here is:
>>
>> http://bugs.kde.org/187172
>>
>> Feel free to add there. You'd need a bugzilla login tough.

... getting OT sorry but in case anyone else is interested,
http://api.kde.org/4.x-api/kdelibs-apidocs/kdecore/html/classKSaveFile.html
also seems relevant.

I'd like to know just what KDE is doing here, so digging a little.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
