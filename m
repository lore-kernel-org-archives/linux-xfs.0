Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q43MJgcl209719 for <xfs@oss.sgi.com>; Thu, 3 May 2012 17:19:43 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id ftdnJHhtqgvgHfwm
	for <xfs@oss.sgi.com>; Thu, 03 May 2012 15:19:41 -0700 (PDT)
Message-ID: <4FA3047D.8060908@hardwarefreak.com>
Date: Thu, 03 May 2012 17:19:41 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Storage server, hung tasks and tracebacks
References: <20120502184450.GA2557@nsrc.org>
	<4FA27EF8.6040002@hardwarefreak.com>
	<20120503204157.GC4387@nsrc.org>
In-Reply-To: <20120503204157.GC4387@nsrc.org>
Reply-To: stan@hardwarefreak.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Brian Candler <B.Candler@pobox.com>
Cc: xfs@oss.sgi.com

On 5/3/2012 3:41 PM, Brian Candler wrote:
> On Thu, May 03, 2012 at 07:50:00AM -0500, Stan Hoeppner wrote:
>>> Any other suggestions (and of course interpretation of the kernel call
>>> tracebacks) would be much appreciated.
>>
>> Which mainboards are these Brian?  Make/model?
> =

> Tyan S5510, with Intel Xeon CPU E31225 @ 3.10GHz
> =

> Upgraded to BIOS 1.05a and iKVM 3.00
> =

>> Make/model/count of all add in cards?
> =

> 1 x LSI SAS9201=9616i
> 1 x LSI SAS92118=968i
> 1 x Intel X520-DA2 dual 10G NIC
> =

> although the 10G link wasn't being used for the most recent tests.

I'm not finding anything down this avenue so far.

>> Make/model of PSU?
> =

> Will have to check, I think it may be this one:
> http://www.xcase.co.uk/XCASE-Power-Supply-p/psu-dolphin-900..htm
> =

>> Make model of chassis?
> =

> http://www.xcase.co.uk/24-bay-Hotswap-rackmount-chassis-norco-RPC-4224-p/=
case-xcase-rm424.htm
> =

> The drives are 24 x ST3000DM001 (I was hoping to get low-power Hitachi
> drives but they weren't available at the time)

Yuk.  Zero technical info available on this "house brand" PSU or
chassis.  That PSU is decidedly consumer oriented.  It may be fine, but
there seems to be no documentation available to verify its output
current or rail config.  No pic of the PSU sticker, no manual to be
found online.  Many of these "house brand" and cheap no-name Chinese
PSUs don't put out anywhere near the advertised power, nor necessarily
cleanly, which is why the UL sticker is so handy--it doesn't lie as the
printing on the box might.  No pic of the inside of that chassis, and no
manual here either, so I have no way of knowing the backplane
architecture.  I'd have to guess it's a 6x 4 drive passive backplane
setup similar to the Norco chassis.

FWIW, I'd never buy a PSU with a "technical description" of:

    140mm Red Fan
    Strong Long Cables
    Strong outer Casing
    Quality Internal Components
    Low Noise - Big Heat Sinks

One can spend a few extra bucks (pounds) and get a SuperMicro or Sparkle
unit with all the tech specs and QC test data available online, such as:
 http://www.supermicro.com/products/powersupply/80plus/80plus_pws-865-pq.pdf

> However, last night I rebooted one box (the one which wouldn't let me ssh
> in) then upgraded it to ubuntu 12.04.  It has been running a couple of
> concurrent bonnie++ instances for over 24 hours without a hitch.
> =

> So maybe it's the mpt2sas driver which is the difference:
> =

> [dmesg from Ubuntu 11.10]
>     mpt2sas version 08.100.00.02
> =

> [dmesg from Ubuntu 12.04]
>     mpt2sas version 10.100.00.00

Glad to hear you've got one running somewhat stable.  Could be a driver
problem, but it's pretty rare for a SCSI driver to hard lock a box isn't
it?  Keep us posted.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
