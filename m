Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q29GooWf257974 for <xfs@oss.sgi.com>; Fri, 9 Mar 2012 10:50:50 -0600
Received: from mail-vx0-f181.google.com (mail-vx0-f181.google.com
	[209.85.220.181]) by cuda.sgi.com with ESMTP id
	GGo3WeF2yMs5n5bV (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 Mar 2012 08:50:49 -0800 (PST)
Received: by vcge1 with SMTP id e1so1749742vcg.26
	for <xfs@oss.sgi.com>; Fri, 09 Mar 2012 08:50:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120308140600.77406b8zzy2zggkc@web.mail.umich.edu>
References: <20120308140600.77406b8zzy2zggkc@web.mail.umich.edu>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Fri, 9 Mar 2012 11:50:18 -0500
Message-ID: <CAGpXXZLQp+m_soTBw8Zq-M0cyKqVTASSAXMt6YV07ntfqJhMag@mail.gmail.com>
Subject: Re: Safe to use XFS in production in Linux 3.2.9?
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8242619807480008696=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Sean Thomas Caron <scaron@umich.edu>
Cc: xfs@oss.sgi.com

--===============8242619807480008696==
Content-Type: multipart/alternative; boundary=20cf307cfd12cda6cb04bad231fa

--20cf307cfd12cda6cb04bad231fa
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Mar 8, 2012 at 2:06 PM, Sean Thomas Caron <scaron@umich.edu> wrote:

> Hi all,
>
> We're currently using Linux 3.0.12 with Cristoph's xfs-bulletproof-sync
> patch and it seems to be working very well for us. Unfortunately this
> kernel is vulnerable to the recent CVE-2012-0056 no permission checking on
> writes to /proc/(pid)/mem local root exploit, so we've got to leave it
> behind.
>
> I see that the newest recommended stable kernel on kernel.org is 3.2.9.
>


Sean,

You do appreciate 3.0 has been designated a long-term kernel by the
kernel.org team and will get kernel.org support for 2 years.  3.2 is not a
long-term kernel, so support drops from kernel.org more or less when 3.3
comes out.

3.2 support will come from the distributors of course, but I don't know if
any of the major releases are based on 3.2.

Greg

--20cf307cfd12cda6cb04bad231fa
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">On Thu, Mar 8, 2012 at 2:06 PM, Sean Tho=
mas Caron <span dir=3D"ltr">&lt;<a href=3D"mailto:scaron@umich.edu">scaron@=
umich.edu</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">

<div id=3D":2gp">Hi all,<br>
<br>
We&#39;re currently using Linux 3.0.12 with Cristoph&#39;s xfs-bulletproof-=
sync patch and it seems to be working very well for us. Unfortunately this =
kernel is vulnerable to the recent CVE-2012-0056 no permission checking on =
writes to /proc/(pid)/mem local root exploit, so we&#39;ve got to leave it =
behind.<br>


<br>
I see that the newest recommended stable kernel on <a href=3D"http://kernel=
.org" target=3D"_blank">kernel.org</a> is 3.2.9. </div></blockquote></div><=
br><br>Sean,<br><br>You do appreciate 3.0 has been designated a long-term k=
ernel by the <a href=3D"http://kernel.org">kernel.org</a> team and will get=
 <a href=3D"http://kernel.org">kernel.org</a> support for 2 years.=A0 3.2 i=
s not a long-term kernel, so support drops from <a href=3D"http://kernel.or=
g">kernel.org</a> more or less when 3.3 comes out.<br>

<br>3.2 support will come from the distributors of course, but I don&#39;t =
know if any of the major releases are based on 3.2.<br><br>Greg<br>

--20cf307cfd12cda6cb04bad231fa--


--===============8242619807480008696==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8242619807480008696==--
