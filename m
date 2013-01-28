Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F258F7F7B
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 16:50:20 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 72BB1AC006
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 14:50:20 -0800 (PST)
Received: from mho-02-ewr.mailhop.org (mho-04-ewr.mailhop.org [204.13.248.74])
	by cuda.sgi.com with ESMTP id xifzJowFzDtE9xba (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 14:50:18 -0800 (PST)
Date: Mon, 28 Jan 2013 23:50:10 +0100
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
Subject: Re: Volume fine on x86_64, corruption on ARM
Message-ID: <20130128225010.GL2287@vicerveza.homeunix.net>
References: <20130127225258.GA2287@vicerveza.homeunix.net>
	<5106FDA5.80409@sandeen.net>
	<20130128224013.GK2287@vicerveza.homeunix.net>
	<5106FF76.6080102@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5106FF76.6080102@sandeen.net>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Mon, Jan 28, 2013 at 04:45:10PM -0600, Eric Sandeen wrote:
> On 1/28/13 4:40 PM, Llu=EDs Batlle i Rossell wrote:
> > On Mon, Jan 28, 2013 at 04:37:25PM -0600, Eric Sandeen wrote:
> >> So this was trying to read a dir2 directory metadata leaf block, and i=
t didn't find the right magic.
> >> XFSB is superblock magic . . . =

> >>
> >> I tested an image which (I think) contains every dir2 format, created =
on x86_64
> >> (under a RHEL6 3.2 kernel) and checked it on ARM (a raspberry pi 3.2.2=
4 kernel)
> >> so it's not really quite an apples to apples test.
> >>
> >> Does the filesystem check clean on x86_64 right after you create it?  =
How did you
> >> create it?
> > I run:
> > mkfs.xfs /dev/sdb1
> > =

> > Then I copied files to it. =

> =

> On the x86_64 machine, right.  Just to be sure, can you do an xfs_repair
> on x86_64 to be sure it's clean at this point?

I don't have the fs anymore... I have that disk in use right now (with ext4
finally).

But I didn't try to run an xfs_repair straight after writing the files with
x86_64.

> > After the first crash in the arm, I used xfs_repair on the
> > x86_64. It created many lost+found. =

> =

> capturing the repair output here would be helpful.

ouhm I can't find it now. Sorry.

> > Then I tried again in the ARM, and it
> > crashed again the same way.
> =

> And by "tried again" do you mean you booted from that filesystem on
> the arm box, I guess, and then encountered the corruption?

Yes, the same procedure I used in the first case.

In the next days I'll try to get some quick test over a loop device or so, =
and
see if I can reproduce it.

Thank you,
Llu=EDs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
