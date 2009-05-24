Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4O78RPK035589 for <xfs@oss.sgi.com>; Sun, 24 May 2009 02:08:27 -0500
Received: from mail-px0-f119.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5311B1A143C9
	for <xfs@oss.sgi.com>; Sun, 24 May 2009 00:08:38 -0700 (PDT)
Received: from mail-px0-f119.google.com (mail-px0-f119.google.com
	[209.85.216.119]) by cuda.sgi.com with ESMTP id
	iByukgTlMWEdvGZz for <xfs@oss.sgi.com>;
	Sun, 24 May 2009 00:08:38 -0700 (PDT)
Received: by pxi17 with SMTP id 17so2262350pxi.20
	for <xfs@oss.sgi.com>; Sun, 24 May 2009 00:08:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7fe205990905220716v7d06b9bch40fe6136af17e345@mail.gmail.com>
References: <7fe205990905220716v7d06b9bch40fe6136af17e345@mail.gmail.com>
Date: Sun, 24 May 2009 15:08:37 +0800
Message-ID: <7fe205990905240008u6a534d21pcdcfffdc19472b6@mail.gmail.com>
Subject: Re: about XFS_IOC_RESVSP
From: Joe Hsu <nagual.hsu@gmail.com>
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
To: xfs@oss.sgi.com

      After days of testing(I only ftruncate to 0 and re-preallocate
files if needed),
fragmentation become much more serious, sigh

2009/5/22 Joe Hsu <nagual.hsu@gmail.com>:
> =A0 =A0 =A0 =A0I pre-allocate blocks for a file. Then I use "open" and "w=
rite" system
> calls to generate the content for that file. After the file is really
> written to the disk,
> I want to set all the extent(s) of that file unwritten. Then I will
> write new content to
> the same file. Is that possible? That means:
> I want to dis-care the content just written and use the same allocated bl=
ocks.
> In another words, I want to restore the state of the file to the state
> when it was
> first pre-allocated.
>
> =A0 =A0 =A0 =A0Why am I doing this? Why not just over-write it? When doing
> partial over-writing,
> some blocks may be read for partial update before they are written
> out. This hurts
> some IO performance and If I can, I would prefer to dis-care old
> content of the file and
> use same (pre)allocated blocks. (In my case, I am doing intensive IO.)
>
> =A0 =A0 =A0 =A0Any one can give me some hints? Thanks.
>
> --
> The sun is shinny but the ice is slippery.
>



-- =

The sun is shinny but the ice is slippery.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
