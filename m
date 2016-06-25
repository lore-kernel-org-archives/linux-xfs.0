Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DC487CA0
	for <xfs@oss.sgi.com>; Sat, 25 Jun 2016 00:21:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9CB43AC002
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 22:21:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Q35e6w6F8XHax2qs for <xfs@oss.sgi.com>;
	Fri, 24 Jun 2016 22:21:27 -0700 (PDT)
Mime-Version: 1.0 (1.0)
Subject: Re: Some xfstests failures on non-crc xfs with latest xfsprogs
	(v4.5.0-rc1)
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20160625044410.GD23649@eguan.usersys.redhat.com>
Date: Sat, 25 Jun 2016 00:21:26 -0500
Message-Id: <DFDE1D5E-8FC3-424F-B9B2-3701EA5A339A@sandeen.net>
References: <20160304112354.GX11419@eguan.usersys.redhat.com>
	<727b405b-7df2-641a-d4d0-24333e003374@sandeen.net>
	<20160625044410.GD23649@eguan.usersys.redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com


> On Jun 24, 2016, at 11:44 PM, Eryu Guan <eguan@redhat.com> wrote:
> 
>> On Fri, Jun 24, 2016 at 05:37:10PM -0500, Eric Sandeen wrote:
>>> On 3/4/16 5:23 AM, Eryu Guan wrote:
>>> Hi,
>>> 
>>> I noticed some xfstests failures while testing v4 XFS with latest
>>> v4.5.0-rc1 xfsprogs on v4.5-rc6 kernel, and all these failures are gone
>>> if I use v3.2.4 xfsprogs, or if test on v5 XFS.
>>> 
>>> So either xfstests needs update or xfsprogs breaks something for non-crc
>>> XFS. But I'm not sure which is which, so I post them out for broader
>>> review.
>>> 
>>> (All tests are checked with 'MKFS_OPTIONS="-m crc=0" ./check <sometest>')
>> 
>> Eryu, sorry you didn't get a reply on this in March.  We should have
>> listened!  ;)  The patches I sent in the pat day or two should
> 
> Thanks for looking at them! :)
> 
>> fix some of these ...
>> 
>>> == 1. xfs/032 fsck failure (xfs_db check) on ppc64 host ==
>> 
>> but not this one.  Do you still see this?
> 
> My recent test with 4.7-rc4 kernel and latest xfsprogs (June 22nd) shows
> xfs/032 passed on ppc64 host. But I'll retest to be sure.

I wasn't thinking.  Brian's recent sparse inode patches fix this one.

Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
