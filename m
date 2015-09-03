Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8081C7F77
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 08:33:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 629FE304048
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 06:33:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id qo4MLYAZLwycJkQL for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 06:33:52 -0700 (PDT)
Subject: Re: XFS and nobarriers on Intel SSD
References: <CA+nZN+grRZBNruxua4inJ-cMe_WX2XSPjsrP+qb579Si8R6ihA@mail.gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <55E84C40.8020602@sandeen.net>
Date: Thu, 3 Sep 2015 08:33:52 -0500
MIME-Version: 1.0
In-Reply-To: <CA+nZN+grRZBNruxua4inJ-cMe_WX2XSPjsrP+qb579Si8R6ihA@mail.gmail.com>
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

On 9/2/15 9:24 PM, Richard Bade wrote:
> Hi Everyone, I have a question about nobarriers. In the XFS FAQ it
> looks like the recommendation is that if you have a Battery Backed
> raid controller you should set nobarriers for performance reasons. =

> Our LSI card doesn=92t have battery backed cache as it=92s configured in
> HBA mode (IT) rather than Raid (IR). Our Intel s3710 SSD=92s do have a
> capacitor backed cache though. So is it recommended that barriers are
> turned off as the drive has a safe cache (I am confident that the
> cache will write out to disk on power failure)?

If you have a device which guarantees that every acknowledged write
will persist even if power is lost, then you can safely turn off
barriers.

> The reason I am asking about this is that we are seeing some
> significant I/O delays on the disks causing a =93SCSI Task Abort=94 from
> the OS. This seems to be triggered by the drive receiving a
> =93Synchronize cache command=94. My current thinking is that setting no
> barriers will stop the drive receiving a sync command and therefore
> stop the I/O delay associated with it.

Interesting, I thought that usually devices with battery-backed cache
will just ignore synchronize cache commands.
 =

But if not, then sure, maybe that's the issue.

-Eric

> This is happening on our Ceph storage cluster. For those not familiar
> with Ceph, it uses XFS as the underlying filesystem for the object
> stores.
> =

> Has anyone else encountered this issue? Any info or suggestions about
> this would be appreciated.
> =

> Regards, Richard
> =

> =

> =

> _______________________________________________ xfs mailing list =

> xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
