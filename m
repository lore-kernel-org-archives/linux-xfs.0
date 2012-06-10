Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5A3wFxq172604 for <xfs@oss.sgi.com>; Sat, 9 Jun 2012 22:58:15 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 6T1iIsoHgWUi11X4
	for <xfs@oss.sgi.com>; Sat, 09 Jun 2012 20:58:14 -0700 (PDT)
Message-ID: <4FD41B53.3080509@hardwarefreak.com>
Date: Sat, 09 Jun 2012 22:58:11 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Repeated XFS corruption on RAID-10 on Adaptec 51245
References: <4FD1C9B8.70907@internet-sicherheit.de>
	<20120608125138.20c79cee@harpe.intellique.com>
	<4FD2545A.40503@internet-sicherheit.de>
	<20120609152311.0523682c@galadriel.home>
In-Reply-To: <20120609152311.0523682c@galadriel.home>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Emmanuel Florac <eflorac@intellique.com>
Cc: "Christian J. Dietrich" <dietrich@internet-sicherheit.de>, xfs@oss.sgi.com

On 6/9/2012 8:23 AM, Emmanuel Florac wrote:
> Le Fri, 08 Jun 2012 21:36:58 +0200 vous =E9criviez:
> =

>> Indeed, it seems to be related to the WD HDDs, I am in contact with
>> Adaptec support and will dig deeper. A couple of disks have comparably
>> high CommandAborts.
> =

> I'm afraid there's not much they can do, but let us know if they come
> back with any constructive suggestion.
>  =

>> Probably, I will rebuild the RAID volume using disks with proper TLER
>> support and activate TLER.

There's nothing to activate.  If a drive has TLER/ERC/etc (any SAS or
enterprise SATA) it's turned on/enabled at the factory.

> I suppose you may turn off the system, connect the drives to some PC
> and run the TLER tool; after that it should work better without even
> rebuilding the array.

wdidle will only change the TLER timeout on firmware that allows it,
which means older drives.  Many/most of WD's newer consumer drives
apparently do not allow this.


Worth noting, the price premium of the 1TB RE4 over the 1TB Black is
currently ZERO at Newegg-- both drives are $120.  No premium for TLER,
enterprise features.

The 2TB RE4 is $230, the 2TB Black is $210, a $20 premium for enterprise
features.

I didn't compare to the WD Green drives because they are squarely low
performance consumer junk designed NOT to be accesses more than TO be
accessed.  WD's anticipated mode of operation for such drives is to be
idle with the heads parked over 99% of the time.  This simply is not
suitable for RAID use, and they boldly tell us that.  Many ignore the
warning then shed tears when arrays die...

At Newegg's current prices, likely other vendors as well, there is no
meaningful price premium for a WD 7.2k enterprise SATA drive over a WD
7.2K performance oriented consumer drive.  Thus, if the preference is
for WD gear, no sysadmin has a valid excuse for not buying the RE series
drives.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
