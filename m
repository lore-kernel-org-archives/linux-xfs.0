Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4IHFIXl228514 for <xfs@oss.sgi.com>; Fri, 18 May 2012 12:15:18 -0500
Date: Fri, 18 May 2012 12:19:59 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Still seeing hangs in xlog_grant_log_space
Message-ID: <20120518171959.GQ16099@sgi.com>
References: <CADLDEKvYkpUnMrqdMyqCmsYrZcUtiJ6ZRhrRu_ERTjn=r7M3Pg@mail.gmail.com>
	<20120426224412.GA9541@dastard>
	<CADLDEKs6oMDA-6OhmcFxyRoBVpduKtSput=53TQGn9NCAOXC1Q@mail.gmail.com>
	<20120426230738.GB9541@dastard>
	<CADLDEKuKLeYiqhQW0E9g_bS0VXoxPGPOck3N004Pxg4_Opbzow@mail.gmail.com>
	<20120427110922.GF9541@dastard>
	<CADLDEKtUHAGcOPT1jtcvyJVk+zsoL5_thYFtHJYs+w=6EGuVSA@mail.gmail.com>
	<CADLDEKs4YbNzj2c0HKHwSdUfKy0efdQRe1rOsWDkWUgd+BOGHw@mail.gmail.com>
	<20120507171908.GA16881@sgi.com>
	<CADLDEKvgT_FcGhJKoPaQv0mh_Jqdaqu8SYatc9xxU7vOY217YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADLDEKvgT_FcGhJKoPaQv0mh_Jqdaqu8SYatc9xxU7vOY217YQ@mail.gmail.com>
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
To: Juerg Haefliger <juergh@gmail.com>
Cc: xfs@oss.sgi.com

Hey Juerg,

On Wed, May 09, 2012 at 09:54:08AM +0200, Juerg Haefliger wrote:
> > On Sat, May 05, 2012 at 09:44:35AM +0200, Juerg Haefliger wrote:
> >> Did anybody have a chance to look at the data?
> >
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/979498
> >
> > Here you indicate that you have created a reproducer. =A0Can you post i=
t to the list?
> =

> Canonical attached them to the bug report that they filed yesterday:
> http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D922

I'm interested in understanding to what extent the hang you see in producti=
on
on 2.6.38 is similar to the hang of the reproducer.  Mark is seeing a situa=
tion
where there is nothing on the AIL and is clogged up in the CIL, others are
seeing items on the AIL that don't seem to be making progress.  Could you
provide a dump or traces from a hang on a filesystem with a normal sized lo=
g?
Can the reproducer hit the hang eventually without resorting to the tiny lo=
g?

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
