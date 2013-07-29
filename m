Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 768057F3F
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 12:06:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0C5B2AC005
	for <xfs@oss.sgi.com>; Mon, 29 Jul 2013 10:05:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id F2ZiQwgAsH7cTVjn for <xfs@oss.sgi.com>;
	Mon, 29 Jul 2013 10:05:58 -0700 (PDT)
Message-ID: <51F6A0F3.8030604@sandeen.net>
Date: Mon, 29 Jul 2013 12:05:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: A short digression on FOSS (Re: understanding speculative
	preallocation)
References: <15781090.2540.1375111802121.JavaMail.root@benjamin.baylink.com>
In-Reply-To: <15781090.2540.1375111802121.JavaMail.root@benjamin.baylink.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jay Ashworth <jra@baylink.com>
Cc: xfs@oss.sgi.com

On 7/29/13 10:30 AM, Jay Ashworth wrote:
> ----- Original Message -----
>> From: "Eric Sandeen" <sandeen@sandeen.net>
> 
>>>> From: "Dave Chinner" <david@fromorbit.com>
>>>
>>>> The "version" of XFS that you are running is that of the
>>>> kernel you are running. i.e. 2.6.32-279.x.y or 2.6.32-358.x.y.
>>>
>>> Those aren't kernel versions; those are kernel *package* versions.
>>
>> Those are RHEL kernel version numbers, which 100% uniquely identify
>> the code contained in those kernels.
> 
> So how, Eric, would that help, say, SuSE users -- 

Well, it doesn't... SuSE helps SuSE users.  And I'm not being glib,
that's just how it works.

> which the XFS website makes 
> special note to point out that there's a specific agreement in place to 
> support.  Even SLES users vice openSUSE, though the XFS.org website doesn't 
> make that distinction.

xfs.org is a public wiki run by a 3rd party, so I can't speak to the accuracy
of statements made about support agreements between SGI & SuSE, if any.

So I guess I have no useful insight there.

> I'm sticking with "those are kernel package versions", and I was yelled
> at the other day because I was interested in things that weren't "mainline
> kernel versions".  RHEL kernels are the *best available example* of "not
> a mainline kernel version", so I find these conflicting reports most
> conflicting.

You're welcome to be interested all you want, but availability of support
from either SGI (not related to CentOS at all), upstream (focused on new work,
not older distros), or Red Hat (who sells support, vs. gives it away, in
order to pay the people to keep maintaining the distro that CentOS is
more than welcome to pick up, rebuild, & ship, and support or not as *they* 
see fit).

You'll find that you usually get very good support for XFS issues & questions
related to near-current mainline kernels.  But people who can spend time
& effort supporting free distros containing custom codebases are going
to be few & far between.

The closer you get to mainline, the more willing & able the developers
will be to help you out.  The further you get into custom distro kernels,
the more it becomes the responsibility of that distro - CentOS, in your case,
and they pretty explicitly tell you what you can expect for support from
them.

I'm not trying to be flippant or glib or antagonistic here, that's just
the way things are structured; you chose CentOS, and "CentOS is designed for
people who need an enterprise class OS without the cost or support of
the prominent North American Enterprise Linux vendor."

>>> Kernel versions are w.x.y or w.x.y.z.
>>
>> ^Upstream.
> 
> "Mainline".  Which was not my choice of term.

(Ok, mainline; I was just differentiating between RHEL & Linux.)

-Eric


> Cheers,
> -- jra
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
