Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DB8087F58
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 10:51:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 68A9EAC003
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2014 08:51:26 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id EfzUS1p40wnt8Dd7 for <xfs@oss.sgi.com>;
	Sat, 25 Oct 2014 08:51:24 -0700 (PDT)
Message-ID: <544BC6FA.8090101@sandeen.net>
Date: Sat, 25 Oct 2014 10:51:22 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: makefs alignment issue
References: <544AB289.8010005@hardwarefreak.com>	<544AB338.2050905@sandeen.net>	<544ACDC4.1070501@hardwarefreak.com>	<544AD077.4080305@sandeen.net>	<544AD234.3060100@sandeen.net>
	<544B1439.6060509@hardwarefreak.com>
In-Reply-To: <544B1439.6060509@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

On 10/24/14 10:08 PM, Stan Hoeppner wrote:
> On 10/24/2014 05:27 PM, Eric Sandeen wrote:
>> On 10/24/14 5:19 PM, Eric Sandeen wrote:
>>> On 10/24/14 5:08 PM, Stan Hoeppner wrote:
>>>>
>>>> On 10/24/2014 03:14 PM, Eric Sandeen wrote:
>>>
>>> ...
>>>
>>>>>> Any ideas how to verify what's going on here and fix it?
>>>>>
>>>>> # blockdev --getiomin --getioopt /dev/s2d_a1l003
>>
>> Also, what does it show for the underlying non-multipath device(s)?
> 
> # blockdev --getiomin --getioopt /dev/sdj
> 512
> 1048576
> # blockdev --getiomin --getioopt /dev/sdf
> 512
> 1048576

Ok, so dm multipath is just bubbling up what the device itself
is claiming; not dm's doing.

I forgot to ask (and you forgot to report...!) what version
of xfsprogs you're using....

Currently, blkid_get_topology() in xfsprogs does:

        /*
         * Blkid reports the information in terms of bytes, but we want it in
         * terms of 512 bytes blocks (just to convert it to bytes later..)
         *
         * If the reported values are the same as the physical sector size
         * do not bother to report anything.  It will just cause warnings
         * if people specify larger stripe units or widths manually.
         */
        val = blkid_topology_get_minimum_io_size(tp);
        if (val > *psectorsize)
                *sunit = val >> 9;
        val = blkid_topology_get_optimal_io_size(tp);
        if (val > *psectorsize)
                *swidth = val >> 9;

so in your case sunit probably wouldn't get set (can you confirm with
# blockdev --getpbsz that the physical sector size is also 512?)

But the optimal size is > physical sector so swidth gets set.

Bleah...  can you just collect all of:

# blockdev --getpbsz --getss --getiomin --getioopt

for your underlying devices, and I'll dig into how xfsprogs is behaving for
those values.  I have a hunch that we should be ignoring stripe units of 512
even if the "width" claims to be something larger.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
