Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ABA3B7F55
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 07:46:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8CB608F8039
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 05:46:20 -0700 (PDT)
Received: from mail-qe0-f43.google.com (mail-qe0-f43.google.com
	[209.85.128.43]) by cuda.sgi.com with ESMTP id 6gXRHjzuLVhO5usy
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 18 Apr 2013 05:46:19 -0700 (PDT)
Received: by mail-qe0-f43.google.com with SMTP id f6so1606377qej.2
	for <xfs@oss.sgi.com>; Thu, 18 Apr 2013 05:46:19 -0700 (PDT)
In-Reply-To: <CAFZPdfguUWWPXcH_NJ30134N=39-KD422LL+k=edOWhjO2GTeA@mail.gmail.com>
References: <20120828172605.607853317@sgi.com>
	<20120828172928.999971219@sgi.com>
	<CAFZPdfgFjRS2rFUekfSr4dT+-sfuji-0uUo1i7VE6=9GZOnzfg@mail.gmail.com>
	<516EB6E3.9040903@sgi.com>
	<CAFZPdfguUWWPXcH_NJ30134N=39-KD422LL+k=edOWhjO2GTeA@mail.gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/5] xfstests: Use libtool to install applications
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Thu, 18 Apr 2013 08:46:17 -0400
Message-ID: <ab33d007-10b8-45c1-b361-c089ee4b15e8@email.android.com>
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
To: Boris Ranto <ranto.boris@gmail.com>, Rich Johnston <rjohnston@sgi.com>
Cc: Boris Ranto <branto@redhat.com>, xfs-oss <xfs@oss.sgi.com>



Boris Ranto <ranto.boris@gmail.com> wrote:

>Rich,
>
>just as Eric guessed, I package the xfstests test suite (and that is
>also
>why I need the DIST_ROOT variable functioning properly). Although I can
>currently work around the problem  by doing something like
>
>./configure
>make
>mkdir -p /var/lib/xfstets/{ltp,src}
>make DIST_ROOT=$RPM_BUILD_ROOT install
>
>it certainly is not the best solution to the problem. If the test suite
>is
>completely independent from its location then also maybe this could
>work (I
>did not try it, yet and I'm still not sure it is the best solution)
>
>./configure --prefix=$RPM_BUILD_ROOT
>make
>make install
>
>but if that is the case then it'd probably make sense to drop the whole
>DIST_ROOT support from install-sh script to avoid confusion and update
>the
>spec file in bulld/rpm/.
>
>Regards,
>Boris

Boris,

When you get it working for packaging purposes I'd appreciate a post detailing what works.  I thought about packaging xfstests for opensuse a couple years ago but aborted the effort when I realized it was not designed to be installed at the time.

Greg
-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
