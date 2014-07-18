Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B13667F56
	for <xfs@oss.sgi.com>; Fri, 18 Jul 2014 01:07:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 33096AC001
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 23:07:44 -0700 (PDT)
Received: from mail-wi0-f179.google.com (mail-wi0-f179.google.com
	[209.85.212.179]) by cuda.sgi.com with ESMTP id
	H3LAYmxBzWWNqjXi (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 17 Jul 2014 23:07:39 -0700 (PDT)
Received: by mail-wi0-f179.google.com with SMTP id f8so248359wiw.12
	for <xfs@oss.sgi.com>; Thu, 17 Jul 2014 23:07:38 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: symlink loop for /lib64/libhandle.so
From: =?utf-8?Q?Jan_=C5=A4ul=C3=A1k?= <jan@tulak.me>
In-Reply-To: <20140715154857.GA14716@infradead.org>
Date: Fri, 18 Jul 2014 08:07:36 +0200
Message-Id: <0924FC53-967B-4EE3-8F0E-CD3709EEDC19@tulak.me>
References: <1404898212.7231.12.camel@jtulak>
	<20140709132836.GA65226@bfoster.bfoster>
	<20140710134851.GA26652@infradead.org>
	<1405009872.31068.22.camel@jtulak> <53BEC1E7.1070904@sandeen.net>
	<1405075678.28203.56.camel@jtulak> <1405325087.3196.6.camel@jtulak>
	<20140714082607.GA19882@infradead.org>
	<CAO78W=0Y-ja8U6ntkKHdOaXBhR5P4Ec8i+0ic3vTqZ5AugwP9A@mail.gmail.com>
	<20140715154857.GA14716@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, XFS mail list <xfs@oss.sgi.com>


On 15 Jul 2014, at 17:48, Christoph Hellwig <hch@infradead.org> wrote:

> Hi Jan,
> =

> there were still some small isues with the patch format, I've attached
> a version of your patch that has the expected format.
> =

> Note that I also changed it to only check the canonical names instead of
> testing the passed in one and the one readlink was called on.  This
> should be enough I think, but please test that it still works for you.
> =

> Thanks for tracking this down!
> <libhandle.diff>

Hi Christoph,

thanks for the checking. This version works too, so it can be used. =


I=92m glad I could help.

Jan
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
