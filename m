Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C07867F83
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 16:45:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4DC91AC006
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 14:45:12 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id MsUBY2fZkDAH3Wlm for <xfs@oss.sgi.com>;
	Mon, 28 Jan 2013 14:45:11 -0800 (PST)
Message-ID: <5106FF76.6080102@sandeen.net>
Date: Mon, 28 Jan 2013 16:45:10 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Volume fine on x86_64, corruption on ARM
References: <20130127225258.GA2287@vicerveza.homeunix.net>
	<5106FDA5.80409@sandeen.net>
	<20130128224013.GK2287@vicerveza.homeunix.net>
In-Reply-To: <20130128224013.GK2287@vicerveza.homeunix.net>
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
To: =?ISO-8859-1?Q?Llu=EDs_Batlle_i_Rossell?= <viric@viric.name>
Cc: xfs@oss.sgi.com

On 1/28/13 4:40 PM, Llu=EDs Batlle i Rossell wrote:
> On Mon, Jan 28, 2013 at 04:37:25PM -0600, Eric Sandeen wrote:
>> So this was trying to read a dir2 directory metadata leaf block, and it =
didn't find the right magic.
>> XFSB is superblock magic . . . =

>>
>> I tested an image which (I think) contains every dir2 format, created on=
 x86_64
>> (under a RHEL6 3.2 kernel) and checked it on ARM (a raspberry pi 3.2.24 =
kernel)
>> so it's not really quite an apples to apples test.
>>
>> Does the filesystem check clean on x86_64 right after you create it?  Ho=
w did you
>> create it?
> =

> Thank you for testing! You mean that your test went fine, right?

with the simple test on the above machines, yes, it was fine.

> I run:
> mkfs.xfs /dev/sdb1
> =

> Then I copied files to it. =


On the x86_64 machine, right.  Just to be sure, can you do an xfs_repair
on x86_64 to be sure it's clean at this point?

> After the first crash in the arm, I used xfs_repair on the
> x86_64. It created many lost+found. =


capturing the repair output here would be helpful.

> Then I tried again in the ARM, and it
> crashed again the same way.

And by "tried again" do you mean you booted from that filesystem on
the arm box, I guess, and then encountered the corruption?

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
