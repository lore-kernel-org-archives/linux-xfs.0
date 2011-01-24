Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0OFMh5s092750 for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 09:22:43 -0600
Received: from lucidpixels.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D3521A1807F
	for <xfs@oss.sgi.com>; Mon, 24 Jan 2011 07:25:03 -0800 (PST)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66]) by
	cuda.sgi.com with ESMTP id rLLrRaiTOb2ERqKx for
	<xfs@oss.sgi.com>; Mon, 24 Jan 2011 07:25:03 -0800 (PST)
Date: Mon, 24 Jan 2011 10:25:02 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Optimize RAID0 for max IOPS?
In-Reply-To: <AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
References: <20110118210112.D13A236C@gemini.denx.de>
	<4D361F26.3060507@stud.tu-ilmenau.de>
	<20110119192104.1FA92D30267@gemini.denx.de>
	<AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="655872-1146966783-1295882702=:14640"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: CoolCold <coolthecold@gmail.com>
Cc: linux-raid@vger.kernel.org, stefan.huebner@stud.tu-ilmenau.de, Wolfgang Denk <wd@denx.de>, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--655872-1146966783-1295882702=:14640
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 24 Jan 2011, CoolCold wrote:

>> So can anybody help answering these questions:
>>
>> - are there any special options when creating the RAID0 to make it
>> =A0perform faster for such a use case?
>> - are there other tunables, any special MD / LVM / file system /
>> =A0read ahead / buffer cache / ... parameters to look for?
> XFS is known for it's slow speed on metadata operations like updating
> file attributes/removing files..but things gonna change after 2.6.35
> where delaylog is used. Citating Dave Chinner :
> < dchinner> Indeed, the biggest concurrency limitation has
> traditionally been the transaction commit/journalling code, but that's
> a lot more scalable now with delayed logging....
>
> So, you may need to benchmark fs part.

Some info on XFS benchmark with delaylog here:
http://comments.gmane.org/gmane.comp.file-systems.xfs.general/34379

Justin.

--655872-1146966783-1295882702=:14640
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--655872-1146966783-1295882702=:14640--
