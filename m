Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6688F7F78
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 16:40:21 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 11136AC007
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 14:40:19 -0800 (PST)
Received: from mho-02-ewr.mailhop.org (mho-04-ewr.mailhop.org [204.13.248.74])
	by cuda.sgi.com with ESMTP id 3s7ViymE6BBaPGcc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 14:40:18 -0800 (PST)
Date: Mon, 28 Jan 2013 23:40:13 +0100
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
Subject: Re: Volume fine on x86_64, corruption on ARM
Message-ID: <20130128224013.GK2287@vicerveza.homeunix.net>
References: <20130127225258.GA2287@vicerveza.homeunix.net>
	<5106FDA5.80409@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5106FDA5.80409@sandeen.net>
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

On Mon, Jan 28, 2013 at 04:37:25PM -0600, Eric Sandeen wrote:
> So this was trying to read a dir2 directory metadata leaf block, and it d=
idn't find the right magic.
> XFSB is superblock magic . . . =

> =

> I tested an image which (I think) contains every dir2 format, created on =
x86_64
> (under a RHEL6 3.2 kernel) and checked it on ARM (a raspberry pi 3.2.24 k=
ernel)
> so it's not really quite an apples to apples test.
> =

> Does the filesystem check clean on x86_64 right after you create it?  How=
 did you
> create it?

Thank you for testing! You mean that your test went fine, right?

I run:
mkfs.xfs /dev/sdb1

Then I copied files to it. After the first crash in the arm, I used xfs_rep=
air on the
x86_64. It created many lost+found. Then I tried again in the ARM, and it
crashed again the same way.

Regards,
Llu=EDs.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
