Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 00B8D7F7B
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 08:43:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D373A30404E
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 06:43:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sX0ZD4dFh5crtqiv for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 06:43:16 -0700 (PDT)
Subject: Re: XFS and nobarriers on Intel SSD
References: <CA+nZN+grRZBNruxua4inJ-cMe_WX2XSPjsrP+qb579Si8R6ihA@mail.gmail.com>
	<55E84C40.8020602@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55E84E74.9050404@sandeen.net>
Date: Thu, 3 Sep 2015 08:43:16 -0500
MIME-Version: 1.0
In-Reply-To: <55E84C40.8020602@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Richard Bade <hitrich@gmail.com>, xfs@oss.sgi.com

On 9/3/15 8:33 AM, Eric Sandeen wrote:
> On 9/2/15 9:24 PM, Richard Bade wrote:

...

>> The reason I am asking about this is that we are seeing some
>> significant I/O delays on the disks causing a =93SCSI Task Abort=94 from
>> the OS. This seems to be triggered by the drive receiving a
>> =93Synchronize cache command=94. My current thinking is that setting no
>> barriers will stop the drive receiving a sync command and therefore
>> stop the I/O delay associated with it.
> =

> Interesting, I thought that usually devices with battery-backed cache
> will just ignore synchronize cache commands.

Or more precisely, the device should advertise itself in such a way that
the commands wouldn't be sent, even if nobarrier wasn't specified...

-Eric

> But if not, then sure, maybe that's the issue.
> =

> -Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
