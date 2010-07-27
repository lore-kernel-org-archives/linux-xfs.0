Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6RBOFPf182039 for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 06:24:15 -0500
Received: from enyo.dsw2k3.info (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3748015C780F
	for <xfs@oss.sgi.com>; Tue, 27 Jul 2010 04:34:38 -0700 (PDT)
Received: from enyo.dsw2k3.info (enyo.dsw2k3.info [195.71.86.239]) by
	cuda.sgi.com with ESMTP id hdg59a8VVTvDJG8B for
	<xfs@oss.sgi.com>; Tue, 27 Jul 2010 04:34:38 -0700 (PDT)
Date: Tue, 27 Jul 2010 13:27:00 +0200
From: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: High latencies writing to a memory mapped file
Message-ID: <20100727112700.GA26093@citd.de>
References: <20100722144706.GA2840@BohrerMBP.rgmadvisors.com>
	<20100727092452.GA23307@citd.de>
	<20100727124750.30bb3209@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100727124750.30bb3209@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>, xfs@oss.sgi.com

On 27.07.2010 12:47, Emmanuel Florac wrote:
> Le Tue, 27 Jul 2010 11:24:52 +0200
> Matthias Schniedermeyer <ms@citd.de> =E9crivait:
> =

> > In case anybody has an idea what i could do to identify and/or
> > isolate the root-cause, i'm open for suggestions.
> > =

> =

> I'd thought that the io scheduler is the culprit. I've generally found
> that the default CFQ scheduler (default) is terrible for file servers.

I have 'deadline'ed the server, if that is the culprit then i will =

"know" in about a month. (As i don't know how to force the problem i can =

only wait for the problem not to happen. :-| )



Bis denn

-- =

Real Programmers consider "what you see is what you get" to be just as =

bad a concept in Text Editors as it is in women. No, the Real Programmer
wants a "you asked for it, you got it" text editor -- complicated, =

cryptic, powerful, unforgiving, dangerous.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
