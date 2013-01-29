Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8038F7F4E
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 23:21:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 623688F8039
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 21:21:07 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id mTa49Fd3Mwr4diKX
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 21:21:03 -0800 (PST)
Message-ID: <51075C42.4050404@hardwarefreak.com>
Date: Mon, 28 Jan 2013 23:21:06 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Volume fine on x86_64, corruption on ARM
References: <20130127225258.GA2287@vicerveza.homeunix.net>
	<5106FDA5.80409@sandeen.net>
	<20130128224013.GK2287@vicerveza.homeunix.net>
	<5106FF76.6080102@sandeen.net>
In-Reply-To: <5106FF76.6080102@sandeen.net>
Reply-To: stan@hardwarefreak.com
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
Cc: =?ISO-8859-1?Q?Llu=EDs_Batlle_i_Rossell?= <viric@viric.name>, xfs@oss.sgi.com

On 1/28/2013 4:45 PM, Eric Sandeen wrote:
> On 1/28/13 4:40 PM, Llu=EDs Batlle i Rossell wrote:

>> I run:
>> mkfs.xfs /dev/sdb1
>>
>> Then I copied files to it. =

> =

> On the x86_64 machine, right.  Just to be sure, can you do an xfs_repair
> on x86_64 to be sure it's clean at this point?

Worth considering, the move may not be the problem but simply a
manifestation of it.  Creating the filesystem directly on the Shiva plug
and testing it may be instructive at this point as well.

-- =

Stan




_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
