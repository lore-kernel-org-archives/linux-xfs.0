Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1I7HFe1016694 for <xfs@oss.sgi.com>; Wed, 18 Feb 2009 01:17:16 -0600
Received: from rv-out-0708.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B9B312DA5F
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 23:16:42 -0800 (PST)
Received: from rv-out-0708.google.com (rv-out-0708.google.com
	[209.85.198.245]) by cuda.sgi.com with ESMTP id
	cElNYGZQB9WZIP22 for <xfs@oss.sgi.com>;
	Tue, 17 Feb 2009 23:16:42 -0800 (PST)
Received: by rv-out-0708.google.com with SMTP id c5so2232283rvf.32
	for <xfs@oss.sgi.com>; Tue, 17 Feb 2009 23:16:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200902171304.18661.arekm@maven.pl>
References: <499AA47A.2050106@redhat.com> <200902171304.18661.arekm@maven.pl>
Date: Wed, 18 Feb 2009 18:08:26 +1100
Message-ID: <d38e348a0902172308o3867ef98yfb685a5ce1cdb470@mail.gmail.com>
Subject: Re: libattr - severe memory leaks from attr_copy_file()
From: Timothy Shimmin <timothy.shimmin@gmail.com>
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
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Tue, Feb 17, 2009 at 11:04 PM, Arkadiusz Miskiewicz <arekm@maven.pl> wrote:
>
> On Tuesday 17 of February 2009, Zdenek Prikryl wrote:
> > -       free(text);
> > +       if (text)
> > +               free(text);
>
> free(NULL) is fine (on Linux at least)

Exactly - in most implementations for free I would say NULL is just fine.

And the variable, text, is assigned straight away before any use,
so I missed where the problem is.

--Tim

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
