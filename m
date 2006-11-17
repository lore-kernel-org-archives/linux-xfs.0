Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 17 Nov 2006 07:21:50 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAHFLeaG020715
	for <xfs@oss.sgi.com>; Fri, 17 Nov 2006 07:21:40 -0800
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A422604C8F
	for <xfs@oss.sgi.com>; Fri, 17 Nov 2006 07:20:52 -0800 (PST)
Message-ID: <48064.10.0.0.2.1163776850.squirrel@sandeen.net>
In-Reply-To: <1163746343.4695.152.camel@edge>
References: <455CB54F.8080901@sandeen.net>
    <BB70F203E29C2D37A2F727C8@timothy-shimmins-power-mac-g5.local>
    <20061117023946.GN11034@melbourne.sgi.com>
    <CEB981736A0E8C7DF9ABD7C8@timothy-shimmins-power-mac-g5.local>
    <20061117055521.GS11034@melbourne.sgi.com>
    <52841.10.0.0.2.1163745285.squirrel@sandeen.net>
    <1163746343.4695.152.camel@edge>
Date: Fri, 17 Nov 2006 09:20:50 -0600 (CST)
Subject: Re: [PATCH] (and bad attr2 bug) - pack xfs_sb_t for 64-bit arches
From: sandeen@sandeen.net
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: sandeen@sandeen.net, David Chinner <dgc@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs@oss.sgi.com

> On Fri, 2006-11-17 at 00:34 -0600, sandeen@sandeen.net wrote:
>> and really, now that this is out in the wild, maybe sb_features3
>> instead of padding is appropriate, and check both for the attr2
>> bit...? :(
>
> Thats not going to work, theres three or four other feature2 bits
> preceding attr2 as well.
>
> The "take a 32 bit systems fs to a 64 bit system" is relatively
> uncommon, so I suppose its just something we live with (as we did
> with the log recovery issues in that situation for several years).

So you think this should not be fixed, then?  Because if it -is- fixed
then it's not an fs transfer problem; suddenly 64-bit attr2 filesystems
will think they have attr1 if proper padding is added.

-Eric
