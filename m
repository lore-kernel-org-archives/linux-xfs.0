Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8A3EB29DFB
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 10:28:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 740EB304032
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 08:28:29 -0700 (PDT)
Received: from dkim1.fusionio.com (dkim1.fusionio.com [66.114.96.53]) by
	cuda.sgi.com with ESMTP id DL7U6LQjA2WcqIhs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 08:28:24 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 2739F7C06A1
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 09:28:24 -0600 (MDT)
Date: Tue, 13 Aug 2013 11:28:22 -0400
From: Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH v3 1/2] xfstests: add fssum tool
Message-ID: <20130813152822.GG2150@localhost.localdomain>
References: <1375949833-1104-1-git-send-email-list.xfs@jan-o-sch.net>
	<1375949833-1104-2-git-send-email-list.xfs@jan-o-sch.net>
	<5203D827.3050909@sandeen.net> <20130812011539.GM12779@dastard>
	<BB446B35-F3DA-462E-9E2C-9E4B780BC6B9@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BB446B35-F3DA-462E-9E2C-9E4B780BC6B9@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jan Schmidt <list.xfs@jan-o-sch.net>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "sbehrens@giantdisaster.de" <sbehrens@giantdisaster.de>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Sun, Aug 11, 2013 at 09:54:41PM -0500, Eric Sandeen wrote:
> On Aug 11, 2013, at 8:15 PM, Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Thu, Aug 08, 2013 at 12:40:55PM -0500, Eric Sandeen wrote:
> >> On 8/8/13 3:17 AM, Jan Schmidt wrote:
> >>> SUBDIRS =
> >>> 
> >>> LLDLIBS = $(LIBATTR) $(LIBHANDLE) $(LIBACL)
> >>> 
> >>> +OPT_LDLIBS = -lssl -lcrypto
> >> 
> >> Hm, new deps.  I guess it's not a huge problem, these should always
> >> be available, right?
> > 
> > Please, let's keep crypto out of xfstests if we can. That's just
> > going to add a nightmare of US export compliance garbage to any
> > distro that wants to package and ship this....
> > 
> It's ssl that's (optionally) required for check summing I believe.  But it's optional if done properly...
> 

It doesn't build without -lcrypto for me, so either we have an external
dependancy (which I'm fine with), or we add it to xfstests (which is what you
wanted).  Does a config option alleviate your concerns?  And I it's just linking
it in at build time, I don't think we have to work about export compliance as
long as we aren't shipping actual crytpo stuff right?  Anybody who is going to
be running this stuff is going to have libssl installed, which installs
libcrypto (at least on my box) so I don't think it's a huge deal to have us
linking it.  Thanks,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
