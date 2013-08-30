Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E4B617F58
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 22:35:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 80502AC00A
	for <xfs@oss.sgi.com>; Thu, 29 Aug 2013 20:35:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id E5c1AXTZXdFi1j0r for <xfs@oss.sgi.com>;
	Thu, 29 Aug 2013 20:35:23 -0700 (PDT)
Message-ID: <522012F8.4020608@sandeen.net>
Date: Thu, 29 Aug 2013 22:35:20 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: higher agcount on LVM2 thinp volumes
References: <321D1F95-5603-4571-A445-A267DA5F670F@colorremedies.com>
	<52200BAE.1060501@sandeen.net>
	<4393C3B8-8C46-41ED-B9F3-BC7B37C2681F@colorremedies.com>
	<52200F5A.9050702@sandeen.net>
	<289A5A42-9879-4A2A-9284-4B8529A1488D@colorremedies.com>
In-Reply-To: <289A5A42-9879-4A2A-9284-4B8529A1488D@colorremedies.com>
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
To: Chris Murphy <lists@colorremedies.com>
Cc: xfs@oss.sgi.com

On 8/29/13 10:24 PM, Chris Murphy wrote:
> 
> On Aug 29, 2013, at 9:19 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>>
>> Argh sorry, how did I type THAT?
>>
>> # blockdev --getiomin --getioopt /dev/mapper/vg1-data
> 
> conventional LV:
> [root@f19s ~]# blockdev --getiomin --getioopt /dev/mapper/vg1-data
> 512
> 0
> 
> thinp LV:
> 
> [root@f19s ~]# blockdev --getiomin --getioopt /dev/mapper/vg1-data
> 512
> 262144
> 
> (Now I see two ways to get the same info.)

:)

ok so it says the stripe unit (minimum IO size) is 512...

Around line 2240, it does:

        if (dsunit && !(BBTOB(dsunit) % blocksize) &&
            dswidth && !(BBTOB(dswidth) % blocksize)) {
...
        } else {
                if (nodsflag)
                        dsunit = dswidth = 0;

essentially saying: If we autodetected a stripe unit or stripe width
which is not a multiple of the block size, silently set it to 0.
So we do that.

However, _just_ before this, we did:

                calc_default_ag_geometry(blocklog, dblocks,
                                dsunit | dswidth, &agsize, &agcount);

when dsunit & dswidth were still set (to invalid values).

So we calculated it w/ stripe geom set, got more AGs, then zeroed
out the stripe geom.

I'm ... not sure how many bugs are here.  ;)  We shouldn't calculate
AG geometry until we've validated sunit/swidth, I think.  But I'm not
convinced that dm-thinp's exported values make a lot of sense either.

-Eric


> 
> Chris Murphy
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
