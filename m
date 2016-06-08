Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C01827CA0
	for <xfs@oss.sgi.com>; Wed,  8 Jun 2016 00:40:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 80C198F8033
	for <xfs@oss.sgi.com>; Tue,  7 Jun 2016 22:40:35 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id p40gQGnXH3hIF997 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 07 Jun 2016 22:40:33 -0700 (PDT)
Date: Tue, 7 Jun 2016 22:40:30 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: crash in xfs in current
Message-ID: <20160608054030.GA27069@infradead.org>
References: <CAAA5faG3Ls0Dh_bx=950db9BV01zoLfmubKbM0UYkWpS0y60BA@mail.gmail.com>
	<79c8e051-24a9-2e2b-553a-bcab17d03e83@sandeen.net>
	<20160607062717.GA30022@infradead.org>
	<c0b9776e-6917-13f2-1948-e7d51f72a909@monom.org>
	<CAAA5faEvt-vrvrkWC8-9Fys0WHN2TBQz7-Y-mtU8FaRHxUM6rw@mail.gmail.com>
	<48817b4c-26f4-5eb6-8a97-d8fa34fe7f6a@monom.org>
	<20160607134442.GA1803@infradead.org>
	<CAAA5faFWyPDienm2NbHkafZh-RvbjJp6f_zDq62z6rC1d1Vzyw@mail.gmail.com>
	<CAAA5faGXHJZPWkkxDM-kvHqh--hPhnD1Y8RuaaSmuzgiz=_LDg@mail.gmail.com>
	<CAAA5faEDdR_L6y9ShhUcermgvjtmzNCzwoYeENjx+8RUEMdwaA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAAA5faEDdR_L6y9ShhUcermgvjtmzNCzwoYeENjx+8RUEMdwaA@mail.gmail.com>
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
To: Reinoud Koornstra <reinoudkoornstra@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Daniel Wagner <wagi@monom.org>, viro@zeniv.linux.org.uk, xfs@oss.sgi.com

On Tue, Jun 07, 2016 at 10:40:11PM -0600, Reinoud Koornstra wrote:
> >> Is this correct?

That's correct!

> >> If so, let me build and test.
> >> Building it already as we speak, but it would be nice if you could
> >> confirm I'm actually testing the right thing.
> >> Though, wouldn't it be good to repro and get a core file as well?
> >> Or would the test of this commit narrow down the possibilities as well?
> >> Thanks,
> >>
> >> Reinoud.
> >>
> >
> > Ouch, forgive me for not responding inline previously.
> > For what it's worth, i've compiled the kernel and are running it as we speak.
> > Will do testing and let you know.
> 
> Ok, going back to commit 555b67e4e729ca544bb4028ab12e532c68b70ddb
> brings the kernel back to 4.6-rc1.
> With that kernel I crash all over the place, so that's something I cannot run.

Oh.  What kinds of crashes?

> Is there a way to get the 4.7-rc1 or rc2 without the commits for XFS?

I can't think of a good way unfortunately.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
