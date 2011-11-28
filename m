Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pASH7V0R244434 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 11:07:31 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BBD5A1D340EF
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 08:56:48 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	9J1ljXsYgBVILFul for <xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 08:56:48 -0800 (PST)
Received: by iaen33 with SMTP id n33so11391840iae.26
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 08:56:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <yq1vcq4grgi.fsf@sermon.lab.mkp.net>
References: <1322162451-17036-1-git-send-email-cmaiolino@redhat.com>
	<20111124195042.GA3671@andromeda.usersys.redhat.com>
	<20111127010643.GU2386@dastard>
	<4ED2C233.8010104@sandeen.net> <20111127235051.GX2386@dastard>
	<yq1vcq4grgi.fsf@sermon.lab.mkp.net>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Mon, 28 Nov 2011 11:56:17 -0500
Message-ID: <CAGpXXZKOzZyj5POd5-GmZxt3Szw8uk=XL8dOSs4Yn0eTuM3guw@mail.gmail.com>
Subject: Re: [PATCH] libxfs: Get Physical Sector Size instead of Logical
	Sector size
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

On Mon, Nov 28, 2011 at 11:08 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
> And while Christoph is right that (thankfully) nobody ended up shipping
> drives with 1-alignment by default, most 512e drives have the alignment
> jumper and some people actually use it.

I've seen at least one of my clients use the jumper.  It was my first
realization that jumper actually "moves" stuff on the disk.

I realize its a virtual move, but data read from sector 63 with the
jumper in place is not the same data that is read from sector 63 with
the jumper removed.

It caught me off guard.  The fix in this case was just to re-install
the jumper like the client had it originally.

Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
