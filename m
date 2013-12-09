Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6F1897F37
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 18:58:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5B656304039
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 16:58:20 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id hyMeSoWnHI0GJEbP
	for <xfs@oss.sgi.com>; Sun, 08 Dec 2013 16:58:07 -0800 (PST)
Message-ID: <52A5159F.2060309@hardwarefreak.com>
Date: Sun, 08 Dec 2013 18:58:07 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Sudden File System Corruption
References: <CAPd9ww_qT9J_Rt04g7+OApoBeggNOyWNwD+57DiDTuUvz-O-0g@mail.gmail.com>	<52A03513.6030408@hardwarefreak.com>	<CAPd9ww9hsOFK6pxqRY-YtLLAkkJHCuSi1BaM4n9=2XTjNVAn2Q@mail.gmail.com>	<CAPd9ww9QzFWUnLtzkdktd+fSX9pdft+wL6cvG2MzLpSdLko1dg@mail.gmail.com>	<52A191BA.20800@hardwarefreak.com>	<CAPd9ww8+W2VX2HAfxEkVN5mL1a_+=HDAStf1126WSE33Vb=VsQ@mail.gmail.com>	<52A302A9.9050509@hardwarefreak.com>	<CAPd9ww8ovd1rOCQdjUF=U_ji2SOjyBCG-eFjeWSPXr8L5Zg9-A@mail.gmail.com>	<52A401FF.9050506@hardwarefreak.com>
	<20131208160339.5c45ab91@galadriel.home>
In-Reply-To: <20131208160339.5c45ab91@galadriel.home>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Mike Dacre <mike.dacre@gmail.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 12/8/2013 9:03 AM, Emmanuel Florac wrote:
> Le Sat, 07 Dec 2013 23:22:07 -0600 vous =E9criviez:
> =

>>> Thanks for the great advice, I think you are on to something
>>> there.  I will  =

>>
>> You're welcome.  Full disclosure:  I should have mentioned that I
>> haven't used CacheCade yet myself.  My statements WRT performance are
>> based on available literature and understanding of the technology.
> =

> I didn't test thoroughly cachecade though I have a license code
> somewhere, however I've used the equivalent Adaptec feature and one SSD
> roughly double the IOPS of a RAID-6 array of 15k RPM SAS drives from
> about 4200 IOPS to 7500 IOPS.

Emmanuel do you recall which SSD you used here?  7500 IOPS is very low
by today's standards.  What I'm wondering is if you had an older low
IOPS SSD, or, a modern high IOPS rated SSD that performed way below its
specs in this application.

The Samsung 840 Pro I recommended is rated at 90K 4K write IOPS and
actually hits that mark in IOmeter testing at a queue depth of 7 and
greater:
http://www.tomshardware.com/reviews/840-pro-ssd-toggle-mode-2,3302-3.html

Its processor is a 3 core ARM Cortex R4 so it should excel in this RAID
cache application, which will likely have gobs of concurrency, and thus
a high queue depth.

Found a review of CacheCade 2.0.  Their testing shows near actual SSD
throughput.  The Micron P300 has 44K/16K read/write IOPS and their
testing hits 30K.  So you should be able to hit close to ~90K read/write
IOPS with the Samsung 840s.

http://www.storagereview.com/lsi_megaraid_cachecade_pro_20_review

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
