Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBC211qZ064953 for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 20:01:01 -0600
Received: from mail-iy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 78E142B3F6F
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 18:00:59 -0800 (PST)
Received: from mail-iy0-f181.google.com (mail-iy0-f181.google.com
	[209.85.210.181]) by cuda.sgi.com with ESMTP id
	ju2P2jRtEzRRQCtO for <xfs@oss.sgi.com>;
	Sun, 11 Dec 2011 18:00:59 -0800 (PST)
Received: by iaoo28 with SMTP id o28so8043495iao.26
	for <xfs@oss.sgi.com>; Sun, 11 Dec 2011 18:00:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111212010053.GM14273@dastard>
References: <CACaf2aYZ=k=x8sPFJs4f-4vQxs+qNyoO1EUi8X=iBjWjRhy99Q@mail.gmail.com>
	<20111211233929.GI14273@dastard>
	<CACaf2aYTsxOBXEJEbQu7gwAminBc3R2usDHvypJW0AqOfnz0Pg@mail.gmail.com>
	<20111212010053.GM14273@dastard>
From: Xupeng Yun <xupeng@xupeng.me>
Date: Mon, 12 Dec 2011 10:00:18 +0800
Message-ID: <CACaf2ab-YjXAFm767MmRU5iuOmvkqQW3ZTfQewD5SGvF-opgYQ@mail.gmail.com>
Subject: Re: Bad performance with XFS + 2.6.38 / 2.6.39
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1923837880804181731=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: XFS group <xfs@oss.sgi.com>

--===============1923837880804181731==
Content-Type: multipart/alternative; boundary=90e6ba6e87ac87215904b3db814d

--90e6ba6e87ac87215904b3db814d
Content-Type: text/plain; charset=UTF-8

On Mon, Dec 12, 2011 at 09:00, Dave Chinner <david@fromorbit.com> wrote:

> Oh, of course, now I remember what the problem is - it's a locking
> issue that was fixed in 3.0.11, 3.1.5 and 3.2-rc1.
>

Got it, thanks.

-- 
Xupeng Yun
http://about.me/xupeng

--90e6ba6e87ac87215904b3db814d
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Mon, Dec 12, 2011 at 09:00, Dave Chin=
ner <span dir=3D"ltr">&lt;<a href=3D"mailto:david@fromorbit.com">david@from=
orbit.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<div id=3D":2o">Oh, of course, now I remember what the problem is - it&#39;=
s a locking<br>
issue that was fixed in 3.0.11, 3.1.5 and 3.2-rc1.</div></blockquote></div>=
<br>Got it, thanks.<br clear=3D"all"><div><br></div>-- <br><div>Xupeng Yun<=
/div><a href=3D"http://about.me/xupeng" target=3D"_blank">http://about.me/x=
upeng</a><br>



--90e6ba6e87ac87215904b3db814d--


--===============1923837880804181731==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1923837880804181731==--
